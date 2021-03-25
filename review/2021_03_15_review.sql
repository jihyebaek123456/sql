SELECT *
FROM emp
--row : 14개, col : 8개

SELECT *
FROM emp
WHERE deptno = 30;

SELECT 'SELECT * FROM ' || table_name || ';'
        CONCAT('SELECT * FROM ', CONCAT(table_name, ';'))
FROM user_tables;

SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD');
WHERE hiredate >= TO_DATE('1982-01-01', 'YYYY-MM-DD');
WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD');