--반복문 LOOP 예시
※ 구구단의 7단 출력
DECLARE
    V_CNT NUMBER := 1;
    V_RES NUMBER := 0;

BEGIN
    LOOP
        V_RES := 7 * V_CNT;
        DBMS_OUTPUT.PUT_LINE('7 * ' || V_CNT || ' = ' || V_RES);
        V_CNT := V_CNT + 1;
        EXIT WHEN V_CNT > 9;
    END LOOP;
   
END;


※ 1~50 사이 피보나치 수 구하기
DECLARE
    V_NUM1 NUMBER := 1;
    V_NUM2 NUMBER := 1;
    V_NUM3 NUMBER := 0;
    V_RES VARCHAR(50) := NULL;
   
BEGIN
    V_RES := V_NUM1 || ', ' || V_NUM2;
    LOOP
        V_NUM3 := V_NUM1 + V_NUM2;
        EXIT WHEN V_NUM3 > 50;
        V_RES := V_RES || ', ' || V_NUM3;
        V_NUM1 := V_NUM2;
        V_NUM2 := V_NUM3;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('피보나치 수열 : ' || V_RES || ', ...');
   
END;


--반복문 WHILE 예시
※ 첫날에 100원 둘째날부터 전날의 2배씩 저축할 경우 최초로 100만 원을
    넘는 날과 저축한 금액 구하기
DECLARE
    V_MONEY NUMBER := 100;
    V_CNT NUMBER := 1;
    V_SUM NUMBER := 0;

BEGIN
    WHILE V_SUM < 50 LOOP
        V_SUM := V_MONEY + V_SUM;
        V_MONEY := V_MONEY * 2;
        V_CNT := V_CNT + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('저금한 금액 : ' || V_SUM || '원 / 일 수 : ' || (V_CNT-1));

END;


※ 회원 테이블(MEMBER)에서 마일리지가 3000 이상인 회원들의
    2005년 5월 구매한 횟수와 구매금액합계 조회
    (회원번호, 회원명, 구매횟수, 구매금액합계)
--LOOP 사용
DECLARE
    V_MID MEMBER.MEM_ID%TYPE;
    V_MNAME MEMBER.MEM_NAME%TYPE;
    V_CNT NUMBER := 0;
    V_AMT NUMBER := 0;

    CURSOR CUR_CART_AMT IS
        SELECT MEM_ID, MEM_NAME
        FROM MEMBER
        WHERE MEM_MILEAGE >= 3000;
    
BEGIN
    OPEN CUR_CART_AMT;
    LOOP
        FETCH CUR_CART_AMT INTO V_MID, V_MNAME;
        EXIT WHEN CUR_CART_AMT%NOTFOUND;
        SELECT COUNT(A.CART_PROD), SUM(CART_QTY*PROD_PRICE)
        INTO V_CNT, V_AMT
        FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
            AND A.CART_MEMBER = V_MID
            AND SUBSTR(A.CART_NO, 1, 6) = '200505';
    
        DBMS_OUTPUT.PUT_LINE(V_MID || ', ' || V_MNAME || ' -> ' || V_AMT || '(' || V_CNT || ')');
    
    END LOOP;
    
END;

--WHILE 사용
DECLARE
    V_MID MEMBER.MEM_ID%TYPE;
    V_MNAME MEMBER.MEM_NAME%TYPE;
    V_CNT NUMBER := 0;
    V_AMT NUMBER := 0;

    CURSOR CUR_CART_AMT IS
        SELECT MEM_ID, MEM_NAME
        FROM MEMBER
        WHERE MEM_MILEAGE >= 3000;
    
BEGIN
    OPEN CUR_CART_AMT;
    FETCH CUR_CART_AMT INTO V_MID, V_MNAME;
    --FETCH를 한 번 넣어서 밑의 조건식을 실행할 수 있도록 함
    
    WHILE CUR_CART_AMT%FOUND LOOP  --조건을 NOTFOUND에서 FOUND로
        SELECT COUNT(A.CART_PROD), SUM(CART_QTY*PROD_PRICE)
        INTO V_CNT, V_AMT
        FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
            AND A.CART_MEMBER = V_MID
            AND SUBSTR(A.CART_NO, 1, 6) = '200505';
    
        DBMS_OUTPUT.PUT_LINE(V_MID || ', ' || V_MNAME || ' -> ' || V_AMT || '(' || V_CNT || ')');
        FETCH CUR_CART_AMT INTO V_MID, V_MNAME;
        --다음 행을 불러올 수 있도록 FETCH 반복
    END LOOP;
    
    CLOSE CUR_CART_AMT;
    
END;


--반복문 FOR
※ 구구단 7단 출력
DECLARE

BEGIN
    FOR I IN 1..9 LOOP
        DBMS_OUTPUT.PUT_LINE('7 * ' || I || ' = ' || (7 * I));
    END LOOP;

END;


※ 회원 테이블(MEMBER)에서 마일리지가 3000 이상인 회원들의
    2005년 5월 구매한 횟수와 구매금액합계 조회
    (회원번호, 회원명, 구매횟수, 구매금액합계)
--FOR 사용 (CURSOR)
DECLARE
    V_CNT NUMBER := 0;
    V_AMT NUMBER := 0;

    CURSOR CUR_CART_AMT IS
        SELECT MEM_ID, MEM_NAME
        FROM MEMBER
        WHERE MEM_MILEAGE >= 3000;
    
BEGIN    
    FOR REC_CART IN CUR_CART_AMT LOOP
        SELECT COUNT(A.CART_PROD), SUM(CART_QTY*PROD_PRICE)
        INTO V_CNT, V_AMT
        FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
            AND A.CART_MEMBER = REC_CART.MEM_ID
            AND SUBSTR(A.CART_NO, 1, 6) = '200505';
    
        DBMS_OUTPUT.PUT_LINE(REC_CART.MEM_ID || ', ' || REC_CART.MEM_NAME || ' -> ' || V_AMT || '(' || V_CNT || ')');
    END LOOP;

END;

--FOR 사용 (INLINE)
DECLARE
    V_CNT NUMBER := 0;
    V_AMT NUMBER := 0;
    
BEGIN    
    FOR REC_CART IN (SELECT MEM_ID, MEM_NAME
                              FROM MEMBER
                              WHERE MEM_MILEAGE >= 3000)
    LOOP
        SELECT COUNT(A.CART_PROD), SUM(CART_QTY*PROD_PRICE)
        INTO V_CNT, V_AMT
        FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
            AND A.CART_MEMBER = REC_CART.MEM_ID
            AND SUBSTR(A.CART_NO, 1, 6) = '200505';
    
        DBMS_OUTPUT.PUT_LINE(REC_CART.MEM_ID || ', ' || REC_CART.MEM_NAME || ' -> ' || V_AMT || '(' || V_CNT || ')');
    END LOOP;

END;


--저장 프로시져
※ 조건에 맞는 재고수불 테이블 만들기
1. 테이블 명 : REMAIN
2. 컬럼
    ------------------------------------------------------
    컬럼 명                데이터 타입          제약 사항
    ------------------------------------------------------
    REMAIN_YEAR       CHAR(4)              PK
    PROD_ID              VARCHAR2(10)     PK & FK
    REMAIN_J_00        NUMBER(5)          DEFAULT 0             --기본재고
    REMAIN_I            NUMBER(5)          DEFAULT 0             --입고수량
    REMAIN_O           NUMBER(5)          DEFAULT 0             --출고수량
    REMAIN_J_99        NUMBER(5)          DEFAULT 0             --기말재고
    REMAIN_DATE      DATE                  DEFAULT SYSDATE  --처리일자

CREATE TABLE REMAIN (
    REMAIN_YEAR     CHAR(4),
    PROD_ID            VARCHAR2(10),
    REMAIN_J_00      NUMBER(5)           DEFAULT 0,
    REMAIN_I           NUMBER(5)          DEFAULT 0,
    REMAIN_O          NUMBER(5)          DEFAULT 0,
    REMAIN_J_99       NUMBER(5)          DEFAULT 0,
    REMAIN_DATE     DATE,

    CONSTRAINT PK_REMAIN PRIMARY KEY (REMAIN_YEAR, PROD_ID),
    CONSTRAINT FK_REMAIN_PROD FOREIGN KEY (PROD_ID)
        REFERENCES PROD (PROD_ID)
);

DESC REMAIN;

SELECT *
FROM PROD;

--PROPER STOCK : 적정 재고량, 평균 판매량의 1.3배
--발주량 : PROPER STOCK - TOTAL STOCK

※ REMAIN 테이블에 데이터 삽입
1. 년도 : 2005년
2. 상품코드 : 상품 테이블의 상품 코드
3. 기초재고 : 상품 테이브르이 적정 재고
4. 입고수량 : X
5. 출고수량 : X
6. 기말재고
7. 처리일자 : 2004/12/31

INSERT INTO REMAIN (REMAIN_YEAR, PROD_ID, REMAIN_J_00, REMAIN_J_99, REMAIN_DATE)
                    SELECT '2005', PROD_ID, PROD_PROPERSTOCK, PROD_PROPERSTOCK, TO_DATE('2004/12/31', 'YYYY/MM/DD') FROM PROD;

SELECT *
FROM REMAIN;

--고객이 결제를 완료한 순간에 재고는 조정 되어야 함