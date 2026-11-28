--We define an employee's total earnings to be their monthly  worked, and the maximum total earnings to be the maximum total earnings for any employee in the Employee table. Write a query to find the maximum total earnings for all employees as well as the total number of employees who have maximum total earnings. Then print these values as  space-separated integers.

--Input Format

--The Employee table containing employee data for a company is described as follows:

WITH total_earnings AS (SELECT employee_id,name, months, salary, months*salary AS earnings 
FROM Employee)
SELECT earnings, count(*) AS no_emp
FROM total_earnings
GROUP BY earnings
ORDER BY earnings DESC LIMIT 1; 

--Write a query identifying the type of each record in the TRIANGLES table using its three side lengths. Output one of the following statements for each record in the table:

--Equilateral: It's a triangle with  sides of equal length.
--Isosceles: It's a triangle with  sides of equal length.
--Scalene: It's a triangle with  sides of differing lengths.
--Not A Triangle: The given values of A, B, and C don't form a triangle

SELECT 
    CASE 
        WHEN A + B <= C OR A + C <= B OR B + C <= A THEN 'Not A Triangle'
        WHEN A = B AND B = C THEN 'Equilateral'
        WHEN A = B OR A = C OR B = C THEN 'Isosceles'
        ELSE 'Scalene'
    END
FROM TRIANGLES;


--Query an alphabetically ordered list of all names in OCCUPATIONS, immediately followed by the first letter of each profession as a parenthetical (i.e.: enclosed in parentheses). For example: AnActorName(A), ADoctorName(D), AProfessorName(P), and ASingerName(S).
--Query the number of ocurrences of each occupation in OCCUPATIONS. Sort the occurrences in ascending order, and output them in the following format:

SELECT CONCAT(NAME,'(', LEFT(OCCUPATION, 1),')')
FROM OCCUPATIONS
ORDER BY NAME;

SELECT CONCAT('There are a total of ', COUNT(o.OCCUPATION),' ',LOWER(o.OCCUPATION),'s.')
FROM OCCUPATIONS AS o
GROUP BY o.OCCUPATION
ORDER BY COUNT(o.OCCUPATION), o.OCCUPATION
