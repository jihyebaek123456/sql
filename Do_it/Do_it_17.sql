--레코드
DECLARE
    TYPE REC_DEPT IS RECORD (
        deptno NUMBER(2) NOT NULL := 99,
        dname DEPT.DNAME%TYPE,
        loc DEPT.LOC%TYPE
    );
    dept_rec REC_DEPT;  --레코드형 변수 선언 (여러 개 선언 가능)
BEGIN
    dept_rec.deptno := 99;
    dept_rec.dname := 'DATABASE';
    dept_rec.loc := 'SEOUL';
    DBMS_OUTPUT.PUT_LINE('DEPTNO : ' || dept_rec.deptno);
    DBMS_OUTPUT.PUT_LINE('DNAME : ' || dept_rec.dname);
    DBMS_OUTPUT.PUT_LINE('LOC : ' || dept_rec.loc);
END;

CREATE TABLE DEPT_RECORD
    AS SELECT * FROM DEPT;
   
DECLARE
    TYPE REC_DEPT IS RECORD (
        deptno NUMBER(2) NOT NULL := 99,
        dname DEPT.DNAME%TYPE,
        loc DEPT.LOC%TYPE
    );
    dept_rec REC_DEPT;
BEGIN
    dept_rec.deptno := 99;
    dept_rec.dname := 'DATABASE';
    dept_rec.loc := 'SEOUL';
    
    INSERT INTO DEPT_RECORD
    VALUES dept_rec;
END;

SELECT *
FROM DEPT_RECORD;

DECLARE
    TYPE REC_DEPT IS RECORD (
        deptno NUMBER(2) NOT NULL := 99,
        dname DEPT.DNAME%TYPE,
        loc DEPT.LOC%TYPE
    );
    dept_rec REC_DEPT;
BEGIN
    dept_rec.deptno := 50;
    dept_rec.dname := 'DB';
    dept_rec.loc := 'SEOUL';
    
    UPDATE DEPT_RECORD
    SET ROW = dept_rec
    WHERE DEPTNO = 99;
END;

DECLARE
    TYPE REC_DEPT IS RECORD (
        deptno DEPT.DEPTNO%TYPE,
        dname DEPT.DNAME%TYPE,
        loc DEPT.LOC%TYPE
    );
    TYPE REC_EMP IS RECORD (
        empno EMP.EMPNO%TYPE,
        ename EMP.ENAME%TYPE,
        dinfo REC_DEPT
    );
    emp_rec REC_EMP;
BEGIN
    SELECT E.EMPNO, E.ENAME, D.DEPTNO, D.DNAME, D.LOC
    INTO emp_rec.empno, emp_rec.ename,
            emp_rec.dinfo.deptno, emp_rec.dinfo.dname, emp_rec.dinfo.loc
    FROM EMP E, DEPT D
    WHERE E.DEPTNO = D.DEPTNO
       AND E.EMPNO = 7788;
    
    DBMS_OUTPUT.PUT_LINE('EMPNO : ' || emp_rec.empno);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || emp_rec.ename);
    
    DBMS_OUTPUT.PUT_LINE('DEPTNO : ' || emp_rec.dinfo.deptno);
    DBMS_OUTPUT.PUT_LINE('DNAME : ' || emp_rec.dinfo.dname);
    DBMS_OUTPUT.PUT_LINE('LOC : ' || emp_rec.dinfo.loc);
END;

DECLARE
    TYPE ITAB_EX IS TABLE OF VARCHAR2(20)
    INDEX BY PLS_INTEGER;
    
    text_arr ITAB_EX;
BEGIN
    text_arr(1) := '1st data';
    text_arr(2) := '2nd data';
    text_arr(3) := '3rd data';
    text_arr(4) := '4th data';
    
    DBMS_OUTPUT.PUT_LINE('text_arr(1) : ' || text_arr(1));
    DBMS_OUTPUT.PUT_LINE('text_arr(2) : ' || text_arr(2));
    DBMS_OUTPUT.PUT_LINE('text_arr(3) : ' || text_arr(3));
    DBMS_OUTPUT.PUT_LINE('text_arr(4) : ' || text_arr(4));
END;

DECLARE
    TYPE REC_DEPT IS RECORD (
        deptno DEPT.DEPTNO%TYPE,
        dname DEPT.DNAME%TYPE
    );
    
    TYPE ITAB_DEPT IS TABLE OF REC_DEPT
    INDEX BY PLS_INTEGER;
    
    dept_arr ITAB_DEPT;
    idx PLS_INTEGER := 0;
BEGIN
    FOR i IN (SELECT DEPTNO, DNAME FROM DEPT) LOOP
        idx := idx +1;
        dept_arr(idx).deptno := i.DEPTNO;
        dept_arr(idx).dname := i.DNAME;
        
        DBMS_OUTPUT.PUT_LINE(dept_arr(idx).deptno || ' : ' || dept_arr(idx).dname);
    END LOOP;
END;

DECLARE
    TYPE ITAB_DEPT IS TABLE OF DEPT%ROWTYPE
    INDEX BY PLS_INTEGER;
    
    dept_arr ITAB_DEPT;
    idx PLS_INTEGER := 0;
BEGIN
    FOR i IN (SELECT * FROM DEPT) LOOP
        idx := idx +1;
        dept_arr(idx).deptno := i.DEPTNO;
        dept_arr(idx).dname := i.DNAME;
        dept_arr(idx).loc := i.LOC;
        
        DBMS_OUTPUT.PUT_LINE(dept_arr(idx).deptno || ' : ' || dept_arr(idx).dname || ' : ' || dept_arr(idx).loc);
    END LOOP;
END;

--1
CREATE TABLE EMP_RECORD
    AS SELECT * FROM EMP WHERE 1<>1;

SELECT * FROM EMP_RECORD;

DECLARE
    --정석은 선언만 하고 실행부에서 초기화 한 뒤에 INSERT..
    --기본키가 되는 EMPNO는 NOT NULL 지정 후 네 자리 숫자 채워주기
    TYPE REC_EMP IS RECORD (
        empno EMP.EMPNO%TYPE NOT NULL := 1111,
        ename EMP.ENAME%TYPE := 'TEST_USER',
        job EMP.JOB%TYPE := 'TEST_JOB',
        mgr EMP.MGR%TYPE,
        hiredate EMP.HIREDATE%TYPE := '2018/03/01',
        sal EMP.SAL%TYPE := 3000,
        comm EMP.COMM%TYPE,
        deptno EMP.DEPTNO%TYPE := 40
    );
    
    emp_rec REC_EMP;
BEGIN
    INSERT INTO EMP_RECORD
        VALUES emp_rec;
    
    DBMS_OUTPUT.PUT_LINE(emp_rec.empno || ' ' || emp_rec.ename || ' ' || emp_rec.job || ' ' || emp_rec.mgr || ' ' || emp_rec.hiredate || ' ' ||emp_rec.sal || ' ' || emp_rec.comm || ' ' || emp_rec.deptno);
END;

--2
DECLARE
    TYPE LEC_EMP IS RECORD (
        empno EMP.EMPNO%TYPE NOT NULL := 9999,
        ename EMP.ENAME%TYPE,
        job EMP.JOB%TYPE,
        mgr EMP.MGR%TYPE,
        hiredate EMP.HIREDATE%TYPE,
        sal EMP.SAL%TYPE,
        comm EMP.COMM%TYPE,
        deptno EMP.DEPTNO%TYPE
    );
    
    TYPE ITAB_EMP IS TABLE OF LEC_EMP
    INDEX BY PLS_INTEGER;
    
    emp_arr ITAB_EMP;
    idx PLS_INTEGER := 0;
BEGIN
    FOR i IN (SELECT * FROM EMP) LOOP
        idx := idx + 1;
        emp_arr(idx).empno := i.EMPNO;
        emp_arr(idx).ename := i.ENAME;
        emp_arr(idx).job := i.JOB;
        emp_arr(idx).mgr := i.MGR;
        emp_arr(idx).hiredate := i.HIREDATE;
        emp_arr(idx).sal := i.SAL;
        emp_arr(idx).comm := i.COMM;
        emp_arr(idx).deptno := i.DEPTNO;
        
        DBMS_OUTPUT.PUT_LINE(emp_arr(idx).empno || ' : ' || emp_arr(idx).ename || ' : ' || emp_arr(idx).job || ' : ' || emp_arr(idx).mgr || ' : ' || emp_arr(idx).hiredate || ' : ' || emp_arr(idx).sal || ' : ' || emp_arr(idx).comm || ' : ' || emp_arr(idx).deptno);
    END LOOP;
END;