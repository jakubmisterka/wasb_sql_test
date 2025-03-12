/*
Approach:
1. Define multiple joins to EMPLOYEE table. Each subsequent join point to manager of employee in previous step.
2. Collect path into array
3. Filter only those paths that are cycles
4. Ensure path ends in original employee

Theoretical explaination:
If employee is part of managerial cycle then after some number of steps cycle would go back to initial state, in this case to original employee. 
After that the cycle will only repeat itself so there is no need to continue the search, hence the additional condition halting the process
before chain reverts itself.
In the most extreme case it will be a cycle of all 9 employees and it will go back to initial state at 10th step.
Thus, for all employees that are in managerial cycle e0.employee_id is NULL.
For employees that are not part of managerial cycle it's impossible to go back to original employee_id by following subsequent managers
Thus, for these employees e0.employee_id is not NULL.
*/

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


