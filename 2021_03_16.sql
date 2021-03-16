--직원의 이름이 ALLEN이면서 담당 업무가 SALESMAN이거나
--직원의 이름이 SMITH인 직원 정보 조회
SELECT *
FROM emp
WHERE ename = 'SMITH'  OR  ename = 'ALLEN' AND job = 'SALESMAN';
--          1           +        2          *      3

--직원 이름이 SMITH이거나 ALLEN이면서
--담당 업무가 SALESMAN인 직원 정보 조회
SELECT *
FROM emp
WHERE (ename = 'SMITH'  OR  ename = 'ALLEN') AND job = 'SALESMAN';
--           1           +        2           *      3

--AND, OR 실습 where14
SELECT *
FROM emp
WHERE job = 'SALESMAN'
      OR (empno LIKE '78%'
          AND hiredate >= TO_DATE('19810601', 'YYYYMMDD'));

--데이터 정렬
--job을 오름차순으로 정렬
SELECT *
FROM emp
ORDER BY job;

--job이 같으면 sal을 오름차순으로 정렬
SELECT *
FROM emp
ORDER BY job, sal;

--job을 오름차순으로 정렬하고, job이 같으면 sal을 내림차순으로 정렬
SELECT *
FROM emp
ORDER BY job, sal DESC;

--SELECT 절의 컬럼 순서로 정렬 가능
SELECT *
FROM emp
ORDER BY 2;

--다른 결과 ( -> 추천하지 않는 방식~)
SELECT ename, job, mgr
FROM emp
ORDER BY 2;

--ALIAS로 정렬 가능
SELECT ename, job, mgr AS m
FROM emp
ORDER BY m;

--ORDER BY 실습 orderby1
SELECT *
FROM dept
ORDER BY dname;

SELECT *
FROM dept
ORDER BY loc DESC;

--ORDER BY 실습 orderby2
SELECT *
FROM emp
WHERE comm IS NOT NULL AND comm != 0
ORDER BY comm DESC, empno DESC;

SELECT *
FROM emp
WHERE comm > 0
ORDER BY comm DESC, empno DESC;

--ORDER BY 실습 orderby3
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

--ORDER BY 실습 orderby4
SELECT *
FROM emp
WHERE deptno IN (10, 30) AND sal > 1500
ORDER BY ename DESC;

--페이징 처리 (게시글)
--페이징 처리 시 필요한 키워드
--ROWNUM : 행에 번호 부여
SELECT ROWNUM, empno, ename
FROM emp;

--ROWNUM (WHERE절에서 사용)
--전체 데이터 : 14건 / 페이지 사이즈 : 5건
--첫 번째 페이지 : 1 ~ 5 / 두 번째 페이지 : 6 ~ 10 / 세 번째 페이지 : 11 ~ 15(14)
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 6 AND 10;  --조회 불가

WHERE ROWNUM BETWEEN 1 AND 5 : 조회 가능
WHERE ROWNUM BETWEEN 6 AND 10 : 조회 불가
WHERE ROWNUM BETWEEN 1 AND 10 : 조회 가능
WHERE ROWNUM = 1 : 조회 가능
WHERE ROWNUM = 2 : 조회 불가
WHERE ROWNUM < 10 : 조회 가능
WHERE ROWNUM > 10 : 조회 불가

--SQL 실행 순서 : FROM - SELECT - ORDER BY
SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;

--페이징 처리 (게시글)
--페이징 처리 시 필요한 키워드
--인라인 뷰

--괄호 안을 하나의 테이블로 인식
(SELECT empno, ename
 FROM emp)

SELECT *
FROM (SELECT empno, ename
      FROM emp);

SELECT ename
FROM (SELECT empno, ename
      FROM emp);

SELECT job  --조회 불가!
FROM (SELECT empno, ename
      FROM emp);

--순서 정렬 완료 -> 인라인 뷰가 필요한 이유
SELECT ROWNUM, empno, ename
FROM (SELECT empno, ename
      FROM emp
      ORDER BY ename);
      
--두 번째 페이지 조회 완료 -> ALIAS가 필요한 이유
--WHERE절에서 ROWNUM을 써버리면 괄호 안의 ROWNUM을 인식하는 것 X
--가장 첫 번째 줄의 SELECT에서 ROWNUM을 찾음
--괄호 안의 ROWNUM에 ALIAS를 부여해서 인식
SELECT *
FROM (SELECT ROWNUM AS rn, empno, ename
      FROM (SELECT empno, ename
            FROM emp
            ORDER BY ename))
WHERE rn BETWEEN 11 AND 15;            
WHERE rn BETWEEN 6 AND 10;
WHERE rn BETWEEN 1 AND 5;

--페이지 사이즈 : 5건
1 page : rn BETWEEN 1 AND 5
2 page : rn BETWEEN 6 AND 10
...
n page : rn BETWEEN 5 * (n-1)+1 AND 5 * n

--페이지 사이즈 : pageSize건
--n, pageSize를 변수로 사용
1 page : rn BETWEEN 1 AND 5
2 page : rn BETWEEN 6 AND 10
...
n page : rn BETWEEN pageSize * (n-1) + 1 AND pageSize * n

--변수 선언
SELECT *
FROM (SELECT ROWNUM AS rn, empno, ename
      FROM (SELECT empno, ename
            FROM emp
            ORDER BY ename))
WHERE rn BETWEEN :pageSize * (:n-1) + 1 AND :pageSize * :n

--가상컬럼 ROWNUM 실습 row_1
SELECT ROWNUM AS rn, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 10;

--가상컬럼 ROWNUM 실습 row_2
SELECT *
FROM (
         SELECT ROWNUM AS rn, empno, ename
         FROM emp
     )
WHERE rn BETWEEN 11 AND 20;

--가상컬럼 ROWNUM 실습 row_3
SELECT *
FROM (
        SELECT ROWNUM AS rn, empno, ename
        FROM (
             SELECT empno, ename
             FROM emp
             ORDER BY ename
             )
     )
WHERE rn BETWEEN 11 AND 20;

--*을 다른 컬럼명과 동시 사용
SELECT ROWNUM, emp.*
FROM emp;

--TABLE에 ALIAS 부여
SELECT *
FROM emp e;

SELECT ROWNUM, e.*
FROM emp e;

SELECT a.*
FROM (
        SELECT ROWNUM AS rn, empno, ename
        FROM (
             SELECT empno, ename
             FROM emp
             ORDER BY ename
             )
     ) a
WHERE rn BETWEEN 11 AND 20;

