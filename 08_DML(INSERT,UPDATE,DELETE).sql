/*
    * DML(DATA MANIPULATION LANGUAGE)
    데이터 조작 언어
    
    테이블에 새로운 데이터를
    삽입(INSERT) 하거나
    기존의 데이터를 수정(UPDATE) 하거나
    삭제(DELETE)하는 구문들.
*/

/*
    1. INSERT : 테이블에 새로운 "행을" 추가하는 구문.
    [표현법]
    * INSERT INTO 계열
    
    1) INSERT INTO 테이블명 VALUES(값1 , 값2, ...);
    => 테이블에 모든칼럼에 대해 추가하고자 하는 값을 내가 직접 제시해서
    "한행"을 INSERT 하고자 할 때 쓰는 표현법.
    
    주의사항 : 칼럼의 순서 , 자료형 , 갯수를 맞춰서 VALUES의 괄호안에 값들을 나열해야한다.
    - 부족하게 제시하면 : NOT ENOUGH VALUE 오류
    - 더 많이 제시하면 : TOO MANY VALUE 오류
*/

-- EMPLOYEE에 데이터 추가
INSERT INTO EMPLOYEE
VALUES (900,'경민','123456-1234567','AAA@aaa.naver.com',
'01012341234','D1','J1','S1',8000000,'0.5',NULL , SYSDATE , NULL , 'Y');

/*
    2) INSERT INTO 테이블명(칼럼명1,칼럼명2,칼럼명3,...)
        VALUES (값1,값2,값3,...)
        
        => 테이블에 "특정"칼럼만 선택해서 그 칼럼에만 추가할 값을 제시하고자 할때 사용.
        한 행단위로 데이터 추가되기 때문에 선택안한 컬럼은 NULL 혹은 DEFAULT 값이 들어감.
        단 , NOT NULL 제약조건이 들어간 칼럼은 반드시 값을 제시 해줘야함.
*/

INSERT INTO EMPLOYEE (DEPT_CODE , JOB_CODE , SAL_LEVEL , EMP_ID , EMP_NAME , EMP_NO)
VALUES ('D1','J1','S1',901,'박말똥','123456-1234567');

/*
    3) INSERT INTO 테이블명 (서브쿼리);
    =>  VALUES()로 값을 직접 기입하는게 아니라
        서브쿼리로 조회한 결과값을 통째로 INSERT 하는 구문.
*/

-- 새로운 테이블생성
CREATE TABLE EMP_01(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    DEPT_TITLE VARCHAR2(20)
);

-- 전체 사원들의 사번 , 이름 , 부서명을 추가
INSERT INTO EMP_01
SELECT EMP_ID , EMP_NAME , DEPT_TITLE
FROM EMPLOYEE , DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);

INSERT INTO EMP_01
SELECT * FROM (
    SELECT 902 , '아무개1' , '총무부' FROM DUAL
    
    UNION ALL
    SELECT 903 , '아무개2' , '인사관리부' FROM DUAL
    
    UNION ALL
    SELECT 904 , '아무개3' , '아무개3' FROM DUAL
);

/*
    * INSERT ALL 계열
    두 개 이상의 테이블에 각각 INSERT 할 때 사용.
    조건 : 사용되는 서브쿼리가 동일해야한다.
    
    1)  INSERT ALL
        INTO 테이블명1 VALUES(칼럼명, 칼럼명...)
        INTO 테이블명2 VALUES(칼럼명, 칼럼명...)
        서브쿼리;
*/

-- 새로운 테이블 생성
-- 첫번째 테이블 : 급여가 300만원 이상인 사원들의 사번 , 사원명 , 직급명을 보관할 테이블
CREATE TABLE EMP_JOB(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    JOB_NAME VARCHAR2(20)
);

-- 두번째 테이블 : 급여가 300만원 이상인 사원들의 사번 , 사원명 , 부서명을 보관할 테이블
CREATE TABLE EMP_DEPT(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    DEPT_TITLE VARCHAR2(20)
);

SELECT EMP_ID , EMP_NAME , JOB_NAME , DEPT_TITLE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
WHERE SALARY >= 3000000;

INSERT ALL
INTO EMP_JOB VALUES(EMP_ID , EMP_NAME , JOB_NAME)
INTO EMP_DEPT VALUES(EMP_ID , EMP_NAME , DEPT_TITLE)
SELECT EMP_ID , EMP_NAME , JOB_NAME , DEPT_TITLE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
WHERE SALARY >= 3000000;