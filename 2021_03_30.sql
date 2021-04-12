SELECT dt, d, DECODE(d, 1, iw+1, iw)
FROM (
        SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1) AS dt,
                       TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'D') AS d,
                       TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'IW') AS iw
        FROM dual
        CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD')
     )

SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1) AS dt,
       TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'D') AS d,
       ROWNUM
FROM dual
WHERE TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'D') = 1        
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD')


SQL 실행 순서
FROM > START WITH > WHERE > GROUP BY > SELECT > ORDER BY


가지치기 (Pruning branch)
계층 쿼리에 조건 넣기 (두 가지 쿼리 비교)
--12건
SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename AS ename, mgr, deptno, job, LEVEL
FROM emp
WHERE job != 'ANALYST'
START WITH mgr IS NULL
CONNECT BY mgr = PRIOR empno;
--10건
SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename AS ename, mgr, deptno, job, LEVEL
FROM emp
START WITH mgr IS NULL
CONNECT BY mgr = PRIOR empno AND job != 'ANALYST';


계층 쿼리 특수 함수
SELECT LPAD(' ', (LEVEL-1)*4) || ename AS ename, CONNECT_BY_ROOT(ename) AS root_ename
FROM emp
START WITH mgr IS NULL
CONNECT BY mgr = PRIOR empno;

SELECT LPAD(' ', (LEVEL-1)*4) || ename AS ename,
       CONNECT_BY_ROOT(ename) AS root_ename,
       LTRIM(SYS_CONNECT_BY_PATH(ename, '-'), '-') AS path_ename,
       CONNECT_BY_ISLEAF AS isleaf
FROM emp
START WITH mgr IS NULL
CONNECT BY mgr = PRIOR empno;


계층 쿼리 실습
SELECT *
FROM board_test;
--계층 쿼리 정렬
SELECT seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title AS title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC;

# 시작(root) 글은 작성 순서의 역순으로
# 답글은 시간 순서대로
# 시작글부터 관련 답글까지 그룹 번호를 부여하기 위해 새로운 컬럼 추가

ALTER TABLE board_test ADD (gn NUMBER);

DESC board_test;

UPDATE board_test SET gn = 1
WHERE seq IN (1, 9);

UPDATE board_test SET gn = 2
WHERE seq IN (2, 3);

UPDATE board_test SET gn = 4
WHERE seq NOT IN (1, 2, 3, 9);

COMMIT;

SELECT gn, seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title AS title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq ASC

SELECT *
FROM (
        SELECT CONNECT_BY_ROOT(seq) AS root_seq, seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title AS title
        FROM board_test
        START WITH parent_seq IS NULL
        CONNECT BY PRIOR seq = parent_seq
     )
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY root_seq DESC, seq ASC

--페이징 처리까지
SELECT *
FROM (
        SELECT ROWNUM AS rn, a.*
        FROM (
                SELECT title
                FROM (
                        SELECT CONNECT_BY_ROOT(seq) AS root_seq, seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title AS title
                        FROM board_test
                        START WITH parent_seq IS NULL
                        CONNECT BY PRIOR seq = parent_seq
                     )
                ORDER BY root_seq DESC, seq ASC
             ) a
     )
WHERE rn BETWEEN :pageSize * (:page - 1) + 1 AND :pageSize * :page;

SELECT ename
FROM emp 
WHERE sal = (
              SELECT MAX(sal)
              FROM emp
              WHERE deptno = 10);
   AND deptno = 10;
  

분석 함수 (window 함수)
SELECT ename2, sal2, deptno2, SUM(bs)+1
FROM (
    SELECT ename2, deptno2, sal2,
           CASE
            WHEN sal1 < sal2 THEN 0
            WHEN sal1 = sal2 THEN 0
            ELSE 1
           END AS bs
    FROM (
            SELECT e.ename AS ename1, m.ename AS ename2,
                   e.deptno AS deptno1, m.deptno AS deptno2,
                   e.sal AS sal1, m.sal AS sal2
            FROM emp e, emp m
            WHERE e.deptno = m.deptno AND e.ename != m.ename
            ORDER BY e.deptno, m.ename
         ) etable
    )
GROUP BY ename2, sal2, deptno2
ORDER BY deptno2, SUM(bs)+1

SELECT ename, sal, deptno, RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS sal_rank
FROM emp
"ORDER BY deptno, sal DESC;"

SELECT a.ename, a.sal, a.deptno, b.rank
FROM 
    (
    SELECT a.*, ROWNUM rn
    FROM 
        (
         SELECT ename, sal, deptno
         FROM emp
         ORDER BY deptno, sal DESC) a ) a,
        
    (
    SELECT ROWNUM rn, rank
    FROM 
        (
        SELECT a.rn rank
        FROM
            (
             SELECT ROWNUM rn
             FROM emp) a,
             
            (
             SELECT deptno, COUNT(*) cnt
             FROM emp
             GROUP BY deptno
             ORDER BY deptno) b
        WHERE a.rn <= b.cnt
        ORDER BY b.deptno, a.rn)) b
WHERE a.rn = b.rn;


순위 관련 분석 함수
SELECT ename, sal, deptno,
       RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS sal_rank,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS sal_dense_rank,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) AS sal_row_number
FROM emp


--window 함수 실습 ana1
SELECT empno, ename, sal, deptno,
       RANK() OVER (ORDER BY sal DESC, empno) AS sal_rank,
       DENSE_RANK() OVER (ORDER BY sal DESC, empno) AS sal_dense_rank,
       ROW_NUMBER() OVER (ORDER BY sal DESC, empno) AS sal_row_number
FROM emp

--window 함수 실습 no_ana2
SELECT e.empno, e.ename, e.deptno, m.cnt
FROM emp e,
    (SELECT deptno, COUNT(*) AS cnt
     FROM emp
     GROUP BY deptno) m
WHERE e.deptno = m.deptno
ORDER BY e.deptno

SELECT empno, ename, deptno,
       COUNT(*) OVER (PARTITION BY deptno) AS cnt
FROM emp
엄청 쉬워지네..