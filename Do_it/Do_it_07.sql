SELECT SUM(DISTINCT SAL),
           SUM(ALL SAL),
           SUM(SAL)
FROM EMP;

SELECT COUNT(DISTINCT SAL),
           COUNT(ALL SAL),
           COUNT(SAL)
FROM EMP;

SELECT MAX(HIREDATE)
FROM EMP
WHERE DEPTNO = 20;

SELECT MIN(HIREDATE)
FROM EMP
WHERE DEPTNO = 20;

SELECT MAX(ENAME)
FROM EMP
WHERE DEPTNO = 20;

SELECT MIN(ENAME)
FROM EMP
WHERE DEPTNO = 20;

SELECT AVG(COMM)
FROM EMP
WHERE DEPTNO = 30;

SELECT AVG(COMM), DEPTNO
FROM EMP
GROUP BY DEPTNO;

SELECT ENAME, DEPTNO, AVG(SAL)
FROM EMP
GROUP BY DEPTNO;

SELECT DEPTNO, JOB, AVG(SAL)
FROM EMP
GROUP BY DEPTNO, JOB
ORDER BY DEPTNO, AVG(SAL);

SELECT DEPTNO, JOB, AVG(SAL)
FROM EMP
GROUP BY DEPTNO, JOB
    HAVING AVG(SAL) >= 2000
ORDER BY DEPTNO, AVG(SAL);

SELECT DEPTNO, JOB, AVG(SAL)
FROM EMP
GROUP BY DEPTNO, JOB
HAVING AVG(SAL) >= 500
ORDER BY DEPTNO, JOB;

SELECT DEPTNO, JOB, COUNT(*), MAX(SAL), SUM(SAL), AVG(SAL)
FROM EMP
GROUP BY DEPTNO, JOB
ORDER BY DEPTNO, JOB;

SELECT DEPTNO, JOB, COUNT(*), MAX(SAL), SUM(SAL), AVG(SAL)
FROM EMP
GROUP BY ROLLUP(DEPTNO, JOB)
ORDER BY DEPTNO, JOB;

SELECT DEPTNO, JOB, COUNT(*), MAX(SAL), SUM(SAL), AVG(SAL)
FROM EMP
GROUP BY CUBE(DEPTNO, JOB)
ORDER BY DEPTNO, JOB;

SELECT DEPTNO, JOB, COUNT(*), MAX(SAL), SUM(SAL), AVG(SAL)
FROM EMP
GROUP BY GROUPING SETS(DEPTNO, JOB)
ORDER BY DEPTNO, JOB;

SELECT DEPTNO, JOB, COUNT(*), MAX(SAL), SUM(SAL), TRUNC(AVG(SAL), 0),
           GROUPING(DEPTNO),
           GROUPING(JOB)
FROM EMP
GROUP BY CUBE(DEPTNO, JOB)
ORDER BY DEPTNO, JOB;

SELECT DECODE(GROUPING(DEPTNO), 1, 'ALL_DEPT', DEPTNO) AS DEPTNO,
           DECODE(GROUPING(JOB), 1, 'ALL_JOB', JOB) AS JOB,
           COUNT(*), MAX(SAL), SUM(SAL), TRUNC(AVG(SAL), 0)
FROM EMP
GROUP BY CUBE(DEPTNO, JOB)
ORDER BY DEPTNO, JOB;