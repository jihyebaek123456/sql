--형변환 : 묵시적 vs 명시적
SELECT *
FROM emp
WHERE empno = '7369';

SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD')
FROM dual;

--NULL 함수
SELECT comm,
        NVL(comm, 0) nvl,
        NVL2(comm, sal+comm, sal) nvl2,
        NULLIF(sal, 3000) nullif,
        COALESCE(comm, 0) coalesce
FROM emp;

--조건 분기
SELECT empno, ename, 
        CASE
            WHEN empno < 7500 THEN sal*2
            ELSE sal
        END
FROM emp;

SELECT empno, ename, job, DECODE(job, 'SALESMAN', '1', 'CLERK', '2', 'NOTHING') decode
FROM emp
ORDER BY decode;

--그룹핑
SELECT COUNT(comm), SUM(comm), ROUND(AVG(sal), 1), MAX(sal), MIN(sal)
FROM emp
GROUP BY deptno
HAVING COUNT(comm) > 3
ORDER BY deptno;

--날짜 추가 함수
SELECT MONTHS_BETWEEN(TO_DATE('20100503', 'YYYYMMDD'), TO_DATE('20000503', 'YYYYMMDD')),
        ADD_MONTHS(SYSDATE, 5),
        NEXT_DAY(SYSDATE, 1),
        LAST_DAY(SYSDATE)
FROM dual;