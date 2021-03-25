--실습 sub6
--2번 고객이 먹는 제품에 대해서만 1번 고객이 먹는 애음 제품 조회
SELECT *
FROM cycle
WHERE pid IN (
              SELECT pid
              FROM cycle
              WHERE cid = 2)
    AND cid = 1;

--실습 sub7
--실습 sub6에서 고객명, 제품명도 포함
SELECT cycle.cid, cnm, product.pid, pnm, day, cnt
FROM cycle, customer, product
WHERE product.pid IN (
                        SELECT pid
                        FROM cycle
                        WHERE cid = 2)
    AND cycle.cid = 1
    AND cycle.cid = customer.cid
    AND product.pid = cycle.pid;

--매니저가 존재 하는 직원
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

SELECT *
FROM emp e
WHERE EXISTS (
              SELECT empno
              FROM emp m
              WHERE e.mgr = m.empno);
--TRUE
SELECT *
FROM emp e
WHERE EXISTS (
              SELECT empno
              FROM emp m
              WHERE 7698 = m.empno);
SELECT *
FROM emp e
WHERE EXISTS (
              SELECT *
              FROM dual);  --비상호 연관 서브 쿼리 O : ⓑ 의미 없는 경우일 때가 많음 (ALL or NOTHING)
SELECT *    
FROM emp e
WHERE EXISTS (
              SELECT 'X'  --값이 중요하지 않기 때문에 가능한 것, 관습적으로 'X' 표기
              FROM emp m
              WHERE e.mgr = m.empno);  --상호 연관 서브 쿼리 O
--FALSE
SELECT *
FROM emp e
WHERE EXISTS (
              SELECT empno
              FROM emp m
              WHERE NULL = m.empno);

--예시
SELECT * 
FROM dual
WHERE EXISTS (SELECT 'X' FROM emp WHERE deptno = 10);

SELECT * 
FROM dual
WHERE EXISTS (SELECT 'X' FROM emp WHERE deptno = 40);

--실습 sub9
--cid = 1인 고객이 애음하는 제품 조회 (EXISTS 사용)
SELECT *
FROM product
WHERE EXISTS (
              SELECT 'X'
              FROM cycle
              WHERE cid = 1
                    AND product.pid = cycle.pid);

SELECT *
FROM product
WHERE NOT EXISTS (
                    SELECT 'X'
                    FROM cycle
                    WHERE cid = 1
                      AND product.pid = cycle.pid);

--집합 연산자
--UNION
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7499)

UNION

SELECT empno, ename  --위쪽의 컬럼 개수와 타입이 다르면 에러
FROM emp
WHERE empno IN (7369, 7521);  --하나의 쿼리!

--처리
SELECT empno, ename, NULL
FROM emp
WHERE empno IN (7369, 7499)

UNION

SELECT empno, ename, deptno
FROM emp
WHERE empno IN (7369, 7521);

--UNION ALL
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7499)

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521);

--INTERSECT
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7499)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521);

--MINUS
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7499)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521);

--INSERT
DESC dept;
INSERT INTO dept (deptno, dname, loc)
       VALUES (99, 'ddit', 'daejeon');

DESC emp;
INSERT INTO emp (empno, ename, job) VALUES (9999, 'brown', 'RANGER');

SELECT *
FROM emp
INSERT INTO emp (empno, ename, job, hiredate, sal, comm)
         VALUES (9999, 'sally', 'RANGER', TO_DATE('2021-03-24', 'YYYY/MM/DD'), 1000, NULL);

--한 번에 여러 값
INSERT INTO dept
SELECT 90, 'DDIT', '대전' FROM dual UNION ALL
SELECT 80, 'DDIT8', '대전' FROM dual;

--COMMIT & ROLLBACK
ROLLBACK;

--UPDATE
SELECT *
FROM dept;

--부서 번호 99번 부서 정보를 부서 명은 대덕IT로, 위치는 영민빌딩으로 변경
UPDATE dept SET dname = '대덕IT', loc = '영민빌딩'
WHERE deptno = 99;

