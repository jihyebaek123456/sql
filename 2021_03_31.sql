--window 함수 실습 ana2
SELECT empno, ename, sal, deptno,
       --해당 직원이 속한 부서의 급여 평균
       ROUND(AVG(sal) OVER (PARTITION BY deptno), 2) AS avg_sal,
       --해당 직원이 속한 부서의 최소 급여
       MIN(sal) OVER (PARTITION BY deptno) AS min_sal,
       --해당 직원이 속한 부서의 최대 급여
       MAX(sal) OVER (PARTITION BY deptno) AS max_sal,
       --해당 직원이 속한 부서의 급여 합
       SUM(sal) OVER (PARTITION BY deptno) AS sum_sal,
       --해당 직원이 속한 부서의 직원 수
       COUNT(*) OVER (PARTITION BY deptno) AS cnt
FROM emp;


※ 분석 함수 LAG, LEAD
SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC;

--자신보다 급여 순위가 한 단계 낮은 사람의 급여를 5번째 컬럼으로 생성
SELECT empno, ename, hiredate, sal, LEAD(sal) OVER (ORDER BY sal DESC, hiredate) AS lead_sal
FROM emp;
"ORDER BY sal DESC;"

--window 함수 실습 ana5
--전체 사원 중 급여 순위가 1단계 높은 사람의 급여 조회
SELECT empno, ename, hiredate, sal,
       LAG(sal) OVER(ORDER BY sal DESC, hiredate) AS lag_sal
FROM emp;

--window 함수 실습 ana5_1
--전체 사원 중 급여 순위가 1단계 높은 사람의 급여 조회
SELECT a.empno, a.ename, a.hiredate, a.sal, b.sal
FROM
(
SELECT a.*, ROWNUM AS rn
FROM (
        SELECT empno, ename, hiredate, sal
        FROM emp
        ORDER BY sal DESC, hiredate
      ) a
) a,
(
SELECT a.*, ROWNUM AS rn
FROM (
        SELECT empno, ename, hiredate, sal
        FROM emp
        ORDER BY sal DESC, hiredate
      ) a
) b
WHERE a.rn - 1 = b.rn(+)
ORDER BY b.sal DESC, a.hiredate;

--window 함수 실습 ana6
--담당 업무 별 급여 순위가 1단계 높은 사람의 급여 조회
SELECT empno, ename, hiredate, job, sal,
       LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp;


※ LAG, LEAD 의 두 번째 인자

--window 함수 실습 no_ana3
--우선 순위가 가장 낮은 사람부터 본인 까지의 급여 합 조회
SELECT a.empno, a.ename, a.sal, SUM(b.sal) c_sum
FROM ( SELECT a.*, ROWNUM AS rn
       FROM (
             SELECT empno, ename, sal
             FROM emp
             ORDER BY sal
            ) a ) a,
    ( SELECT a.*, ROWNUM AS rn
      FROM (
            SELECT empno, ename, sal
            FROM emp
            ORDER BY sal
           ) a ) b
WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal
ORDER BY a.sal;

분석 함수 WINDOWING
SELECT empno, ename, sal,
       --명확하게 하기 위해 길게 쓰는 것이 좋음
       SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS c_sum,
       SUM(sal) OVER (ORDER BY sal, empno ROWS UNBOUNDED PRECEDING) AS c_sum
FROM emp
ORDER BY sal, empno;


SELECT empno, ename, sal,
       --명확하게 하기 위해 길게 쓰는 것이 좋음
       SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS c_sum
FROM emp
ORDER BY sal, empno;

--window 함수 실습 ana7
--부서별로 급여, 사원 번호 오름차순 정렬 했을 때 자신의 급여와 선행하는 사원들의 급여 합 조회
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS c_sum
FROM emp;


분석 함수 WINDOWING의 ROWS vs RANGE
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) AS rows_c_sum,
       SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) AS range_c_sum,
       SUM(sal) OVER (ORDER BY sal) AS no_win_c_sum,        --기본은 RANGE UNBOUNDED PRECEDING!
       SUM(sal) OVER () AS no_ord_c_sum
FROM emp;