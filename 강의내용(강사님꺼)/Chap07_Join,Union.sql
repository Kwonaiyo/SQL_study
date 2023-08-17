/*******************************************************************************
1. 테이블 간 데이터 연결 및 조회 (JOIN)
 
  JOIN : 둘 이상의 테이블을 연결 해서 데이터를 검색하는 방법 
        . 테이블을 서로 연결 하기 위해서는 하나 이상의 컬럼을 공유하고 있어야 함.
	ON : 두 테이블을 연결 할 기준 컬럼 설정 및 연결 테이블의 조건 기술.


  - JOIN 의 종류 
   . 내부 조인 (INNER JOIN) : JOIN. 둘 이상의 테이블이 연결 되었을때 반드시 
                              두테이블에 동시에 값이 존재 해야 한다. 
							  하나의 테이블이라도 데이터가 없을경우 데이터가 표현되지 
							  않는다. 

   . 외부 조인 (OUTER JOIN) : LEFT JOIN, RIGHT JOIN, FULL JOIN
							  두개 이상의 테이블 이 연결 되었을 경우 
							  하나의 테이블에 데이터가 없더라도 일단은 데이터가 
							  표현 되는 JOIN
*/

/* 
   T_Customer  : 고객
   T_SalesList : 판매 이력  

   T_Customer 테이블 과 T_SalesList 테이블 에서 
   각각 고객ID, 고객이름, 판매일자, 과일, 판매 수량을 표현하세요.*/
SELECT * FROM T_Custmer
SELECT * FROM T_SalesList

-- 명시적으로 JOIN 문과 ON 을 써서 표현하는 방법.
SELECT A.CUST_ID,
	   B.NAME,
	   A.DATE,
	   A.FURIT,
	   A.AMOUNT
  FROM T_SalesList A JOIN T_Custmer B
					   ON A.CUST_ID = B.CUST_ID


SELECT A.*, B.*
  FROM T_SalesList A JOIN T_Custmer B
					   ON A.CUST_ID = B.CUST_ID

SELECT B.CUST_ID,
	   A.NAME,
	   B.DATE,
	   B.FURIT,
	   B.AMOUNT
  FROM T_Custmer A JOIN T_SalesList B
					 ON A.CUST_ID = B.CUST_ID
-- JOIN : T_Customer 테이블을 기준으로 조회 하지만, T_SalesList 테이블에 
--        5번 이수 에 대한 데이터가 없으므로 표현 되지 않음.



-- JOIN 테이블 을 하위쿼리로 작성하여 연결 
-- . 조회를 원하는 데이터 가 가공된 임시 테이블 형태로 JOIN 문을 완성.
SELECT *
  FROM T_Custmer A JOIN (SELECT CUST_ID
                               ,FURIT
							   ,DATE
						   FROM T_SalesList
						  WHERE DATE < '2022-12-02') B
					 ON A.CUST_ID = B.CUST_ID


/***** OUTER JOIN *********************************
1. LEFT JOIN 
  . 왼쪽에 있는 테이블의 데이터를 기준으로 오른쪽에 있는 테이블의
    데이터를 검색 및 연결 하고 ,데이터가 없을 경우 NULL 로 표시 된다.
*/

--  고객 별로 판매 이력을 조회해 보세요. 
SELECT A.CUST_ID
      ,A.NAME
	  ,ISNULL(B.FURIT,'판매이력없음') AS FRUIT
	  ,ISNULL(B.AMOUNT,0) AS AMOUNT
	  ,B.DATE
  FROM T_Custmer A LEFT JOIN T_SalesList B
						  ON A.CUST_ID = B.CUST_ID

-- ISNULL 부분을 CASE WHEN 으로 변경해서 표현해 보세요.
SELECT A.CUST_ID
      ,A.NAME
	  ,CASE WHEN B.FURIT IS NULL THEN '판매이력없음'
								 ELSE B.FURIT END    AS FRUIT

	  ,CASE WHEN B.AMOUNT IS NULL THEN 0 
								  ELSE B.AMOUNT END  AS AMOUNT
	  ,B.DATE
  FROM T_Custmer A LEFT JOIN T_SalesList B
						  ON A.CUST_ID = B.CUST_ID


-- LEFT JOIN 을 써서 왼쪽 테이블을 판매이력 테이블로. 
-- 아래의 SQL 에는 5 이수 가 표현이 될까 ? 
SELECT A.CUST_ID
	  ,B.NAME
	  ,A.FURIT
	  ,A.AMOUNT
  FROM T_SalesList A LEFT JOIN T_Custmer B	
							ON A.CUST_ID = B.CUST_ID


-- RIGHT JOIN 
-- 오른쪽에 있는 테이블의 데이터를 기준으로 왼쪽에 있는 테이블의 
-- 데이터를 검색하고 왼쪽 테이블 데이터가 없을경우 NULL 

-- 고객별 판매현황. (고객이 판매 이력이 없어도 데이터는 나와야한다.)
SELECT B.CUST_ID
      ,B.NAME
	  ,A.FURIT
	  ,A.AMOUNT
  FROM T_SalesList  A RIGHT JOIN T_Custmer B
							  ON A.CUST_ID = B.CUST_ID


-- 판매 현황별 고객 정보 (판매 이력에 없는 고객은 나타낼 필요가 없다.)
SELECT A.CUST_ID
      ,A.NAME
	  ,B.FURIT
	  ,B.AMOUNT
  FROM T_Custmer  A RIGHT JOIN T_SalesList B
							  ON A.CUST_ID = B.CUST_ID


-- 묵시적 표현법 JOIN 
-- JOIN 문을 쓰지 않고 테이블을 나열 후 WHERE 절에 참조컬럼 연결. 
SELECT *
  FROM T_Custmer A , T_SalesList B
 WHERE A.CUST_ID = B.CUST_ID
   AND B.DATE > '2020-01-01'


/***************************** 다중 JOIN 
 . 참조 할 데이터 가 여러 테이블에 있을때 
 기준 테이블과 참조 테이블 과의 다중 JOIN 으로 데이터를 표현할 수 있다.
*/

-- 과일의 판매 현황을 
-- 판매일자, 고객이름, 연락처, 판매과일, 과일단가, 판매금액 으로 나타내세요

SELECT A.DATE             AS DATE
      ,A.CUST_ID          AS CUST_ID    
	  ,B.NAME	          AS NAME
	  ,A.FURIT	          AS FURIT
	  ,C.PRICE	          AS PRICE
	  ,A.AMOUNT	          AS AMOUNT
	  ,C.PRICE * A.AMOUNT AS TOTALPRICE
  FROM T_SalesList A JOIN T_Custmer B
					   ON A.CUST_ID = B.CUST_ID
					 JOIN T_FRUIT C
					   ON A.FURIT = C.FRUIT
 
 SELECT * FROM TB_StockMMrec
 SELECT * FROM TB_ItemMaster
 /********** 실습 **********************
 TB_StockMMrec : 자재 입출 이력 테이블 
 TB_ItemMaster : 품목 마스터
 INOUTFLAG :  입고 유형  , I : 입고
 ITEMTYPE  :  품목유형 , ROH : 원자재

 자재 입출 이력 테이블 (A) 에서 ITEMCODE  가 NULL 이 아니고 ,
 INOUTFLAG 가 I 중 
 품목 마스터 테이블 (B) 에서 ITEMTYPE 이 'ROH' 인 것의
 A.INOUTDATE,  A.INOUTSEQ,  A.MATLOTNO,  A.ITEMCODE,  B.ITEMNAME 
 의 정보를 나타 내세요. 
    - 공유 컬럼 A.ITEMCODE, B.ITEMCODE */
   
   SELECT A.INOUTDATE
         ,A.INOUTSEQ
		 ,A.MATLOTNO
		 ,A.ITEMCODE
		 ,B.ITEMNAME
     FROM TB_StockMMrec A  JOIN TB_ItemMaster B
								 ON A.ITEMCODE = B.ITEMCODE  
							    --AND B.ITEMTYPE = 'ROH' -- JOIN 전에 데이터를 필터링
	WHERE A.ITEMCODE IS NOT NULL
	  AND A.INOUTFLAG = 'I'
	  AND B.ITEMTYPE = 'ROH'  -- JOIN 이후에 완성된 데이터를 필터링. 

/* 품목 마스터 ITEMTYPE= 'ROH' 조건을 추가 시 
   자재 입고이력 테이블의 ITEMCODE 컬럼에 NULL 상태인 행이 있을경우

   1. JOIN 구문에 조건을 줄때 에는 LEFT JOIN 으로 인하여 
           자재입고입출 이력 중 ITEMCODE 가 표현 되고
   2. WHERE 절에 조건을 줄때 에는 LEFT JOIN 으로 나온 결과 
           이후에 조건이 적용 되므로 필터링 되어표현 됨 */


/********************* 실습 *************************************
 과일판매 이력에서 고객 별 과일의 총 계산 금액 구하기 
 고객ID, 고객 명, 과일이름, 과일별 총 계산 금액. 
*/

-- 문제의 의도 GROUP BY 와 JOIN 을 적절히 사용할 수 있는가 ? 

-- 1. 메인테이블로 선정해야 할 테이블이 무엇일까 ?  
--   메인테이블 :문제 해결을 위한 전체적인 흐름의 데이터를 포함하는
--               테이블 
-- 고객별 판매 이력 테이블을 메인 테이블 로 하기 적합. 


-- 2. 고객별 과일 별 총 수량 GROUP BY
  SELECT CUST_ID     AS CUST_ID,
		 FURIT       AS FURIT,
		 SUM(AMOUNT) AS FP_SALECNT
    FROM T_SalesList
GROUP BY CUST_ID, FURIT


-- 3.단가 금액 과 수량을 곱하고 총 금액을 산출. 
--     2 에서 구한 고객별 과일의 판매수량 합을 메인테이블로 잡고 하위쿼리로 표현. 
  SELECT C.NAME
        ,A.FURIT
		,A.FP_SALECNT * B.PRICE AS TOTALPRICE
    FROM (SELECT CUST_ID     AS CUST_ID,
				 FURIT       AS FURIT,
				 SUM(AMOUNT) AS FP_SALECNT
			FROM T_SalesList
		GROUP BY CUST_ID, FURIT) A LEFT JOIN T_FRUIT B
										  ON A.FURIT = B.FRUIT
								   LEFT JOIN T_Custmer C
									      ON A.CUST_ID = C.CUST_ID
 ORDER BY A.CUST_ID


 -- 풀이 유형 2)

 SELECT C.NAME                   AS C_NAME,
		A.FURIT                  AS FURIT,
		SUM(A.AMOUNT * B.PRICE)  AS F_TOTAL_PRICE
   FROM T_SalesList A LEFT JOIN T_FRUIT B 
                             ON A.FURIT = B.FRUIT
						   JOIN T_Custmer C 
						     ON A.CUST_ID = C.CUST_ID
GROUP BY C.NAME, A.FURIT





 SELECT C.NAME , 
		A.FURIT,
		SUM(A.AMOUNT*B.PRICE)
   FROM T_SalesList A LEFT JOIN T_FRUIT B 
                             ON A.FURIT = B.FRUIT
						   JOIN T_Custmer C 
						     ON A.CUST_ID = C.CUST_ID 
GROUP BY C.NAME , A.FURIT


/************************************ 실습 ***********************************

총 구매 금액이 가장 큰 고객을 표현하세요. 
(ID, 고객이름, 고객주소, 고객 연락처, 총 구매 금액) 
****************************************************************/

-- 1번 방법 
  SELECT TOP(1) C.CUST_ID				  AS CUST_ID,
                C.NAME                    AS C_NAME,
				C.ADDRESS				  AS ADDRESS,
				C.PHONE                   AS PHONE,
			    SUM(A.AMOUNT * B.PRICE)   AS F_TOTAL_PRICE 
   FROM T_SalesList A LEFT JOIN T_FRUIT B 
                             ON A.FURIT = B.FRUIT
						   JOIN T_Custmer C 
						     ON A.CUST_ID = C.CUST_ID
GROUP BY C.CUST_ID,C.NAME,C.ADDRESS,C.PHONE 
ORDER BY F_TOTAL_PRICE DESC
 







-- 2번 방법 (MAX 집계 함수를 통해 가장 큰 값을 가진 데이터 를구한후 찾기)
DECLARE @LI_MAXPRICEW INT --  구매 금액이 가장 큰 값을 담을 변수 

-- 1.가장 큰 매출 액 찾기
SELECT @LI_MAXPRICEW = MAX(AA.TOTAL_PRICE)
  FROM (SELECT  SUM(A.AMOUNT * B.PRICE) AS TOTAL_PRICE
          FROM T_SalesList A JOIN T_FRUIT B
							   ON A.FURIT = B.FRUIT
							 JOIN T_Custmer C
							   ON A.CUST_ID = C.CUST_ID
	    GROUP BY A.CUST_ID) AA

-- 2. 가장 큰 매출액을 가진 고객의 정보 구하기.
SELECT  C.CUST_ID				AS CUST_ID,
        C.NAME                  AS C_NAME,
		C.ADDRESS				AS ADDRESS,
		C.PHONE                 AS PHONE,
        SUM(A.AMOUNT * B.PRICE) AS TOTAL_PRICE
  FROM T_SalesList A JOIN T_FRUIT B
					   ON A.FURIT = B.FRUIT
					 JOIN T_Custmer C
					   ON A.CUST_ID = C.CUST_ID
GROUP BY C.CUST_ID,C.NAME,C.ADDRESS,C.PHONE 
HAVING SUM(A.AMOUNT * B.PRICE) = @LI_MAXPRICEW


/*************************** 실습 *************************
2022-12-01 일부터 2022-12-31 (월간)
까지 가장 많이 팔린 과일의 종류 와 판매 수량을 구하세요

과일이름, 판매수량 

 * 단 판매 수량이 같은 과일은 N 개의 행으로 표현할것 */

    DECLARE @MAXFRUIT     INT,
	        @LS_STARTDATE VARCHAR(10) = '2022-12-03' ,
			@LS_ENDDATE   VARCHAR(10) = '2022-12-31'

   SELECT @MAXFRUIT = MAX(AA.TOTAL_FRUIT)
     FROM(SELECT SUM(A.AMOUNT) AS TOTAL_FRUIT
          FROM T_SalesList A LEFT JOIN T_Fruit B
                        ON A.FURIT = B.FRUIT
                       JOIN T_Custmer C
                         ON A.CUST_ID = C.CUST_ID
		  WHERE A.DATE BETWEEN @LS_STARTDATE AND @LS_ENDDATE
       GROUP BY A.FURIT) AA
	    
 SELECT A.FURIT       AS FRUIT
        ,SUM(A.AMOUNT) AS AMOUNT
     FROM T_SalesList A LEFT JOIN T_Fruit B
                        ON A.FURIT = B.FRUIT
                       JOIN T_Custmer C
                         ON A.CUST_ID = C.CUST_ID
    WHERE A.DATE BETWEEN @LS_STARTDATE AND @LS_ENDDATE
  GROUP BY A.FURIT
   HAVING SUM(A.AMOUNT) = @MAXFRUIT



/***************************************************** 실습 *********************

고객 별 총 구매 금액이 12만원 (120000) 이 넘는 고객의 내역을 조회 하세요
(고객 ID,  고객이름,   총 구매 금액)*/

   SELECT A.CUST_ID,
		  B.NAME,
		  SUM(A.AMOUNT * C.PRICE) AS TOTALPRICE
     FROM T_SalesList A LEFT JOIN T_Custmer B
							   ON A.CUST_ID = B.CUST_ID
					    LEFT JOIN T_Fruit C 
						       ON A.FURIT = C.FRUIT

	GROUP BY A.CUST_ID, B.NAME
      HAVING SUM(A.AMOUNT * C.PRICE) > 120000

-- 위 내용을 SUM 집계함수 한번반 써서 표현 해 보세요.
 
SELECT *
  FROM (SELECT A.CUST_ID,
	 		   B.NAME,
	 		   SUM(A.AMOUNT * C.PRICE) AS TOTALPRICE
	      FROM T_SalesList A LEFT JOIN T_Custmer B
	 							   ON A.CUST_ID = B.CUST_ID
	 					    LEFT JOIN T_Fruit C 
	 						       ON A.FURIT = C.FRUIT
	 
	  GROUP BY A.CUST_ID, B.NAME) AA 
WHERE AA.TOTALPRICE > 120000



/***********************************************************************************************************
3. UNION / UNION ALL 
 . 다수의 검색 내역(행) 을 합치는 기능. 
 . 조회 한 다수의 SELECT 결과를 하나로 합치고 싶을때 (UNION) 을 사용. 
 
 UNION : 중복되는 행은 하나만 표시. 
 UNION ALL : 중복 을 제거 하지 않고 모두 표시. 

 ***** 합쳐질 조회문의 데이터 컬럼은 형식과 갯수가 일치 해야한다. 
 */

 -- UNION (중복되는 데이터 는 제외하고 표현)
 SELECT DATE      AS DATE
       ,CUST_ID   AS CSTINFO
	   ,FURIT     AS FRUIT
	   ,AMOUNT    AS AMONT
   FROM T_SalesList
UNION 
SELECT ORDERDATE AS DATE
      ,CUSTCODE AS CUSTINFO
	  ,FRUIT     AS FRUIT
	  ,AMOUNT    AS AMOUNT
  FROM T_ORDERLIST
-- 위 의 결과 는 
-- 판매 리스트 가 총 31개 
-- 발주 리스트 가 총 31개 지만

-- 아래 쿼리 를 통해 발주 리스트 중 중복 데이터가 4건 있음을 확인할 수있다
SELECT ORDERDATE AS DATE
      ,CUSTCODE  AS CUSTINFO
	  ,FRUIT     AS FRUIT
	  ,AMOUNT    AS AMOUNT
	  ,COUNT(*)
  FROM T_ORDERLIST
GROUP BY  ORDERDATE,CUSTCODE ,FRUIT,AMOUNT   

-- * UNION 은 중복된 데이터를 제외하고 합쳐서 표현한다.






-- **************************************************
-- UNION ALL 
 SELECT DATE      AS DATE
       ,CUST_ID   AS CSTINFO
	   ,FURIT     AS FRUIT
	   ,AMOUNT    AS AMONT
   FROM T_SalesList
UNION ALL
SELECT ORDERDATE AS DATE
      ,CUSTCODE AS CUSTINFO
	  ,FRUIT     AS FRUIT
	  ,AMOUNT    AS AMOUNT
  FROM T_ORDERLIST



---------- 타이틀 표현하기. 
 SELECT '판매'    AS TITLE
	   ,DATE      AS DATE
       ,CUST_ID   AS CSTINFO
	   ,FURIT     AS FRUIT
	   ,AMOUNT    AS AMONT
   FROM T_SalesList
UNION ALL
SELECT '발주'    AS TITLE
	  ,ORDERDATE AS DATE
      ,CUSTCODE  AS CUSTINFO
	  ,FRUIT     AS FRUIT
	  ,AMOUNT    AS AMOUNT
  FROM T_ORDERLIST
ORDER BY DATE




/******** 실습 ******** 
위 결과 에서 

판매이력 관련 고객 ID 에 따른 이름을 표현하고. 
발주이력 관련 거래처 관련 업체명을 표현.
고객 ID 에 대한 정보 T_Custmer 에서 가져오고 
거래처 명은 10 : 대림, 20 : 삼전, 30 : 하나 , 40 : 농협
으로 표현 하세요.
*/
 SELECT '판매'      AS TITLE
	   ,A.DATE      AS DATE
       ,B.NAME      AS CSTINFO
	   ,A.FURIT     AS FRUIT
	   ,A.AMOUNT    AS AMONT
   FROM T_SalesList A LEFT JOIN T_Custmer B
							 ON A.CUST_ID = B.CUST_ID
UNION ALL
SELECT '발주'								   AS TITLE
	  ,ORDERDATE							   AS DATE
      ,CASE CUSTCODE WHEN '10' THEN '대림'
				     WHEN '20' THEN '삼전'
					 WHEN '30' THEN '하나'
					 WHEN '40' THEN '농협' END AS CUSTINFO
	  ,FRUIT								   AS FRUIT
	  ,AMOUNT								   AS AMOUNT
  FROM T_ORDERLIST
ORDER BY DATE