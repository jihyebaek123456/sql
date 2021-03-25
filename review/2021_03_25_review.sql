EXISTS
-서브 쿼리 연산자
-WHERE절에 기술 > 조회 되는 행이 있으면 true, 아니면 false
--ex. 매니저가 있는 직원
SELECT *
FROM emp e
WHERE EXISTS (
                SELECT *
                FROM emp m
                WHERE e.mgr = m.empno);
--true인 경우 : 조회 되는 행이 있는 경우
SELECT *
FROM emp 
WHERE EXISTS (
              SELECT 'X'  --관습적 표기
              FROM emp 
              WHERE 7698 = empno);
--false인 경우
SELECT *
FROM emp 
WHERE EXISTS (
              SELECT 'X'
              FROM emp 
              WHERE NULL = empno);
--실습
SELECT *
FROM product
WHERE pid IN (
             SELECT pid
             FROM cycle
             WHERE cid = 1)

SELECT *
FROM product
WHERE EXISTS (
              SELECT 'X'
              FROM cycle
              WHERE cid = 1
                AND cycle.pid = product.pid)

# true 발견


집합 연산자 : 데이터(행) 확장
--JOIN : 데이터(열) 확장
--서브 쿼리 : 2개 이상의 쿼리를 1개의 쿼리로 > 조건에 필요한 값들을 유연하게 변경 가능
-UNION : 합집합, 중복 X
-UNION ALL : 합집합, 중복 O
-MINUS : 차집합
-INTERSECT : 교집합

# 위 아래 집합의 컬럼 개수와 타입이 일치해야 실행됨
# 컬럼 명
# ORDER BY


DML (SELECT, INSERT, UPDATE, DELETE)
-INSERT : 데이터 입력
1. 테이블 특정 컬럼에 특정 값 넣기
INSERT INTO 테이블 명 (컬럼 명1, 컬럼 명2, 컬럼 명3, ...)
             VALUES (값1, 값2, 값3, ...);
2. 테이블의 모든 컬럼에 특정 값 넣기
INSERT INTO 테이블 명 VALUES (값1, 값2, 값3, ...);
3. 테이블에 한 번에 여러 값 넣기
INSERT INTO 테이블 명
SELECT 값1, 값2, 값3 FROM dual UNION ALL
SELECT 값1, 값2, 값3 FROM dual 

-UPDATE : 데이터 수정
1.
UPDATE 테이블 명 SET 컬럼 명1 = 값1, 컬럼 명2 = 값2, ...
WHERE 조건

-트랜잭션
-COMMIT & ROLLBACK