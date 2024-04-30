/*
    <SUBQUERY>
    하나의 주된 SQL(SELECT , INSERT , DELETE , UPDATE , CREATE...) 안에 포함된 또 하나의 SELECT문

    메인 SQL문을 위해서 보조역할을 한다.
    => SELECT, FROM, WHERE, HAVING 절 등 다양한 위치에서 사용가능하며 , 사용되는 위치마다 부르는 명칭이 다름.
    => SELECT => 스칼라 서브쿼리 -> 스칼라 (하나의 값) 을 반환 해주는 서브쿼리
    => FROM => 인라인 뷰(파생 테이블) -> VIEW 라는 객체를 인라인에 정의했다 라는 의미, 서브쿼리의 조회결과를 테이블처럼 활용.
    => WHERE , HAVING => 프레디케이트 서브쿼리 --> 조건검사에 사용되는 서브쿼리
*/

-- 간단 서브쿼리 예시
-- 1) 노옹철사원과 같은 부서인 사원들 정보를 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철'

SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 두 쿼리를 하나로 합치기
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = (
                    SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '노옹철'
                    );

-- 2) 전체 사원의 평균 급여보다 더 많이 받고 있는 사원들의 사번 , 이름 , 직급 코드 조회
-- 1] 전체 사원의 평균 급여
SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE;

SELECT EMP_ID , EMP_NAME , JOB_CODE
FROM EMPLOYEE
WHERE SALARY > (
                SELECT ROUND(AVG(SALARY))
                FROM EMPLOYEE
                ); -- 비효율적?

/*
    서브쿼리 구문
    서브쿼리를 수행한 결과값이 몇행 몇열 이냐에 따라서 분류됨.

    - 단일행 (단일열) 서브쿼리 : 서브쿼리를 수행한 결과값이 오직 1개일떄
    - 다중행 (단일열) 서브쿼리 : 서브쿼리를 수행한 결과값이 여러 행일때
    - (단일행) 다중열 서브쿼리 : 서브쿼리를 수행한 결과값이 여러 열일때
    - 다중행 다중열 서브쿼리 : 서브쿼리를 수행한 결과값이 여러행 여러열 일때
*/

/*
    1. 단일행 (단일열) 서브쿼리
        서브쿼리의 조회 결과값이 오직 1개일 때

    일반 연산자들 활용가능 (= ,  != , >= , <=...)
*/
-- 전 직원의 평균 급여 보다 더 적게 받는 사원들의 사원명 , 직급코드 , 급여 조회
SELECT EMP_NAME , JOB_CODE , SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY) FROM EMPLOYEE);

-- 노옹철 사원의 급여보다 더 많이 받은 사원들의 사번 , 이름 , 부서명 , 급여를 조회
--> 오라클전용 구문
SELECT EMP_NO , EMP_NAME , DEPT_TITLE , SALARY
FROM EMPLOYEE , DEPARTMENT
WHERE EMPLOYEE.DEPT_CODE = DEPT_ID(+) AND SALARY > (SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME='노옹철')
ORDER BY 1;

--> ANSI 구문
SELECT EMP_NO , EMP_NAME , DEPT_TITLE , SALARY
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME='노옹철');

-- 부서별 급여 합이 가장 큰 부서 하나만을 조회. 부서코드 , 부서명 , 급여의 합
-- 1) 각 부서별 급여의 합을 구한후 , 최대값 찾기
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE

-- 2) 메인 쿼리문 작성
SELECT DEPT_CODE , DEPT_TITLE , SUM(SALARY) 급여의합
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON DEPT_CODE=DEPT_ID
GROUP BY DEPT_CODE , DEPT_TITLE;
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY)) FROM EMPLOYEE GROUP BY DEPT_CODE);

/*
    2. 다중행 서브쿼리

    서브쿼리의 조회 결과값이 여러행일 경우
    - 칼럼 IN (10,20,30) : 여러개의 결과값중 하나라도 일치하는것이 있다면...
    - 칼럼 > ANY (10,20,30) : 여러개의 결과값중 "하나라도" 칼럽값이 더 클 경우 참.
    - 칼럼 < ANY (10,20,30) : 여러개의 결과값중 "하나라도" 칼럽값이 더 작을 경우 참.
    - 칼럼 [> / <] ALL (서브쿼리) : 여러개의 결과값들과 "모두 비교해봤을때 크거나 작을경우 참."
*/

-- 각 부서별 최고 급여를 받는 사원들의 이름 , 직급코드 , 급여 조회
-- 1) 각 부서별 최고급여들 조회
SELECT MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 2) 위의 급여를 받는 사원들 조회
SELECT EMP_NAME , JOB_CODE , SALARY
FROM EMPLOYEE
WHERE SALARY IN (SELECT MAX(SALARY) FROM EMPLOYEE GROUP BY DEPT_CODE);

-- 이오리 또는 하동운 사원과 같은 직급인 사원들을 조회하시오(사원명 , 직급코드 , 부서코드 , 급여)
SELECT EMP_NAME , JOB_CODE , DEPT_CODE , SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (SELECT JOB_CODE FROM EMPLOYEE WHERE EMP_NAME IN ('이오리','하동운'));

-- 사원 < 대리 < 과장 < 차장 < 부장
-- 대리 직급임에도 불구하고 과장보다 더 많은 급여를 받는 사원들 정보를 조회 (사번 , 이름 , 직급명 , 급여)
-- 1) 과장자급의 급여들 조회
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'

-- 2) 위의 급여들보다 하나라도 더 높은 급여를 받는 직원들 조회
SELECT EMP_ID , EMP_NAME , JOB_NAME , SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리' AND SALARY >= ANY(
    SELECT SALARY
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
    WHERE JOB_NAME = '과장'
);

-- 과장 직급임에도 "모든" 차장 직급의 급여보다도 더 많이 받는 직원 정보 조회 (사번 , 이름 , 직급명 , 급여)
SELECT EMP_NO , EMP_NAME , JOB_NAME , SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장' AND SALARY >= ALL (
    SELECT SALARY
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
    WHERE JOB_NAME = '차장'
);

/*
    3. (단일행) 다중열 서브쿼리
    서브쿼리 조회 결과가 단일행이지만 , 나열된 칼럼의 갯수가 여러개인경우.
*/
-- 하이유 사원과 같은 부서코드 이면서 같은 직급코드에 해당되는 사원들 조회 (사원명 , 부서코드 , 직급코드 , 고용날짜)