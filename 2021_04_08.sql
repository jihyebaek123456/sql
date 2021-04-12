SELECT *
FROM REMAIN;


--프로시져 생성
※ 오늘이 2005년 1월 31일이라 가정하고 오늘까지 발생된 상품 입고 정보를 이용해
   재고 수불 테이블 UPDATE 하는 프로시져 생성
   1. 프로시져 명 : PROC_REMAIN_IN
   2. 매개변수 : 상품 코드
   3. 처리 내용 : 해당 상품 코드에 대한 입고 수량, 현재 수량, 날짜 UPDATE
   
   ◎ 해야 할 것
   1. 2005년 상품 별 매입 수량 집계  --프로시져 밖에서 처리
   2. 1의 결과를 프로시져에 전달
   3. 재고 수불 테이블 UPDATE --프로시져에서

CREATE OR REPLACE PROCEDURE PROC_REMAIN_IN (
    P_CODE IN PROD.PROD_ID%TYPE,  --상품 코드
    P_CNT   IN NUMBER )  --매입 수량

IS

BEGIN
    UPDATE REMAIN
    SET (REMAIN_I, REMAIN_J_99, REMAIN_DATE) = (SELECT REMAIN_I + P_CNT,
                                                                               REMAIN_J_99 + P_CNT,
                                                                                '2005/01/31'
                                                                    FROM REMAIN
                                                                    WHERE REMAIN_YEAR = '2005'
                                                                        AND PROD_ID = P_CODE)
    WHERE REMAIN_YEAR = '2005' AND PROD_ID = P_CODE;
    --기본키 인덱스 이용 (기본키가 두 개의 열로 이루어져 있으니 두 개의 조건 기술)
    
END;

SELECT BUY_PROD,
          SUM(BUY_QTY)  --함수 상태로 전달할 수 없으니 별칭 생성
FROM BUYPROD
WHERE BUY_DATE BETWEEN '2005/01/01' AND '2005/01/31'
GROUP BY BUY_PROD;

--▼

SELECT BUY_PROD AS BCODE,
          SUM(BUY_QTY) AS BAMT
FROM BUYPROD
WHERE BUY_DATE BETWEEN '2005/01/01' AND '2005/01/31'
GROUP BY BUY_PROD;


--프로시져 실행
DECLARE
    CURSOR CUR_BUY_AMT IS
        SELECT BUY_PROD AS BCODE,
                   SUM(BUY_QTY) AS BAMT
        FROM BUYPROD
        WHERE BUY_DATE BETWEEN '2005/01/01' AND '2005/01/31'
        GROUP BY BUY_PROD;
      
BEGIN
    FOR REC01 IN CUR_BUY_AMT
    LOOP
        PROC_REMAIN_IN (REC01.BCODE, REC01.BAMT);
    END LOOP;
    
END;

CREATE OR REPLACE VIEW V_REMAIN01
    AS SELECT * FROM REMAIN
    WITH READ ONLY;
   
SELECT * FROM V_REMAIN01;

CREATE OR REPLACE VIEW V_REMAIN02
    AS SELECT * FROM REMAIN
    WITH READ ONLY;
   
SELECT * FROM V_REMAIN02;


※ 회원 아이디를 입력 받아 그 회원의 이름, 주소, 직업을 반환하는 프로시져 작성
    1. 프로시져 명 : PROC_MEM_INFO
    2. 매개변수 : 입력용 - 아이디
                     출력용 - 이름, 주소, 직업

--프로시져 생성
CREATE OR REPLACE PROCEDURE PROC_MEM_INFO (
    P_MID IN MEMBER.MEM_ID%TYPE,
    P_MNAME OUT MEMBER.MEM_NAME%TYPE,
    P_MADD OUT VARCHAR,
    P_MJOB OUT MEMBER.MEM_JOB%TYPE)

IS
    
BEGIN
    SELECT MEM_NAME, MEM_ADD1 || ' ' || MEM_ADD2, MEM_JOB
    INTO P_MNAME, P_MADD, P_MJOB
    FROM MEMBER
    WHERE MEM_ID = P_MID;
    
END;

--프로시져 실행
ACCEPT P_ID PROMPT '아이디 입력 : '
DECLARE
    V_MNAME MEMBER.MEM_NAME%TYPE;
    V_MADD VARCHAR(200);
    V_MJOB MEMBER.MEM_JOB%TYPE;

BEGIN
    PROC_MEM_INFO(LOWER('&P_ID'), V_MNAME, V_MADD, V_MJOB);
    DBMS_OUTPUT.PUT_LINE('&P_ID' || ' 회원 조회');
    DBMS_OUTPUT.PUT_LINE('--------------------');
    DBMS_OUTPUT.PUT_LINE('이름 : ' || V_MNAME);
    DBMS_OUTPUT.PUT_LINE('주소 : ' || V_MADD);
    DBMS_OUTPUT.PUT_LINE('직업 : ' || V_MJOB);

END;


※ 년도를 입력 받아 해당 년도에 구매를 가장 많이 한 회원 이름과
   구매액 반환 프로시져 작성
   1. 프로시져 명 : PROC_MEM_PTOP
   2. 매개변수 : 입력용 - 년도
                    출력용 - 회원명, 구매액

--프로시져 생성
CREATE OR REPLACE PROCEDURE PROC_MEM_PTOT (
    P_YEAR IN VARCHAR2,  --문자를 받아올 거니까 CHAR, VARCHAR2, NUMBER 상관 없음
    P_NAME OUT MEMBER.MEM_NAME%TYPE,
    P_AMT OUT VARCHAR2)  --문자를 보낼 거니까 CHAR, VARCHAR2만 가능, NUMBER 사용 불가

IS

BEGIN
   SELECT NAME, TO_CHAR(AMT, '99,999,999')
   INTO P_NAME, P_AMT
   FROM (SELECT M.MEM_NAME AS NAME,
                        SUM(C.CART_QTY * P.PROD_PRICE) AS AMT
             FROM CART C, MEMBER M, PROD P
             WHERE C.CART_MEMBER = M.MEM_ID
                AND C.CART_PROD = P.PROD_ID
                AND SUBSTR(CART_NO, 1, 4) = P_YEAR
             GROUP BY M.MEM_NAME
             ORDER BY SUM(C.CART_QTY * P.PROD_PRICE) DESC)
    WHERE ROWNUM = 1;

END;

--프로시져 실행
ACCEPT P_YEAR PROMPT '년도 입력 : '
DECLARE
    V_NAME MEMBER.MEM_NAME%TYPE;
    V_AMT VARCHAR2(100);  --NUMBER로 받을 거면 초기화 필요!

BEGIN
    PROC_MEM_PTOT(('&P_YEAR'), V_NAME, V_AMT);
    DBMS_OUTPUT.PUT_LINE('회원 이름 : ' || V_NAME);
    DBMS_OUTPUT.PUT_LINE('구매 금액 : ' || V_AMT);
    
END;


※ 2005년도 구매금액이 없는 회원을 찾아 회원테이블(MEMBER)의
   삭제 여부컬럼(MEM_DELETE)의 값을 'Y'로 변경하는 프로시져 작성
--프로시져 생성
CREATE OR REPLACE PROCEDURE PROC_MEM_DEL (
    P_ID IN MEMBER.MEM_ID%TYPE)

IS

BEGIN
    UPDATE MEMBER
    SET MEM_DELETE = 'Y'
    WHERE MEM_ID = P_ID;

    --COMMIT;

END;

--프로시져 실행
ACCEPT P_YEAR PROMPT '년도 입력(구매 이력이 없는 회원 조회) : '
DECLARE
    CURSOR CUR_MEM_BUY IS
        SELECT MEM_ID
        FROM MEMBER
        WHERE MEM_ID NOT IN (SELECT CART_MEMBER
                                           FROM CART
                                           WHERE CART_NO LIKE '&P_YEAR%'
                                                      --SUBSTR(CART_NO, 1, 4) = '&P_YEAR'
                                                      --칠거지악 중 하나 : 컬럼 가공 X
                                                      --SUBSTR으로 가공하는 대신 LIKE 연산자 사용
                                                      --가공 시 똑같이 가공 처리하여 만든 인덱스가 아니면 일반 인덱스는 사용 불가
                                           GROUP BY CART_MEMBER);

BEGIN
    FOR LEC IN CUR_MEM_BUY
    LOOP
        PROC_MEM_DEL(LEC.MEM_ID);
    END LOOP;

END;

--확인
SELECT MEM_ID, MEM_NAME, MEM_dELETE
FROM MEMBER;

ROLLBACK;
