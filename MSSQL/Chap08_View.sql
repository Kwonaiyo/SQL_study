/*
	- View
	  . 자주 사용되는 SELECT 구문을 미리 만들어두고, 테이블처럼 호출하여 사용할 수 있도록 만든 기능.

	  . SQL SERVER의 VIEW는 하나의 테이블로부터 특정 컬럼들만 보여주거나 특정 조건에 맞는 행을 보여주는데 사용될 수 있으며,
	  . 두개 이상의 테이블을 조인하여 VIEW로 사용자에게 보여주는데 이용할 수 있다. 
	  
	  . *** VIEW는 기본키를 포함한 데이터를 삽입, 삭제, 수정 작업이 가능 ***

	  . 보안상의 이유로 테이블 중 일부 컬럼만 공개하거나 갱신 작업을 방지할 때에도 사용할 수 있다. 
*/


-- VIEW의 작성
-- 과일가게 일자별 판매, 발주 리스트를 VIEW로 만들고 VIEW를 호출하여 데이터를 표현하세요.

CREATE VIEW V_FRUIT_ORDERSALE_LIST AS
(
-- VIEW를 통해 표현할 내용.
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
)

-- V_FRUIT_ORDERSALE_LIST 뷰 호출
SELECT DATE			   AS DATE
	  ,CSTINFO
	  ,SUM(INOUTPRICE) AS DAYPRICE
  FROM V_FRUIT_ORDERSALE_LIST
GROUP BY DATE, CSTINFO



/********************* 실습 *****************************
위에서 만든 V_FRUIT_ORDERSALE_LIST를 이용하여 
과일가게에서 발주금액이 가장 많았던 업체와 발주금액을 산출하세요.
*/
  SELECT TOP(1) *
    FROM ( SELECT CSTINFO		    AS CST
		         ,SUM(INOUTPRICE) AS DAYPRICE
             FROM V_FRUIT_ORDERSALE_LIST
         GROUP BY CSTINFO) A
ORDER BY A.DAYPRICE ASC

-- 0) 업체별 발주금액 리스트를 VIEW로 생성
CREATE VIEW V_ORDERPERCUST_PRICE AS
(
SELECT CSTINFO
       	    ,SUM(INOUTPRICE) AS TOTAL_ORDERPRICE
       FROM V_FRUIT_ORDERSALE_LIST
       WHERE TITLE = '발주'
       GROUP BY CSTINFO
)

-- 1) 업체별로 가장 발주 금액이 많은 값을 산출
SELECT*
FROM V_ORDERPERCUST_PRICE
WHERE TOTAL_ORDERPRICE = (SELECT MIN(TOTAL_ORDERPRICE) AS MAXPRICE
							FROM V_ORDERPERCUST_PRICE)



/******** KEY 컬럼을 포함한 VIEW에 DATE 등록 수정 삭제. ******/

--VIEW 생성(고객 정보)
CREATE VIEW V_CUSTOMER AS
(
	SELECT CUST_ID, NAME 
	  FROM T_Customer
	 WHERE CUST_ID > 2
)

SELECT * FROM V_CUSTOMER

--VIEW에 데이터 등록(INSERT INTO)
INSERT INTO V_CUSTOMER (CUST_ID, NAME)
				VALUES (6, '윤종신')
--> 실제로 뷰에 데이터가 등록되는게 아니라 T_Customer에 등록됨.
SELECT * FROM T_Customer

--VIEW 삭제(DROP VIEW)
DROP VIEW V_CUSTOMER




/***************************** 실습 *********************************
아래 POINT5를 참조하여
	1. 일자별 총 판매금액을 view로 만들고	(V_DAY_SALELIST)
	2. 일자별 총 발주금액을 view로 생성 후  (V_DAY_ORDERLIST)

	생성한 VIEW를 통해
	판매, 발주된 전체 내역의 마진을 구하세요.

	표현할 컬럼 : TOTALMARGIN(총마진)

	1-1) UNION을 사용
	1-2) JOIN을 사용
*/
-- [Chap07_POINT 5] UNION 을 쓰지 않고 JOIN 으로 표현

-- 1.일자 별 총 판매 금액 산출
SELECT A.DATE                 AS DATE,
      SUM(A.AMOUNT * B.PRICE) AS INOUTPRICE
  FROM T_SalesList A LEFT JOIN T_Fruit B 
                     ON A.FRUIT = B.FRUIT
GROUP BY  A.DATE

-- 2. 일자 별 총 발주 금액 산출
SELECT A.ORDERDATE            AS DATE,
      SUM(A.AMOUNT * B.PRICE) AS INOUTPRICE
  FROM T_OrderList A LEFT JOIN T_Fruit B 
                     ON A.FRUIT = B.FRUIT
GROUP BY A.ORDERDATE


-- 3. 총 판매금액 과 총 발주 금액 을 연결.

SELECT AA.DATE,
      (ISNULL(AA.INOUTPRICE,0) - ISNULL(BB.INOUTPRICE,0)) AS TOTALMARGIN
  FROM (SELECT A.DATE                 AS DATE,
             SUM(A.AMOUNT * B.PRICE) AS INOUTPRICE
         FROM T_SalesList A LEFT JOIN T_Fruit B 
                            ON A.FRUIT = B.FRUIT
       GROUP BY  A.DATE) AA LEFT JOIN (SELECT A.ORDERDATE            AS DATE,
                                      SUM(A.AMOUNT * B.PRICE) AS INOUTPRICE
                                  FROM T_OrderList A LEFT JOIN T_Fruit B 
                                                     ON A.FRUIT = B.FRUIT
                                GROUP BY A.ORDERDATE ) BB
                            ON AA.DATE = BB.DATE

CREATE VIEW V_DAY_SALELIST AS		-- 일자별 총 판매금액 뷰 생성
(
SELECT A.DATE                 AS DATE,
      SUM(A.AMOUNT * B.PRICE) AS INOUTPRICE
  FROM T_SalesList A LEFT JOIN T_Fruit B 
                     ON A.FRUIT = B.FRUIT
GROUP BY  A.DATE
)

CREATE VIEW V_DAY_ORDERLIST AS		-- 일자별 총 발주금액 뷰 생성
(
SELECT A.ORDERDATE            AS DATE,
      SUM(A.AMOUNT * B.PRICE) AS INOUTPRICE
  FROM T_OrderList A LEFT JOIN T_Fruit B 
                     ON A.FRUIT = B.FRUIT
GROUP BY A.ORDERDATE
)

SELECT * FROM V_DAY_SALELIST
SELECT * FROM V_DAY_ORDERLIST

-- 1-1)
SELECT SUM(A.INOUTPRICE) AS TOTALMARGIN
  FROM (SELECT INOUTPRICE
          FROM V_DAY_SALELIST
         UNION ALL
        SELECT -1 * INOUTPRICE
          FROM V_DAY_ORDERLIST) A

-- 1-2)
SELECT SUM(AA.SALE_INOUTPRICE - AA.ORDER_INOUTPRICE) AS TOTALMARGIN
FROM (SELECT ISNULL(A.INOUTPRICE,0) AS SALE_INOUTPRICE
		    ,ISNULL(B.INOUTPRICE,0) AS ORDER_INOUTPRICE
        FROM V_DAY_SALELIST A FULL JOIN V_DAY_ORDERLIST B
							         ON A.DATE = B.DATE) AA

