--트랜잭션
CREATE TABLE DEPT_TCL
    AS SELECT * FROM DEPT;

SELECT * FROM DEPT_TCL;

INSERT INTO DEPT_TCL VALUES(50, 'DATABASE', 'SEOUL');

UPDATE DEPT_TCL SET LOC = 'BUSAN' WHERE DEPTNO = 40;

DELETE FROM DEPT_TCL WHERE DNAME = 'RESEARCH';

ROLLBACK;

INSERT INTO DEPT_TCL VALUES(50, 'NETWORK', 'SEOUL');

UPDATE DEPT_TCL SET LOC = 'BUSAN' WHERE DEPTNO = 20;

DELETE FROM DEPT_TCL WHERE DEPTNO = 40;

COMMIT;

SELECT * FROM DEPT

--1
DATABASE, SEOUL, SALES, CHICAGO

--2
대기 중. . .
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON

--3
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	DATABASE SEOUL
40	OPERATIONS	BOSTON

--4
SALES, CHICAGO, DATABASE, SEOUL

--5
DATABASE, SEOUL, DATABASE, SEOUL