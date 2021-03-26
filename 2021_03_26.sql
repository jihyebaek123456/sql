--UPDATE
--9999 사번을 갖는 brown 직원을 입력
INSERT INTO emp (empno, ename) VALUES (9999, 'brown');

DESC emp;
SELECT * FROM emp;

--9999 사번을 갖는 직원의 deptno와 job 정보를 SMITH 사원의 deptno, job 정보로 업데이트
UPDATE emp SET deptno = (SELECT deptno FROM emp WHERE ename = 'SMITH'),
               job = (SELECT job FROM emp WHERE ename = 'SMITH')
WHERE empno = 9999;


--DELETE
DELETE emp
WHERE ename = 'brown';

ROLLBACK;


--UNDO log
CREATE TABLE emp_test AS
SELECT *
FROM emp;

ROLLBACK;

SELECT *
FROM emp_test;

TRUNCATE TABLE emp_test;

ROLLBACK;


--TRANSACTION


--인덱스
--테이블에는 순서가 없음
-- > 데이터 조회를 위해서는 테이블을 처음부터 끝까지, 만족하는 데이터를 찾을 때까지 검색
-- > 데이터 양이 많아질수록 소요되는 시간도 많아짐
--인덱스가 있으면
-- > 빠르게 접근 가능
SELECT ROWID, emp.*
FROM emp;

--14건의 데이터를 모두 조회한 뒤 결과를 출력
SELECT emp.*
FROM emp
WHERE empno = 7369;

--정렬이 되어 있으면 데이터를 빠르게 찾아내고 출력
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);
--DBMS_XPLAN : 패키지, 기능들을 묶어 놓음
--DISPLAY : 반환해줌
--TABLE : 테이블로 만들어 줌
--조회 시 TABLE ACCESS FULL이 뜨면 테이블을 다 읽었다는 것 = 비효율적이라는 것

--인덱스 생성
--empno를 기준으로 정렬한 인덱스 생성
CREATE UNIQUE INDEX PK_emp ON emp (empno);

--인덱스를 이용해서 데이터 조회
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

--인덱스 삭제
DROP INDEX pk_emp;
CREATE INDEX IDX_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);
--UNIQUE : 1개만 읽음 (중복이 허용되지 않기 때문에)
--RANGE : 범위를 읽음 (중복이 허용되기 때문에)
--ex. 데이터 정렬 : 7782 - 7783 - 7785 (7782 다음에 7782보다 큰 값이 왔으니 종료)
--              : 7782 - 7782 - 7783 (중복 된 7782를 다 읽고 나서 더 큰 값이 오면 종료)

--job 컬럼에 인덱스 생성
CREATE INDEX IDX_emp_02 ON emp (job);

SELECT job, ROWID
FROM emp
ORDER BY job;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'C%';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

CREATE INDEX IDX_emp_03 ON emp (job, ename);

SELECT job, ename, ROWID
FROM emp
ORDER BY job, ename;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'C%';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE '%C';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);