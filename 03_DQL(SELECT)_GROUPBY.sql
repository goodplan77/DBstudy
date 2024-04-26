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