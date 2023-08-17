/*************************************************************************
1. 쿼리문에서 변수를 지정하고 사용하는 방법 

 . DECLARE @[변수명][데이터타입](크기) */

 -- 변수를 선언할때는 반드시 @가 앞에 있어야한다.

 -- 1) 문자형 변수 선언.
	DECLARE @LS_VALUE VARCHAR(10);

 -- 2) 숫자형 변수 선언.
	DECLARE @LI_VALUE INT;

 -- 2-1) 동시 선언.
	DECLARE @LS_VALUE2 VARCHAR(20),
			@LI_VALUE2 INT;


 -- 3) 변수에 데이터 등록/대입. (SET)
	SET @LS_VALUE = '안녕하세요';
	SET @LI_VALUE = 20;

-- 4) 변수에 데이터 등록/대입 (SELECT)
	SELECT @LS_VALUE = '안녕하세요',
		   @LI_VALUE = 20;

	SELECT @LS_VALUE, @LI_VALUE

	
/*************************************************************************
2. 분기문 (IF)
 . 조건에 따라 로직의 흐름을 제어하는 명령문. */

	DECLARE @LS_MESSAGE VARCHAR(30), -- 메세지가 담길 변수.
			@LI_INVALUE INT;		 -- 입력되는 숫자가 담길 변수.

	SET @LI_INVALUE = 1500;
	
	IF (@LI_INVALUE > 900)
	BEGIN -- {
		SET @LS_MESSAGE = '900보다 큽니다.'
	END -- } 
	ELSE IF (@LI_INVALUE <= 900 AND @LI_INVALUE > 400)
	BEGIN
		SET @LS_MESSAGE = '400보다 크고 900이하입니다.'
	END
	ELSE
	BEGIN
		SET @LS_MESSAGE = '400 이하입니다.'
	END
	SELECT @LS_MESSAGE



/*************************************************************************
3. 분기문 (CASE WHEN THEN END)
 . 대상의 상태에 따라 값이나 조건을 다르게 적용하는 분기문.

 -1- CASE [비교대상] WHEN [조건] THEN [결과] END
	- 고정된 비교대상과 다수의 조건에 따른 결과를 표현할 경우.

 -2- CASE WHEN [비교대상, 비교연산자, 조건] THEN [결과] END
	- 다수의 비교대상과 다수의 조건에 따른 결과를 표현할 경우. */

	-- 1) 조회부 SELECT에서 사용되는 CASE WHEN문
	-- 1-1) CASE [비교대상] WHEN [조건] THEN [결과] END

	    	SELECT INOUTFLAG,
	    		   CASE INOUTFLAG WHEN 'I' THEN '입고' 
	    						  WHEN 'O' THEN '출고' 
	    						  WHEN 'OUT' THEN '출고'
	    						  WHEN 'IN' THEN '입고'
	    						  ELSE 'X' END			AS INOUTFLAG
	    	  FROM TB_StockMMrec
	
	-- 1-2) CASE WHEN [비교대상, 비교연산자, 조건] THEN [결과] END
			SELECT ITEMCODE,
				   STOCKQTY,
				   CASE WHEN STOCKQTY <= 0 THEN '재고없음'
					    WHEN STOCKQTY > 0 AND STOCKQTY <= 1000 THEN '안전재고'
						ELSE '재고초과' END	AS STOCKSTATUS
			  FROM TB_StockMM

	-- 2) 조건부에 사용되는 CASE WHEN
	-- 2-1) 
		DECLARE @LI_STOCKQTY INT;
		SET @LI_STOCKQTY = 1700;

		SELECT * 
		  FROM TB_StockMM
	     WHERE MATLOTNO = CASE @LI_STOCKQTY WHEN 1700 THEN 'LTROH2130262570001'
										    ELSE 'LT_R2021082012481881' END

	-- 2-2)
		DECLARE @LI_CNT INT;
		SET @LI_CNT = 100;

		SELECT * 
		  FROM TB_StockMM
		 WHERE 1 = CASE WHEN @LI_CNT = 100 THEN 1
					    ELSE 0 END


/***********************************************************************************************
4. NULL 처리된 행을 원하는 데이터로 변환하기 (ISNULL) */

/* TB_StockMMrec : 자재 입출 이력 테이블

	자재 입출 이력 테이블에서
	PLANTCODE, INOUTDATE, INOUTSEQ, ITEMCODE 컬럼의 데이터를 검색하고
	ITEMCODE가 NULL일 경우 X로 표현하세요. */

	SELECT PLANTCODE,
		   INOUTDATE,
		   INOUTSEQ,
		   ISNULL(ITEMCODE, 'X') AS ITCD
	  FROM TB_StockMMrec



 -- NULL 처리된 컬럼 데이터 조회하기
 SELECT ITEMCODE,
	    ITEMNAME,
	    LOCCODE
   FROM TB_ItemMaster
   WHERE ISNULL(LOCCODE, '') LIKE '%%'



   
