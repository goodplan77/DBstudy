/*
    <VIEW 뷰>
    SELECT를 저장해둘수 있는 객체 == 쿼리문을 저장해둘수 있는 객체.
    (자주 사용되는 긴 SELECT문을 VIEW에 저장해두면 매번 SELECT문을 호출할 필요가 없어서 효율적임)
    => 조회용 임시테이블
*/
-- 관리자 계정 -> 뷰 생성 권한 부여
-- GRANT CREATE VIEW TO C##KH;
-- CREATE VIEW VW_TEST AS SELECT * FROM EMPLOYEE; ?

-- '한국'에서 근무하는 사원들의 사번 , 이름 , 부서명 , 급여 , 근무국가명 , 직급명을 조회하시오.
SELECT EMP_ID , EMP_NAME , DEPT_TITLE  , SALARY , NATIONAL_NAME , JOB_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN LOCATION L ON D.LOCATION_ID = LOCAL_CODE
JOIN NATIONAL N USING (NATIONAL_CODE)
JOIN JOB USING(JOB_CODE)
WHERE NATIONAL_NAME = '한국';

/*
    1. VIEW 생성방법
    [표현법]
    CREATE VIEW 뷰명 AS 서브쿼리;
    
    CREATE [OR REPLACE] VIEW 뷰명 AS 서브쿼리;
    
    =>  뷰 생성시 기존에 중복된 이름의 뷰가 있다면 , 그 이름의 뷰를 갱신(REPLACE) 없다면 새롭게 생성(CREATE)
        OR REPLCAE는 생략가능함.
*/

CREATE VIEW VW_EMPLOYEE
AS SELECT EMP_ID , EMP_NAME , DEPT_TITLE  , SALARY , NATIONAL_NAME , JOB_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN LOCATION L ON D.LOCATION_ID = LOCAL_CODE
JOIN NATIONAL N USING (NATIONAL_CODE)
JOIN JOB USING(JOB_CODE)
WHERE NATIONAL_NAME = '한국';

SELECT EMP_ID , EMP_NAME , BONUS -- 서브쿼리를 통해 데이터를 받아올때 BONUS는 없었음
FROM VW_EMPLOYEE
WHERE DEPT_TITLE = '총무부';

CREATE OR REPLACE VIEW VW_EMPLOYEE -- OR REPLACE 옵션 생략시 , 에러 (같은 이름 사용중)
AS SELECT EMP_ID , EMP_NAME , DEPT_TITLE  , SALARY , NATIONAL_NAME , JOB_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN LOCATION L ON D.LOCATION_ID = LOCAL_CODE
JOIN NATIONAL N USING (NATIONAL_CODE)
JOIN JOB USING(JOB_CODE);

-- 뷰는 논리적인 가상테이블 => 실질적으로 데이터를 저장하고 있지는 않음.
-- 단순히 쿼리문이 TEXT문구로 저장되어 있음.
SELECT TEXT FROM USER_VIEWS;
----------------------------------------------------------------
/*
    뷰 컬럼에 별칭 부여
    서브쿼리 부분에 SELECT 절에 함수나 산술 연산식이 기술되어 있는 경우 별칭 지정
*/
CREATE VIEW VW_EMP_JOB
AS SELECT EMP_ID , EMP_NAME , JOB_CODE , DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여') AS "성별"
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

SELECT EMP_NAME , 성별
FROM VW_EMP_JOB;

-- 다른 방식으로 별칭부여
CREATE OR REPLACE VIEW VW_EMP_JOB (사번 , 사원명 , 직급명 , 성별)
AS SELECT EMP_ID , EMP_NAME , JOB_NAME , DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여')
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

-- INSERT , UPDATE , DELETE문 사용하기
/*
    생성된 뷰를 이용해서 DML (INSERT , UPDATE , DELETE) 사용가능
    
    주의사항 : VIEW 를 통해서 DML 을 하게되면 , 뷰가 참조하고 있는 테이블들에 변경사항이 발생한다.
*/

CREATE VIEW VW_JOB
AS SELECT * FROM JOB;

SELECT * FROM JOB;
SELECT * FROM VW_JOB;

INSERT INTO VW_JOB
VALUES ('J8','인턴'); -- JOB , VW_JOB에 동시에 추가된다.

UPDATE VW_JOB SET JOB_NAME = '알바' WHERE JOB_CODE = 'J8';

DELETE FROM VW_JOB WHERE JOB_CODE = 'J8';

/*
    * DML이 가능한 경우 : 서브쿼리를 이용해서 기존의 테이블을 조건처리 없이 복제한 경우
    
    + 하지만 뷰를 가지고 DML이 불가능한 경우가 더 많음
    1) 뷰에 정의 되어 있지 않은 칼럼을 조작
    2) 뷰에 정의 되어 있지 않은 컬럼중에 베이스 테이블 상에 NOT NULL 제약조건이 추가 된 경우
    3) 산술연산식 , 또는 함수를 통해서 정의 되어 있는 경우
    4) 그룹함수나 GROUP BY 절이 포함된 경우
    5) DISTINCT 구문이 포함 된 경우
    6) JOIN 을 이용한 경우
*/

-- 1) 뷰에 정의 되어 있지 않은 칼럼을 조작 하는 경우
CREATE OR REPLACE VIEW VW_JOB
AS SELECT JOB_NAME FROM JOB;

SELECT * FROM VW_JOB;
INSERT INTO VW_JOB (JOB_CODE , JOB_NAME)
VALUES('J8' , '인턴'); -- 뷰에는 JOB_CODE 가 정의 되어 있지 않음

INSERT INTO VW_JOB (JOB_NAME)
VALUES ('인턴');
-- 베이스 테이블 상에선 JOB_CODE 값이 NOT NULL 상태라 필수로 넣어야 하나
-- 뷰에는 정의 되어 있지 않아서 에러 발생

UPDATE VW_JOB SET
JOB_NAME = '알바' WHERE JOB_NAME = '사원';

-- 6) JOIN을 이용해서 여러 테이블의 행을 합친 경우
CREATE OR REPLACE VIEW VW_JOIN_EMP
AS SELECT EMP_ID , EMP_NAME , DEPT_TITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
    
INSERT INTO VW_JOIN_EMP VALUES(300,'조세오','총무부'); -- 에러 발생

UPDATE VW_JOIN_EMP SET
EMP_NAME = '서동일'
WHERE EMP_ID = 200; -- 하나의 테이블에서만 확인 하는 상황 . 가능함?
---------------------------------------------------------------
ROLLBACK;

-- VIEW 에서 사용가능한 옵션들.
-- 1. OR REPLACE
-- 2. FORCE / NO FORCE 옵션 : 실제 테이블이 없더라도 VIEW를 먼저 생성 할 수 있게 해주는 옵션.
-- NO FORCE 기본값

CREATE FORCE VIEW VW_FORCETEST
AS SELECT A,B,C FROM NOTABLE;
SELECT * FROM VW_FORCETEST; -- 에러 발생

CREATE TABLE NOTABLE (
    A NUMBER,
    B NUMBER,
    C NUMBER
);

-- 3. WITH CHECK OPTION
-- SELECT 문의 WHERE절에 사용한 칼럼을 수정하지 못하게 막아두는 옵션.
CREATE OR REPLACE VIEW VW_CHECKOPTION
AS SELECT EMP_ID , EMP_NAME , SALARY , DEPT_CODE
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D5' WITH CHECK OPTION;
    
UPDATE VW_CHECKOPTION SET EMP_NAME = '박나라' WHERE EMP_ID = 206;

UPDATE VW_CHECKOPTION SET DEPT_CODE = 'D6' WHERE EMP_ID = 206;

-- 4. WITH READ ONLY
-- VIEW를 수정 못하게 차단 하는 옵션.
CREATE OR REPLACE VIEW VW_READ
AS SELECT EMP_ID , EMP_NAME , DEPT_CODE
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D5' WITH READ ONLY;

UPDATE VW_READ SET EMP_NAME = 'DDD';