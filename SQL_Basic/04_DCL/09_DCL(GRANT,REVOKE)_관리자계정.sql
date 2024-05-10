/*
    * DCL(DATA CONTROL LANGUAGE)
    데이터 제어 언어
    
    계정에게 시스템 권한 또는 객체 접근 권한을 부여(GRANT) 하거나 회수(REVOKE) 하는 언어
    
    -   권한 부여(GRANT)
        시스템권한   :   특정 DB에 접근 하는 권한.
                        객체들을 생성 할 수 있는 권한.
        객체접근권한  :  특정 객체들에 접근해서 "조작" 할 수 있는 권한
        
    -   시스템 권한의 종류
        CREATE SESSION : 계정에 접속 할 수 있는 권한.
        CREATE TALBE
        CREATE VIEW
        CREATE SEQUENCE
        CREATE ...
        
    [표현법]
    GRANT 권한1 , 권한2 , ... TO 계정명
*/

-- 1. SAMPLE 계정 생성
CREATE USER C##SAMPLE IDENTIFIED BY SAMPLE;

-- 2. SAMPLE 계정에 접속하기 위한 CREATE SESSION 권한 부여
GRANT CREATE SESSION TO C##SAMPLE;

-- 3-1. SAMPLE 계정에 테이블 생성 할 수 있는 CREATE TABLE 권한 부여
GRANT CREATE TABLE TO C##SAMPLE;

-- 3-2. SAMPLE 계정에 테이블 스페이스 할당.
GRANT UNLIMITED TABLESPACE TO C##SAMPLE;

-- 4. SAMPLE 계정에게 뷰를 생성 할 수 있는 권한 부여
GRANT CREATE VIEW TO C##SAMPLE;

/*
    - 객체 에 접근 할 수 있는 권한
    특정 객체들을 조작 할 수 있는 권한
    조작 : SELECT , INSERT , UPDATE , DELETE => DML
    
    [표현법]
    GRANT 권한종류 ON 특정객체 TO 계정명;
    
    권한종류        |       특정객체
    ---------------------------------
    SELECT         |       TABLE , VIEW , SEQUENCE
    UPDATE         |       TABLE , VIEW
    INSERT         |       TABLE , VIEW
    DELETE         |       TABLE , VIEW
*/

-- 5. KH.EMPLOYEE 에 접근 할 수 있는 권한 부여
GRANT SELECT ON C##KH.EMPLOYEE TO C##SAMPLE;

-- 6. KH.DEPARTMENT INSERT 권한만 부여
GRANT INSERT ON C##KH.DEPARTMENT TO C##SAMPLE;

/*
    <롤 ROLE>
    특정 권한들을 하나의 집합으로 모아 놓은 것.
    
    CONNECT : CREATE SESSION(데이터베이스에 접속 할 수 있는 권한)
    RESOURCE : CREATE TABLE , CREATE SEQUENCE , SELECT , CREATE INDEX,...
                (다양한 객체를 생성 및 조작 할 수 있는 권한 == 객체관리권한)
*/

-----------------------------------------------

/*
    * 권한 회수(REVOKE)
    권한을 회수 할 때 사용하는 명령어.
    
    [표현법]
    REVOKE 권한1 , 권한2,... FROM 계정명;
*/

-- 7. SAMPLE 계정에서 테이블을 생성하는 권한을 회수
REVOKE CREATE TABLE FROM C##SAMPLE;