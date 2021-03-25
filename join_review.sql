RDBMS는 중복을 최소화 하는 데이터 베이스
 > JOIN이라는 키워드로 테이블 간 결합을 통해 데이터 조회
 > JOIN 은 컬럼을 확장시킴!

# 논리적 조인 형태
SELF JOIN : JOIN 하는 두 개의 테이블이 같은 경우 (계층 구조)
NONEQUI-JOIN : JOIN 하는 두 개의 테이블 간 연결 조건이 equal이 아닌 경우

# INNER JOIN : 컬럼 연결 실패 시 데이터가 조회 되지 않는 JOIN
--NATURAL JOIN (컬럼 명 동일 시 자동 연결)
SELECT empno, ename, deptno, dname
FROM emp NATURAL JOIN dept;

--JOIN USING (컬럼 명, 타입이 같은 컬럼이 두 개 이상 > 개발자가 원하는 특정 컬럼으로만 연결)
SELECT empno, ename, deptno, dname
FROM emp JOIN dept USING (deptno);

--JOIN ON
SELECT empno, ename, emp.deptno, dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--ORACLE JOIN
SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

# OUTER JOIN : 컬럼 연결에 실패해도 [기준]이 되는 테이블 쪽의 컬럼 정보가 나오도록 하는 JOIN
--LEFT OUTER JOIN
SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

--RIGHT OUTER JOIN
SELECT e.ename, m.ename
FROM emp m RIGHT OUTER JOIN emp e ON (e.mgr = m.empno);

--FULL OUTER JOIN
SELECT e.ename AS emp, m.ename AS mgr
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

--ORACLE JOIN
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+)

# CROSS JOIN : 연결 조건이 없는 조인 > 두 테이블의 행 간 연결 가능한 모든 경우의 수로 연결
SELECT customer.cid, cnm, pid, pnm
FROM customer, product;