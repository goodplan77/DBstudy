/* 
    <GROUP BY 절>
    
    그룹을 묶어줄 기준을 제시 할 수 있는 구문.
    그룹별 집합결과를 반환 해주는 그룹함수와 함께 사용된다.
    GROUP BY 절에 제시된 칼럼을 기준으로 그룹을 묶을수 있고 ,
    여러개의 칼럼을 제시해서 여러 그룹을 만들 수도 있음.
    
    [표현법]
    GROUP BY 칼럼
*/

-- 각 부서별로 총 급여의 합계
SELECT DEPT_CODE , SUM(SALARY) --4
FROM EMPLOYEE --1
WHERE 1=1 --2
GROUP BY DEPT_CODE --3
ORDER BY 1; --5

-- 'D1' 부서의 총 급여합
SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- 각 부서별 총 급여 합을 , 부서별 오름 차순으로 정렬하여 조회
SELECT DEPT_CODE , SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY 1;

-- 각 부서별 총 급여 합을 급여별 내림 차순으로 정렬하여 조회
SELECT DEPT_CODE , SUM(SALARY)--3
FROM EMPLOYEE --1
GROUP BY DEPT_CODE --2
ORDER BY 2 DESC; --4

-- 각 직급별 직급 코드 와 총 급여의 합 , 사원수 , 보너스를 받는 사원수 , 평균 급여 , 최고 급여 , 최소 급여
SELECT
    JOB_CODE ,
    SUM(SALARY) ,
    COUNT(*) ,
    COUNT(BONUS) ,
    TRUNC(AVG(SALARY)) ,
    MAX(SALARY) ,
    MIN (SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

-- 각 부서별 부서코드 , 사원수 , 보너스를 받는 사원수 , 사수가 있는 사원수 , 평균 급여를 부서별 오름차순 정렬
SELECT
    DEPT_CODE,
    COUNT(*),
    COUNT(BONUS),
    COUNT(MANAGER_ID),
    TRUNC(AVG(SALARY))
FROM EMPLOYEE -- 1
-- WHERE DEPT_CODE IS NOT NULL -- 2
GROUP BY DEPT_CODE --3
ORDER BY DEPT_CODE ASC;

-- 성별별 사원숫자 구하기
SELECT SUBSTR(EMP_NO,8,1) "성별",
    COUNT(*)
FROM EMPLOYEE
GROUP BY SUBSTR (EMP_NO,8,1);

-- 성별기준으로 평균 급여 구하기
-- 성별의 값이 1일때는 남자 , 2일 때는 여자값이 대신 나오도록 하고,
-- 평균 급여는 반올림 처리한후 , 0000000원 형식으로 반환.
SELECT
    CASE SUBSTR(EMP_NO,8,1) WHEN '1' THEN '남자' WHEN '2' THEN '여자' END "성별",                          
    -- DECODE (SUBSTR(EMP_NO,8,1) , '1' , '남자' , '2' , '여자' , '중성') AS "성별",
    ROUND(AVG(SALARY)) || '원' AS "평균 급여"
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO,8,1);

-- 부서별 월급이 200만원 이하인 사원의 수
-- WHERE 을 사용 할 경우 그룹화 시킬 때 제외 해버림
SELECT
    DEPT_CODE,
    COUNT(CASE WHEN SALARY <= 2000000 THEN 1 /*ELSE NULL*/ END) AS "월급 200만원 이하 사원수"
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 모든 부서별로 부서 코드와 , 직급 코드가 'J6' 인 사원의 수
-- 부서 내에 직급코드가 'J6' 인 사원이 없다면 0명 출력
SELECT
    DEPT_CODE,
    COUNT(CASE WHEN JOB_CODE = 'J6' THEN 1 END) "직급 코드가 'J6' 인 사원의 수"
    -- COUNT(DECODE (JOB_CODE , 'J6' , 1 , NULL))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 각 부서별로 평균급여가 300만원 이상인 부서들만 조회시.
SELECT
    DEPT_CODE,
    (ROUND(AVG(SALARY))) "평균급여" --4
FROM EMPLOYEE -- 1
WHERE ROUND(AVG(SALARY)) >= 3000000 -- 2 -- 오류 발생. 문법상 현재위치에서 그룹 함수를 호출 할 수 없음
GROUP BY DEPT_CODE; --3

/*
    <HAVING 절>
    - 그룹에 대한 조건을 제시할 때 사용되는 구문
    - GROUP BY 절과 함께 사용함. 그룹화된 데이터를 기준으로만 조건을 제시함.
*/

SELECT
    DEPT_CODE,
    ROUND(AVG(SALARY)) --4
FROM EMPLOYEE --1
GROUP BY DEPT_CODE --2
HAVING AVG(SALARY) >= 3000000; --3

-- 각 직급별 급여 평균이 300만원 이상인 직급 코드 , 평균급여 , 사원수 , 최고급여 , 최소급여
SELECT
    JOB_CODE,
    ROUND(AVG(SALARY)),
    COUNT(*),
    MAX(SALARY),
    MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING AVG(SALARY) >= 3000000;

/*
    <SELECT 문 구조 및 실행 순서>
    5. SELECT   : 조회하고자 하는 칼럼들
    1. FROM     : 조회하고자 하는 테이블 / 가상테이블(DUAL) / VIEW
    2. WHERE    : 조건식 (단 , 그룹 함수는 사용 불가)
    3. GROUP BY : 그룹화 시킬 칼럼명 / 함수식
    4. HAVING   : 그룹 함수 식에 대한 조건식 (그룹화가 완료된 이후에 수행)
    6. ORDER BY : 정렬기준 (항상 마지막에 실행)
*/

/*
    <집합 연산자 SET OPERATOR>
    여러개의 쿼리문을 가지고 하나의 쿼리문으로 만들어주는 연산자
    
    - UNION (합집합) : 두 쿼리문을 수행한 결과값 (Result Set) 을 더한 후 "중복" 되는 부분은 제거
    - UNION ALL (합집합) : 두 쿼리문을 수행한 결과값 (Result Set) 을 더한 후 "중복" 되는 부분은 그대로 냅둠.
    - INTERSECT (교집합) : 두 쿼리문을 수행한 후 중복된 부분만 추출
    - MINUS (차집합) : 선행 쿼리문에서 후행 쿼리문의 결과값을 뺀 나머지 부분.
    
    결과 값을 합쳐서 하나의 Result set 으로 보여줘야함. 따라서 두 쿼리문의 SELECT 절 부분은 항상 동일해야함.
    즉 , 조회할 칼럼이 동일해야함.
*/

-- 1. UNION(합집합) : 두 쿼리문을 수행한 RESULT SET을 더해준 후 , 중복값은 제거.

-- 부서 코드가 D5이거나 , 급여가 300 만원 초과인 사원들을 조회
SELECT EMP_ID, EMP_NAME , DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'; -- 6명

SELECT EMP_ID, EMP_NAME , DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3000000; -- 8명

-- UNION
SELECT EMP_ID, EMP_NAME , DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' -- 6명
UNION
SELECT EMP_ID, EMP_NAME , DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3000000; -- 8명 (부서코드가 D5 인 사람 2명)

-- 2. UNION ALL : 두개의 쿼리 결과를 더해서 보여주는 연산자(단 , 중복제거 하지 않음)
-- 직급코드가 J6 이거나 또는 부서코드가 D1인 사원들을 조회 (사번 , 사원명 , 부서코드 , 직급코드)
SELECT EMP_ID , EMP_NAME , DEPT_CODE , JOB_CODE
FROM EMPLOYEE
WHERE JOB_CODE = 'J6' -- 6명 조회 (부서코드가 D1인 사원은 2명 존재함)
UNION ALL -- 9명 조회 (차태연 , 전지연 중복행 그대로 추가)
SELECT EMP_ID , EMP_NAME , DEPT_CODE , JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1'; -- 3명 조회 (직급 코드가 J6인 사원은 2명 존재함)

-- 3. INTERSECT : 교집합. 여러 쿼리 결과의 중복값만 조회
-- 직급 코드가 J6이고 부서코드가 D1인 사원들을 조회
SELECT EMP_ID , EMP_NAME , DEPT_CODE , JOB_CODE
FROM EMPLOYEE
WHERE JOB_CODE = 'J6'
INTERSECT
SELECT EMP_ID , EMP_NAME , DEPT_CODE , JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- 4. MINUS : 차집합. 선행 쿼리결과에 후행 쿼리 결과를 뺀 나머지 값.
-- 직급코드가 J6인 사원들중 부서코드가 D1인 사원들을 뺀 나머지 값을 조회
SELECT EMP_ID , EMP_NAME , DEPT_CODE , JOB_CODE
FROM EMPLOYEE
WHERE JOB_CODE = 'J6' -- AND DEPT_CODE != 'D1'
MINUS
SELECT EMP_ID , EMP_NAME , DEPT_CODE , JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

/*
    <그룹별 집계 함수>
    - GROUP BY 로 계산된 그룹별 산출결과물들을 "소그룹" 별로 추가 집계를 해주는 함수들
   
    1. <ROLLUP>
    ROLLUP(칼럼1 , 칼럼2) : GROUP BY로 묶은 소그룹간의 합계와 전체합계 , 칼럼 1번그룹의 합계를 산출
    GROUP BY ROLLUP(컬럼1 , 컬럼2) == GROUP BY (컬럼1 , 컬럼2) + GROUP BY (컬럼1) + 모든 집합 그룹 결과
   
    2. <CUBE>
    CUBE(칼럼1 , 칼럼2) : GROUP BY로 묶은 소그룹간의 합계와 전체합계 , 칼럼 1번그룹 , 칼럼2번그룹의 합계를 모두 반환
    GROUP BY CUBE(컬럼1 , 컬럼2) == GROUP BY (컬럼1 , 컬럼2) + GROUP BY (컬럼1) + GROUP BY (컬럼2) + 모든 집합 그룹 결과
    
    3. <GROUPING SETS>
    GROUPING SETS(칼럼1, 칼럼2) : GROUP BY로 묶은 칼럼1번 , 칼럼2번 그룹의 합계를 반환
    GROUP BY GROUPING SETS(컬럼1 , 컬럼2) == GROUP BY (컬럼1) + GROUP BY (컬럼2)
*/

-- 부서별 급여 총합.
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 직급별 급여 총합.
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

-- ROULLUP 함수?
SELECT DEPT_CODE, JOB_CODE,SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE , JOB_CODE -- 기본 실행 결과
UNION ALL
SELECT DEPT_CODE , NULL AS JOB_CODE , SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
UNION ALL
SELECT NULL AS DEPT_CODE , NULL AS JOB_CODE , SUM (SALARY)
FROM EMPLOYEE;
-- (칼럼1+2) + (칼럼1) + 총집계 결과

-- ROULLUP 함수
-- 통계용? 보고서용?
SELECT DEPT_CODE, JOB_CODE ,SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE,JOB_CODE)
ORDER BY DEPT_CODE;

-- CUBE (모든 조합별 통계를 구함)
SELECT DEPT_CODE, JOB_CODE ,SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE,JOB_CODE)
ORDER BY DEPT_CODE;

-- GROUPING SETS(칼럼1, 칼럼2)
SELECT DEPT_CODE, JOB_CODE ,SUM(SALARY)
FROM EMPLOYEE
GROUP BY GROUPING SETS(DEPT_CODE,JOB_CODE);

SELECT DEPT_CODE , SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
UNION ALL
SELECT JOB_CODE , SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

-- GROUPING
-- 그룹 집계 함수와 함께 사용되며 , NULL 값이 아닌 다른값으로 대체 할 때 사용함.
SELECT
    CASE WHEN GROUPING(DEPT_CODE) = 1 THEN '종합'
    WHEN DEPT_CODE IS NULL THEN '부서코드없음'
    ELSE DEPT_CODE
    END AS "부서코드",
    CASE GROUPING(JOB_CODE) WHEN 1 THEN DEPT_CODE ||' 부서코드 합'
    ELSE JOB_CODE
    END AS "직급코드",
    SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE,JOB_CODE)
ORDER BY DEPT_CODE;