--인덱스 객체 생성
※ 상품 테이블에서 상품 명으로 NORMAL INDEX 생성
CREATE INDEX IDX_PROD_NAME
               ON PROD (PROD_NAME);

※ 장바구니 테이블에서 장바구니 번호 중 3번째에서 6글자로 인덱스 구성
SELECT *
FROM CART;

CREATE INDEX IDX_CART_NO
               ON CART (SUBSTR(CART_NO, 3, 6));


--PL/SQL
ACCEPT P_NUM PROMPT '수 입력(2~9) : '
--매개변수에는 파라미터 P를 붙임
DECLARE
    V_BASE NUMBER := TO_NUMBER('&P_NUM');
    --변수에는 V를 붙임
    --자료형 선언
    --대입 연산자 := 사용
    V_CNT NUMBER := 0;
    --초기화 하지 않을 시 어떤 자료형의 변수든 NULL로 지정됨
    --실행부에서 연산 시 자료형이 일치하지 않는 오류 발생 가능성 존재
    V_RES NUMBER := 0;
BEGIN
    LOOP
    --무한 루프
        V_CNT := V_CNT+1;
        EXIT WHEN V_CNT > 9;
        --무한 루프 탈출
        V_RES := V_BASE * V_CNT;
        
        DBMS_OUTPUT.PUT_LINE(V_BASE || ' * ' || V_CNT || ' = ' || V_RES);
        --출력 명령 (Syso)
    END LOOP;
    --루프의 끝 설정
    
    EXCEPTION WHEN OTHERS THEN
    --Java의 Exception 클래스 역할 (모든 예외를 수렴)
        DBMS_OUTPUT.PUT_LINE('예외 발생 : ' || SQLERRM);
        --변수 SQLERRM : SQL ERROR MESSAGE
END;


--PL/SQL 변수 선언
※ 장바구니에서 2005년 5월 가장 많은 구매를 한 회원 정보 조회 (구매 금액 기준)
   회원 번호, 회원 명, 구매 금액 합

SELECT CART_MEMBER, SUM(CART_QTY)
FROM CART
WHERE SUBSTR(CART_NO, 1, 6) = '200505'
GROUP BY CART_MEMBER;

SELECT ROWNUM, A.*
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