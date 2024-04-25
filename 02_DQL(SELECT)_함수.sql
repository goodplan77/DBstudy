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