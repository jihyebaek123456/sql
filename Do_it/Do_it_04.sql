--041
DESC EMP;
DESC DEPT;
DESC SALGRADE;

--043
SELECT EMPNO, DEPTNO
FROM EMP;

--044
SELECT DISTINCT DEPTNO
FROM EMP;

SELECT DISTINCT JOB, DEPTNO
FROM EMP;

--045
SELECT ENAME, SAL, SAL * 12 + COMM, COMM
FROM EMP;

SELECT ENAME, SAL, SAL * 12 + COMM AS ANNSAL, COMM
FROM EMP;

--문제 (92p)
SELECT DISTINCT JOB
FROM EMP;

SELECT EMPNO AS EMPLOYEE_NO,
           ENAME AS EMPLOYEE_NAME,
           JOB,
           MGR AS MANAGER,
           HIREDATE,
           SAL AS SALARY,
           COMM AS COMMISSION,
           DEPTNO AS DEPARTMENT_NO
FROM EMP
ORDER BY DEPTNO DESC, ENAME;