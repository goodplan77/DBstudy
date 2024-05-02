/*
    * SUBQUERY를 이용한 테이블 생성 (테이블 복사본)
    메인 SQL문을 보조하는 역할의 쿼리 == 서브쿼리
    
    [표현법]
    CREATE TABLE 테이블명 AS 서브쿼리;
*/
SELECT * FROM EMPLOYEE;

CREATE TABLE EMPLOYEE_COPY AS (SELECT * FROM EMPLOYEE);

SELECT * FROM EMPLOYEE_COPY;
-- 컬럼명 , 자료형 , 행 데이터 , NOT NULL 제약조건 까지는 제대로 복사가 이루어짐.
-- 단 , PRIMARY KEY , UNIQUE , FOREGIN KEY 등은 복사가 제대로 되지 않는다.

-- 구조만 가져올 때
CREATE TABLE EMPLOYEE_COPY2
AS
SELECT * FROM EMPLOYEE WHERE 1 = 0;
-- 거짓 조건식을 넣어서 데이터 출력이 안되도록함?
-- 1 = 0? : 결과값 거짓 나옴

-- 전체 사원들 중 급여가 300만원 이상인 사원들의 사번 , 이름 , 부서코드 , 급여를 조회한 결과를 복제한 테이블 생성
CREATE TABLE EMPLOYEE_COPY3
AS
SELECT EMP_ID , EMP_NAME , DEPT_CODE , SALARY FROM EMPLOYEE WHERE SALARY >= 3000000;
SELECT * FROM EMPLOYEE_COPY3;

-- 전체 사원의 사번 , 사원명 , 급여 , 연봉을 조회한 결과를 복제한 테이블 생성
CREATE TABLE EMPLOYEE_COPY4
AS
SELECT EMP_ID , EMP_NAME , SALARY  , SALARY*12 AS 연봉 FROM EMPLOYEE;
-- 산술 연산 값을 계산해서 넣은 경우 별칭을 따로 부여 해야함
SELECT * FROM EMPLOYEE_COPY4;