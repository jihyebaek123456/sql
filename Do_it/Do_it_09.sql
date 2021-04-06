SELECT *
FROM EMP
WHERE SAL > (SELECT SAL
                    FROM EMP
                    WHERE ENAME = 'JONES');
                    
SELECT *
FROM EMP
WHERE COMM > (SELECT COMM
                         FROM EMP
                         WHERE ENAME = 'ALLEN');

SELECT *
FROM EMP
WHERE HIREDATE < (SELECT HIREDATE
                            FROM EMP
                            WHERE ENAME = 'SCOTT');

SELECT E.EMPNO, E.ENAME, E.JOB, E.SAL, D.DEPTNO, D.DNAME, D.LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
    AND D.DEPTNO = 20
    AND SAL > (SELECT AVG(SAL)
                     FROM EMP);

SELECT *
FROM EMP
WHERE SAL IN (SELECT MAX(SAL)
                        FROM EMP
                        GROUP BY DEPTNO);

SELECT *
FROM EMP
WHERE SAL = ANY (SELECT MAX(SAL)
                            FROM EMP
                            GROUP BY DEPTNO);

SELECT *
FROM EMP
WHERE SAL = SOME (SELECT MAX(SAL)
                             FROM EMP
                             GROUP BY DEPTNO);

SELECT *
FROM EMP
WHERE SAL < ANY (SELECT SAL
                             FROM EMP
                             WHERE DEPTNO = 30)
ORDER BY SAL, EMPNO;

SELECT *
FROM EMP
WHERE SAL < ALL(SELECT SAL
                          FROM EMP
                          WHERE DEPTNO = 30);

SELECT *
FROM EMP
WHERE EXISTS (SELECT DNAME
                      FROM DEPT
                      WHERE DEPTNO = 10);

SELECT *
FROM EMP
WHERE EXISTS (SELECT DNAME
                      FROM DEPT
                      WHERE DEPTNO = 50);

SELECT *
FROM EMP
WHERE (DEPTNO, SAL) IN (SELECT DEPTNO, MAX(SAL)
                                    FROM EMP
                                    GROUP BY DEPTNO);

SELECT EMPNO, ENAME, JOB, SAL,
            (SELECT GRADE
            FROM SALGRADE
            WHERE E.SAL BETWEEN LOSAL AND HISAL) AS SALGRADE,
            DEPTNO,
            (SELECT DNAME
            FROM DEPT
            WHERE E.DEPTNO = DEPT.DEPTNO) AS DNAME
FROM EMP E;

--1
SELECT E.JOB, E.EMPNO, E.ENAME, E.SAL, D.DEPTNO, D.DNAME
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
    AND E.JOB = (SELECT JOB
                        FROM EMP
                        WHERE ENAME = 'ALLEN');

--2
SELECT E.EMPNO, E.ENAME, D.DNAME, E.HIREDATE, D.LOC, E.SAL, S.GRADE
FROM EMP E, DEPT D, SALGRADE S
WHERE E.DEPTNO = D.DEPTNO
    AND E.SAL BETWEEN S.LOSAL AND S.HISAL
    AND E.SAL > (SELECT AVG(SAL)
                    FROM EMP)
ORDER BY E.SAL DESC, E.EMPNO;

--3
SELECT E.EMPNO, E.ENAME, E.JOB, D.DEPTNO, D.DNAME, D.LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
    AND D.DEPTNO = 10
    AND E.JOB NOT IN (SELECT JOB
                                FROM EMP
                                WHERE DEPTNO = 30)

--4
SELECT E.EMPNO, E.ENAME, E.SAL, S.GRADE
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL
    AND E.SAL > (SELECT MAX(SAL)
                        FROM EMP
                        WHERE JOB = 'SALESMAN');

SELECT E.EMPNO, E.ENAME, E.SAL, S.GRADE
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL
    AND E.SAL > ALL (SELECT SAL
                             FROM EMP
                             WHERE JOB = 'SALESMAN')
ORDER BY EMPNO;
