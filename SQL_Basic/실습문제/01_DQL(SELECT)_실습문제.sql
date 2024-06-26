-- 1
SELECT department_name AS "학과 이름" , category AS "계열"
FROM tb_department;

-- 2
SELECT department_name || '의 정원은 ' || capacity || '명 입니다.' AS "학과별 정원"
FROM tb_department;

-- 3
SELECT student_name
FROM tb_student
-- WHERE department_no = '001' AND ABSENCE_YN = 'Y' AND (student_ssn LIKE '%-2%' OR student_ssn LIKE '%-4%')
WHERE department_no = '001' AND student_ssn LIKE '%-2%' AND ABSENCE_YN = 'Y';

-- 4
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE student_no IN ('A513079' , 'A513090' , 'A513091' , 'A513110' , 'A513119')
ORDER BY STUDENT_NAME DESC;

-- 5
SELECT DEPARTMENT_NAME , CATEGORY
FROM TB_DEPARTMENT
WHERE CAPACITY BETWEEN 20 AND 30;

-- 6
SELECT PROFESSOR_NAME
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;

-- 7
SELECT *
FROM TB_STUDENT
WHERE DEPARTMENT_NO IS NULL;

-- 8
SELECT CLASS_NO
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;

-- 9
SELECT DISTINCT CATEGORY
FROM TB_DEPARTMENT
ORDER BY CATEGORY ASC;

-- 10
SELECT STUDENT_NO , STUDENT_NAME , STUDENT_SSN
FROM TB_STUDENT
WHERE STUDENT_ADDRESS LIKE '%전주%' AND ENTRANCE_DATE LIKE '02%' AND ABSENCE_YN NOT LIKE 'Y'
-- ENTRANCE_DATE BETWEEN '02/01/01' AND '02/12/31'
ORDER BY STUDENT_NAME ASC;