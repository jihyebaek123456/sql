--함수 연습 : 함수 명을 보고
--어떤 파라미터가 들어갈지(유형)
--몇 개의 파라미터가 들어갈지
--반환되는 값은 무엇일지

SELECT INITCAP(ename), LOWER(job), UPPER('test')
FROM emp
ORDER BY ename;

SELECT SUBSTR(ename, 1, 4)  --첫 번째 인덱스부터 세 번째 인덱스까지의 문자 반환
FROM emp;

SELECT SUBSTR(ename, 3)  --세 번째 인덱스부터 끝까지의 문자 반환
FROM emp;

SELECT REPLACE(ename, 'S', 'T')
FROM emp;

SELECT LENGTH('test')  --하나의 정보를 알기 위해 14행을 조회할 필요가 없으니
FROM emp;

SELECT LENGTH('test')  --한 행만 조회
FROM dual;

SELECT LENGTH('test')  --데이터 복제
FROM dual
CONNECT BY LEVEL <= 10;

SELECT *
FROM emp
WHERE LENGTH(ename) > 5;

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith';  --권장 X : LOWER 함수가 14번이나 실행됨

SELECT *
FROM emp
WHERE ename = UPPER('smith');

--Oracle 문자열 함수
SELECT 'Hello' || ', ' || 'world' x,                --문자열 결합
        CONCAT('Hello', ', world') concat,          --문자열 결합 (2개)
        SUBSTR('Hello, world', 1, 5) substr,        --문자열 부분 반환
        LENGTH('Hello, world') length,              --문자열 길이
        INSTR('Hello, world', 'o') instr,           --문자열 찾기
        INSTR('Hello, world', 'o', 6) instr2,       --문자열 찾기 (시작 인덱스 위치 지정)
        LPAD('Hello, world', 15, '*') lpad,         --문자열 확장
        RPAD('Hello, world', 15, '*') rpad,         --문자열 확장
        TRIM('   Hello, world   ') trim,            --공백 제거 (앞뒤만)
        TRIM('d' FROM 'Hello, world') trim2,        --문자열 제거 (앞뒤만)
        REPLACE('Hello, world', 'o', 'x') replace   --문자열 대체
FROM dual;

--Oracle 숫자 함수
SELECT MOD(10, 3) mod,
FROM dual;

SELECT ROUND(105.54, 1) round1,         --반올림(소수 첫째 자리까지)
        ROUND(105.55, 1) round2,        --반올림(소수 첫째 자리까지)
        ROUND(105.55, 0) round3,        --반올림(첫 번째 자리까지)
        ROUND(105.55, -1) round4        --반올림(두 번째 자리까지)
FROM dual;

SELECT TRUNC(105.54, 1) trunc1,         --삭제(소수 첫째 자리까지 표현)
        TRUNC(105.54, 1) trunc2,        --삭제(소수 첫째 자리까지 표현)
        TRUNC(105.54, 0) trunc3,        --삭제(첫 번째 자리까지 표현)
        TRUNC(105.54, -1) trunc4,       --삭제(두 번째 자리까지 표현)
FROM dual;

--문제1
SELECT empno, ename, sal, TRUNC(sal/1000), MOD(sal, 1000)
FROM emp;

--Oracle 날짜 함수
SELECT SYSDATE, SYSDATE + 1/24/60
FROM dual;

--문제1
SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') AS lastday,
        TO_DATE('2019/12/31', 'YYYY/MM/DD') - 5 AS lastday_before5,
        SYSDATE AS now, 
        SYSDATE - 3 AS now_before3
FROM dual;

--날짜를 문자로
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') AS 날짜
FROM dual;

--1년(52~53주) 중 몇주차인지 조회
SELECT TO_CHAR(SYSDATE, 'IW') AS 날짜
FROM dual;

--주간 요일(D) : 요일을 숫자로 표현 (0~6 : 일~토)
SELECT TO_CHAR(SYSDATE, 'D') AS 날짜
FROM dual;

--문제2
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') AS dt_dash,
        TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') AS dt_dash_with_time,
        TO_CHAR(SYSDATE, 'DD-MM-YYYY') AS dt_dd_mm_yyyy
FROM dual;

--병합 가능
SELECT TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'), 'YYYY/MM/DD')
FROM dual;

--'2021-03-17' > '2021-03-17 00:00:00'
SELECT TO_CHAR(TO_DATE('2021-03-17', 'YYYY-MM-DD'), 'YYYY-MM-DD HH24:MI-SS')
FROM dual;

--'2021-03-17' > '2021-03-17 12:41:00'
SELECT TO_CHAR(TO_DATE('2021-03-17' || '12:41:00', 'YYYY-MM-DD HH24:MI-SS'), 'YYYY-MM-DD HH24:MI-SS')
FROM dual;