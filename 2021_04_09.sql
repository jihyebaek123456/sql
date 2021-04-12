--함수
※ 장바구니 테이블에서 2005년 6월 5일 판매된 상품 코드를 입력 받아
   상품명을 출력하는 함수 작성
   1. 함수 명 : FN_PNAME_OUTPUT
   2. 매개변수 : 입력용 - 상품 코드
   3, 반환 값 : 상품명

--함수 생성
CREATE OR REPLACE FUNCTION FN_PNAME_OUTPUT (
    P_CODE IN PROD.PROD_ID%TYPE)
    RETURN PROD.PROD_NAME%TYPE  --크기 지정 X, (;) 사용 X

AS
    V_NAME PROD.PROD_NAME%TYPE;
    
BEGIN
    SELECT PROD_NAME
    INTO V_NAME
    FROM PROD
    WHERE PROD_ID = P_CODE;
    --위 아래는 다른 영역
    RETURN V_NAME;
    
END;

--함수 실행
SELECT CART_MEMBER, CART_PROD, FN_PNAME_OUTPUT(CART_PROD) 
FROM CART
WHERE CART_NO LIKE '20050605%';


※ 2005년 5월 모든 상품에 대한 매입현황을 조회
   ALIAS는 상품코드, 상품명, 매입수량, 매입금액
   --주의! 모든 상품에 대한 조회이므로 NULL도 포함되어야 함
   --OUTER JOIN 사용
--ORACLE
SELECT P.PROD_ID AS 상품코드,   
           P.PROD_NAME AS 상품명,
           NVL(SUM(B.BUY_QTY), 0) AS 매입수량,
           NVL(SUM(B.BUY_QTY * P.PROD_COST), 0) AS 매입금액
FROM BUYPROD B, PROD P
WHERE B.BUY_PROD(+) = P.PROD_ID
    AND B.BUY_DATE(+) BETWEEN '20050501' AND '20050531' 
    --편법 중 하나.. 항상 될 거라는 보장이 없으니 정석대로 ANSI OUTER JOIN 사용
GROUP BY P.PROD_ID, P.PROD_NAME;

--ANSI
SELECT P.PROD_ID AS 상품코드,   
           P.PROD_NAME AS 상품명,
           NVL(SUM(B.BUY_QTY), 0) AS 매입수량,
           NVL(SUM(B.BUY_QTY * P.PROD_COST), 0) AS 매입금액
FROM BUYPROD B RIGHT OUTER JOIN PROD P ON (B.BUY_PROD = P.PROD_ID
                                                               AND B.BUY_DATE BETWEEN '20050501' AND '20050531')
GROUP BY P.PROD_ID, P.PROD_NAME;

--서브 쿼리
SELECT P.PROD_ID AS 상품코드,
           P.PROD_NAME AS 상품명,
           NVL(B.BUY_QTY, 0) AS 매입수량,
           NVL(B.BUY_SUM, 0) AS 매입금액
FROM PROD P, (SELECT BUY_PROD,
                                SUM(BUY_QTY) AS BUY_QTY,
                                SUM((BUY_QTY * BUY_COST)) AS BUY_SUM
                      FROM BUYPROD B
                      WHERE BUY_DATE BETWEEN '20050501' AND '20050531'
                      GROUP BY BUY_PROD) B
WHERE B.BUY_PROD(+) = P.PROD_ID;


※ 2005년 5월 모든 상품에 대한 매입현황을 조회
   ALIAS는 상품코드, 상품명, 매입수량, 매입금액
--함수 사용
CREATE OR REPLACE FUNCTION FN_BUYPROD_AMT (
    P_CODE IN PROD.PROD_ID%TYPE)
    RETURN VARCHAR2

IS
    V_RES VARCHAR2(100);  --매입 수량 합 + 매입 금액 합을 문자로 변환 후 한 번에 리턴
    V_QTY NUMBER := 0;  --매입 수량 합
    V_AMT NUMBER := 0;  --매입 금액 합

BEGIN
    SELECT SUM(BUY_QTY), SUM(BUY_QTY * BUY_COST)
    INTO V_QTY, V_AMT
    FROM BUYPROD
    WHERE BUY_PROD = P_CODE
        AND BUY_DATE BETWEEN '20050501' AND '20050531';
    --GROUP BY BUY_PROD : SELECT절에 일반 컬럼이 없으므로 GROUP BY가 없어도 사용 가능
    
    IF V_QTY IS NULL THEN
        V_RES := '0';
    ELSE
        V_RES := '수량 : ' || V_QTY || ', 구매 금액 : ' || V_AMT;
    END IF;
    
    RETURN V_RES;
    
END;

SELECT PROD_ID AS 상품코드,
          PROD_NAME AS 상품명,
          FN_BUYPROD_AMT(PROD_ID) AS 구매내역
FROM PROD;


※ 상품 코드를 입력 받아 2005년 상품 별 평균 판매 횟수, 판매 수량 합계, 판매 금액 합계를
   출력하는 함수 작성
   1. 함수 명 : FN_CART_QAVG, FN_CART_QAMT, FN_CART_FAMT
   2. 매개변수 : 입력용 - 상품 코드, 년도

--상품 별 평균 판매 횟수
CREATE OR REPLACE FUNCTION FN_CART_QAVG (
    P_CODE IN PROD.PROD_ID%TYPE,
    P_YEAR IN CHAR)
    RETURN NUMBER

AS
    V_QAVG NUMBER := 0;
   
BEGIN
    SELECT ROUND(AVG(CART_QTY))
    INTO V_QAVG
    FROM CART
    WHERE CART_NO LIKE P_YEAR||'%'
        AND CART_PROD = P_CODE;
    
    RETURN V_QAVG;

END;

--판매 수량 합계
CREATE OR REPLACE FUNCTION FN_CART_QAMT (
    P_CODE PROD.PROD_ID%TYPE,
    P_YEAR CHAR)
    RETURN NUMBER

AS
    V_QATY NUMBER := 0;

BEGIN
    SELECT SUM(CART_QTY)
    INTO V_QATY
    FROM CART
    WHERE CART_NO LIKE P_YEAR||'%'
        AND CART_PROD = P_CODE;
       
    RETURN V_QATY;

END;

--상품 별 판매 금액 합계
CREATE OR REPLACE FUNCTION FN_CART_FAMT (
    P_CODE IN PROD.PROD_ID%TYPE,
    P_YEAR IN VARCHAR2)
    RETURN NUMBER

AS
    V_FAMT NUMBER := 0;

BEGIN
    SELECT SUM(C.CART_QTY * P.PROD_PRICE)
    INTO V_FAMT
    FROM CART C, PROD P
    WHERE C.CART_PROD = P.PROD_ID
       AND C.CART_PROD = P_CODE
       AND C.CART_NO LIKE P_YEAR||'%';
    
    RETURN V_FAMT;

END;

--실행
SELECT PROD_ID AS 상품명,
          NVL(FN_CART_QAVG(PROD_ID, '2005'), 0) AS "평균 판매 횟수",
          NVL(FN_CART_QAMT(PROD_ID, '2005'), 0) AS "판매 수량",
          NVL(TO_CHAR(FN_CART_FAMT(PROD_ID, '2005'), '999,999,999'), 0) AS "판매 금액"
FROM PROD

※ 2005년 2~3월 제품 별 매입 수량을 구하여 제고 수불 테이블을 UPDATE
   처리 일자는 2005년 3월 마지막일

--함수 생성
CREATE OR REPLACE FUNCTION FN_REMAIN_UPDATE (
    P_CODE IN BUYPROD.BUY_PROD%TYPE,
    P_QTY IN BUYPROD.BUY_QTY%TYPE,
    P_DATE IN DATE)
    RETURN VARCHAR2

AS
    V_MESSAGE VARCHAR2(100);

BEGIN
    UPDATE REMAIN          
    SET REMAIN_I = REMAIN_I + P_QTY,
          REMAIN_J_99 = REMAIN_J_99 + P_QTY,
          REMAIN_DATE = P_DATE
   -- SET (REMAIN_I, REMAIN_J_99, REMAIN_DATE) = (SELECT REMAIN_I + P_QTY,
   --                                                                            P_QTY + REMAIN_J_99,
   --                                                                            P_DATE
   --                                                                 FROM REMAIN
   --                                                                 WHERE REMAIN_YEAR = '2005'
   --                                                                     AND PROD_ID = P_CODE;
    WHERE REMAIN_YEAR = '2005'
        AND PROD_ID = P_CODE;
    
    V_MESSAGE := P_CODE || ' 입고 처리 완료';
    
    RETURN V_MESSAGE;

END;

--실행
DECLARE
    CURSOR CUR_PROD IS
        SELECT BUY_PROD, SUM(BUY_QTY) AS BUY_QTY
        FROM BUYPROD
        WHERE BUY_DATE BETWEEN '20050201' AND '20050331'
        GROUP BY BUY_PROD;
    
    V_RES VARCHAR(100);
    
BEGIN
    FOR REC IN CUR_PROD
    LOOP
        V_RES :=FN_REMAIN_UPDATE(REC.BUY_PROD, REC.BUY_QTY, LAST_DAY('20050331'));  --반환 값을 담을 것이 없으면 오류
        DBMS_OUTPUT.PUT_LINE(V_RES);
    END LOOP;
    
END;

SELECT *
FROM REMAIN;

ROLLBACK;

--왜 안 되는..? : cannot perform a DML operation inside a query 
SELECT FN_REMAIN_UPDATE(A.BUY_PROD, A.BQTY, LAST_DAY('20050331'))
FROM (SELECT BUY_PROD, SUM(BUY_QTY) AS BQTY
          FROM BUYPROD
          WHERE BUY_DATE BETWEEN '20050201' AND '20050331'
          GROUP BY BUY_PROD) A;
          
          
          
          
          
          
          
          
          
          
          
          