SELECT 
     em.employee_id
    ,em.first_name || ' ' || em.last_name AS employee_name
    ,m.employee_id                        AS manager_id
    ,m.first_name || ' ' || m.last_name   AS manager_name
    ,ex.total_expensed_amount
FROM (
        SELECT 
             employee_id
            ,SUM(unit_price * quantity) AS total_expensed_amount 
        FROM EXPENSES 
        GROUP BY employee_id
     ) ex
LEFT JOIN EMPLOYEE em ON em.employee_id = ex.employee_id
LEFT JOIN EMPLOYEE m  ON em.manager_id  = m.employee_id
ORDER BY total_expensed_amount DESC
;