--SMITH가 속한 부서에 있는 직원들을 조회
--1. SMITH가 속한 부서 번호 알아내기
SELECT deptno
FROM emp
WHERE ename = 'SMITH';
--2. SMITH가 속한 부서에 있는 직원 조회하기
SELECT *
FROM emp
WHERE deptno = 20;
--합체 : 서브쿼리 활용 > SMITH의 부서 번호가 바뀌면 결과도 달라짐
SELECT *  --메인쿼리
FROM emp
WHERE deptno = ( --서브쿼리
                SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');
--응용
SELECT *
FROM emp
WHERE deptno IN (
                SELECT deptno
                FROM emp
                WHERE ename = 'SMITH' OR ename = 'ALLEN');

--실습 subquery1
SELECT AVG(sal)
FROM emp;

SELECT COUNT(*)
FROM emp
WHERE sal >= (
              SELECT AVG(sal)
              FROM emp);

--실습 subquery2
SELECT *
FROM emp
WHERE sal >= (
              SELECT AVG(sal)
              FROM emp);

--실습 subquery3
SELECT *
FROM emp
WHERE deptno IN (
                SELECT deptno
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));

--ANY
--직원 중 급여 값이 SMITH(800)나 WARD(1250)의 급여보다 적은 직원 조회
-- = 직원 중 급여 값이 1250보다 적은 직원 조회
SELECT *
FROM emp e
WHERE e.sal < ANY (
                   SELECT s.sal
                   FROM emp s
                   WHERE s.ename IN ('SMITH', 'WARD'));

--대체 가능
SELECT *
FROM emp e
WHERE e.sal < (
               SELECT MAX(s.sal)
               FROM emp s
               WHERE s.ename IN ('SMITH', 'WARD'));

--ALL
--직원 중 급여 값이 TURNER(1500)보다 적고 WARD(1250)의 급여보다 적은 직원 조회
-- = 직원 중 급여 값이 1250보다 적은 직원 조회
SELECT *
FROM emp e
WHERE e.sal < ALL (
                   SELECT s.sal
                   FROM emp s
                   WHERE s.ename IN ('TURNER', 'WARD'));
                   
SELECT *
FROM emp e
WHERE e.sal < (
               SELECT MIN(s.sal)
               FROM emp s
               WHERE s.ename IN ('TURNER', 'WARD'));
               
--subquery 주의 사항 - NULL
SELECT *
FROM emp
WHERE deptno IN (10, 20, NULL);
      deptno = 10 OR deptno = 20 OR deptno = NULL
                                        FALSE (지만 OR로 묶였기 때문에 결과 조회 가능)

SELECT *
FROM emp
WHERE deptno NOT IN (10, 20, NULL);
      !(deptno = 10 OR deptno = 20 OR deptno = NULL)
      deptno != 10 AND deptno != 20 AND deptno != NULL
                                            FALSE (결과는 항상 FALSE 로 정보 조회 불가)
--NULL - NOT IN 사용
SELECT *
FROM emp
WHERE empno NOT IN (
                    SELECT mgr
                    FROM emp);
--처리 방법 - NULL 처리 함수 사용
SELECT *
FROM emp
WHERE empno NOT IN (
                    SELECT NVL(mgr, 0)
                    FROM emp);
                    
--PAIR WISE
SELECT *
FROM emp
WHERE mgr IN (
                SELECT mgr
                FROM emp
                WHERE empno IN (7499, 7782))
 AND deptno IN (
                SELECT deptno
                FROM emp
                WHERE empno IN (7499, 7782));

--ALLEN(30, 7698), CLARK(10, 7839)
SELECT ename, mgr, deptno
FROM emp
WHERE empno IN (7499, 7782);

--요구사항 : ALLEN 또는 CLARK의 소속 부서 번호와 같으면서 상사도 같은 경우
SELECT *
FROM emp
WHERE (mgr, deptno) IN (
                        SELECT mgr, deptno  
                        FROM emp
                        WHERE ename IN ('ALLEN', 'CLARK'));
                        
--스칼라 서브 쿼리
SELECT empno, ename, (SELECT SYSDATE FROM dual)
FROM emp;

--에러 > 컬럼이 한 개 이상
SELECT empno, ename, (SELECT SYSDATE, SYSDATE FROM dual)
FROM emp;

--스칼라 서브 쿼리는 일반적으로 상호 연관 서브 쿼리를 사용
--emp 테이블 : 부서 번호 / dept 테이블 : 부서 명 정보 > JOIN을 사용하는 이유
SELECT empno, ename, deptno
FROM emp;

SMITH : SELECT dname FROM dept WHERE deptno = 20;
ALLEN : SELECT dname FROM dept WHERE deptno = 30;
CLARK : SELECT dname FROM dept WHERE deptno = 10;

--상호 연관 서브 쿼리는 항상 메인 쿼리가 먼저 실행됨
--행 개수에 따라 실행 횟수가 정해짐 > 큰 데이터 처리 시 문제가 될 가능성 有
SELECT empno, ename, e.deptno,
       (SELECT dname FROM dept d WHERE e.deptno = d.deptno)
FROM emp e;

--비상호 연관 서브 쿼리는 실행 순서(메인 쿼리/서브 쿼리)를 성능 측면에서 유리한 쪽 먼저 실행
--(오라클이 선택)

--인라인 뷰 : SELECT QUERY

--실습 subquery3
--직원이 속한 부서의 급여 평균보다 높은 급여를 받는 직원
SELECT *
FROM emp
WHERE sal >= (
              SELECT AVG(sal)
              FROM emp);

SELECT AVG(sal)
FROM emp
WHERE deptno = 30;

SELECT e.empno, e.ename, e.sal, e.deptno
FROM emp e
WHERE e.sal >= (
                SELECT AVG(m.sal)
                FROM emp m
                WHERE e.deptno = m.deptno);

--실습 subquery4
--직원이 속하지 않은 부서 조회
INSERT INTO dept VALUES (99, 'ddit', 'daejeon')
COMMIT;

SELECT *
FROM dept
WHERE 0 = (
           SELECT COUNT(*)
           FROM emp
           WHERE emp.deptno = dept.deptno);

SELECT *
FROM deptno
WHERE deptno NOT IN (
                    SELECT deptno
                    FROM emp);

--실습 subquery5
SELECT *
FROM product
WHERE pid NOT IN (
                  SELECT pid
                  FROM cycle
                  WHERE cid = 1);

