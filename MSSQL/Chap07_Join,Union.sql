/*********************************************************************************
1. 테이블 간 데이터 연결 및 조회 (JOIN)

JOIN : 둘 이상의 테이블을 연결해서 데이터를 검색하는 방법.
	 . 테이블을 서로 연결하기 위해서는 하나 이상의 컬럼을 공유하고 있어야 함.
 ON  : 두 테이블을 연결할 기준컬럼 설정 및 연결 테이블의 조건 기술. 


 - JOIN의 종류
  . 내부 조인(INNER JOIN) : JOIN. 둘 이상의 테이블이 연결되었을때 반드시 두 테이블에 동시에 값이 존재해야한다.
						  . 하나의 테이블이라도 데이터가 없을 경우 데이터가 표현되지 않는다.

  . 외부 조인(OUTER JOIN) : LEFT JOIN, RIGHT JOIN, FULL JOIN
						  . 둘 이상의 테이블이 연결되었을 경우 하나의 테이블에 데이터가 없더라도 일단은 데이터가 표현되는 JOIN

*/

/* T_Customer 테이블과 T_SalesList 테이블에서 각각 고객ID, 고객이름, 판매일자, 과일, 판매수량을 표현하세요. 
	T_Customer : 고객 테이블
	T_SalesList : 판매이력 테이블
*/

SELECT * FROM T_Customer
SELECT * FROM T_SalesList

-- 명시적으로 JOIN문과 ON을 써서 표현하는 방법
SELECT A.CUST_ID,
	   B.NAME,
	   A.DATE,
	   A.FRUIT,
	   A.AMOUNT
  FROM T_SalesList A JOIN T_Customer B
					   ON A.CUST_ID = B.CUST_ID
-->> T_SalesList 테이블을 기준으로 조회

SELECT A.*, B.*
  FROM T_SalesList A JOIN T_Customer B
				       ON A.CUST_ID = B.CUST_ID
  
SELECT B.CUST_ID,
	   A.NAME,
	   B.DATE,
	   B.FRUIT,
	   B.AMOUNT
  FROM T_Customer A JOIN T_SalesList B
				      ON A.CUST_ID = B.CUST_ID	-->> 결과는 같게 나옴
-->> JOIN : T_Customer 테이블을 기준으로 조회하지만, T_SalesList 테이블에 5번(이수)에 대한 데이터가 없으므로
--          이수에 대한 데이터는 표현되지 않음.(이수는 과일을 구매하지 않음.)



-- JOIN 테이블을 하위쿼리로 작성하여 연결해보자.
-- . 조회를 원하는 데이터가 가공된 임시 테이블 형태로 JOIN문을 완성.
SELECT *
FROM T_Customer A JOIN (SELECT CUST_ID,
							   FRUIT,
							   DATE
						  FROM T_SalesList
						 WHERE DATE < '2022-12-02') B
					ON  A.CUST_ID = B.CUST_ID

/************************ OUTER JOIN **********************************************
판매이력별 고객이 아니라 고객별로 판매이력을 보고 싶다면 어떻게 해야하는가?... --> OUTER JOIN?

1. LEFT JOIN
 . 왼쪽에 있는 테이블의 데이터를 기준으로 오른쪽에 있는 테이블의 데이터를 검색 및 연결하고, 데이터가 없을 경우 NULL로 표시된다.
*/

-- 고객별로 판매이력을 조회해보세요.
SELECT A.CUST_ID,
	   A.NAME,
	   ISNULL(B.FRUIT, '판매이력없음') AS FRUIT,
	   ISNULL(B.AMOUNT, '0') AS AMOUNT,
	   B.DATE
  FROM T_Customer A LEFT JOIN T_SalesList B
						   ON A.CUST_ID = B.CUST_ID

-- ISNULL 부분을 CASE WHEN으로 변경해서 표현해 보세요.
	   SELECT A.CUST_ID,
	   A.NAME,
	   CASE WHEN B.FRUIT IS NULL THEN '판매이력없음'
			ELSE B.FRUIT END AS FRUIT,
	   CASE WHEN B.AMOUNT IS NULL THEN '0'
			ELSE B.AMOUNT END AS AMOUNT,
	   B.DATE
  FROM T_Customer A LEFT JOIN T_SalesList B
						   ON A.CUST_ID = B.CUST_ID

	-- LEFT JOIN을 써서 왼쪽 테이블을 판매이력 테이블로 한다면, 아래의 SQL에는 5(이수)가 표현이 될까? --> NO!
	SELECT A.CUST_ID,
		   B.NAME,
		   A.FRUIT,
		   A.AMOUNT
	  FROM T_SalesList A LEFT JOIN T_Customer B
								ON A.CUST_ID = B.CUST_ID	--> LEFT JOIN의 기준이 되는 T_SalesList에 이수에 대한 데이터가 없으므로, 표현되지 않는다.
														--> 이수의 데이터를 표현하고싶고 T_SalesList 테이블을 왼쪽에 두고 싶다면 LEFT 대신에 RIGHT JOIN을 사용하면 된다.
														

/* RIGHT JOIN
   오른쪽에 있는 테이블의 데이터를 기준으로 왼쪽에 있는 테이블의 데이터를 검색하고, 왼쪽 테이블에 데이터가 없을 경우 NULL */

-- 고객별 판매현황(고객에 대한 판매이력이 없어도 데이터는 나와야한다.)
SELECT B.CUST_ID,
	   B.NAME,
	   A.FRUIT,
	   A.AMOUNT
  FROM T_SalesList A RIGHT JOIN T_Customer B
							 ON A.CUST_ID = B.CUST_ID

-- 판매현황별 고객 정보(판매 이력에 없는 고객은 나타낼 필요가 없다.)
SELECT A.CUST_ID,
	   A.NAME,
	   B.FRUIT,
	   B.AMOUNT
  FROM T_Customer A RIGHT JOIN T_SalesList B
							 ON A.CUST_ID = B.CUST_ID


-- 묵시적 표현법 JOIN
-- JOIN문을 쓰지 않고 테이블을 나열한 후 WHERE절에 참조 컬럼을 연결하는 방식
SELECT *
  FROM T_Customer A, T_SalesList B
 WHERE A.CUST_ID = B.CUST_ID
   AND B.DATE > '2020-01-01'


/***************************** 다중 JOIN ********************************************
참조할 데이터가 여러 테이블에 있을때.
기준 테이블과 참조 테이블과의 다중 JOIN으로 데이터를 표현할 수 있다.

- 과일의 판매 현황을 판매일자, 고객이름, 연락처, 판매과일, 과일단가, 판매금액으로 나타내세요. */
 SELECT A.DATE             AS DATE 
	   ,A.CUST_ID	       AS CUST_ID 
	   ,B.NAME		       AS NAME 
	   ,A.FRUIT		       AS FRUIT 
	   ,C.PRICE		       AS PRICE 
	   ,A.AMOUNT	       AS AMOUNT 
	   ,C.PRICE * A.AMOUNT AS TOTALPRICE
   FROM T_SalesList A JOIN T_Customer B
				   	    ON A.CUST_ID = B.CUST_ID
				      JOIN T_FRUIT C
				        ON A.FRUIT = C.FRUIT



/********************* 실습 **************************
TB_StockMMrec : 자재 입출 이력 테이블
TB_ItemMaster : 품목마스터 테이블
INOUTFLAG : 입고유형(I : 입고)
ITEMTYPE : 품목유형(ROH : 원자재)

자재 입출 이력 테이블 A에서 ITEMCODE가 NULL이 아니고 INOUTFLAG가 'I'인 데이터 중
품목마스터 테이블 B에서 ITEMTYPE이 'ROH'인 데이터의
A.INOUTDATE, A.INOUTSEQ, A.MATLOTNO, A.ITEMCODE, B.ITEMNAME의 정보를 나타내세요
	- 공유 컬럼 A.ITEMCODE, B.ITEMCODE */
SELECT A.INOUTDATE
	  ,A.INOUTSEQ
	  ,A.MATLOTNO
	  ,A.ITEMCODE
	  ,B.ITEMNAME
  FROM TB_StockMMrec A LEFT JOIN TB_ItemMaster B
					          ON A.ITEMCODE = B.ITEMCODE
							  --AND B.ITEMTYPE = 'ROH'		--> JOIN 전에 데이터를 필터링
 WHERE A.ITEMCODE IS NOT NULL
   AND A.INOUTFLAG = 'I'
   AND B.ITEMTYPE = 'ROH'		--> JOIN 이후 완성된 데이터를 필터링
/* -> AND B.ITEMTYPE = 'ROH'가 JOIN 안에 들어가는거랑 밖으로 빠져나와서 WHERE절에 붙는거랑은 검색 결과에 차이가 있다. 
   -> ** 추가되는 결과인 ITEMCODE KFQS01-01는 TB_ItemMaster에는 없는 데이터이다.
   -> 1. JOIN안에 AND를 이용해서 'ROH'를 필터링할 때에는 LEFT JOIN에 의해 ItemMaster에는 없지만 StockMMrec에는 있는 ITEMCODE가 KFQS01-01인 데이터를 ITEMNAME을
	   . NULL처리해서 결과에 같이 출력해준다.
   -> 2. WHERE절에 'ROH'를 필터링할 경우에는 LEFT JOIN에 의해 출력된 데이터들 중 KFQS01-01의 데이터가 필터링된다. 즉, KFQS01-01은 ItemMaster 테이블에 들어있지 않기
       . 때문에 ITEMTYPE의 값이 없다. 따라서 ITEMTYPE <> 'ROH'이기 때문에 필터링되어 데이터가 빠지게 된다.
   ->  * LEFT JOIN과 실행 프로세스에 의해서 발생하는 결과이다. (FROM -> WHERE -> SELECT)
*/



/*********************** 실습 *********************************
고객별 과일의 총 계산 금액 구하기
고객ID, 고객명, 과일이름, 과일별 총 계산금액.

  * GROUP BY와 JOIN을 적절히 사용할 수 있는가?
*/
--> 1. 메인테이블로 어떤 테이블을 선정해야 할까? --> 문제 해결을 위한 전체적인 데이터의 흐름을 포함하는 테이블

--> 2. 고객별 과일별 총 수량 GROUP BY
SELECT CUST_ID	   AS CUST_ID
	  ,FRUIT	   AS FRUIT
	  ,SUM(AMOUNT) AS FRUITPERSALECOUNT
  FROM T_SalesList
GROUP BY CUST_ID, FRUIT

--> 3. 단가금액과 수량을 곱하고 총 금액을 산출. - 2에서 구한 고객별 과일의 판매수량 합을 메인테이블로 잡고 하위쿼리로 표현했다.
-- 3-1)
SELECT A.CUST_ID                AS CUST_ID
	  ,C.NAME	                AS NAME
	  ,A.FRUIT	                AS FRUIT
	  ,A.FP_SALECNT * B.PRICE   AS TOTALPRICE
  FROM (SELECT CUST_ID			AS CUST_ID
	          ,FRUIT			AS FRUIT
	          ,SUM(AMOUNT)		AS FP_SALECNT
          FROM T_SalesList
      GROUP BY CUST_ID, FRUIT) A LEFT JOIN T_FRUIT B
								        ON A.FRUIT = B.FRUIT
								 LEFT JOIN T_Customer C
									    ON A.CUST_ID = C.CUST_ID
ORDER BY A.CUST_ID ASC

-- 3-2) 3-1과 다른 방법. 결과는 같다.
  SELECT A.CUST_ID               AS CUST_ID
  	    ,C.NAME	                 AS NAME
  	    ,A.FRUIT	             AS FRUIT
  	    ,SUM(A.AMOUNT * B.PRICE) AS F_TOTAL_PRICE
    FROM T_SalesList A LEFT JOIN T_FRUIT B
  							  ON A.FRUIT = B.FRUIT
  						    JOIN T_Customer C
  						      ON A.CUST_ID = C.CUST_ID
GROUP BY A.CUST_ID, C.NAME, A.FRUIT
ORDER BY A.CUST_ID ASC



/********************************** 실습 ***************************************
총 구매 금액이 가장 큰 고객을 표현하세요.
(ID, 고객이름, 고객주소, 고객연락처, 총 구매 금액)
********************************************************************************/
SELECT MAX(TOTAL_PRICE) AS MAX_PRICE
FROM (SELECT A.CUST_ID             AS CUST_ID
	        ,C.NAME	               AS NAME
	        ,C.ADDRESS             AS ADDRESS
	        ,C.PHONE               AS PHONE
	        ,SUM(A.AMOUNT*B.PRICE) AS TOTAL_PRICE
        FROM T_SalesList A JOIN T_FRUIT B
				        	 ON A.FRUIT = B.FRUIT
				           JOIN T_Customer C
				             ON A.CUST_ID = C.CUST_ID
    GROUP BY A.CUST_ID, C.NAME, C.ADDRESS, C.PHONE) AS NEW_TABLE



--고객별 총 구매 금액을 먼저 보자. -- T_SalesList랑 T_Fruit를 JOIN해서 가격을 받아와야 함.
--TABLE을 F_TOTAL_PRICE 기준으로 내림차순으로 정렬한 후 가장 위에있는 데이터 값을 뽑아옴.
  SELECT TOP(1) C.CUST_ID               AS CUST_ID
			   ,C.NAME	                AS C_NAME
			   ,C.ADDRESS               AS ADDRESS
			   ,C.PHONE	                AS PHONE
		       ,SUM(A.AMOUNT * B.PRICE) AS F_TOTAL_PRICE
    FROM T_SalesList A LEFT JOIN T_FRUIT B
						      ON A.FRUIT = B.FRUIT
						    JOIN T_Customer C
						      ON A.CUST_ID = C.CUST_ID
GROUP BY C.NAME, C.CUST_ID, C.NAME, C.ADDRESS, C.PHONE
ORDER BY F_TOTAL_PRICE DESC

--2. MAX 집계함수를 통해 가장 큰 값을 가진 데이터를 구한 후 찾기. -내가한거
DECLARE @LI_MAX_VALUE int;
SET @LI_MAX_VALUE = (SELECT MAX(TOTAL_PRICE)		      AS MAX_PRICE
                       FROM (SELECT A.CUST_ID             AS CUST_ID
                       	           ,C.NAME	              AS NAME
                       	           ,C.ADDRESS             AS ADDRESS
                       	           ,C.PHONE               AS PHONE
                       	           ,SUM(A.AMOUNT*B.PRICE) AS TOTAL_PRICE
                               FROM T_SalesList A JOIN T_FRUIT B
                       				        	 ON A.FRUIT = B.FRUIT
                       				           JOIN T_Customer C
                       				             ON A.CUST_ID = C.CUST_ID
                           GROUP BY A.CUST_ID, C.NAME, C.ADDRESS, C.PHONE) AS NEW_TABLE) -- @LI_MAX_VALUE에 최댓값을 찾아서 할당했음.

SELECT *
  FROM ( SELECT A.CUST_ID             AS CUST_ID
               ,C.NAME	              AS NAME
               ,C.ADDRESS             AS ADDRESS
               ,C.PHONE               AS PHONE
               ,SUM(A.AMOUNT*B.PRICE) AS TOTAL_PRICE
		   FROM T_SalesList A JOIN T_FRUIT B
    		                    ON A.FRUIT = B.FRUIT
    		                  JOIN T_Customer C
    		                    ON A.CUST_ID = C.CUST_ID
	   GROUP BY A.CUST_ID, C.NAME, C.ADDRESS, C.PHONE) AS NEW_TABLE
 WHERE NEW_TABLE.TOTAL_PRICE = @LI_MAX_VALUE

 --2. MAX 집계함수를 통해 가장 큰 값을 가진 데이터를 구한 후 찾기. -강사님거
DECLARE @LI_MAXPRICE INT --  구매 금액이 가장 큰 값을 담을 변수 

-- 1)가장 큰 매출 액 찾기
SELECT @LI_MAXPRICE = MAX(AA.TOTAL_PRICE)
  FROM (SELECT  A.CUST_ID
               ,SUM(A.AMOUNT * B.PRICE) AS TOTAL_PRICE
          FROM T_SalesList A JOIN T_FRUIT B
                        ON A.FRUIT = B.FRUIT
                      JOIN T_Customer C
                        ON A.CUST_ID = C.CUST_ID
       GROUP BY A.CUST_ID) AA

-- 2) 가장 큰 매출액을 가진 고객의 정보 구하기.
SELECT C.CUST_ID            AS CUST_ID,
       C.NAME               AS C_NAME,
       C.ADDRESS            AS ADDRESS,
       C.PHONE              AS PHONE,
       SUM(A.AMOUNT * B.PRICE) AS TOTAL_PRICE
  FROM T_SalesList A JOIN T_FRUIT B
                       ON A.FRUIT = B.FRUIT
                     JOIN T_Customer C
                       ON A.CUST_ID = C.CUST_ID
GROUP BY C.CUST_ID,C.NAME,C.ADDRESS,C.PHONE 
HAVING SUM(A.AMOUNT * B.PRICE) = @LI_MAXPRICE

 
 /************************************** 실습 *************************************************
 '2022-12-01'부터 '2022-12-31' (12월 한달간)까지 가장 많이 팔린 과일의 종류와 판매 수량을 구하세요. 
 단, 판매수량이 같은 과일은 N개의 행으로 표현할 것.

 과일이름, 판매수량*/
 DECLARE @LI_MAX_FRUIT_SALES int
	    ,@LS_STARTDATE VARCHAR(10) = '2022-12-01'
		,@LS_ENDDATE VARCHAR(10) = '2022-12-31'
 
  SELECT @LI_MAX_FRUIT_SALES = MAX(AA.TOTAL_FRUIT_SALES)
    FROM(SELECT A.FRUIT
	           ,SUM(A.AMOUNT)	AS TOTAL_FRUIT_SALES
           FROM T_SalesList A JOIN T_Fruit B
					            ON A.FRUIT = B.FRUIT
		  WHERE A.DATE >= @LS_STARTDATE
            AND A.DATE <= @LS_ENDDATE
GROUP BY A.FRUIT) AA						-- 변수 @LI_MAX_FRUIT_SALES에 최댓값 할당.

  SELECT A.FRUIT		     AS HIGHEST_FRUIT_NAME
        ,A.Q			     AS HIGHEST_FRUIT_SALES
    FROM (SELECT A.FRUIT
	          ,SUM(A.AMOUNT) AS Q
          FROM T_SalesList A JOIN T_FRUIT B
					           ON A.FRUIT = B.FRUIT
		 WHERE A.DATE >= @LS_STARTDATE
		   AND A.DATE <= @LS_ENDDATE
	  GROUP BY A.FRUIT) A
   WHERE A.Q = @LI_MAX_FRUIT_SALES



/************************ 실습 *******************************
고객별 총 구매금액이 12만원(120000)이 넘는 고객의 내역을 조회하세요.
(고객ID, 고객이름, 총구매금액)
*/

      SELECT A.CUST_ID
		    ,C.NAME
			,SUM(A.AMOUNT * B.PRICE) AS TOTAL_PRICE
	    FROM T_SalesList A LEFT JOIN T_FRUIT B
					              ON A.FRUIT = B.FRUIT
					       LEFT JOIN T_Customer C
					              ON A.CUST_ID = C.CUST_ID
    GROUP BY A.CUST_ID, C.NAME
	  HAVING SUM(A.AMOUNT * B.PRICE) > 120000

--위 내용을 SUM 집계함수 한번만 써서 표현해보세요.
SELECT *
  FROM (SELECT A.CUST_ID
		      ,C.NAME
			  ,SUM(A.AMOUNT * B.PRICE) AS TOTAL_PRICE
	      FROM T_SalesList A LEFT JOIN T_FRUIT B
					                ON A.FRUIT = B.FRUIT
					         LEFT JOIN T_Customer C
					                ON A.CUST_ID = C.CUST_ID
      GROUP BY A.CUST_ID, C.NAME) AA
 WHERE AA.TOTAL_PRICE > 120000




 /*************************************************************************************************
 3. UNION / UNION ALL
  . 다수의 검색 내역(행)을 합치는 기능.
  . 조회한 다수의 SELECT 결과를 하나로 합치고 싶을때 UNION을 사용.
  
UNION : 중복되는 행은 하나만 표시
UNION ALL : 중복을 제거하지 않고 모두 표시

***** 합쳐질 조회문의 데이터 컬럼은 형식과 개수가 일치해야한다. */

-- UNION (중복되는 데이터는 제외하고 표현)

SELECT DATE      AS DATE
	  ,CUST_ID   AS CSTINFO
	  ,FRUIT     AS FRUIT
	  ,AMOUNT    AS AMOUNT
  FROM T_SalesList
UNION
SELECT ORDERDATE AS DATE
	  ,CUSTCODE  AS CUSTINFO
	  ,FRUIT     AS FRUIT
	  ,AMOUNT    AS AMOUNT
  FROM T_OrderList
-- 판매 리스트 총 31개, 발주 리스트 총 31개이지만, UNION의 결과는 총 57개 행이다. 
-- 2번째 컬럼이 중복되지 않으므로 판매 리스트와 발주 리스트 사이의 중복 데이터는 존재하지 않지만
-- 판매 리스트 내에서 서로 중복되는 데이터들과 발주 리스트 내에서 서로 중복되는 데이터들이 UNION과정에서 제외된 결과이다.
-- >> UNION은 중복된 데이터를 제외하고 표현한다. 


SELECT DATE      AS DATE
	  ,CUST_ID   AS CSTINFO
	  ,FRUIT     AS FRUIT
	  ,AMOUNT    AS AMOUNT
  FROM T_SalesList
UNION ALL
SELECT ORDERDATE AS DATE
	  ,CUSTCODE  AS CUSTINFO
	  ,FRUIT     AS FRUIT
	  ,AMOUNT    AS AMOUNT
  FROM T_OrderList





  --------- 타이틀 표현하기 ----------
  SELECT '판매'     AS TITLE 
        ,DATE       AS DATE
	    ,CUST_ID    AS CSTINFO
	    ,FRUIT      AS FRUIT
	    ,AMOUNT     AS AMOUNT
    FROM T_SalesList  
UNION ALL		    
  SELECT '발주'       AS TITLE
        ,ORDERDATE    AS DATE
  	    ,CUSTCODE     AS CUSTINFO
  	    ,FRUIT        AS FRUIT
  	    ,AMOUNT       AS AMOUNT
    FROM T_OrderList
ORDER BY DATE



/******************* 실습 **********************
위 결과에서
판매이력 관련 고객ID에 따른 이름을 표현하고 
발주이력 관련 거래처명을 표현.
고객 ID에 대한 정보는 T_Customer에서 가져오고,
거래처명은 10 : 대림, 20 : 삼전, 30 : 하나, 40 : 농협으로 표현하세요. */
  SELECT '판매'                              AS TITLE 
        ,A.DATE                              AS DATE
	    ,B.NAME                              AS CSTINFO
	    ,A.FRUIT                             AS FRUIT
	    ,A.AMOUNT                            AS AMOUNT
    FROM T_SalesList A LEFT JOIN T_Customer B
						      ON A.CUST_ID = B.CUST_ID
UNION ALL		    
  SELECT '발주'                              AS TITLE
        ,ORDERDATE                           AS DATE
		,CASE CUSTCODE WHEN '10' THEN '대림'
				       WHEN '20' THEN '삼전'
				       WHEN '30' THEN '하나'
				       WHEN '40' THEN '농협' 
					   END                   AS CUSTINFO							   
  	    ,FRUIT                               AS FRUIT
  	    ,AMOUNT                              AS AMOUNT
    FROM T_OrderList




  /************************* 실습 *********************************
  발주내역과 주문내역에 각각 과일의 판매금액(수량 * 단가)와 
  주문(발주)금액 (발주수량 * 단가)를 추가하여 보여주세요.
   * 컬럼 이름은 INOUTPRICE 라고 표현
   * 발주된 금액은 (-) 표현
   */
   SELECT '판매'                             AS TITLE 
        ,A.DATE                              AS DATE
	    ,B.NAME                              AS CSTINFO
	    ,A.FRUIT                             AS FRUIT
	    ,A.AMOUNT                            AS AMOUNT
		,A.AMOUNT * C.PRICE	                 AS INOUTPRICE
    FROM T_SalesList A LEFT JOIN T_Customer B
						      ON A.CUST_ID = B.CUST_ID
							JOIN T_Fruit C
							  ON A.FRUIT = C.FRUIT
UNION ALL		    
  SELECT '발주'                              AS TITLE
        ,A.ORDERDATE                         AS DATE
		,CASE CUSTCODE WHEN '10' THEN '대림'
				       WHEN '20' THEN '삼전'
				       WHEN '30' THEN '하나'
				       WHEN '40' THEN '농협' 
					   END                   AS CUSTINFO							   
  	    ,A.FRUIT                             AS FRUIT
  	    ,A.AMOUNT                            AS AMOUNT
		,-1 * (A.AMOUNT * B.PRICE)			 AS INOUTPRICE
    FROM T_OrderList A LEFT JOIN T_Fruit B
							  ON A.FRUIT = B.FRUIT


/************************* 실습 *******************************
두가지 방법으로 과일 가게의 일자별 마진 금액을 산출하세요.

 1. UNION을 사용하여 마진 금액 표기
 2. UNION을 사용하지 않고 마진 금액 표기.

 마진 금액 : 판매한 총 금액 - 발주 금액

  . 표현할 컬럼 : DATE(일자), MARGIN_DATE(마진금액) */

-- 1) UNION 이용

SELECT AA.DATE
	  ,SUM(INOUTPRICE) AS MARGIN_DATE
  FROM ( 	      SELECT '판매'                              AS TITLE 
				        ,A.DATE                              AS DATE
					    ,B.NAME                              AS CSTINFO
					    ,A.FRUIT                             AS FRUIT
					    ,A.AMOUNT                            AS AMOUNT
						,A.AMOUNT * C.PRICE	                 AS INOUTPRICE
				    FROM T_SalesList A LEFT JOIN T_Customer B
										      ON A.CUST_ID = B.CUST_ID
											JOIN T_Fruit C
											  ON A.FRUIT = C.FRUIT
				UNION ALL		    
				  SELECT '발주'                              AS TITLE
				        ,A.ORDERDATE                         AS DATE
						,CASE CUSTCODE WHEN '10' THEN '대림'
								       WHEN '20' THEN '삼전'
								       WHEN '30' THEN '하나'
								       WHEN '40' THEN '농협' 
									   END                   AS CUSTINFO							   
				  	    ,A.FRUIT                             AS FRUIT
				  	    ,A.AMOUNT                            AS AMOUNT
						,-1 * (A.AMOUNT * B.PRICE)			 AS INOUTPRICE
				    FROM T_OrderList A LEFT JOIN T_Fruit B
											  ON A.FRUIT = B.FRUIT) AA
GROUP BY AA.DATE


-- 2) UNION 이용 X -- T_OrderLIst, T_SalesList
-- 마진 금액 : 판매한 총 금액 - 발주 금액
-- 판매한 총 금액 -> SalesList에서 Price * Amount
-- 발주 금액 -> OrderList에서 Price * Amount
-- ** Price 는 Fruit테이블에서 뽑아와야함.

-----2-1)
SELECT A.DATE AS DATE
      ,SUM(A.AMOUNT * B.PRICE) AS INOUTPRICE
	  FROM T_SalesList A LEFT JOIN T_Fruit B
								ON A.FRUIT = B.FRUIT
GROUP BY A.DATE
-----2-2)
SELECT A.ORDERDATE AS DATE
	  ,SUM(A.AMOUNT * B.PRICE) AS INOUTPRICE
	  FROM T_OrderList A LEFT JOIN T_Fruit B
							ON A.FRUIT = B.FRUIT
ORDER BY A.ORDERDATE

-----2-1) + 2-2)
SELECT AA.DATE
      ,(ISNULL(AA.INOUTPRICE,0) - (ISNULL(BB.INOUTPRICE,0))) AS TOTALMARGIN
  FROM (SELECT A.DATE AS DATE
              ,SUM(A.AMOUNT * B.PRICE) AS INOUTPRICE
	      FROM T_SalesList A LEFT JOIN T_Fruit B
									ON A.FRUIT = B.FRUIT
	  GROUP BY A.DATE) AA LEFT JOIN (SELECT A.ORDERDATE AS DATE
										   ,SUM(A.AMOUNT * B.PRICE) AS INOUTPRICE
									   FROM T_OrderList A LEFT JOIN T_Fruit B
																 ON A.FRUIT = B.FRUIT
									GROUP BY A.ORDERDATE) BB
							     ON AA.DATE = BB.DATE
