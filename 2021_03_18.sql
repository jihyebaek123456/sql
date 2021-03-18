--ex. 근속년수, 근속월수 셀 때
SELECT ename,
        hiredate AS hiredate1,
        TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') AS hiredate2,
        MONTHS_BETWEEN(sysdate, hiredate) AS months_between
FROM emp;

SELECT hiredate,
        ADD_MONTHS(hiredate, 3) AS add_months1,
        ADD_MONTHS(TO_DATE('2021-03-08', 'YYYY/MM/DD'), -3) AS add_months2
FROM emp;

--시분초 날리기!
SELECT TO_CHAR(TO_DATE('2021-03-17', 'YYYY-MM-DD'), 'YYYY-MM-DD HH24:MI-SS')
FROM dual;

--특정 시간으로 고정
SELECT TO_CHAR(TO_DATE('2021-03-17' || '23:59:59', 'YYYY-MM-DD HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS')
FROM dual;

SELECT SYSDATE,
        NEXT_DAY(SYSDATE, 2) AS next_day
FROM dual;

SELECT SYSDATE,
        LAST_DAY(SYSDATE) AS last_day
FROM dual;

--1일 구하기
SELECT TO_DATE(TO_CHAR(SYSDATE, 'YYYY/MM') || '01', 'YYYY/MM/DD')
FROM dual;

--date 종합 실습 fn3ㅁ
SELECT :YYYYMM AS param,
        TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD') AS dt
FROM dual;

--묵시적 형변환
SELECT *
FROM emp
WHERE empno = '7369';  --숫자 = 문자

--명시적 형변환
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM emp
WHERE empno = TO_NUMBER('7369');

--숫자 format (formatting을 많이 사용하지는 않음~)
--L : 화폐 단위(사용자 지역) / 0 : 0으로 채우기 / 9 : 숫자 / , : 천 단위 / . : 소수점 자리
SELECT ename, sal, TO_CHAR(sal, 'L0009,999.00') AS fm_sal
FROM emp;

--NULL 함수
SELECT empno, ename, NVL(comm, 0) AS comm
FROM emp;

SELECT empno, ename, sal + NVL(comm, 0) 
FROM emp;

SELECT NVL2(comm, comm+sal, sal)
FROM emp;

SELECT *
FROM emp;

SELECT empno, NULLIF(sal, 1250)
FROM emp;

SELECT empno, sal, comm, COALESCE(comm, 0)
FROM emp;

--null 실습 fn2
SELECT empno, ename, mgr,
        NVL(mgr, 9999) AS mgr_n,
        NVL2(mgr, mgr, 9999) AS mgr_n_1,
        COALESCE(mgr, 9999) AS mgr_n_2
FROM emp;

--null 실습 fn5
SELECT userid, usernm,
        TO_CHAR(reg_dt, 'YYYY/MM/DD') AS reg_dt,
        TO_CHAR(NVL(reg_dt, SYSDATE), 'YYYY/MM/DD') AS n_reg_dt
FROM users
WHERE userid IN ('brown', 'cony', 'sally', 'james');

--조건 분기
SELECT ename, job, sal AS sal1,
        CASE
            WHEN job='SALESMAN' THEN sal*1.05
            WHEN job='MANAGER' THEN sal*1.1
            WHEN job='PRESIDENT' THEN sal*1.2
            ELSE sal
        END AS sal2
FROM emp;

SELECT ename, job, sal AS sal1,
        DECODE(job, 'SALESMAN', sal*1.05, 'MANAGER', sal*1.1, 'PRESIDENT', sal*1.2, sal) AS sal2
FROM emp;

--condition 실습 cond1
SELECT empno, ename, DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT') AS dname
FROM emp;

SELECT empno, ename, 
        CASE
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            WHEN deptno = 40 THEN 'OPERATIONS'
            ELSE 'DDIT'
        END AS dname
FROM emp;

--condition 실습 cond2
SELECT empno, ename, TO_CHAR(hiredate, 'YYYY/MM/DD') AS hiredate,
        CASE
            WHEN 
                MOD(TO_NUMBER(TO_CHAR(hiredate, 'YYYY')), 2)
                = MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')), 2) THEN '건강검진 대상자'
            ELSE '건강검진 비대상자'
        END AS contact_to_doctor
FROM emp;

--condition 실습 cond3
SELECT userid, usernm, TO_CHAR(reg_dt, 'YYYY/MM/DD'),
        CASE
            WHEN MOD(TO_CHAR(reg_dt, 'YYYY'), 2) = MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) THEN '건강검진 대상자'
            ELSE '건강검진 비대상자'
        END AS contact_to_doctor
FROM users
WHERE usernm IN ('브라운', '코니', '샐리', '제임스', '문');

--그룹 함수
SELECT deptno AS 부서번호,
        COUNT(sal) AS 갯수,
        SUM(sal) AS 합계,
        ROUND(AVG(sal), 2) AS 평균,
        MAX(sal) AS 최댓값,
        MIN(sal) AS 최솟값,
FROM emp
GROUP BY deptno
ORDER BY deptno;

SELECT COUNT(*), SUM(sal), ROUND(AVG(sal),2), MAX(sal), MIN(sal)
FROM emp;

SELECT COUNT(mgr),
        COUNT(*)
FROM emp
GROUP BY deptno
ORDER BY deptno;

SELECT empno, COUNT(*)  --empno가 에러
FROM emp
GROUP BY deptno
ORDER BY deptno;

SELECT deptno, empno, COUNT(*)  --해결은 했지만..
FROM emp
GROUP BY deptno, empno
ORDER BY deptno;

SELECT 'test', COUNT(*)
FROM emp
GROUP BY deptno
ORDER BY deptno;

SELECT deptno, SUM(comm)
FROM emp
GROUP BY deptno
ORDER BY deptno;

SELECT deptno,
        NVL(SUM(comm), 0),  --효율적
        SUM(NVL(comm, 0))   --비효율적
FROM emp
GROUP BY deptno
ORDER BY deptno;

SELECT deptno,
        NVL(SUM(comm), 0),
        SUM(NVL(comm, 0))
FROM emp
GROUP BY deptno
HAVING COUNT(*) >= 4
ORDER BY deptno;

--group function 실습 grp1
SELECT MAX(sal),
        MIN(sal),
        ROUND(AVG(sal), 2),
        SUM(sal),
        COUNT(sal),
        COUNT(mgr),
        COUNT(*)
FROM emp
GROUP BY deptno;