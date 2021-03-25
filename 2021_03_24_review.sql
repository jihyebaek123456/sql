--SMITH와 같은 부서에 속하는 직원 조회
SELECT *
FROM emp
WHERE deptno = (
                SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');
--SMITH가 속하는 부서 찾기 > 그 부서에 속하는 직원 조회

--SMITH, ALLEN과 같은 부서에 속하는 직원 조회
SELECT *
FROM emp
WHERE deptno IN (
                SELECT deptno
                FROM emp
                WHERE ename IN ('SMITH', 'ALLEN'));

--평균 급여 비교
--전 직원의 급여 평균보다 많은 급여를 받는 직원 조회
SELECT *
FROM emp
WHERE sal > (
            SELECT AVG(sal)
            FROM emp);
--전 직원의 급여 평균보다 많은 급여를 받는 직원은 몇 명인지 조회
SELECT COUNT(*)
FROM emp
WHERE sal > (
            SELECT AVG(sal)
            FROM emp);
--자신이 속한 부서의 급여 평균보다 많은 급여를 받는 직원 조회
SELECT *
FROM emp e
WHERE sal > (
            SELECT AVG(sal)
            FROM emp m
            WHERE e.deptno = m.deptno);


--스칼라 서브 쿼리
SELECT empno, ename, (SELECT SYSDATE FROM dual)
FROM emp;
--안 됨, 스칼라 서브 쿼리는 반드시 하나의 컬럼만!
SELECT empno, ename, (SELECT SYSDATE, 1 FROM dual)
FROM emp;

--각 직원이 속하는 부서의 부서 명 조회
--JOIN 이용
SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
ORDER BY deptno;
--스칼라 서브 쿼리 이용 - 상호 보완 서브 쿼리
SELECT empno, ename, deptno,
        (SELECT dname
        FROM dept
        WHERE emp.deptno = dept.deptno)
FROM emp
ORDER BY deptno;

--서브 쿼리 실행 시 NULL - NOT IN의 문제점
SELECT *
FROM emp
WHERE empno NOT IN (
                    SELECT mgr
                    FROM emp);
--가공이 필요
SELECT *
FROM emp
WHERE empno NOT IN (
                    SELECT NVL(mgr,0)
                    FROM emp);

--PAIR WISE
--직원 a, 직원 b 둘 중 한 명과 상사가 같고, 부서가 같은 경우 조회
SELECT *
FROM emp
WHERE mgr IN (
                SELECT mgr
                FROM emp
                WHERE ename IN ('ALLEN', 'CLARK'))
    AND deptno IN (
                    SELECT deptno
                    FROM emp
                    WHERE ename IN ('ALLEN', 'CLARK'));

SELECT *
FROM emp
WHERE (mgr, deptno) IN (
                        SELECT mgr, deptno
                        FROM emp
                        WHERE ename IN ('ALLEN', 'CLARK'));