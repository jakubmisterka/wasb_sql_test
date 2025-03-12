/*
Approach:
1. For each invoice create array that will contain all dates at which payments will be done
2. Explode this array so that there is a seperate row for each payment x invoice
3. Calcualte the amount that should be paid out per this invoice
4. Wrap up this part in view for readibility
5. Aggregate all payments that are to be done on each payment date (in case there are multiple invoices to be paid out)
6. Use window function to calculate all remaining payments to be done for a given supplier
7. Add info about supplier

*/

CREATE OR REPLACE VIEW payment_dates AS
SELECT
     supplier_id
    ,payment_ammount
    ,payment_date
FROM (
        SELECT 
             supplier_id
            ,invoice_ammount/cardinality(payment_dates) AS payment_ammount
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
     ) AS invoices (supplier_id,payment_ammount,payment_dates)
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