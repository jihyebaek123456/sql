CREATE OR REPLACE VIEW V_MAXAMT
AS
        SELECT 회원번호, 회원명, 구매금액합
        FROM (
                SELECT A.CART_MEMBER AS 회원번호,
                           B.MEM_NAME AS 회원명,
                           SUM(PROD_PRICE * CART_QTY) AS 구매금액합
                FROM CART A, MEMBER B, PROD C
                WHERE A.CART_MEMBER = B.MEM_ID
                    AND A.CART_PROD = C.PROD_ID
                    AND SUBSTR(A.CART_NO, 1, 6) = '200505'
                GROUP BY A.CART_MEMBER, B.MEM_NAME
                ORDER BY SUM(PROD_PRICE * CART_QTY) DESC
                ) A
        WHERE ROWNUM = 1;

SELECT *
FROM V_MAXAMT;


--익명 블록

DECLARE
    V_MID V_MAXAMT.회원번호%TYPE;
    --V_MAXAMT 뷰에 있는 회원번호 컬럼과 같은 자료형으로 변수의 자료형을 설정
    V_NAME V_MAXAMT.회원명%TYPE;
    V_AMT V_MAXAMT.구매금액합%TYPE;
    V_RES VARCHAR2(100);

BEGIN
    SELECT 회원번호, 회원명, 구매금액합
    INTO V_MID, V_NAME, V_AMT
    --INTO : SELECT절에 기술한 열에 있는 데이터들을 전달 받을 변수 입력
    FROM V_MAXAMT;
    
    V_RES := V_MID || ', ' || V_NAME || ',' || TO_CHAR(V_AMT, '99,999,999');
    
    DBMS_OUTPUT.PUT_LINE(V_RES);
END;


--상수 사용
※ 수 한 개를 입력 받아 그 값을 반지름으로 하는 원의 넓이 구하기

ACCEPT P_NUM PROMPT '원의 반지름 : '

DECLARE
    V_RADIUS NUMBER := TO_NUMBER('&P_NUM');
    V_PI CONSTANT NUMBER := 3.1415926;
    V_RES NUMBER := 0;

BEGIN
    V_RES := V_RADIUS * V_RADIUS * V_PI;
    DBMS_OUTPUT.PUT_LINE('원의 넓이 = ' || V_RES);

END;


--CURSOR
--사용 예
※ 상품 매입 테이블(BUYPROD)에서 2005년 3월
   상품 별 매입 현황(상품코드, 상품명, 거래처명, 매입수량)을 출력하는
   쿼리를 커서를 사용하여 작성
--커서
DECLARE
    V_PCODE PROD.PROD_ID%TYPE;
    V_PNAME PROD.PROD_NAME%TYPE;
    V_BNAME BUYER.BUYER_NAME%TYPE;
    V_AMT NUMBER := 0;

    CURSOR CUR_BUY_INFO IS
        SELECT BUY_PROD,
                   SUM(BUY_QTY) AS AMT
        FROM BUYPROD
        WHERE BUY_DATE BETWEEN '20050301' AND '20050331'
        GROUP BY BUY_PROD;

BEGIN
    OPEN CUR_BUY_INFO;
    
    LOOP --반복 명령
        FETCH CUR_BUY_INFO INTO V_PCODE, V_AMT;
        EXIT WHEN CUR_BUY_INFO%NOTFOUND;
            SELECT PROD_NAME, BUYER_NAME INTO V_PNAME, V_BNAME
            FROM PROD, BUYER
            WHERE PROD_ID = V_PCODE
                AND PROD_BUYER = BUYER_ID;
        DBMS_OUTPUT.PUT_LINE('상품코드 : ' || V_PCODE);
        DBMS_OUTPUT.PUT_LINE('상품명 : ' || V_PNAME);
        DBMS_OUTPUT.PUT_LINE('거래처명 : ' || V_BNAME);
        DBMS_OUTPUT.PUT_LINE('매입수량 : ' || V_AMT);
        DBMS_OUTPUT.PUT_LINE('--------------------------------------');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('자료 수 : ' || CUR_BUY_INFO%ROWCOUNT);
    CLOSE CUR_BUY_INFO;
    
END;

--표준 SQL
SELECT BP.BUY_PROD AS 상품코드,
           P.PROD_NAME AS 상품명,
           B.BUYER_NAME AS 거래처명,
           SUM(BP.BUY_QTY) AS 매입수량
FROM BUYPROD BP, BUYER B, PROD P
WHERE TO_CHAR(BP.BUY_DATE, 'YYYYMM') = '200503'
    AND BP.BUY_PROD = P.PROD_ID
    AND P.PROD_BUYER = B.BUYER_ID
GROUP BY BP.BUY_PROD, P.PROD_NAME, B.BUYER_NAME;


※ 상품 분류 코드 'P102'에 속한 상품의 상품명, 매입가격, 마일리지 출력 커서 작성
--커서

ACCEPT P_LCODE PROMPT '분류코드 : '
--정보 조회를 위해 분류 코드 입력 받기
DECLARE
    V_PNAME PROD.PROD_NAME%TYPE;
    V_PCOST PROD.PROD_COST%TYPE;
    V_PMILE PROD.PROD_MILEAGE%TYPE;
    
    CURSOR CUR_PROD_INFO(P_LGU LPROD.LPROD_GU%TYPE) IS
    --매개변수를 이용해 입력된 분류 코드 받기
        SELECT PROD_NAME, PROD_COST, PROD_MILEAGE
        FROM PROD
        WHERE PROD_LGU = P_LGU;

BEGIN
    OPEN CUR_PROD_INFO('&P_LCODE');
    --입력 받은 분류 코드 보내기
    DBMS_OUTPUT.PUT_LINE('상품명                               매입가격            마일리지');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------');
    LOOP 
        FETCH CUR_PROD_INFO INTO V_PNAME, V_PCOST, V_PMILE;
        EXIT WHEN CUR_PROD_INFO%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(V_PNAME||'         '||V_PCOST||'         '||NVL(V_PMILE, 0));
    END LOOP;
    CLOSE CUR_PROD_INFO;
    
END;

--표준 SQL
SELECT PROD_NAME, PROD_COST, PROD_MILEAGE
FROM PROD
WHERE PROD_LGU = 'P102';


※ 상품 테이블에서 'P201' 분류에 속한 상품들의 평균 단가를 구하고
   해당 분류에 속한 상품들의 판매 단가를 비교하여
   '평균 가격 상품', '평균 가격 이하 상품', '평균 가격 이상 상품'으로 나누기
   (상품코드, 상품명, 가격, 비고)

SELECT AVG(PROD_PRICE)
FROM PROD
WHERE PROD_LGU = 'P201'

DECLARE
    V_PCODE PROD.PROD_ID%TYPE;
    V_PNAME PROD.PROD_NAME%TYPE;
    V_PRICE PROD.PROD_PRICE%TYPE;
    V_REMARKS VARCHAR2(50);
    V_AVG_PRICE PROD.PROD_PRICE%TYPE;
    
    CURSOR CUR_PROD_PRICE IS
        SELECT PROD_ID, PROD_NAME, PROD_PRICE
        FROM PROD
        WHERE PROD_LGU = 'P201';

BEGIN
    SELECT ROUND(AVG(PROD_PRICE)) INTO V_AVG_PRICE
    FROM PROD
    WHERE PROD_LGU = 'P201';
    
    OPEN CUR_PROD_PRICE;
    DBMS_OUTPUT.PUT_LINE('상품코드       상품명            가격      비고');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------');
    LOOP
        FETCH CUR_PROD_PRICE INTO V_PCODE, V_PNAME, V_PRICE;
        EXIT WHEN CUR_PROD_PRICE%NOTFOUND;
        IF V_PRICE > V_AVG_PRICE THEN
            V_REMARKS := '평균 가격 이상 상품';
        ELSIF V_PRICE < V_AVG_PRICE THEN
            V_REMARKS := '평균 가격 이하 상품';
        ELSE
            V_REMARKS := '평균 가격 상품';
        END IF;
        DBMS_OUTPUT.PUT_LINE(V_PCODE || '   ' || V_PNAME || '   ' || V_PRICE || '   ' || V_REMARKS);
    END LOOP;
    
END;


※ 수도 요금 계산

    물 사용 요금 : 톤 당 단가
    1   -   10      :    350 원
    11  -   20      :    550 원
    21  -   30      :    900 원
    그 이상        :   1500 원
    
    하수도 사용료 : 사용량 * 450원

--26톤 사용 > (10 * 350) + (20 * 550) + (6 * 900) + (26 * 450) 원 = 26,100 원

ACCEPT P_AMOUNT PROMPT '물 사용량 : '
DECLARE
    V_AMT NUMBER := TO_NUMBER('&P_AMOUNT');
    V_WA1 NUMBER := 0;      --물 사용 요금
    V_WA2 NUMBER := 0;      --하수도 사용 요금
    V_HAP NUMBER := 0;      --요금 합계

BEGIN
    CASE WHEN V_AMT BETWEEN 1 AND 10 THEN
            V_WA1 := V_AMT * 350;
            WHEN V_AMT BETWEEN 11 AND 20 THEN
            V_WA1 := (V_AMT - 10) * 550 + 3500;
            WHEN V_AMT BETWEEN 21 AND 30 THEN
            V_WA1 := (V_AMT - 20) * 900 + 3500 + 5500;
            ELSE
            V_WA1 := (V_AMT - 30) * 1500 + 3500 + 5500 + 9000;
    END CASE;
    V_WA2 := V_AMT * 450;
    V_HAP := V_WA1 + V_WA2;
    DBMS_OUTPUT.PUT_LINE(V_AMT || '톤의 수도 요금 : ' || V_HAP || '원');

END;
