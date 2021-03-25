--함수
--single row function (SELECT, WHERE절 사용)
--multi row function (SELECT절 사용)

--dual table
SELECT *
FROM dual;

--문자 함수
SELECT UPPER('test'),
        LOWER('TEST'),
        INITCAP('test'),
        CONCAT('hello', ', world'),
        SUBSTR('hello, world', 2, 5),
        LENGTH('hello, world'),
        INSTR('hello, world', 'l'),
        LPAD('hello, world', 20, '*'),
        RPAD('hello, world', 20, '*'),
        TRIM('    hello, world    '),
        REPLACE('hello, world', 'l', 'r')
FROM dual;

--숫자 함수
SELECT MOD(234, 17),
        ROUND(83.56, 1),
        TRUNC(342.34, 1)
FROM dual;

--날짜 함수
SELECT TO_DATE('20190317 09:30:05', 'YYYY/MM/DD HH24:MI:SS')
FROM dual;

SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS'),
        TO_CHAR(SYSDATE, 'IW') || '주차',
        TO_CHAR(SYSDATE, 'D') || '요일'
FROM dual;