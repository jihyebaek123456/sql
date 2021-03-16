--BETWEEN AND
--부서 번호가 10번에서 20번 사이에 속한 직원들만 조회
SELECT *
FROM emp
WHERE deptno BETWEEN 10 AND 20;

--emp 테이블에서 급여(sal)가 1000보다 크거나 같고 2000보다 작거나 같은 직원들만 조회
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000 AND deptno = 10;

--BETWEEN AND 실습 where1
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('19820101', 'YYYYMMDD')
                   AND TO_DATE('19830101', 'YYYYMMDD');

SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD')
      AND hiredate <= TO_DATE('19830101', 'YYYYMMDD');


--IN
--부서 번호가 10이나 20이면 true
SELECT *
FROM emp
WHERE deptno IN (10, 20);

SELECT *
FROM emp
WHERE deptno = 10 OR deptno = 20;

SELECT *
FROM emp
WHERE 10 IN (10, 20);  --10은 10과 같거나 10은 20과 같다 (전자는 true or 후자는 false)


--NOT IN
--직원의 부서 번호가 30번이 아닌 직원 조회
SELECT * 
FROM emp
WHERE deptno NOT IN (30);

SELECT *
FROM emp
WHERE deptno != 30;

SELECT *
FROM emp
WHERE mgr IN (7698, 7839, NULL);
      mgr = 7698 OR mgr = 7839 OR < mgr = NULL >  --<오류가 발생하는 부분>

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839, NULL);
      NOT (mgr = 7698  OR  mgr = 7839  OR  mgr = NULL)
           mgr != 7698 AND mgr != 7839 AND mgr != NULL

SELECT *
FROM emp
WHERE mgr IN (7698, 7839);

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839);

--IN 실습 where3
SELECT userid AS "아이디", usernm AS "이름", alias AS "별명"
FROM users
WHERE userid IN ('brown', 'cony', 'sally');
--    userid = 'brown' OR userid = 'cony' OR userid = 'sally'


--LIKE
--게시글 : 제목 검색, 내용 검색
--        제목에 [맥북에어]가 들어가는 게시글만 조회 (얼마 안 된 맥북에어 팔아요, 맥북에어 팔아요)
--유저 아이디가 c로 시작하는 모든 사용자 조회 
SELECT *
FROM users
WHERE userid LIKE 'c%';

--유저 아이디가 c로 시작하면서 c 이후에 3개의 글자가 오는 모든 사용자 조회 
SELECT *
FROM users
WHERE userid LIKE 'c___';

--유저 아이디에 l가 포함되는 모든 사용자 조회 
SELECT *
FROM users
WHERE userid LIKE '%l%';

--NOT LIKE
SELECT * 
FROM emp
WHERE ename NOT LIKE 'S%';

--LIKE, %, _ 실습 where4
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

--LIKE, %, _ 실습 where5
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';

--테이블명-게시글, 제목 컬럼-제목, 내용 컬럼-내용 / 맥북에어 검색
SELECT *
FROM 게시글
WHERE 제목 LIKE '%맥북에어%' OR 내용 LIKE '%맥북에어%';


--IS (NULL 비교)
--emp 테이블에서 comm 컬럼의 값이 NULL인 사람만 조회
SELECT *
FROM emp
WHERE comm IS NOT NULL;

--emp 테이블에서 매니저가 없는 직원만 조회
SELECT *
FROM emp
WHERE mgr IS NULL;


--논리 연산자
--emp 테이블에서 mgr의 사번이 7698이면서 sal 값이 1000보다 큰 직원만 조회
SELECT *
FROM emp
WHERE mgr = 7698 AND sal > 1000;  --순서 무관

--emp 테이블에서 mgr의 사번이 7698이거나 sal 값이 2000보다 큰 직원만 조회
SELECT *
FROM emp
WHERE mgr = 7698 OR sal > 2000;

--AND, OR 실습 where7
SELECT *
FROM emp
WHERE job = 'SALESMAN' AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

--AND, OR 실습 where8
SELECT *
FROM emp
WHERE deptno != 10 AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

--AND, OR 실습 where9
SELECT *
FROM emp
WHERE deptno NOT IN (10) AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

--AND, OR 실습 where10
SELECT *
FROM emp
WHERE deptno IN (20, 30) AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

--AND, OR 실습 where11
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR hiredate >= TO_DATE('19810601', 'YYYYMMDD');

--AND, OR 실습 where12
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%';  --LIKE는 문자열 매칭 -> 숫자를 문자로 자동 형변환하여 매칭

--AND, OR 실습 where13
SELECT *
FROM emp
WHERE job = 'SALESMAN'
    OR empno BETWEEN 7800 AND 7899
    OR empno BETWEEN 780 AND 789
    OR empno = 78;