--view 실습1
--사원 테이블에서 부모 부서 코드가 90번 부서에 속한 사원 정보 조회
--조회 할 데이터 : 사원 번호, 사원 명, 부서 명, 급여

--view 실습2
--회원 테이블에서 마일리지가 3000 이상인 회원 조회
--조회 할 데이터 : 회원 번호, 회원 명, 직업, 마일리지

SELECT mem_id AS "회원 번호",
       mem_name AS "회원 명",
       mem_job AS "직업",
       mem_mileage AS "마일리지"
FROM member
WHERE mem_mileage >= 3000;


※ 이름이 없는 뷰 > 재사용 불가 => 뷰 생성
CREATE OR REPLACE VIEW V_MEMBER01
AS
    SELECT mem_id AS "회원 번호",
           mem_name AS "회원 명",
           mem_job AS "직업",
           mem_mileage AS "마일리지"
    FROM member
    WHERE mem_mileage >= 3000;


※ 뷰에서 데이터 확인
SELECT *
FROM v_member01;


※ 테이블에서 신용환 데이터 확인
SELECT mem_name, mem_job, mem_mileage
FROM member
WHERE mem_id = 'c001';


※ member 테이블에서 신용환의 마일리지를 10000으로 변경
UPDATE member SET mem_mileage = 10000
WHERE mem_name = '신용환';


※ v_member01 뷰에서 신용환의 마일리지를 500으로 변경
UPDATE v_member01 SET 마일리지 = 500
WHERE "회원 명" = '신용환';


※ with check option 설정
CREATE OR REPLACE VIEW V_MEMBER01 (mid, mna, mjob, mmile)
AS
    SELECT mem_id AS "회원 번호",
           mem_name AS "회원 명",
           mem_job AS "직업",
           mem_mileage AS "마일리지"
    FROM member
    WHERE mem_mileage >= 3000
WITH CHECK OPTION;


※ 뷰에서 데이터 확인
SELECT *
FROM v_member01;


※ 테이블에서 신용환 데이터 확인
SELECT mem_name, mem_job, mem_mileage
FROM member
WHERE mem_id = 'c001';


※ v_member01 뷰에서 신용환의 마일리지를 2000으로 변경
UPDATE v_member01 SET mmile = 2000
WHERE mna = '신용환';


※ member 테이블에서 신용환의 마일리지를 2000으로 변경
UPDATE member SET mem_mileage = 2000
WHERE mem_name = '신용환';


※ with read only 설정
CREATE OR REPLACE VIEW V_MEMBER01 (mid, mna, mjob, mmile)
AS
    SELECT mem_id AS "회원 번호",
           mem_name AS "회원 명",
           mem_job AS "직업",
           mem_mileage AS "마일리지"
    FROM member
    WHERE mem_mileage >= 3000
WITH READ ONLY;


※ 뷰에서 데이터 확인
SELECT *
FROM v_member01;


※ 테이블에서 신용환 데이터 확인
SELECT mem_name, mem_job, mem_mileage
FROM member
WHERE mem_id = 'c001';


※ v_member01 뷰에서 오철희의 마일리지를 2700으로 변경
UPDATE v_member01 SET mmile = 5700
WHERE mid = 'k001';


※ member 테이블에서 신용환의 마일리지를 2000으로 변경
UPDATE member SET mem_mileage = 2000
WHERE mem_name = '신용환';


※ 다른 계정에 있는 테이블 조회
SELECT hr.departments.department_id,
           department_name
FROM hr.departments


--문제
--HR 계정의 사원 테이블에서 50번 부서에 속한 사원 중 급여가 5000 이상인 직원들을 읽기 전용 뷰로 생성
--조회 할 컬럼 : 사원 번호, 사원 명, 입사일자, 급여
CREATE OR REPLACE VIEW v_emp_sal01
AS
    SELECT employee_id, emp_name, hire_date, salary
    FROM employees
    WHERE department_id = 50 AND salary >= 5000
WITH READ ONLY;

SELECT *
FROM v_emp_sal01;

SELECT *
FROM jobs

SELECT v.employee_id 사원번호, v.emp_name 사원명, j.job_title 직무명, v.salary 급여
FROM v_emp_sal01 v, employees t, jobs j
WHERE v.employee_id = t.employee_id
   AND t.job_id = j.job_id;

View 객체
SEQUENCE 객체
CURSOR

다른 계정에 있는 테이블 조회

실습
 . View 객체 생성 1
 . View 객체 생성 2

