/* INSERT
	- 테이블에 데이터를 등록
	- INSERT의 기본 유형
	  . INSERT INTO <테이블> (열이름1, 열이름2, ...) VALUES (값1, 값2, ...) 
*/

-- 1-1. 고객테이블에 데이터를 등록해보자.
SELECT * FROM T_Customer
INSERT INTO T_Customer (CUST_ID,   NAME,       PHONE)
			    VALUES (7,         '임창정',   '7777-7777')  -- * NULL을 허용하지 않는 컬럼에는 무조건 값을 넣어야함.

-- 1-2. 모든 컬럼에 데이터를 등록할때는 컬럼의 이름을 생략할 수 있다.
INSERT INTO T_Customer VALUES(8, '박효신', '1981', '서울', '888-8888')

-- 1-3. 테이블의 복사.(구조 및 데이터를 복사하여 신규 테이블 생성)
SELECT * INTO T_CUSTOMER2 FROM T_Customer

-- 1-5 SELECT를 통한 다수의 데이터 등록.
INSERT INTO T_CUSTOMER2 (CUST_ID,	NAME,	BIRTH,	ADDRESS)
				  SELECT CUST_ID,   NAME,   BIRTH,  ADDRESS
				    FROM T_Customer
				   WHERE CUST_ID > 3

-- 1-6 변수를 통한 등록
DECLARE @LA_NAME VARCHAR(10) = '닐로'
INSERT INTO T_CUSTOMER2(CUST_ID, NAME) VALUES (20, @LA_NAME)

-- 1-7 변수를 통한 등록2
DECLARE @LS_NAME2 VARCHAR(10) = 'TTTT'
INSERT INTO T_CUSTOMER2 (CUST_ID, NAME,		 BIRTH, ADDRESS)
				  SELECT CUST_ID, @LS_NAME2, BIRTH, ADDRESS
					FROM T_Customer
				   WHERE CUST_ID <=3

/******** UPDATE
  - 테이블의 데이터를 수정
  - UPDATE의 기본 유형
  - UPDATE <테이블>
       SET 열이름1 = 값1,
	       열이름2 = 값2,
		   열이름3 = 값3
	 WHERE [조건]
*/
	
-- 사과의 단가를 수정해야 되는 일이 있을떄 .. 
	UPDATE T_Fruit
	   SET PRICE = 2500
	 WHERE FRUIT = '사과'

SELECT * FROM T_Fruit

-- 숫자를 더하기
-- 모든 과일의 가격을 현재보다 500원 인상할 경우.
UPDATE T_Fruit
   SET PRICE += 500


UPDATE T_Fruit
   SET PRICE = NULL
 WHERE FRUIT = '사과'


/****************** DELETE
테이블에서 행의 데이터를 삭제
*/

SELECT * FROM T_CUSTOMER2

DELETE T_CUSTOMER2
 WHERE CUST_ID = 18

DELETE T_CUSTOMER2
 WHERE CUST_ID BETWEEN 10 AND 15


/*************** DELETE와 UPDATE는 조건을 필수로 확인해야 한다!! **************/


-- 만약 데이터를 변경해버렸을 경우?
-- 백업 데이터를 이용해서 복원하는 방법밖에 없다 .. 백업 데이터가 없다면?.....

-- 그렇다면 DELETE, UPDATE, INSERT를 미리 실행해보고 확인한 후 승인할 수 있는 방법이 없을까? --> 트랜잭션(TRANSACTION)


/************* 트랜잭션 ******************
  . 트랜잭션 (TRANSACTION)
    - 데이터 갱신 내역 승인 또는 복구 (BEGIN TRAN, COMMIT, ROLLBACK)
	- 데이터의 일관성
	  . 데이터 관리시 발생하는 오류사항 10건의 데이터가 갱신(INSERT, UPDATE, DELETE)될때
	    중간에 5번째에서 오류가 발생하여 트랜잭션을 실행하지 못할경우.
	- 트랜재견의 독립성(격리성)
	  . 하나의 트랜잭션이 수행되고 있을때 또다른 트랜잭션이 간섭할 수 없다.

	  BEGIN TRAN
	    rollback		-> begin tran을 원상복구.
	      commit		-> begin tran을 승인.
*/

BEGIN TRAN
DELETE T_CUSTOMER2

SELECT * FROM T_CUSTOMER2 --> T_CUSTOMER2 테이블이 전부 날아갔다!
rollback --> 데이터를 다시 살려줘..

SELECT * FROM T_CUSTOMER2 --> 데이터가 다시 살아났음.
---------
BEGIN TRAN
DELETE T_CUSTOMER2
 WHERE CUST_ID < 10			--> CUST_ID가 10보다 작은 데이터를 지우려고 함.

SELECT * FROM T_CUSTOMER2   --> 정상적으로 완료됨을 확인
COMMIT						--> 최종 승인.

-->> BEGIN TRAN : rollback이나 COMMIT이 나올때까지 데이터를 붙잡고 있다.
-->> 또한 rollback이나 COMMIT이 나와서 트랜잭션이 수행 완료될때까지 T_CUSTOMER2의 테이블은 건드릴 수 없다.(다른 트랜잭션의 간섭 불가)
