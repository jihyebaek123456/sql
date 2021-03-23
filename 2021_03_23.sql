--월 별 실적
                반도체     핸드폰     냉장고
2021년 1월 :     500       300       400
2021년 2월 :     400    NULL -> 0    200
        
--실습 OUTER JOIN2
SELECT TO_DATE(:YYMMDD, 'YYMMDD'), buy_prod, prod_id, prod_name, buy_qty
FROM prod, buyprod
WHERE buy_prod(+) = prod_id
        AND buy_date(+) = TO_DATE(:YYMMDD, 'YYMMDD');
        
--실습 OUTER JOIN3
SELECT buy_date, buy_prod, prod_id, prod_name, NVL(buy_qty, 0)
FROM prod, buyprod
WHERE buy_prod(+) = prod_id
        AND buy_date(+) = TO_DATE(:YYMMDD, 'YYMMDD');
        
--실습 OUTER JOIN4
SELECT product.pid, pnm, :cid, NVL(day, 0) AS day, NVL(cnt, 0) AS cnt
FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cid = :cid);

--실습 OUTER JOIN5 : 고객 이름 컬럼 추가 (4개 비교)
SELECT product.pid, pnm, :cid, cnm, NVL(day, 0) AS day, NVL(cnt, 0) AS cnt
FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cycle.cid = :cid)
    LEFT OUTER JOIN customer ON (:cid = customer.cid);
    
SELECT product.pid, pnm, :cid, cnm, NVL(day, 0) AS day, NVL(cnt, 0) AS cnt
FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cycle.cid = :cid)
    LEFT OUTER JOIN customer ON (cycle.cid = customer.cid);
    
SELECT product.pid, pnm, :cid, cnm, NVL(day, 0) AS day, NVL(cnt, 0) AS cnt
FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cycle.cid = :cid)
    JOIN customer ON (:cid = customer.cid);

SELECT product.pid, pnm, :cid, cnm, NVL(day, 0) AS day, NVL(cnt, 0) AS cnt
FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cycle.cid = :cid)
    JOIN customer ON (cycle.cid = customer.cid);

--CROSS JOIN
SELECT *
FROM emp, dept;

--실습 CROSS JOIN1
SELECT customer.cid, cnm, pid, pnm
FROM customer, product;

--하..
SELECT u.rg, u.count, d.count
FROM 
    (
    SELECT sido || ' ' || sigungu AS rg, COUNT(storecategory) AS count
    FROM burgerstore
    WHERE storecategory IN ('BURGER KING', 'KFC', 'MACDONALD')
    GROUP BY sido, sigungu
    ) u,
    (
    SELECT sido || ' ' || sigungu AS rg, COUNT(storecategory) AS count
    FROM burgerstore
    WHERE storecategory IN ('LOTTERIA')
    GROUP BY sido, sigungu
    ) d
WHERE u.rg = d.rg
GROUP BY u.rg u.count, d.count;

--행을 컬럼으로 변경
--storecategory가 BURGER KING이면 1, 0
SELECT sido, sigungu,
        ROUND ((SUM(DECODE (storecategory, 'BURGER KING', 1, 0)) +
        SUM(DECODE (storecategory, 'KFC', 1, 0)) +
        SUM(DECODE (storecategory, 'MACDONALD', 1, 0))) /
        DECODE (SUM(DECODE (storecategory, 'LOTTERIA', 1, 0)), 0, 1, SUM(DECODE (storecategory, 'LOTTERIA', 1, 0))), 2) AS idx
FROM burgerstore
GROUP BY sido, sigungu
ORDER BY idx DESC;

SELECT *
FROM emp