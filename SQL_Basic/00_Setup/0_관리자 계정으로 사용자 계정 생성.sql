-- 한줄 주석
/*
    여러줄 주석
*/
-- DBA_USERS ? 현재 오라클서버의 모든 계정정보를 보관하는 "테이블"
SELECT * FROM DBA_USERS; -- 명령문 한줄 실행시 CTRL+ENTER

-- 계정 생성
-- 일반 사용자 계정을 생성 할 수 있는 권한은 오직 관리자 계정에게만 있음
-- 사용자 계정 생성 방법
-- [표현법]
-- CREATE USER C##계정명 IDENTIFIED BY 비밀번호;
CREATE USER C##KH IDENTIFIED BY KH;

-- 생성된 사용자 계정에 권한부여
-- 부여할 권한 ? DB에 접속 할 수 있는 권한 (CREATE SESSION) , 데이터를 관리 (CREATE TABLE , INSERT TABLE , DELETE TABLE...)
-- [표현법] GRANT 권한1, 권한2, ... TO 계정명;

GRANT CONNECT, RESOURCE TO C##KH;

-- 관리자 계정 : DB의 생성과 관리를 담당하는 계정. 모든 권한과 책임을 가지는 계정.
-- 사용자 계정 : DB에 대해서 질의, 갱신, 보고서 작성들의 작업을 수행할 수 있는 계정.
--             업무에 필요한 최소한의 권한만 가지는 것을 원칙으로함.

-- ROLE 권한
-- CONNECT : 사용자가 데이터베이스에 접속 가능 하도록 하기 위한 CREATE SESSION 권한이 있는 ROLE 권한.
-- RESOURCE : CREATE 구문을 통해 객체를 생성 할 수있는 권한과 , INSERT UPDATE DELETE 구문을 사용 할 수있는 권한을 모아둔 ROLE 권한.

GRANT UNLIMITED TABLESPACE TO C##KH;