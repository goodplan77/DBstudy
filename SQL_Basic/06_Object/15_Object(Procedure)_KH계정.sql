/*
    <PROCEDURE>
    - PL/SQL 구문을 "저장"해서 이용하는 객체.
    필요할때마다 PL/SQL 문을 편하게 호출 가능함.
    
    프로시져 생성방법
    
    CREATE [OR REPLACE] PROCEDURE 프로시저명 [(매개변수)]
    IS
    PL/SQL문;
    
    프로시저 실행방법
    EXEC 프로시저명;
*/

CREATE TABLE PRO_TEST
AS SELECT * FROM EMPLOYEE;

-- 프로시저 만들기
CREATE PROCEDURE DEL_DATA
IS
BEGIN
    DELETE FROM PRO_TEST;
    COMMIT;
END;
/
SELECT * FROM PRO_TEST; -- 27

SELECT * FROM USER_PROCEDURES;

EXEC DEL_DATA;

SELECT * FROM PRO_TEST; -- 0

-- 프로시저에 매개 변수 추가하기
-- IN : 프로시저 실행시 필요한 값을 받는 변수 (매개변수)
-- OUT : 호출한 곳으로 되돌려주는 변수 (결과값 반환시 사용)
CREATE OR REPLACE PROCEDURE PRO_SELECT_EMP (
    V_EMP_ID IN EMPLOYEE.EMP_ID%TYPE ,
    V_EMP_NAME OUT EMPLOYEE.EMP_NAME%TYPE , 
    V_SALARY OUT EMPLOYEE.SALARY%TYPE,
    V_BONUS OUT EMPLOYEE.BONUS%TYPE
)
IS
BEGIN
    SELECT EMP_NAME , SALARY , BONUS
    INTO V_EMP_NAME , V_SALARY , V_BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = V_EMP_ID;
END;
/

-- 매개변수 있는 프로시저 실행
VAR EMP_NAME VARCHAR2(20);
VAR SALARY NUMBER;
VAR BONUS NUMBER;
EXEC PRO_SELECT_EMP (200 , :EMP_NAME , :SALARY , :BONUS);

PRINT EMP_NAME;
PRINT SALARY;
PRINT BONUS;
-- PRINT EMP_NAME SALARY BONUS;

/*
    프로시저 장점
    1. 처리속도가 빠름
    2. 대량 자료처리시 유리함.
    
    프로시저 단점
    1. DB자원을 직접 소모하기 때문에 DB에 부하를 주게됨.
    2. 관리적 측면에서 자바소스코드 , 오라클 코드를 동시에 형상관리하기 어렵다.
    3. 제대로 사용하지 못한다면 성능이 떨어질 수 있다.
    -- 4. 일관성 문제 - (엔진의 차이?)
*/

/*
    <FUNCTION>
    프로시저와 거의 유사하지만 실행 결과를 반환 받을수 있음.
    
    FUNCTION 생성방법
    [표현식]
    CREATE [OR REPLACE] FUNCTION 함수명[(매개변수)]
    RETURN 자료형
    IS
    PL/SQL문
    
    함수명(매개변수);
*/
CREATE OR REPLACE FUNCTION MYFUNC(V_STR VARCHAR2)
RETURN VARCHAR2
IS
 -- DECLARE (생략 필수)
    RESULT VARCHAR2(1000);
BEGIN
    DBMS_OUTPUT.PUT_LINE(V_STR);
    RESULT := '*'|| V_STR || '*';
    
    RETURN RESULT;
END;
/

/*
    사용자에게 EMP_ID 값을 전달받아 연봉을 계산해서 반환 해주는 함수 만들기.
    함수명 : CALC_SALARY
    매개변수명 : V_EMP_ID 자료형
    
    SELECT EMP_ID , CALC_SALARY(EMP_ID)
    FROM EMPLOYEE;
*/

CREATE OR REPLACE FUNCTION CALC_SALARY (V_EMP_ID EMPLOYEE.EMP_ID%TYPE)
RETURN NUMBER
IS
    V_SALARY EMPLOYEE.SALARY%TYPE;
    V_BONUS EMPLOYEE.BONUS%TYPE;
    RESULT NUMBER;
BEGIN
    SELECT SALARY , BONUS
    INTO V_SALARY , V_BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = V_EMP_ID;
    
    IF V_BONUS IS NULL
    THEN RESULT := V_SALARY * 12;
    ELSE RESULT := (V_SALARY * 12) * (1 + V_BONUS);
    END IF;
    
    RETURN RESULT;
    
END;
/

-- 풀이
CREATE OR REPLACE FUNCTION CALC_SALARY (V_EMP_ID EMPLOYEE.EMP_ID%TYPE)
RETURN NUMBER
IS
    E EMPLOYEE%ROWTYPE;
    RESULT NUMBER;
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = V_EMP_ID;
    
    RESULT := E.SALARY * (1 + NVL(E.BONUS,0)) * 12;
    RETURN RESULT;

END;
/

SELECT EMP_ID , CALC_SALARY(EMP_ID)
FROM EMPLOYEE;

SELECT MYFUNC('ASDF') FROM DUAL;