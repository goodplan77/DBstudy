/*
    <PL/SQL>
    PROCEDURE LANGUAGE
    
    오라클 자체에 내장되어 있는 절차적 언어
    SQL 문장 내에서 변수의 정의 , 조건 처리(IF) , 반복처리 (LOOP , FOR , WHILE) , 예외 처리등을 지원하여
    SQL의 단점을 보완.
    
    PL/SQL 구조
    [선언부(DECLARE SECTION)] : DECLARE 로 시작 변수나 상수를 선언 및 초기화 가능.
    실행부(EXECUTEABLE SECTION) : BEGIN으로 시작, SQL문 또는 제어문들의 로직을 기술하는 부분.
    [예외처리부(EXCEPTION SECTION)] : EXCEPTION으로 시작, 예외발생시 해결하기 위한 구문을 미리 기술하는 부분.
*/

-- 콘솔창에 결과값 출력
SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/

/*
    1. DECLARE 선언부
        변수 및 상수 선언하는 공간(선언과 동시에 초기화도 가능)
        일반타입 변수 , 레퍼런스 변수 , ROW타입 변수
        
        1-1) 일반 타입 변수 선언 및 초기화
        변수명 [CONSTANT] 자료형 [:=값];
*/

DECLARE
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER := 3.14;
BEGIN
    EID := 800;
    ENAME := '&이름';
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : ' || PI);
END;
/

/*
        1-2) 레퍼런스 타입 변수 선언 및 초기화
        (어떤 테이블의 어떤 칼럼의 데이터타입을 참조하여 그 타입으로 지정)
        변수명 테이블명.컬럼명%TYPE;
*/
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    EID:=300;
    ENAME:='홍길똥';
    SAL:=3000000;
    
    SELECT EMP_ID , EMP_NAME , SALARY
        INTO EID , ENAME , SAL
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('EID ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('SAL ' || SAL);
END;
/

/*
    실습문제
    레퍼런스 타입 변수로 EID , ENAME , JCODE , SAL , DTITLE를 선언하고
    각 자료형 EMPLOYEE (EMP_ID , EMP_NAME , JOB_CODE , SALARY)
            DEPARTMENT(DEPT_TITLE) 을 참조 하도록 한다.
            
    사용자가 입력한 사번인 사원의 사번 , 사원명 , 직급코드 , 급여 , 부서명 조회후 변수에 담아서 출력.
*/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT EMP_ID , EMP_NAME , JOB_CODE , SALARY , DEPT_TITLE
        INTO EID , ENAME , JCODE , SAL , DTITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('EID ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('JCODE ' || JCODE);
    DBMS_OUTPUT.PUT_LINE('SAL ' || SAL);
    DBMS_OUTPUT.PUT_LINE('DTITLE ' || DTITLE);
END;
/

/*
        1-3) ROW 타입 변수
             테이블의 한행에 대한 모든 칼럼값을 한꺼번에 담을 수 있는 변수
             변수명 테이블명%ROWTYPE;
*/

DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
        INTO E
        FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME || ' 급여 : ' || E.SALARY || ' 보너스 : ' || E.BONUS);
END;
/

-- 2. BEGIN 실행부
-- <조건문>
-- 1) IF 조건식 THEN 실행내용 END IF;
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID , EMP_NAME , SALARY , BONUS
    INTO EID , ENAME , SAL , BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    IF BONUS IS NULL
    THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    ELSE DBMS_OUTPUT.PUT_LINE(ENAME || '사원의 보너스는 ' || BONUS*100 || '입니다.');
    END IF;

END;
/

-------------- 실습문제 --------------
DECLARE
    -- 레퍼런스 타입 변수 (EID , ENAME , DTITLE , NCODE)
    -- 참조할 칼럼 (EMP_ID , EMP_NAME , DEPT_TITLE , NATIONAL_CODE)
    -- 일반타입 변수
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE LOCATION.NATIONAL_CODE%TYPE;
    -- NCODE C##KH.NATIONAL.NATIONAL_CODE
    -- NCODE "NATIONAL".NATIONAL_CODE
    TEAM VARCHAR2(10);
    -- NCODE값에 따라 국내팀 또는 해외팀 값을 저장
    -- NATIONAL : 예약어
BEGIN
    -- 사용자가 입력한 사번의 사원의 사번 , 이름 , 부서명 , 근무국가코드 조회후 각 변수에 대입.
    SELECT EMP_ID , EMP_NAME , DEPT_TITLE , NATIONAL_CODE
    INTO EID , ENAME , DTITLE , NCODE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
    WHERE EMP_ID = &사번;
    -- 저장한 NCODE 값이 KO 일경우 TEAM에 "한국팀"대입
    
    IF NCODE = 'KO'
    THEN TEAM := '한국팀';
    ELSE TEAM := '해외팀';
    END IF;
    
    -- 그외는 "해외팀" 대입
    
    -- 사번 , 이름 , 부서 , 소속(TEAM) 출력
    DBMS_OUTPUT.PUT_LINE (EID || ' , ' || ENAME || ' , ' || DTITLE || ' , ' || TEAM);
END;
/

-- 2) IF 조건식1 THEN 실행내용1 ELSIF 조건식2 THEN 실행내용 ... ENF IF;
-- 급여가 500만원 이상인 사원은 고급인력
-- 급여가 300만원 이상인 사원은 중급인력
-- 그외 초급인력
DECLARE
    SAL EMPLOYEE.SALARY%TYPE;
    GRADE VARCHAR2(2CHAR); -- 두 글자
BEGIN
    SELECT SALARY
    INTO SAL
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    IF SAL >= 5000000 THEN GRADE := '고급';
    ELSIF SAL >= 3000000 THEN GRADE := '중급';
    ELSE GRADE := '초급';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(GRADE);

END;
/

-- 3) CASE 비교대상자 WHEN 동등비교값1 THEN 결과값1 WHEN 동등비교값2 THEN 결과값2 ELSE 결과 END;
DECLARE
    EMP EMPLOYEE%ROWTYPE;
    DNAME VARCHAR2(20);
BEGIN
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DNAME := CASE EMP.DEPT_CODE
                WHEN 'D1' THEN '인사팀'
                WHEN 'D2' THEN '회계팀'
                WHEN 'D3' THEN '마케팅팀'
                WHEN 'D4' THEN '국내영업팀'
                ELSE '해외영업팀'
            END;
    DBMS_OUTPUT.PUT_LINE(EMP.EMP_NAME || '은 ' || DNAME || '입니다.');
                
    
END;
/

/*
    반복분
    
    1) BASIC LOOP 문
    [표현법]
    LOOP
        반복적으로 실행할 구문;
        
        * 반복문을 빠져 나갈 수 있는 구문
        1) IF 조건식 THEN EXIT; END IF;
        2) EXIT WHEN 조건식;
    END LOOP;
*/

-- 1 ~ 5 까지 순차적으로 1씩 증가하는 값을 출력
DECLARE
    I NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I := I + 1;
        IF I = 6 THEN EXIT; END IF;
        -- EXIT WHEN I = 6;
    END LOOP;
END;
/

/*
    2) FOR LOOP문
    FOR 변수 IN [REVERSE] 초기값 .. 최종값
    LOOP
        반복적으로 수행할 구문;
    END LOOP;
*/

-- 1 ~ 5 까지 순차적으로 1씩 증가하는 값을 출력
BEGIN
    FOR I IN 1..5
    LOOP
         DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/

CREATE TABLE TEST(
    TNO NUMBER PRIMARY KEY,
    TDATE DATE
);

CREATE SEQUENCE SEQ_TNO
INCREMENT BY 2
MAXVALUE 1000;

BEGIN
    FOR I IN 1..500
    LOOP
        INSERT INTO TEST VALUES(SEQ_TNO.NEXTVAL , SYSDATE);
        COMMIT;
    END LOOP;
END;
/

-- 서브 쿼리를 이용한 반복문 조건 사용
BEGIN
    FOR emp IN (SELECT * FROM EMPLOYEE)
    LOOP
        DBMS_OUTPUT.PUT_LINE(emp.EMP_ID || ' , ' || emp.EMP_NAME);
    END LOOP;

END;
/

-- 중첩 반복문
BEGIN
    FOR OUTER IN (SELECT * FROM EMPLOYEE)
    LOOP
        FOR INNER IN (SELECT DEPT_TITLE FROM DEPARTMENT WHERE DEPT_ID = OUTER.DEPT_CODE)
        LOOP
            DBMS_OUTPUT.PUT_LINE(OUTER.EMP_NAME || ' + ' || INNER.DEPT_TITLE);
        END LOOP;
        /*
             FOR INNER IN (SELECT DEPT_TITLE FROM DEPARTMENT)
             LOOP
                IF INNER.DEPT_ID = OUTER.DEPT_CODE
                THEN DBMS_OUTPUT.PUT_LINE(OUTER.EMP_NAME || ' + ' || INNER.DEPT_TITLE);
                    EXIT;
                END IF;
             END LOOP;
        */
    END LOOP;
END;
/

-- 3) WHILE LOOP문
/*
    WHILE 반복문이 수행될 조건
    LOOP
        반복적으로 실행시킬 구문;
    END LOOP;
*/
-- 1 ~ 5 까지 순차적으로 1씩 증가하는 값을 출력
DECLARE
    I NUMBER := 1;
BEGIN
    WHILE I<6
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I := I + 1;
    END LOOP;
END;
/

-- 실습 문제

-- 1. 사원의 연봉을 구하는 pl/sql 블럭 작성. 보너스가 있는 사원은 보너스도 포함
DECLARE
    YSAL EMPLOYEE.SALARY%TYPE;
BEGIN
    FOR emp IN (SELECT * FROM EMPLOYEE)
    LOOP
        YSAL := (emp.salary * 12) * (1 + NVL(emp.BONUS,0)) ;
        DBMS_OUTPUT.PUT_LINE(emp.EMP_NAME || '의 연봉 : ' || YSAL);
    END LOOP;
END;
/

-- 1 풀이

DECLARE
    EMP EMPLOYEE%ROWTYPE;
    YSALARY EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    IF EMP.BONUS IS NULL
        THEN YSALARY := EMP.SALARY *12;
    ELSE YSALARY := EMP.SALARY * (1 + EMP.BONUS) * 12;
    END IF;

    DBMS_OUTPUT.PUT_LINE(EMP.EMP_NAME || '의 연봉 : ' || YSALARY);
END;
/

-- 2. 구구단 짝수 (FOR , WHILE)
-- 2-1) FOR LOOP
BEGIN
    FOR I IN 2..9
    LOOP
        IF MOD(I,2) = 0 THEN
        FOR J IN 1..9
        LOOP
            DBMS_OUTPUT.PUT_LINE(I || ' * ' || J || ' = ' || I*J);
        END LOOP;
            DBMS_OUTPUT.PUT_LINE('---------');
        END IF;
    END LOOP;
END;
/

-- 2-1) 풀이
BEGIN
    FOR DAN IN 2..9
    LOOP
        IF MOD(DAN , 2) = 0 THEN
        FOR SU IN 1..9
        LOOP
        DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || SU || ' = ' || DAN*SU);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
        END IF;
    END LOOP;
END;
/

-- 2-2) WHILE LOOP
DECLARE
    I NUMBER := 2;
    J NUMBER := 1;
BEGIN
    WHILE I < 10
    LOOP
        IF MOD(I,2) = 0 THEN
        WHILE J < 10
        LOOP
            DBMS_OUTPUT.PUT_LINE(I || ' * ' || J || ' = ' || I*J);
            J := J + 1;
        END LOOP;
            DBMS_OUTPUT.PUT_LINE('---------');
        END IF ;
            J := 1;
            I := I + 1;
    END LOOP;
END;
/

-- 2-2) 풀이
DECLARE
    DAN NUMBER := 2;
    SU NUMBER := 1;
BEGIN
    WHILE DAN < 10
    LOOP
        SU := 1;
        IF MOD (DAN , 2) = 0 THEN
        WHILE SU < 10
        LOOP
            DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || SU || ' = ' || DAN*SU);
            SU := SU +1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
        END IF;
        DAN := DAN +1;
    END LOOP;
END;
/