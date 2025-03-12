CREATE TABLE IF NOT EXISTS SUPPLIER (
supplier_id TINYINT,
NAME        VARCHAR
);

CREATE TABLE IF NOT EXISTS INVOICE (
supplier_id     TINYINT,
invoice_ammount DECIMAL(8, 2),
due_date        date
);

CREATE TABLE IF NOT EXISTS INVOICE_tmp (
supplier        VARCHAR,
invoice_ammount DECIMAL(8, 2),
months_due      TINYINT
);

INSERT INTO INVOICE_tmp (supplier,invoice_ammount,months_due)
VALUES
('Party Animals',6000,3),
('Catering Plus',2000,2),
('Catering Plus',1500,3),
('Dave''s Discos',500,1),
('Entertainment tonight',6000,3),
('Ice Ice Baby',4000,6);

TRUNCATE TABLE INVOICE;
TRUNCATE TABLE SUPPLIER;

INSERT INTO SUPPLIER
SELECT
     ROW_NUMBER() OVER (ORDER BY name) AS supplier_id
    ,name
FROM
    (SELECT
        supplier     AS name
    FROM INVOICE_tmp
    GROUP BY supplier
    ) a
;


INSERT INTO INVOICE
SELECT
     s.supplier_id
    ,tmp.invoice_ammount
    ,last_day_of_month(date_add('month', tmp.months_due-1, now())) AS due_date
FROM INVOICE_tmp tmp
LEFT JOIN SUPPLIER s ON s.name = tmp.supplier
;

DROP TABLE INVOICE_tmp;

