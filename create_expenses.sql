CREATE TABLE IF NOT EXISTS EXPENSES (
employee_id TINYINT,
unit_price  DECIMAL(8, 2),
quantity    TINYINT
);

CREATE TABLE IF NOT EXISTS EXPENSES_tmp (
employee_name VARCHAR,
unit_price    DECIMAL(8, 2),
quantity      TINYINT
);

INSERT INTO EXPENSES_tmp (employee_name, unit_price, quantity)
VALUES
('Alex Jacobson',6.50,14),
('Alex Jacobson',11.00,20),
('Alex Jacobson',22.00,18),
('Alex Jacobson',13.00,75),
('Andrea Ghibaudi',300,1),
('Darren Poynton',40.00,9),
('Umberto Torrielli',17.50,4);

TRUNCATE TABLE EXPENSES;

INSERT INTO EXPENSES
SELECT 
     em.employee_id
    ,ex.unit_price
    ,ex.quantity    
FROM EXPENSES_tmp ex
INNER JOIN EMPLOYEE em ON ex.employee_name = em.first_name || ' ' || em.last_name
;

DROP TABLE EXPENSES_tmp;