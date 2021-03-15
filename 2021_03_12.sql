--실습 select1-------------------------
SELECT *
FROM lprod;

SELECT buyer_id, buyer_name
FROM buyer

SELECT *
FROM cart

SELECT mem_id, mem_pass, mem_name
FROM member
---------------------------------------

SELECT empno "empno"
FROM emp;

SELECT hiredate, hiredate + 10
FROM emp;

DESC emp;

SELECT ename, sal, sal+comm, comm
FROM emp;

--실습 select2--------------------------------
SELECT prod_id "id", prod_name "name"
FROM prod;

SELECT lprod_gu "gu", lprod_nm "nm"
FROM lprod;

SELECT buyer_id "바이어아이디", buyer_name 이름
FROM buyer;
----------------------------------------------

SELECT empno, 10, Hello World  --컬럼명을 Hello로 인식
FROM emp;

SELECT ename || ', world' || ', 안녕'
FROM emp;

SELECT CONCAT(ename, ', World')
FROM emp;

SELECT '아이디: ' || userid AS "유저아이디 표현방법1",
        CONCAT('아이디: ', userid) AS "유저아이디 표현방법2"
FROM users;

--실습 문자열 결합 sel_con1---------------------
SELECT table_name
FROM user_tables;  --오라클에서 관리하는 테이블

SELECT 'SELECT * FROM ' || table_name || ';' AS "문자열 결합",
        CONCAT('SELECT * FROM ', CONCAT(table_name, ';'))
FROM user_tables;
---------------------------------------------

SELECT *
FROM emp
--부서 번호가 10인 직원들만 조회
WHERE deptno = 20;

SELECT *
FROM users
--userid 컬럼 값이 brown인 사용자만 조회
WHERE userid = 'brown';

{
WHERE userid = brown;  --컬럼으로 생각
WHERE userid = 'BROWN';  --데이터는 대소문자 구분이 필요
}

SELECT *
FROM emp
--부서 번호가 20보다 큰 직원들만 조회
WHERE deptno > 20;

SELECT *
FROM emp
--부서 번호가 20이 아닌 직원들만 조회
WHERE deptno != 20;

SELECT *
FROM emp
WHERE 1=1;  --조건이 모든 행에서 참이므로 모든 행을 조회 가능

SELECT *
FROM emp
WHERE 1=2;  --조건이 모든 행에서 거짓이므로 모든 행을 조회 불가능

--문자열을 날짜 타입으로 변환
SELECT empno, ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1981/03/01', 'YYYY/MM/DD');

