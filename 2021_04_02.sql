--FORCE/NOFORCE
--모두 원본 테이블이 존재 하는 것임!

SELECT *
FROM DUAL;

SELECT 10, 20, 'TEST'
FROM DUAL;

SELECT EMPNO, ENAME, DNAME, 10
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO;


--SEQUENCE 객체
--사용 예시

※ LPROD 테이블에 자료 삽입 (시퀀스 이용)
   [자료]
   LPROD_ID :       10번부터
   LPROD_GU :      P501              P502             P503
   LPORD_NM :     농산물           수산물           임산물

--시퀀스 생성
CREATE SEQUENCE SEQ_LPROD
    START WITH 10;
   
--자료 삽입
INSERT INTO LPROD VALUES(SEQ_LPROD.NEXTVAL, 'P501', '농산물');
INSERT INTO LPROD VALUES(SEQ_LPROD.NEXTVAL, 'P502', '수산물');
INSERT INTO LPROD VALUES(SEQ_LPROD.NEXTVAL, 'P503', '임산물');

SELECT *
FROM LPROD
ORDER BY LPROD_ID;


--문제
※ 오늘이 2005년 7월 28일인 경우 'm001' 회원이 제품 'P201000004'를 5개 구입했을 때
    CART 테이블에 해당 자료를 사입하는 쿼리 작성

--CART_NO 생성
SELECT CART_NO          --날짜 + 사이트에 접속한 고객 중 구매를 한 고객의 순서대로 순번 붙이기
FROM CART;

SELECT TO_CHAR(TO_CHAR(TO_DATE('20050728', 'YYYYMMDD'), 'YYYYMMDD') ||
          MAX(SUBSTR(CART_NO, 9))+1)
FROM CART;

SELECT TO_CHAR(MAX(CART_NO)+1)
FROM CART;

--참고사항 : ORACLE은 숫자 우선, Java는 문자 우선
SELECT 100 + '1'            --System.out.println(100 + "1"); > 1001
FROM DUAL;

CREATE SEQUENCE SEQ_CART
    START WITH 5;
   
--자료 삽입
INSERT INTO CART(CART_MEMBER, CART_NO, CART_PROD, CART_QTY)           --날짜, 순번 사이 공백 제거,            5자리 수의 문자로 변환
              VALUES ('m001', (TO_CHAR(TO_DATE('20050728', 'YYYYMMDD'), 'YYYYMMDD') || TRIM(TO_CHAR(SEQ_CART.NEXTVAL, '00000'))), 'P201000004', 5);

SELECT *
FROM CART;


--SYNONYM 객체
--사용 예시

※ HR 계정의 REGIONS 테이블 내용 조회
SELECT HR.REGIONS.REGION_ID AS 지역코드,
           HR.REGIONS.REGION_NAME AS 지역명
FROM HR.REGIONS;

--참고사항 - 원칙적인 테이블 명 표기법
SELECT *
FROM jihye.EMP;         --(자기 계정 명.)테이블 명 > ( )생략 가능

--테이블 별칭 사용 : 해당 SELECT문에서만 유용
SELECT RG.REGION_ID AS 지역코드,
           RG.REGION_NAME AS 지역명
FROM HR.REGIONS RG;

--SYNONYM 객체(동의어) 사용 : SELECT문을 벗어나도 계속 존재
CREATE OR REPLACE SYNONYM REG FOR HR.REGIONS;

SELECT REG.REGION_ID AS 지역코드,
           REG.REGION_NAME AS 지역명
FROM REG;


--INDEX 객체
SELECT *
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NULL;

SELECT *
FROM JOBS;

