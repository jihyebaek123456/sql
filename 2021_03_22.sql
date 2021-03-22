--실습 join1
SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod, lprod
WHERE prod_lgu = lprod_gu
ORDER BY lprod_gu, prod_id;

--실습 join2
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer, prod
WHERE buyer_id = prod_buyer
ORDER BY buyer_id, prod_id;

--실습 join3
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
WHERE mem_id = cart_member AND cart_prod = prod_id;

SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member JOIN cart ON mem_id = cart_member
            JOIN prod ON prod_id = cart_prod;

--실습 join4
SELECT customer.cid, cnm, pid, day, cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
    AND cnm IN ('brown', 'sally');

--실습 join5
SELECT customer.cid, cnm, cycle.pid, pnm, day, cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
    AND cycle.pid = product.pid
    AND cnm IN ('brown', 'sally');

--실습 join6
SELECT customer.cid, cnm, product.pid, pnm, SUM(cnt)
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
    AND cycle.pid = product.pid
GROUP BY product.pid, pnm, customer.cid, cnm;

--실습 join7
SELECT product.pid, pnm, SUM(cnt)
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY product.pid, pnm;

--직원의 이름, 직원의 상사 이름 두 개의 컬럼이 나오도록 join query 작성
SELECT e.ename AS emp, m.ename AS mgr
FROM emp e, emp m
WHERE e.mgr = m.empno;

--OUTER JOIN
SELECT e.ename AS emp, m.ename AS mgr
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

SELECT e.ename AS emp, m.ename AS mgr
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

SELECT e.ename AS emp, m.ename AS mgr, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno AND m.deptno = 10);

SELECT e.ename AS emp, m.ename AS mgr, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
WHERE m.deptno = 10;

SELECT e.ename AS emp, m.ename AS mgr, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
    AND m.deptno = 10;

SELECT e.ename AS emp, m.ename AS mgr, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
    AND m.deptno(+) = 10;

SELECT e.ename AS emp, m.ename AS mgr, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

--결과 예측 해보기
SELECT e.ename AS emp, m.ename AS mgr, m.deptno
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno);

SELECT e.ename AS emp, m.ename AS mgr
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

--실습 OUTER JOIN1
--모든 제품을 다 보여주고, 실제 구매가 있을 때는 구매 수량을, 없을 경우는 null을 조회
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM prod LEFT OUTER JOIN buyprod
    ON (buy_prod = prod_id
        AND buy_date = TO_DATE('05/01/25', 'RR/MM/DD'));

--행 갯수가 같아야 함 (왜?)
SELECT COUNT(*)
FROM prod;

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM prod, buyprod
WHERE buy_prod(+) = prod_id
        AND buy_date(+) = TO_DATE('05/01/25', 'RR/MM/DD');