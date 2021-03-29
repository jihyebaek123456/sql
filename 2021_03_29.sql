SELECT ename, job, ROWID
FROM emp
ORDER BY ename, job;

DROP INDEX idx_emp_03;

CREATE INDEX idx_emp_04 ON emp (ename, job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'C%';
 
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT ROWID, dept.*
FROM dept;

CREATE INDEX idx_dept_01 ON dept (deptno);

SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.empno = 7788;

emp 관련 테이블 접근 방법
 1. table full access
 2. idx_emp_01
 3. idx_emp_02
 4. idx_emp_04

dept 관련 테이블 접근 방법
 1. table full access
 2. idx_dept_01

emp (4) -> dept (2) : 8가지 방법
dept(2) -> emp (4) : 8가지 방법         => 총 16가지 방법

 . 응답성(OLTP, Online Transaction Processing)
 . 퍼포먼스(OLAP, Online Analysis Processing)
    ex. 은행 이자 계산
   
--달력 만들기 쿼리
문자열 년월('201905')이 주어짐
해당 년월의 일자를 달력 형태로 출력
--LEVEL은 1부터 시작
SELECT 
       MIN(DECODE(d, 1, dt)) AS sun,  --max, min 둘 중 아무거나 써도 어차피 값은 하나 뿐이기 때문에 상관 X, ⓑ 오라클이 min을 권장
       MIN(DECODE(d, 2, dt)) AS mon,
       MIN(DECODE(d, 3, dt)) AS tue,
       MIN(DECODE(d, 4, dt)) AS wed,
       MIN(DECODE(d, 5, dt)) AS thu,
       MIN(DECODE(d, 6, dt)) AS fri,
       MIN(DECODE(d, 7, dt)) AS sat
FROM (  
        SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1) AS dt,
               TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'D') AS d,
               TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'DD') AS iw
        FROM dual
        CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD')
     )  
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);

SELECT TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD')
FROM dual;


※ 계층 쿼리 : 정렬이 어떻게 되어 있는지 확인
--KING에서 뻗어나가기
SELECT empno, ename, mgr, LEVEL
FROM emp
START WITH empno = 7839
CONNECT BY PRIOR empno = mgr;

--JONES에서 뻗어나가기
SELECT empno, ename, mgr, LEVEL
FROM emp
START WITH empno = 7566
CONNECT BY PRIOR empno = mgr;

--들여쓰기로 보기 좋게 (LPAD)
SELECT LPAD('TEST2', 1*10)
FROM dual;

SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename AS ename, mgr, LEVEL
FROM emp
START WITH empno = 7839
CONNECT BY PRIOR empno = mgr;

KING의 사번 = mgr 컬럼의 값이 KING의 사번인 직원
empno = mgr

PRIOR - 이전의, 사전의, 이미 읽은 데이터
이미 읽은 데이터          앞으로 읽어야 할 데이터
  KING의 사번   =   mgr 컬럼의 값이 KING의 사번인 직원

CONNECT BY - 내가 읽은 행의 사번과 - 앞으로 읽을 행의 mgr 컬럼

--조합
CONNECT BY PRIOR empno = mgr;       --CONNECT BY와 PRIOR는 한 세트 X, PRIOR는 컬럼과 함께 사용되는 것

※ 계층쿼리 방향에 따른 분류
상향식 : 아래서 위로 뻗어나가는, 최하위 노드(leaf node)에서 자신의 부모를 방문하는 형태
하향식 : 위에서 아래로 뻗어나가는, 최상위 노드(root node)에서 모든 자식 노드를 방문하는 형태
상향식 vs 하향식 > 조회 되는 건수가 다름
KING에서 시작 : 14건
SMITH에서 시작 : 4건

--SMITH에서 뻗어나가기
SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename AS ename, mgr, LEVEL
FROM emp
START WITH empno = 7369
CONNECT BY PRIOR mgr = empno;

SELECT *
FROM dept_h;

--최상위 노드부터 리프 노드까지 탐색하는 계층 쿼리 작성
--하향식 실습 h_1
SELECT LEVEL AS lv, LPAD(' ', (LEVEL-1)*4) || deptnm AS deptnm
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;

--하향식 실습 h_2
SELECT LEVEL AS lv,
       deptcd,
       LPAD(' ', (LEVEL-1)*4) || deptnm AS deptnm,
       p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;


※ oracle의 계층 쿼리 탐색 순서 : pre-order
(In-order, Post-order, Pre-order, Level-order)

--상향식 실습 h_3
SELECT deptcd,
       LPAD(' ', (LEVEL-1)*4) || deptnm AS deptnm,
       p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY deptcd = PRIOR p_deptcd;

--실습 h_4
SELECT *
FROM h_sum;

SELECT LPAD(' ', (LEVEL-1)*4) || s_id AS s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

※ 인덱스 컬럼은 비교되기 전에 변형이 일어나면 사용할 수 없음
    ex. s_id로 인덱스를 만들었는데, TO_NUMBER(s_id)를 이용하면 인덱스를 사용할 수 없음
        s_id가 문자열 유형이면 s_id = '0'으로 해줘야 함