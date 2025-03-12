CREATE OR REPLACE VIEW payment_dates AS
SELECT
     supplier_id
    ,payment_ammount
    ,due_date
    ,payment_date
FROM (
        SELECT 
             supplier_id
            ,invoice_ammount/cardinality(payment_dates) AS payment_ammount
            ,due_date
            ,payment_dates
        FROM
                (
                    SELECT 
                         supplier_id
                        ,due_date
                        ,invoice_ammount
                        ,sequence(last_day_of_month(date(now())), due_date, interval '1' month) AS payment_dates
                    FROM INVOICE
                ) invoices_with_payment_days
     ) AS invoices (supplier_id,payment_ammount,due_date,payment_dates)
CROSS JOIN UNNEST(payment_dates) AS t(payment_date)
;

SELECT 
     p.supplier_id
    ,s.name AS supplier_name
    ,p.payment_ammount
    ,SUM(p.payment_ammount) OVER (PARTITION BY p.supplier_id ORDER BY p.payment_date DESC) - p.payment_ammount AS balance_outstanding
    ,p.payment_date 
    
FROM (
      SELECT 
         supplier_id
        ,payment_date
        ,sum(payment_ammount) AS payment_ammount 
      FROM  payment_dates 
      GROUP BY supplier_id, payment_date
      ) p
LEFT JOIN SUPPLIER s ON p.supplier_id = s.supplier_id
ORDER BY p.supplier_id, p.payment_date
;