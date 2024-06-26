-- 1.
INSERT INTO TB_CLASS_TYPE VALUES ('01','전공필수');
INSERT INTO TB_CLASS_TYPE VALUES ('02','전공선택');
INSERT INTO TB_CLASS_TYPE VALUES ('03','교양필수');
INSERT INTO TB_CLASS_TYPE VALUES ('04','교양선택');
INSERT INTO TB_CLASS_TYPE VALUES ('05','논문지도');

-- 1 풀이
-- 추가 표현 예시
INSERT INTO TB_CLASS_TYPE VALUES ('01','전공필수');
INSERT INTO TB_CLASS_TYPE(CLASS_TYPE_NO , CLASS_TYPE_NAME) VALUES ('02','전공선택');
INSERT INTO TB_CLASS_TYPE
SELECT * FROM (
    SELECT '03' , '교양필수' FROM DUAL
    
    UNION ALL 
    
    SELECT '04' , '교양선택' FROM DUAL
    
    UNION ALL
    
    SELECT '05' , '논문지도' FROM DUAL
);

COMMIT;

-- 2.
CREATE TABLE TB_학생일반정보 (학번 , 학생이름 , 주소)
AS (
SELECT STUDENT_NO , STUDENT_NAME , STUDENT_ADDRESS
FROM TB_STUDENT);

-- 3.
CREATE TABLE TB_국어국문학과 (학번 , 학생이름 , 출생년도 , 교수이름)
AS (
SELECT STUDENT_NO , STUDENT_NAME , '19'||SUBSTR(STUDENT_SSN,1,2) , PROFESSOR_NAME
FROM TB_STUDENT S
JOIN TB_PROFESSOR P ON (COACH_PROFESSOR_NO = PROFESSOR_NO)
JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '국어국문학과'
);

-- 3 풀이
CREATE TABLE TB_국어국문학과 (학번 , 학생이름 , 출생년도 , 교수이름)
AS SELECT
    STUDENT_NO , STUDENT_NAME,
    19 || SUBSTR(STUDENT_SSN,1,2) , NVL(PROFESSOR_NO,'지도 교수 없음')
    FROM TB_STUDENT TS
    LEFT JOIN TB_PROFESSOR ON COACH_PROFESSOR_NO = PROFESSOR_NO
    JOIN TB_DEPARTMENT TD ON TS.DEPARTMENT_NO = TD.DEPARTMENT_NO
    WHERE DEPARTMENT_NAME = '국어국문학과';

-- 4.
UPDATE TB_DEPARTMENT SET
CAPACITY = ROUND(CAPACITY*1.1);

-- 5.
UPDATE TB_STUDENT SET
STUDENT_ADDRESS = '서울시 종로구 숭인동 181-21 '
WHERE STUDENT_NO = 'A413042' AND STUDENT_NAME = '박건우';

-- 5 풀이
UPDATE TB_STUDENT SET
STUDENT_ADDRESS = '서울시 종로구 숭인동 181-21'
WHERE STUDENT_NO = 'A413042';

-- 6.
UPDATE TB_STUDENT SET
STUDENT_SSN = SUBSTR(STUDENT_SSN,1,6);

-- 7.
UPDATE TB_GRADE SET
POINT = 3.5
WHERE TERM_NO = '200501'
AND STUDENT_NO = (
SELECT STUDENT_NO
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
WHERE STUDENT_NAME = '김명훈'
AND DEPARTMENT_NAME = '의학과')
AND CLASS_NO = (SELECT CLASS_NO FROM TB_CLASS WHERE CLASS_NAME = '피부생리학');

-- 7 풀이
UPDATE TB_GRADE SET
POINT = 3.5
WHERE TERM_NO = '200501'
AND STUDENT_NO = (SELECT STUDENT_NO FROM TB_STUDENT JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
WHERE STUDENT_NAME = '김명훈' AND DEPARTMENT_NAME = '의학과')
AND CLASS_NO = (SELECT CLASS_NO FROM TB_CLASS WHERE CLASS_NAME = '피부생리학');

-- 8.
DELETE FROM TB_GRADE
WHERE 'Y' = (SELECT ABSENCE_YN
FROM TB_STUDENT
WHERE TB_STUDENT.STUDENT_NO = TB_GRADE.STUDENT_NO);

-- 8 풀이
DELETE FROM TB_GRADE
WHERE STUDENT_NO IN (
SELECT STUDENT_NO FROM TB_STUDENT
WHERE ABSENCE_YN = 'Y'
);

COMMIT;