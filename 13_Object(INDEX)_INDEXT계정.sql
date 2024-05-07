/*
    <INDEX>
    - 인덱스 ? 데이터를 빠르게 검색하기 위한 객체로 데이터의 정렬과 ,
    탐색과 같은 DBMS의 성능향상을 목적으로 생성하는 객체
    - 배열에서와 같이 INDEX는 '목차'라는 의미를 가졌다.
    - 테이블의 찾고자하는 정보(칼럼값)을 통해 인덱스를 만들면,
    인덱스로 지정된 칼럼은 별도의 저장공간에 컬럼값과 위치정보(ROWID)가 함께 저장된다.
    이때 , 검색의 편리성을 위해 컬럼값 기준 오름차순하여 데이터를 보관해둔다.
    - 인덱스의 자료구조는 일반적으로 B*Tree (Balanced Tree) 자료구조로 구현되어있다.
    * B*Tree
        루프 , 브랜치 , 리프 노드가 존재.
        루트 노드 에서 리프까지 항상 균등한 깊이를 가진 형태의 자료 구조. (모든 리프 노드의 높이(차수)가 동등함)
        루트와 브랜치는 값의 범위(1~10,5~50)를 key 값으로 가지고 있고
        리프노드는 실제 인덱스의 key값과 해당 테이블의 칼럼에 접근할수 있는 위치주소(rowid)를 보관하고 있으며,
        기 값들은 key 값 기준으로 오름차순 정렬되어 있다.
        
    인덱스 활용처
    - SELECT , JOIN문 등이 실행 될때 각 조건절에서 인덱스로 지정한 칼럼이 사용될 경우 DBMS에 의해 사용 될 수 있음.
    + 검색할 칼럼이 그렇게 크지 않을경우 INDEX를 사용하지 않는 것이 더 좋을수 있음.
    
    [표현법]
    CREATE INDEX 인덱스명 ON 테이블명(칼럼명 , 칼럼명2, 칼럼명3...);
    
    자동 생성 :
    PRIMARY KEY || UNIQUE 제약조건 설정시 자동으로 생성.
*/
SELECT * FROM USER_MOCK_DATA; -- CARD : 58583 , COST : 137

-- 현재 계정의 인덱스 정보 확인
SELECT * FROM USER_INDEXES;

SELECT * FROM USER_MOCK_DATA
WHERE ID = 22222; -- CARDINALITY = 5 , COST = 137

SELECT * FROM USER_MOCK_DATA
WHERE EMAIL='niacobassi65@shareasale.com'; -- CARDINALITY = 5 , COST = 137

SELECT * FROM USER_MOCK_DATA
WHERE GENDER = 'Male'; -- CARDINALITY = 29382 , COST = 137

SELECT * FROM USER_MOCK_DATA
WHERE FIRST_NAME LIKE 'R%'; -- CARDINALITY = 3385 , COST = 137

ALTER TABLE USER_MOCK_DATA
ADD CONSTRAINT UMD_PK_ID PRIMARY KEY(ID);

ALTER TABLE USER_MOCK_DATA
ADD CONSTRAINT UMD_UQ_EMAIL UNIQUE(EMAIL);

SELECT * FROM USER_INDEXES;

SELECT * FROM USER_MOCK_DATA
WHERE ID = 22222; -- CARDINALITY = 1 , COST = 2 (접근 과정?)
-- UNIQUE SCAN?

SELECT * FROM USER_MOCK_DATA
WHERE EMAIL='niacobassi65@shareasale.com'; -- CARDINALITY = 1 , COST = 2 (접근 과정?)
-- 인덱스 ? 실제 메모리 공간을 차지함
-- CARDINALITY : 검색한 행의 갯수 , 예측값?
-- FULL SCAN -> INDEX UNIQUE SCAN
-- COST : 속도 , 메모리 차지 여부?

CREATE INDEX IDX_USER_MOCK_DATA_GENDER ON USER_MOCK_DATA(GENDER);

SELECT * FROM USER_MOCK_DATA
WHERE GENDER = 'Male'; -- FULL SCAN. 분포도 검사? 결과 값에 따라 UNIQUE SCAN을 하지 않는 경우가 있음

CREATE INDEX IDX_UMD_FN ON USER_MOCK_DATA(FIRST_NAME);

SELECT * FROM USER_MOCK_DATA
WHERE FIRST_NAME LIKE 'R%'; -- FULL SCAN. INDEX를 사용하는 것보다 전체 행을 읽는게 더 효율적이라고 판단.

SELECT * FROM USER_MOCK_DATA
WHERE ID >= 1000 AND ID <= 2000; -- RANGE SCAN

/*
    인덱스를 효율적으로 쓰기 위해선?
    데이터의 분포도가 높고 , 조건절에서 자주 사용되며 , 중복값이 적은 컬럼이 좋다.
    
    1) 조건절에 자주 등장하는 칼럼
    2) 항상 동등비교(=) 로 비교 되는 칼럼
    3) 중복되는 데이터가 최소한인 칼럼 == 분포도가 높은 칼럼
    4) ORDER BY 절에 자주 사용되는 칼럼
    5) JOIN 시 자주 사용되는 칼럼
    
    인덱스 장점
        1) SELECT , JOIN 시 인덱스 칼럼을 사용하면 훨씬 빠르게 연산 가능.
        2) 인덱스 칼럼 기준으로 ORDER BY 연산을 할 필요가 없음.
        3) 인덱스 칼럼을 통해 MIN , MAX 를 찾을때 연산속도가 매우 빠름. (오름차순 정렬이 이미 되어 있기 때문)
    
    인덱스 단점
        1) 인덱스가 많을 수록 저장공간을 많이 차지함.
        2) DML에 취약함.
            -> INSERT , UPDATE , DELETE 등 새롭게 데이터가 추가 및 삭제 되면 ,
            인덱스 테이블안에 있는 값들을 다시 정렬하고 , 물리적인 주소값도 수정해줘야함.
        3) INDEX를 활용한 검색보다 , 테이블전체를 FULL SCAN 하는게 더 유리할 때가 있음. (생성하고도 사용 안하는 경우)
*/
