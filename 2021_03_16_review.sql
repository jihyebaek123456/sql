--데이터 정렬을 하는 이유? 데이터 순서가 보장되지 않아서 (조회할 때마다 순서가 달라지는 경우 有)
--                     현실 세계에서는 정렬된 데이터가 필요할 때가 있음 (ex. 게시글 조회)
--데이터 정렬 : ORDER BY(컬럼명, 컬럼 순서, ALIAS로 가능)
SELECT *
FROM emp
ORDER BY job, sal DESC;

SELECT ename AS 이름, empno
FROM emp
ORDER BY 이름;

--페이징 처리 : 페이지 사이즈가 정해진 경우 원하는 페이지의 데이터만 가져오기
--            ex. 한 페이지에 게시글이 8개씩 존재하는 게시글에서 3페이지 조회하기
--페이징 처리에 필요한 것 : 정렬 기준, 키워드, 변수
--키워드 : ROWNUM, ALIAS
--변수 : pageSize, page

--inLine view가 필요한 이유 : 행번호가 뒤죽박죽
SELECT ROWNUM, emp.*
FROM emp
ORDER BY ename;

SELECT ROWNUM, empno, ename
FROM (
        SELECT ename, empno
        FROM emp
        ORDER BY ename
     );
     
--ALIAS가 필요한 이유 : ROWNUM의 제약사항 때문에
SELECT *
FROM (
        SELECT ROWNUM AS rn, empno, ename
        FROM (
                SELECT ename, empno
                FROM emp
                ORDER BY ename
             )
     )
WHERE rn BETWEEN 6 AND 10;

--변수 사용
한 페이지 당 조회되는 게시글 수 : pageSize건
1 page : 1 ~ 5
2 page : 6 ~ 10
(page) page : pageSize * (page - 1) + 1 ~ pageSize * page

--변수 선언
SELECT *
FROM (
        SELECT ROWNUM AS rn, empno, ename
        FROM (
                SELECT ename, empno
                FROM emp
                ORDER BY ename
             )
     )
WHERE rn BETWEEN :pageSize * (:page - 1) + 1 AND :pageSize * :page;

