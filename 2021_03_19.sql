--group function 실습 grp3
SELECT DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 'OPERATION'),
        MAX(sal),
        MIN(sal),
        ROUND(AVG(sal),2),
        SUM(sal),
        COUNT(sal),
        COUNT(mgr),
        COUNT(*)
FROM emp
GROUP BY deptno;

SELECT DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 'OPERATION'),
        MAX(sal),
        MIN(sal),
        ROUND(AVG(sal),2),
        SUM(sal),
        COUNT(sal),
        COUNT(NVL(mgr,0)),
        COUNT(*)
FROM emp
GROUP BY deptno;

--group function 실습 grp4
SELECT TO_CHAR(hiredate, 'YYYYMM') AS hire_yyyymm, COUNT(*) AS cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM')
ORDER BY TO_CHAR(hiredate, 'YYYYMM');

--group function 실습 grp5
SELECT TO_CHAR(hiredate, 'YYYY') AS hire_yyyy, COUNT(*) AS cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY');

--group function 실습 grp6
SELECT *
FROM dept;

SELECT COUNT(*)
FROM dept;

--group function 실습 grp7
SELECT COUNT(*)
FROM (
        SELECT deptno
        FROM emp
        GROUP BY deptno
     );
     
--NATURAL JOIN
SELECT *
FROM emp NATURAL JOIN dept
ORDER BY deptno;

--ORACLE JOIN
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--emp 테이블의 직원과 상위 담당자 직원 조회
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

--JOIN WITH USING
SELECT *
FROM emp JOIN dept USING(deptno);

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;  --같은 결과

--JOIN WITH ON
SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;  --같은 결과

--사원 번호, 사원 이름, 해당 사원의 상사 사번, 해당 사원의 상사 이름 (JOIN WITH ON)
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno)
WHERE e.empno BETWEEN 7369 AND 7698;

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno
    AND e.empno BETWEEN 7369 AND 7698;
    
--NONEQUI-JOIN
SELECT *
FROM emp, dept
WHERE emp.deptno != dept.deptno;
--부서 번호가 10번인 사람이 20, 30, 40과 연결됨 > 14건이 42건으로

--salgrade를 이용해 직원의 급여 등급 구하기
--empno, ename, sal, salgrade
SELECT *
FROM salgrade;

SELECT e.empno, e.ename, e.sal, s.grade  --ORACLE JOIN
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal;

SELECT e.empno, e.ename, e.sal, s.grade  --ANSI JOIN
FROM emp e JOIN salgrade s ON(e.sal BETWEEN s.losal AND s.hisal);

--실습 join0
SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORDER BY e.deptno;

--실습 join0_1
SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
        AND d.deptno IN (10, 30);
        
--실습 join0_2
SELECT e.empno, e.ename, e.sal, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
        AND e.sal > 2500
ORDER BY e.deptno;

--실습 join0_3
SELECT e.empno, e.ename, e.sal, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
        AND e.sal > 2500
        AND e.empno > 7600
ORDER BY e.deptno;

--실습 join0_4
SELECT e.empno, e.ename, e.sal, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
        AND e.sal > 2500
        AND e.empno > 7600
        AND d.dname = 'RESEARCH'
ORDER BY e.deptno;

SELECT e.empno, e.ename, e.sal, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
        AND e.sal > 2500
        AND e.empno > 7600
        AND e.deptno = 20
ORDER BY e.deptno;

