SELECT
     employee_id
    ,concat(array_except(manager_cycle, array[NULL]), array[employee_id]) manager_cycle
FROM
   (
    SELECT 
        e1.employee_id
        ,array[e1.employee_id, e2.employee_id, e3.employee_id, e4.employee_id, e5.employee_id, e6.employee_id, e7.employee_id, e8.employee_id, e9.employee_id] manager_cycle

    FROM EMPLOYEE e1
    LEFT JOIN EMPLOYEE e2 on e1.manager_id = e2.employee_id AND e1.employee_id <> e2.employee_id
    LEFT JOIN EMPLOYEE e3 on e2.manager_id = e3.employee_id AND e1.employee_id <> e3.employee_id
    LEFT JOIN EMPLOYEE e4 on e3.manager_id = e4.employee_id AND e1.employee_id <> e4.employee_id
    LEFT JOIN EMPLOYEE e5 on e4.manager_id = e5.employee_id AND e1.employee_id <> e5.employee_id
    LEFT JOIN EMPLOYEE e6 on e5.manager_id = e6.employee_id AND e1.employee_id <> e6.employee_id
    LEFT JOIN EMPLOYEE e7 on e6.manager_id = e7.employee_id AND e1.employee_id <> e7.employee_id
    LEFT JOIN EMPLOYEE e8 on e7.manager_id = e8.employee_id AND e1.employee_id <> e8.employee_id
    LEFT JOIN EMPLOYEE e9 on e8.manager_id = e9.employee_id AND e1.employee_id <> e9.employee_id
    LEFT JOIN EMPLOYEE e0 on e8.manager_id = e0.employee_id AND e1.employee_id <> e0.employee_id
    WHERE e0.employee_id is NULL
   )
;


