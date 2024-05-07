/*
    <시퀀스 SEQUENCE>
    
    자동으로 번호를 발생시켜주는 역할을 하는 개체
    정수값을 자동으로 "순차"적으로 발생시켜준다.
    
    "순차적" 으로 겹치지 않는 숫자를 사용하여 값을 부여할때 사용.
    
    1. 시퀀스객체 생성 구문
    
    [표현법]
    CREATE SEQUENCE 시퀀스명
    START WITH 시작숫자 => 생략가능 , 처음발생시킬시작값 (DEFAULT 1)
    INCREMENT BY 증가값 => 생략가능. 한번 시퀀스 증가할때마다 몇씩 증가할건지 결정 (DEFAULT 1)
    MAXVALUE 최대값 => 생략가능 , 최대값 지정
    MINVALUE 최소값 => 생략가능 , 최소값 지정
    CYCLE / NOCYCLE => 생략가능 , 값의 순환여부 지정. (기본값은 )
    CACHE 바이트크기 / NOCACHE => 생략가능 , 캐시메모리 사용 여부 지정 (기본값은 CACHE 20BYTE)
    
    * 캐시메모리란?
    시퀀스로부터 미리 발생될 값들을 생성해서 저장해두는 공간.
    매번 시퀀스를 호출하여 값을 새롭게 생성하는 것보단 , 캐시메모리에 미리 생성된 값들을 가져다 쓰게 되면
    훨씬 속도가 빠르다. 단 , 접속이 끊기고 나서 재접속시 기존에 생성 되어 있던 값들은 사라진다.
*/
CREATE SEQUENCE SEQ_TEST;

-- 현재 계정이 소유하고 있는 시퀀스에 대한 정보를 조회 할 수 있는 데이터 딕셔너리
SELECT * FROM USER_SEQUENCES;

-- 현재 계정으로 확인 가능한 데이터 딕셔너리들
SELECT * FROM DICT;

CREATE SEQUENCE SEQ_EMP_NO
START WITH 300
INCREMENT BY 5
MAXVALUE 315
NOCYCLE
NOCACHE;

/*
    2. 시퀀스 활용 구문
    시퀀스명.CURRVAL : 현재 시퀀스의 값 (마지막으로 성공된 NEXTVAL값)
    시퀀스명.NEXTVAL : 현재 시퀀스의 다음 값 (첫 호출시에는 시작값)
*/

SELECT SEQ_EMP_NO.CURRVAL FROM DUAL;
-- 시퀀스가 생성되고나서 NEXTVAL을 한번이라도 수행 하지 않은 경우 CURRVAL을 호출 할 수 없음.
-- => CURRVAL은 마지막으로 성공적으로 수행된 NEXTVAL값을 저장해주는 임시값.

SELECT * FROM USER_SEQUENCES;

SELECT SEQ_EMP_NO.NEXTVAL FROM DUAL; -- 첫 실행시 START WITH 으로 설정된 초기값 -- 300
SELECT SEQ_EMP_NO.CURRVAL FROM DUAL; -- 300
SELECT SEQ_EMP_NO.NEXTVAL FROM DUAL; -- 305
SELECT SEQ_EMP_NO.CURRVAL FROM DUAL; -- 305

SELECT SEQ_EMP_NO.NEXTVAL FROM DUAL; -- 310
SELECT SEQ_EMP_NO.NEXTVAL FROM DUAL; -- 315

SELECT SEQ_EMP_NO.CURRVAL FROM DUAL; -- 315
SELECT SEQ_EMP_NO.NEXTVAL FROM DUAL; -- 에러 발생
-- MAXVALUE 를 초과했기 때문에 에러 발생

/*
    3. 시퀀스 변경
    [표현법]
    ALTER SEQUENCE 시퀀스명
    INCREMENT BY 증가값
    MAXVALUE 최대값
    MINVALUE 최소값
    CYCLE / NOCYCLE
    CACHE 바이트 크기
    
    => START WITH은 변경불가. 바꾸고 싶다면 삭제후 재생성.
*/
ALTER SEQUENCE SEQ_EMP_NO
INCREMENT BY 10
MAXVALUE 400;

SELECT * FROM USER_SEQUENCES;

SELECT SEQ_EMP_NO.CURRVAL FROM DUAL; -- 315
SELECT SEQ_EMP_NO.NEXTVAL FROM DUAL; -- 315 + 10 = 325

DROP SEQUENCE SEQ_EMP_NO;
----------------------------------------------------------
-- 실습문제
-- 매번 새로운 사번이 발생되는 시퀀스 생성 (시퀀스명 SEQ_EMP_EID)
-- 시작값 : 300 , 증가값 : 1 , 최대값 : 400
-- 시퀀스 생성후 , 시퀀스를 활용하여 2명의 사원정보 추가.
-- 사원 정보는 임의로 생성하기.
CREATE SEQUENCE SEQ_EMP_EID
START WITH 300
INCREMENT BY 1 -- 기본값
MAXVALUE 400;

SELECT * FROM USER_SEQUENCES;

INSERT INTO EMPLOYEE (EMP_ID , EMP_NAME , EMP_NO , JOB_CODE , SAL_LEVEL)
VALUES (SEQ_EMP_EID.NEXTVAL , '임시1' , '111111-1111111' , 'J1' , 'S1');

INSERT INTO EMPLOYEE (EMP_ID , EMP_NAME , EMP_NO , JOB_CODE , SAL_LEVEL)
VALUES (SEQ_EMP_EID.NEXTVAL , '임시2' , '222222-2222222' , 'J1' , 'S1');

SELECT * FROM EMPLOYEE;

-- 시퀀스는 INSERT문의 PK값에 데이터를 추가할때 가장 많이 사용된다.
