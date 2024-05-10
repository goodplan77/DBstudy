/*
    <함수 FUNCTION>
    Java 메소드와 같은 존재
    매개변수로 전달된 값들을 읽어서 계산한 결과를 반환해줌.
    
    - 단일행 함수 : N개의 값을 읽어서 N개의 결과 값을 리턴해주는 함수
                    (매 행마다 실행되는 함수) 
    - 그룹 함수 :   N개의 값을 읽어서 1개의 결과를 리턴
                    (하나의 그룹별로 함수 실행후 결과 값 반환)
                    
    단일행 함수와 그룹 함수는 함께 사용 할 수 없음 : 결과 행의 갯수가 다름
*/

----- <단일 행 함수> -----
----- <문자열 관련 함수> -----
/*
    LENGTH / LENGTHB
    - LENGTH(문자열)   : 문자열의 글자수 반환
    - LENGTHB(문자열)  : 문자열의 바이트수 반환
    
    결과 값은 NUMBER로 반환
    
    한글 : 3BYTE 취급.
    영문 , 숫자 , 특수문자 : 1BYTE
*/

SELECT LENGTH('오라클') , LENGTHB('오라클')
-- FROM EMPLOYEE;
FROM DUAL;
-- 가상 테이블(DUMMY TABLE) : 산술연산이나 가상 칼럼등 값을 한번만 출력하고 싶을 때 사용하는 테이블

SELECT '오라클' , 1 , 2 ,3
FROM DUAL;

SELECT EMAIL, LENGTH(EMAIL) , LENGTHB(EMAIL)
FROM EMPLOYEE;

/*
    INSTR
    - INSTR(문자열 , 특정문자 , 찾을위치의 시작값 , 순번) : 문자열로부터 특정 문자의 위치값 반환.
    
    찾을 위치의 시작값 , 순번은 생략가능하며 , 결과값은 number
    
    찾을 위치의 시작 값 : (1 / -1)
    1 : 앞에서부터
    -1 : 뒤에서부터
*/
SELECT INSTR('AABAACAABBAA' , 'B' , 1) -- 1기본값
FROM DUAL; --3

SELECT INSTR('AABAACAABBAA' , 'B' , -1) -- 1기본값
FROM DUAL; --10

SELECT INSTR('AABAACAABBAA' , 'B' , -1 , 2) -- 1기본값
FROM DUAL; --9

SELECT INSTR('AABAACAABBAA' , 'B' , -1 , 0) -- 1기본값
FROM DUAL; -- 범위를 벗어난 순번 제시 했을 경우 오류 발생.

-- EMAIL에서 @의 위치를 찾아보기.
SELECT EMP_NAME , EMAIL , INSTR(EMAIL , '@') AS "@의 위치"
FROM EMPLOYEE;

/*
    <SUBSTR>
    문자열로 부터 특정 문자열을 추출하는 함수
    
    - SUBSTR (문자열 , 처음위치 , 추출한 문자 갯수)
    
    결과값은 CHARACTER 타입으로 반환
    추출할 문자 갯수는 생략가능(생략시에는 문자열 끝까지 추출)
    처음 위치는 음수로 제시 가능 : 뒤에서 부터 N번째 위치에서 추출 시작
*/
SELECT SUBSTR('SHOWMETHEMONEY' , 7)
FROM DUAL; --THEMONEY

SELECT SUBSTR('SHOWMETHEMONEY' , 5 , 2)
FROM DUAL; --ME

SELECT SUBSTR('SHOWMETHEMONEY' , 1 , 6)
FROM DUAL; --ME

SELECT SUBSTR('SHOWMETHEMONEY' , -8 , 8)
FROM DUAL; --THEMONEY

-- 주민등록번호에서 성별부분만 추출해서 남자인지, 여자인지를 체크
SELECT EMP_NAME , SUBSTR(EMP_NO , INSTR(EMP_NO,'-') + 1 , 1) AS "성별"
FROM EMPLOYEE;

-- 이메일에서 @이전. 즉 , ID 값만 추출
SELECT EMP_NAME,EMAIL, SUBSTR(EMAIL , 1 , INSTR(EMAIL,'@')-1) AS "ID"
FROM EMPLOYEE;

-- 남자 사원들만 , 여자 사원들만 조회
SELECT EMP_NAME , EMP_NO
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) IN(1,3); -- 자동 형변환

/*
    <LPAD / RPAD>
    - LPAD / RPAD(문자열 , 최종적으로 반환할 문자의 길이(byte) , 덧붙이고자 하는 문자)
    : 문자열에 덧붙이고자 하는 문자를 왼쪽 / 오른쪽에 덧붙여서 최종 n만큼의 문자열을 반환
    
    결과값 CHARACTER 반환
    덧붙이고자하는 문자는 생략가능 : 기본 값 ''
*/

SELECT LPAD(EMAIL , 16)
FROM EMPLOYEE;

SELECT RPAD(EMAIL , 16)
FROM EMPLOYEE;

-- 주민등록번호 조회 : 611211-198123 -> 611211-1*****
SELECT EMP_NAME , EMP_NO , RPAD(SUBSTR(EMP_NO,1,INSTR(EMP_NO,'-')+1) /*8*/ , 14 , '*')
FROM EMPLOYEE;

/*
    LTRIM / RTRIM
    
    - LTRIM / RTRIM (문자열 , 제거시키고자 하는 문자)
    : 문자열에서 왼쪽 / 오른쪽 에서 제거 시키고자 하는 문자들을 찾아서 제거한 나머지 문자열을 반환
    
    결과 값 CHARACTER 형태.
    제거 시키고자 하는 문자 생략가능. 기본값은 ' '
*/

SELECT RTRIM('     K H    ')
FROM DUAL;

SELECT LTRIM('0001230456000' , '0')
FROM DUAL;

SELECT LTRIM ('123KH123' , '132') -- 포함되어 있으면 제거
FROM DUAL;

/*
    <TRIM>
    - TRIM (BOTH / LEADING / TRAILING '제거 하고자 하는 문자' FROM '문자열')
    
    결과값은 CHARACTER
    BOTH / LEADING / TRAILING 은 생략 가능 (기본 값 BOTH)
*/

SELECT TRIM('             K      H           ')
FROM DUAL; -- 제거 시키고자 하는 문자도 생략가능 기본값 ' '

-- ZZZZZZKHZZZZZZZZ
SELECT TRIM ('Z' FROM 'ZZZZZZKHZZZZZZZZ')
FROM DUAL;

SELECT TRIM (BOTH 'Z' FROM 'ZZZZZZKHZZZZZZZZ')
FROM DUAL; -- BOTH 가 기본값

SELECT TRIM (LEADING 'Z' FROM 'ZZZZZZKHZZZZZZZZ')
FROM DUAL; -- TRIM

SELECT TRIM (TRAILING 'Z' FROM 'ZZZZZZKHZZZZZZZZ')
FROM DUAL; -- RTRIM

/*
    LOWER/UPPER/INITCAP
    
    - LOWER : 다 대문자 변경
    - UPPER : 다 소문자 변경
    - INITCAP : 각 단어의 앞글자만 대문자로 변경 (공백 , _ 이 있는경우 분리 되어서 사용됨)
*/

SELECT LOWER('Welcome to C class') , UPPER('Welcome to C class') , INITCAP('Welcome to C class')
FROM DUAL;

/*
    CONCAT
    
    - CONCAT(문자열1 , 문자열2)
    : 전달된 문자열 2개를 하나의 문자열 합쳐서 반환
    
    결과 값은 문자열
*/

SELECT CONCAT ('가나다' , '라마바')
FROM DUAL; -- 연결 연산자를 통해 문자열 합치기 가능.

/*
    REPLACE
    
    - REPLACE(문자열, 찾을 문자, 바꿀문자)
    : 문자열로 부터 찾을 문자를 찾아서 바꿀문자로 바꾼 문자열 반환
    찾을 문자 자리에는 정규표현식 기술 가능.
*/
SELECT REPLACE ('서울시 강남구 역삼동' , '역삼동' , '삼성동')
FROM DUAL;

-- EMAIL -> kh.or.kr 을 iei.or.kr
SELECT EMP_NAME , REPLACE (EMAIL , 'kh' , 'iei') AS "바꾼 email"
FROM EMPLOYEE;

----- <숫자 관련 함수> -----
/*
    ABS
    - ABS(절대값을 구할 숫자) : 절대값을 구해주는 함수
    : NUMBER
*/

SELECT ABS(-10) , ABS(-10.9)
FROM DUAL;

/*
    ROUND
    - ROUND(반올림 하고자 하는 수 , 반올림 할 위치) : 반올림 처리 해주는 함수
    
    반올림 할 위치 : 소숫점 기준으로 아래 N번째 수에서 반올림 하겠다. (생략가능) 기본값은 0
*/

SELECT ROUND(123.456)
FROM DUAL; -- 123

SELECT ROUND(123.456 , 1)
FROM DUAL; -- 123.5

SELECT ROUND(123.456 , 2)
FROM DUAL; -- 123.46

SELECT ROUND(123.456 , -1)
FROM DUAL; -- 120

SELECT ROUND(123.456 , -2)
FROM DUAL; -- 100

/*
    <CEIL / FLOOR>
    - CEIL(올림 처리 할 숫자) : 소숫점 아래의 수를 무조건 올림 처리
    - FLOOR(버림 처리 할 숫자) : 소숫점 아래의 수를 무조건 버림 처리
*/

SELECT CEIL(123.1111) , FLOOR(123.1111)
FROM DUAL; --124 , 123

-- 각 직원별 근무 일수 구하기 (현재 시간 - 근무 날짜)
SELECT EMP_NAME , CEIL(SYSDATE - HIRE_DATE) || '일' AS "근무일수"
FROM EMPLOYEE;

/*
    TRUNC
    - TRUNC (버림 처리할 숫자 , 위치) : 위치 지정이 가능한 버림 처리 함수
    
    위치 값 생략 가능. 기본값 0
*/

SELECT TRUNC(123.786)
FROM DUAL; -- 123 == FLOOR와 동일

SELECT TRUNC(123.786 , 1)
FROM DUAL; -- 123.7

SELECT TRUNC(123.786 , 2)
FROM DUAL; -- 123.78

SELECT TRUNC(123.786 , -1)
FROM DUAL; -- 120

SELECT TRUNC(123.786 , -2)
FROM DUAL; -- 100

----- <날짜 관련 함수> -----
/*
    DATE 타입 : 년 , 월 , 일 , 시 , 분 , 초 를 전부다 가지고 있는 자료형
*/

SELECT SYSDATE FROM DUAL;

-- 1. MONTHS_BETWEEN (DATE1 , DATE2) : 두 날짜 사이의 개월 수 반환 (결과값 NUMBER)
-- DATE2 가 과거여야 한다. DATE2 가 좀 더 미래 일 경우 음수 값 반환
-- 각 지원별 근무 일수 . 근무 개월 수

SELECT
    EMP_NAME ,
    FLOOR (SYSDATE - HIRE_DATE) AS 근무일수,
    FLOOR (MONTHS_BETWEEN(SYSDATE , HIRE_DATE)) AS 근무개월수
FROM EMPLOYEE;

-- 2. ADD_MONTHS (DATE, NUMBER) : 특정 날짜에 해당 개월 수를 더한 날짜를 반환
-- 오늘 날짜로부터 5개월 이후
SELECT ADD_MONTHS (SYSDATE , 5)
FROM DUAL;

-- 전체 사원들의 1년 근속일 (== 입사일 기준 1주년 되는날)
SELECT EMP_NAME , HIRE_DATE , ADD_MONTHS(HIRE_DATE , 12)
FROM EMPLOYEE;

-- 3. NEXT_DAY (DATE , 요일(문자/숫자)) : 특정 날짜에서 가장 가까운 해당 요일을 찾아서 그 날짜를 반환
SELECT NEXT_DAY (SYSDATE , '수요일')
FROM DUAL;
/*
SELECT NEXT_DAY (SYSDATE , 'SAT')
FROM DUAL; -- 현재 컴퓨터 언어 세팅이 KOREAN 이기 때문에 문제 발생
SELECT NEXT_DAY (SYSDATE , '수')
FROM DUAL; -- 현재 컴퓨터 언어 세팅이 KOREAN 이 아니면 문제 발생 (AMERICAN)
*/

SELECT NEXT_DAY (SYSDATE , 4)
FROM DUAL;

-- 일    월   화   수   목   금   토
-- 1     2   3    4    5    6    7

-- 사용 언어 변경하기
-- ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
-- ALTER SESSION SET NLS_LANGUAGE = KOREAN;

-- 4. LAST_DAY (DATE) : 해당 달의 마지막 날짜를 구해서 반환
SELECT LAST_DAY (SYSDATE)
FROM DUAL;

SELECT EMP_NAME , HIRE_DATE , LAST_DAY(HIRE_DATE)
FROM EMPLOYEE;

-- 5. EXTRACT : 추출하다. 년도 , 월 , 일 정보를 추출해서 반환. 반환형이 NUMBER
-- EXTRACT(YEAR/MONTH/DAY FROM 날짜) : 날짜에서 년 , 월 , 일 정보를 추출
SELECT
    EXTRACT(YEAR FROM SYSDATE),
    EXTRACT(MONTH FROM SYSDATE),
    EXTRACT(DAY FROM SYSDATE)
FROM DUAL;

----- <형 변환 함수> -----
/*
    NUMBER / DATE => CHARACTER
    
    - TO_CHAR(NUMBER/DATE , 포맷)
    : 숫자형 또는 날짜형 데이터를 문자형 타입으로 반환
*/
-- 숫자를 문자열로
SELECT TO_CHAR(1234)
FROM DUAL; -- 1234 -> '1234'

SELECT TO_CHAR(1234, '00000')
FROM DUAL; -- 0 : 빈칸을 0으로 채움 -> 01234

SELECT TO_CHAR(1234, '99999')
FROM DUAL; -- 9 : 빈칸을 ' ' 으로 채움

SELECT TO_CHAR(1234, 'L99,999')
FROM DUAL;
-- 9 : 빈칸을 ' ' 으로 채움
-- L : LOCAL, 지역 정보상의 화폐 단위

SELECT TO_CHAR(1234, 'L0,000')
FROM DUAL;
-- 9 : 빈칸을 ' ' 으로 채움
-- L : LOCAL, 지역 정보상의 화폐 단위

-- 각 사원의 월급을 3자리 마다 , 로 찍어서 확인
SELECT
    EMP_NAME,
    LTRIM(TO_CHAR(SALARY , '999,999,999')) AS "급여"
FROM EMPLOYEE;

-- 날짜를 문자열로
SELECT TO_CHAR(SYSDATE , 'YYYY-MM-DD PM HH:MI:SS')
FROM DUAL; -- HH : 12시간 기준 , HH24 : 24시간 기준

SELECT TO_CHAR(SYSDATE , 'MON DY DAY')
FROM DUAL;

-- 년도를 표시 할 때 사용하는 포맷
-- (YYYY , RRRR , YY , RR , YEAR)
SELECT
    TO_CHAR(SYSDATE, 'YYYY'),
    TO_CHAR(SYSDATE, 'RRRR'),
    TO_CHAR(SYSDATE, 'YY'),
    TO_CHAR(SYSDATE, 'RR'),
    TO_CHAR(SYSDATE, 'YEAR')
FROM DUAL;
/*
    -- YY 와 RR 의 차이점
    -- R? (ROUND 반올림)
    
    -- YY : 앞자리에 20을 붙임
    -- RR : 50년을 기준으로 적으면 20 , 크면 19가 붙음 => 89 -? 1989
*/

-- 월로 사용가능한 포맷
-- (MM , MON , MONTH , RM)
SELECT
    TO_CHAR(SYSDATE, 'MM'),
    TO_CHAR(SYSDATE, 'MON'),
    TO_CHAR(SYSDATE, 'MONTH'),
    TO_CHAR(SYSDATE, 'RM')
FROM DUAL;

-- 일로 사용가능한 포맷
SELECT
    TO_CHAR(SYSDATE , 'D'),
    TO_CHAR(SYSDATE , 'DD'),
    TO_CHAR(SYSDATE , 'DDD')
FROM DUAL;
-- D : 1주일 기준 일요일 부터 며칠째 인지 알려주는 포맷
-- DD : 1달 기준 현재 요일
-- DDD : 1년 기준으로 1월 1일 부터 며칠째인지 알려주는 포맷

-- 사원명 , 입사일(YYYY년 MM월 DD일 (DY)) 로 출력
-- 2010년 이후에 입사한 사원들만 출력
SELECT
    EMP_NAME ,
    TO_CHAR(HIRE_DATE , 'YYYY"년" MM"월" DD"일" (DAY)') AS "입사일"
FROM EMPLOYEE
-- WHERE HIRE_DATE >= '2010/01/01'
-- WHERE TO_CHAR(HIRE_DATE,'YYYY') >=2010
WHERE EXTRACT (YEAR FROM HIRE_DATE) >= 2010;

/*
    NUMBER / CHARACTER -> DATE
    
    - TO_DATE(NUMBER / CHARACTER '포맷') : 숫자 또는 문자형 데이터를 날짜로 변환
*/

SELECT TO_DATE(20240426)
FROM DUAL;

SELECT TO_DATE('20240427')
FROM DUAL;

SELECT TO_DATE('000101')
FROM DUAL; -- 0으로 시작하는 년도는 반드시 홀따옴표로 묶어서 문자열 처럼 다뤄야함.

SELECT TO_DATE('20240426' , 'YYYYMMDD')
FROM DUAL;

SELECT TO_DATE('240426 103950' , 'YYMMDD HHMISS')
FROM DUAL; -- RESULT SET 에서는 시,분,초 표기가 안되어 있으나 , 데이터 자체는 다 들어가 있음

SELECT TO_DATE('140630' , 'RRMMDD')
FROM DUAL;

SELECT TO_DATE('980630' , 'RRMMDD')
FROM DUAL;

SELECT TO_DATE('980630' , 'YYMMDD')
FROM DUAL;

/*
    CHARACTER -> NUMBER
    - TO_NUMBER(CHARACTER , '포맷') : 문자형 데이터를 숫자형으로 변환.
*/

SELECT '123' + '12345'
FROM DUAL; -- 자동형변환을 거친 후 산술연산 수행

SELECT '10,000,000' + '550,000'
FROM DUAL; -- 정수 안에 , 가 포함되어 있어 형 변환 불가

SELECT TO_NUMBER('10,000,000' , '99,999,999') + TO_NUMBER('55,000' , '999,999') AS "계산"
FROM DUAL;

SELECT TO_NUMBER('0123')
FROM DUAL;

----- <NULL 처리 함수> -----
-- NULL : 값이 존재 하지 않다를 나타내는 값
-- NVL , NVL2 , NULLIF

-- 1. NVL(칼럼명 , 해당 칼럼값이 NULL 일 경우 반환할 반환 값)
SELECT EMP_NO , BONUS , NVL(BONUS , 0)
FROM EMPLOYEE;

-- 보너스 포함 된 연봉 구하기
SELECT 
    EMP_NO,
    SALARY,
    NVL(BONUS , 0) AS BONUS,
    (SALARY + NVL(BONUS , 0) * SALARY) * 12 AS "보너스 포함 연봉"
FROM EMPLOYEE;

-- 2. NVL2(칼럼명 , 결과값1 , 결과값2)
-- 컬럼명이 NULL이 아닐경우 결과값1
-- 컬럼명이 NULL일 경우 결과값2
SELECT EMP_NAME, BONUS, NVL2(BONUS , '보너스있음' , '보너스없음') AS "보너스 유무"
FROM EMPLOYEE;

-- 사원명 , 부서코드 , 부서코드가 업는 경우 부서배치 미완료 , 부서코드가 있는 경우 부서 배치 완료
SELECT EMP_NAME , DEPT_CODE , NVL2(DEPT_CODE , '부서배치완료' , '부서배치 미완료') AS "부서배치유무"
FROM EMPLOYEE;

-- 3. NULLIF(비교대상1 , 비교대상2) : 동등비교
-- 두 값을 비교하여 동일할 경우 NULL 반환
-- 두 값을 비교하여 동일하지 않을 경우 비교대상1 반환

SELECT NULLIF('123','123')
FROM DUAL; -- 두값이 동일한경우 NULL값 반환

SELECT NULLIF('123','456')
FROM DUAL; -- 두값이 다른경우 비교대상1('123') 반환

SELECT NULLIF(EMP_NAME , '선동일')
FROM EMPLOYEE;

----- <선택 함수> -----
-- 선택 함수1 : DECODE -> SWITCH
-- 선택 함수2 : CASE WHEN THEN -> IF

/*
    - DECODE (비교대상 칼럼 , 조건값1, 결과1, 조건값2, 결과값2 ,...,[기본 결과값])
    
    - 자바에서 SWITCH 문과 유사
    switch(비교대상칼럼) {
    case 조건값1: 결과값1; break;
    case ...
    [default : 기본결과값;]
    }
    
    기본 결과 값은 생략시 null 처리된다.
    비교대상칼럼에는 칼럼명 , 산술연산결과 , 함수의 반환값이 들어갈 수 있음.
*/

-- 사번 , 사원명 , 주민번호 , 성별(남자,여자)
SELECT
    EMP_ID,
    EMP_NAME,
    EMP_NO,
    DECODE (SUBSTR(EMP_NO,8,1) , '1' , '남자' , '2' , '여자' , '중성') AS "성별"
FROM EMPLOYEE;

-- 직원들의 급여정보를 인상시켜서 조회
-- 직급코드가 J7 인경우 급여 10% 인상하여 조회
-- 직급코드가 J6 인경우 15% 인상
-- 직급코드가 j5 인경우 20% 인상
-- 그외 직급은 5%인상하여 조회
-- 사원명 , 직급코드 , 변경전 급여 , 변경후 급여
SELECT
    EMP_NAME,
    JOB_CODE,
    SALARY AS "변경전 급여",
    DECODE(JOB_CODE , 'J7' , SALARY*1.1 , 'J6' , SALARY*1.15 , 'J5' , SALARY*1.2 , SALARY*1.05) AS "변경후 급여"
FROM EMPLOYEE;

/*
    CASE WHEN THEN 구문
    
    - DECODE 선택 함수와 비교하면 DECODE는 해당 조건 검사시 동등비교만 수행
    CASE WHEN THEN 구문의 경우 특정 조건을 내 맘대로 제시 할 수 있음.
    
    [표현법]
    CASE [칼럼값] WHEN 조건식1 THEN 결과값1
                 WHEN 조건식2 THEN 결과값2
                 ...
                 ELSE 결과값
    END;
    
    - 자바의 if ~ else if 문과 비슷한 구조
    if(조건식1){
        결과값1;
    }
    else if(조건식2){
        결과값2;
    }
    else {
        결과값;
    }  
*/

-- CASE WHEN 으로 성별 자리를 추출
SELECT
    EMP_ID,
    EMP_NAME,
    EMP_NO,
    CASE
        WHEN SUBSTR(EMP_NO , 8 , 1) = 1 THEN '남자'
        WHEN SUBSTR(EMP_NO , 8 , 1) = 2 THEN '여자'
        WHEN SUBSTR(EMP_NO , 8 , 1) = 3 THEN '남자'
        WHEN SUBSTR(EMP_NO , 8 , 1) = 4 THEN '여자'
        ELSE '중성'
        END AS "성별"
FROM EMPLOYEE;

-- CASE WHEN에서 단순 특정값에 대해 동등비교만 수행하고 있다면?
-- CASE 비교값 WHEN 비교값1 THEN 결과값1 ... END;

SELECT
    EMP_ID,
    EMP_NAME,
    EMP_NO,
    CASE SUBSTR(EMP_NO , 8 , 1)
        WHEN '1' THEN '남자'
        WHEN '2' THEN '여자'
        WHEN '3' THEN '남자'
        WHEN '4' THEN '여자'
        ELSE '중성'
        END AS "성별"
FROM EMPLOYEE;

-- 사원명 , 급여 , 급여등급을 조회 (SAL_LEVEL 칼럼 사용금지)
-- 급여 등급은 SALARY 값이 400 만원 초과인 경우 '고급'
--           SALARY 값이 400 만원 이하 350 만원 초과 일 경우 '중급'
--           SALARY 값이 350 만원 이하 200 만원 초과 일 경우 '초급'
--           그 외는 '수습'
-- CASW WHEN 구문으로 작성해보기
SELECT
    EMP_NAME,
    SALARY,
    CASE
        WHEN SALARY > 4000000 THEN '고급'
        WHEN SALARY > 3500000 THEN '중급'
        WHEN SALARY > 2000000 THEN '초급'
        ELSE '수습'
        END AS "급여등급"
FROM EMPLOYEE;

-- CASE WHEN 구문 WHERE 절에서 사용
SELECT *
FROM EMPLOYEE
WHERE CASE WHEN SALARY > 4000000 THEN 1 END = 1;

-- CASE WHEN + ORDER BY 절 구문으로 행의 순서 고정하기
-- CASE WHEN 조건1 THEN 1
--      WHEN 조건2 THEN 2
--      WHEN 조건3 THEN 3
--      WHEN 조건4 THEN 4
--      ELSE 4;

-- EMPLOYEE EMP_ID 205번인 사원을 항상 1등으로 , 210번 사원을 항상 2등처리 , 그 외는 정상적으로 출력
SELECT EMP_NAME , EMP_ID , SALARY
FROM EMPLOYEE
ORDER BY
    CASE EMP_ID
        WHEN '205' THEN 1
        WHEN '210' THEN 2
        ELSE 3
        END;
        
SELECT EMP_NAME , EMP_ID , SALARY , JOB_CODE
FROM EMPLOYEE
ORDER BY
    CASE JOB_CODE
            WHEN 'J3' THEN 1
            WHEN 'J4' THEN 2
            ELSE 3 END , SALARY DESC;
            
            
----- <그룹 함수> -----
-- 그룹함수 : 데이터들의 합 (SUM) , 평균(AVG) ...
/*
    N개의 값을 읽어 들여서 1개의 결과를 반환 (하나의 그룹별로 함수 실행 결과를 반환)
*/

-- 1. SUM(숫자타입컬럼) : 컬럼 값의 총 합계를 반환
-- 전체 사원들의 총 급여 합계
SELECT SUM(SALARY*12) AS "연봉 총합"
FROM EMPLOYEE;

-- 부서코드가 D5인 사원들의 총 급여 합계
SELECT SUM(SALARY) -- , EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- 2. AVG(숫자타임컬럼) : 평균반환
SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE;

-- 3. MIN (ANY 타입) : 칼럼값중 가장 작은값 반환
-- 전체 사원들중 최저급여 , 가장 작은? 이름 , 가장 작은 이메일 , 가장 과거 입사 날짜
SELECT MIN(SALARY) , MIN(EMP_NAME) , MIN(EMAIL) , MIN(HIRE_DATE)
FROM EMPLOYEE;

-- 4. MAX (ANY 타입) : 칼럼값중 가장 큰값 반환
-- 위 3 예시에서 가장 큰 경우
SELECT MAX(SALARY) , MAX(EMP_NAME) , MAX(EMAIL) , MAX(HIRE_DATE)
FROM EMPLOYEE;

-- 5. COUNT(*/컬럼/DISTINCT컬럼) : 조회딘 행의 갯수를 세서 반환.
-- COUNT(*) : 조회결과로 나온 행의 갯수를 모두 세서 반환
-- COUNT(컬럼이름) : 컬럼값이 NULL이 아닌 행의 갯수만 세서 반환
-- COUNT(DISTINCT 컬럼이름) : 제시한 해당 컬럼값에 중복값이 있는 경우 한개로 처리. 그리고 NULL도 포함시키지 않음

SELECT COUNT(*)
FROM EMPLOYEE;

-- 여자인 사원의 수?
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR (EMP_NO,8,1) = 2;

-- 부서 배치가 완료된 사원의 수
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE;

SELECT COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL;

-- 부서 배치가 완료된 여자 사원의 수
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE
WHERE SUBSTR (EMP_NO,8,1) = 2;

SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR (EMP_NO,8,1) = 2 AND DEPT_CODE IS NOT NULL;

-- 현재 사원들이 속해 있는 부서의 개수
SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;

-- 현재 사용되고 있는 직급의 갯수
SELECT COUNT(DISTINCT JOB_CODE)
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 직원명 , 부서코드 , 생년월일 , 나이 조회
-- 생년월일 : 주민번호에서 추출하여 00년 00월 00일로 출력 되게 하며,
-- 나이는 주민번호에서 추출하여 날짜데이터로 변화한 다음 계산 -> 현재 년도 - 태어난 년도
SELECT
    EMP_NAME,
    DEPT_CODE,
    -- SUBSTR(EMP_NO,1,2) || '년 ' ||SUBSTR(EMP_NO,3,2) || '월 ' || SUBSTR(EMP_NO,5,2) ||'일',
    TO_CHAR (TO_DATE (SUBSTR(EMP_NO,1,6) , 'RRMMDD'), 'RR"년" MM"월" DD"일"'),
   -- (EXTRACT (YEAR FROM SYSDATE)) - (EXTRACT (YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,6) , 'RRMMDD')))
   SYSDATE - EXTRACT (YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2) ,'RR'))
FROM EMPLOYEE;

----- <윈도우 함수> -----
/*
    - 윈도우 함수(WINDOW FUNCTION) == 분석 함수 , 순위 함수
    WINDOW ? SQL 에서 RESULT SET를 특정 부분으로 분할하거나 , 관찰하는 논리적인 개념
            WINDOW(창)을 통해 데이터를 "관찰" 또는 "분석" 하고 "순위"를 매기는 함수들을 WINDOW FUNCTION 이라고 부름
            조회결과 혹은 통계결과를 확인 시 사용.
           
    SELECT가 완료된 후 , ORDER BY 실행 전에 실행됨.
    
    1. FROM
    2. WHERE
    3. SELECT
    4. WINDOW FUNCTION
    5. ORDER BY
    
    1. 순위를 매기는 함수
    RANK () OVER ([그룹화 기준] 정렬기준)
    DENSE_RANK() OVER ([그룹화 기준] 정렬기준)
    ROW_NUMBER() OVER ([그룹화 기준] 정렬기준)
*/

-- 1. RANK () OVER ([PARTITION BY 칼럼] ORDER BY 칼럼 [ASC/DESC])
-- 공동 1위가 3명 존재할 경우 그 다음 순위를 4위로 정함.
-- 정렬 기준 ? ORDER BY 정렬기준 칼럼이름 [ASC/DESC] NULLSFIRST/NULLSLAST 는 기술 불가.
-- PARTITON ? 데이터를 분할 하는 행위. 칼럼 기준으로 데이터를 분할하기 위한 예약어.
--            그룹화된 데이터 안에서 순위를 매길 수 있음

-- 사원들의 급여가 높은 순서대로 매겨서 사원명 , 급여 , 순위 조회
SELECT EMP_NAME , SALARY , RANK() OVER (ORDER BY SALARY DESC) AS 순위
FROM EMPLOYEE;

-- 2. DENSE_RANK () OVER ([PARTITION BY 칼럼] ORDER BY 칼럼 [ASC/DESC])
-- DENSE == 밀집된 랭킹 부여?
-- 공동 1위가 3명 존재 해도 , 그 다음 순위는 2위로 정함.
-- 사원들의 급여가 높은 순서대로 매겨서 사원명 , 급여 , 순위 조회
SELECT EMP_NAME , SALARY , DENSE_RANK() OVER (ORDER BY SALARY DESC) AS 순위
FROM EMPLOYEE;

-- 3. ROW_NUMBER () OVER ([PARTITION BY 칼럼] ORDER BY 칼럼 [ASC/DESC])
-- 공동 순위가 없는 고유한 번호를 부여 하는 함수.
SELECT EMP_NAME , SALARY , ROW_NUMBER() OVER (ORDER BY SALARY DESC) AS 순위
FROM EMPLOYEE;

-- DEPT_CODE(부서) 별로 데이터를 그룹화 한 후 SALARY 기준 내림차순 정렬을 시킨후 고유한 순위를 부여 하시오
SELECT EMP_NAME , DEPT_CODE ,SALARY , ROW_NUMBER() OVER(PARTITION BY DEPT_CODE ORDER BY SALARY DESC)
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 사원의 이름 , 직급코드 , 봉급 , 보너스 미포함 연봉을 구한후
-- 직급별로 그룹화 하여 소그룹 내에서 연봉을 많이 받는 사원부터 고유한 순서를 매기시오.
SELECT
    EMP_NAME,
    JOB_CODE,
    SALARY,
    (SALARY*12) AS "보너스 미포함 연봉",
    ROW_NUMBER() OVER (PARTITION BY JOB_CODE ORDER BY (SALARY*12) DESC) AS "순위"
FROM EMPLOYEE;

-- 윈도우 함수 + ORDER BY 절
SELECT EMP_NAME , SALARY , ROW_NUMBER() OVER (ORDER BY SALARY DESC) AS "순위"
FROM EMPLOYEE
ORDER BY EMP_ID ASC;
-- ORDER BY 절은 RESULT SET 집합 결과가 다 만들어진 후 마지막에 실행된다.
-- 사용시기가 겹치는 WINDOW 함수와 함께 사용하지 않는다.

/*
    그룹 내 행의 순서를 가져오는 함수
    4. LAG(LEAD AND GET) : 현재행 기준 앞의 행의 값을 가져올때 사용함.
    5. LEAD : 현재행 기준 뒤의 행의 값을 가져올때 사용함.
    
    [표현법]
    LAG/LEAD(가져올 칼럼, 가져올 행번호, 행이 없는 경우 기본값) OVER ([PARTITION BY 칼럼] ORDER BY 칼럼)
*/

-- 조회 결과 내에서 월급 기준으로 내림차순 정렬한 후, 이전 행의 월급 가져오기
SELECT
    EMP_NAME,
    DEPT_CODE,
    SALARY,
    LAG(SALARY) OVER (ORDER BY SALARY DESC) "이전 직원 월급"
FROM EMPLOYEE;

-- 조회 결과 내에서 월급 기준으로 내림차순 정렬한 후, 이후 행의 월급 가져오기
SELECT
    EMP_NAME,
    DEPT_CODE,
    SALARY,
    LEAD(SALARY) OVER (ORDER BY SALARY DESC) "다음 직원 월급"
FROM EMPLOYEE;

-- 전전 사람의 월급 가져오기
SELECT
    EMP_NAME,
    DEPT_CODE,
    SALARY,
    LAG(SALARY , 2 , 0) OVER (ORDER BY SALARY DESC) "이전 직원 월급"
FROM EMPLOYEE;

-- 조회결과 내에서 DEPT_CODE 별로 그룹화시켜준후 월급 기준 내림차순 정렬
-- 이후 각 소그룹별로 다음사람의 월급 가져오기
SELECT
    EMP_NAME,
    DEPT_CODE,
    SALARY,
    LEAD(SALARY) OVER(PARTITION BY DEPT_CODE ORDER BY SALARY DESC)
FROM EMPLOYEE;

/*
    [실습]
    직원의 사원번호 , 이름 , 직급코드 , 월급을 조회 한 후
    조회결과 내에서 직급 코드 별로 그룹화 하여 소그룹 내에서 전 직원의 월급을 가져오기
    단 , 가져올 데이터가 없는 경우 0원으로 표시하며 소그룹 내에서 사원번호 기준으로 오름차순 정렬
*/
SELECT
    EMP_ID,
    EMP_NAME,
    JOB_CODE,
    SALARY,
    LAG(SALARY , 1 , 0) OVER (PARTITION BY JOB_CODE ORDER BY EMP_ID ASC) AS "결과"
FROM EMPLOYEE;

SELECT EMPLOYEE.* , RANK() OVER(ORDER BY SALARY DESC) "순위"
FROM EMPLOYEE;