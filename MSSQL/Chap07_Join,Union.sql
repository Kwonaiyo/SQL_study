/*********************************************************************************
1. ���̺� �� ������ ���� �� ��ȸ (JOIN)

JOIN : �� �̻��� ���̺��� �����ؼ� �����͸� �˻��ϴ� ���.
	 . ���̺��� ���� �����ϱ� ���ؼ��� �ϳ� �̻��� �÷��� �����ϰ� �־�� ��.
 ON  : �� ���̺��� ������ �����÷� ���� �� ���� ���̺��� ���� ���. 


 - JOIN�� ����
  . ���� ����(INNER JOIN) : JOIN. �� �̻��� ���̺��� ����Ǿ����� �ݵ�� �� ���̺� ���ÿ� ���� �����ؾ��Ѵ�.
						  . �ϳ��� ���̺��̶� �����Ͱ� ���� ��� �����Ͱ� ǥ������ �ʴ´�.

  . �ܺ� ����(OUTER JOIN) : LEFT JOIN, RIGHT JOIN, FULL JOIN
						  . �� �̻��� ���̺��� ����Ǿ��� ��� �ϳ��� ���̺� �����Ͱ� ������ �ϴ��� �����Ͱ� ǥ���Ǵ� JOIN

*/

/* T_Customer ���̺�� T_SalesList ���̺��� ���� ��ID, ���̸�, �Ǹ�����, ����, �Ǹż����� ǥ���ϼ���. 
	T_Customer : �� ���̺�
	T_SalesList : �Ǹ��̷� ���̺�
*/

SELECT * FROM T_Customer
SELECT * FROM T_SalesList

-- ��������� JOIN���� ON�� �Ἥ ǥ���ϴ� ���
SELECT A.CUST_ID,
	   B.NAME,
	   A.DATE,
	   A.FRUIT,
	   A.AMOUNT
  FROM T_SalesList A JOIN T_Customer B
					   ON A.CUST_ID = B.CUST_ID
-->> T_SalesList ���̺��� �������� ��ȸ

SELECT A.*, B.*
  FROM T_SalesList A JOIN T_Customer B
				       ON A.CUST_ID = B.CUST_ID
  
SELECT B.CUST_ID,
	   A.NAME,
	   B.DATE,
	   B.FRUIT,
	   B.AMOUNT
  FROM T_Customer A JOIN T_SalesList B
				      ON A.CUST_ID = B.CUST_ID	-->> ����� ���� ����
-->> JOIN : T_Customer ���̺��� �������� ��ȸ������, T_SalesList ���̺� 5��(�̼�)�� ���� �����Ͱ� �����Ƿ�
--          �̼��� ���� �����ʹ� ǥ������ ����.(�̼��� ������ �������� ����.)



-- JOIN ���̺��� ���������� �ۼ��Ͽ� �����غ���.
-- . ��ȸ�� ���ϴ� �����Ͱ� ������ �ӽ� ���̺� ���·� JOIN���� �ϼ�.
SELECT *
FROM T_Customer A JOIN (SELECT CUST_ID,
							   FRUIT,
							   DATE
						  FROM T_SalesList
						 WHERE DATE < '2022-12-02') B
					ON  A.CUST_ID = B.CUST_ID

/************************ OUTER JOIN **********************************************
�Ǹ��̷º� ���� �ƴ϶� ������ �Ǹ��̷��� ���� �ʹٸ� ��� �ؾ��ϴ°�?... --> OUTER JOIN?

1. LEFT JOIN
 . ���ʿ� �ִ� ���̺��� �����͸� �������� �����ʿ� �ִ� ���̺��� �����͸� �˻� �� �����ϰ�, �����Ͱ� ���� ��� NULL�� ǥ�õȴ�.
*/

-- ������ �Ǹ��̷��� ��ȸ�غ�����.
SELECT A.CUST_ID,
	   A.NAME,
	   ISNULL(B.FRUIT, '�Ǹ��̷¾���') AS FRUIT,
	   ISNULL(B.AMOUNT, '0') AS AMOUNT,
	   B.DATE
  FROM T_Customer A LEFT JOIN T_SalesList B
						   ON A.CUST_ID = B.CUST_ID

-- ISNULL �κ��� CASE WHEN���� �����ؼ� ǥ���� ������.
	   SELECT A.CUST_ID,
	   A.NAME,
	   CASE WHEN B.FRUIT IS NULL THEN '�Ǹ��̷¾���'
			ELSE B.FRUIT END AS FRUIT,
	   CASE WHEN B.AMOUNT IS NULL THEN '0'
			ELSE B.AMOUNT END AS AMOUNT,
	   B.DATE
  FROM T_Customer A LEFT JOIN T_SalesList B
						   ON A.CUST_ID = B.CUST_ID

	-- LEFT JOIN�� �Ἥ ���� ���̺��� �Ǹ��̷� ���̺�� �Ѵٸ�, �Ʒ��� SQL���� 5(�̼�)�� ǥ���� �ɱ�? --> NO!
	SELECT A.CUST_ID,
		   B.NAME,
		   A.FRUIT,
		   A.AMOUNT
	  FROM T_SalesList A LEFT JOIN T_Customer B
								ON A.CUST_ID = B.CUST_ID	--> LEFT JOIN�� ������ �Ǵ� T_SalesList�� �̼��� ���� �����Ͱ� �����Ƿ�, ǥ������ �ʴ´�.
														--> �̼��� �����͸� ǥ���ϰ�Ͱ� T_SalesList ���̺��� ���ʿ� �ΰ� �ʹٸ� LEFT ��ſ� RIGHT JOIN�� ����ϸ� �ȴ�.
														

/* RIGHT JOIN
   �����ʿ� �ִ� ���̺��� �����͸� �������� ���ʿ� �ִ� ���̺��� �����͸� �˻��ϰ�, ���� ���̺� �����Ͱ� ���� ��� NULL */

-- ���� �Ǹ���Ȳ(���� ���� �Ǹ��̷��� ��� �����ʹ� ���;��Ѵ�.)
SELECT B.CUST_ID,
	   B.NAME,
	   A.FRUIT,
	   A.AMOUNT
  FROM T_SalesList A RIGHT JOIN T_Customer B
							 ON A.CUST_ID = B.CUST_ID

-- �Ǹ���Ȳ�� �� ����(�Ǹ� �̷¿� ���� ���� ��Ÿ�� �ʿ䰡 ����.)
SELECT A.CUST_ID,
	   A.NAME,
	   B.FRUIT,
	   B.AMOUNT
  FROM T_Customer A RIGHT JOIN T_SalesList B
							 ON A.CUST_ID = B.CUST_ID


-- ������ ǥ���� JOIN
-- JOIN���� ���� �ʰ� ���̺��� ������ �� WHERE���� ���� �÷��� �����ϴ� ���
SELECT *
  FROM T_Customer A, T_SalesList B
 WHERE A.CUST_ID = B.CUST_ID
   AND B.DATE > '2020-01-01'


/***************************** ���� JOIN ********************************************
������ �����Ͱ� ���� ���̺� ������.
���� ���̺�� ���� ���̺���� ���� JOIN���� �����͸� ǥ���� �� �ִ�.

- ������ �Ǹ� ��Ȳ�� �Ǹ�����, ���̸�, ����ó, �ǸŰ���, ���ϴܰ�, �Ǹűݾ����� ��Ÿ������. */
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



/********************* �ǽ� **************************
TB_StockMMrec : ���� ���� �̷� ���̺�
TB_ItemMaster : ǰ�񸶽��� ���̺�
INOUTFLAG : �԰�����(I : �԰�)
ITEMTYPE : ǰ������(ROH : ������)

���� ���� �̷� ���̺� A���� ITEMCODE�� NULL�� �ƴϰ� INOUTFLAG�� 'I'�� ������ ��
ǰ�񸶽��� ���̺� B���� ITEMTYPE�� 'ROH'�� ��������
A.INOUTDATE, A.INOUTSEQ, A.MATLOTNO, A.ITEMCODE, B.ITEMNAME�� ������ ��Ÿ������
	- ���� �÷� A.ITEMCODE, B.ITEMCODE */
SELECT A.INOUTDATE
	  ,A.INOUTSEQ
	  ,A.MATLOTNO
	  ,A.ITEMCODE
	  ,B.ITEMNAME
  FROM TB_StockMMrec A LEFT JOIN TB_ItemMaster B
					          ON A.ITEMCODE = B.ITEMCODE
							  --AND B.ITEMTYPE = 'ROH'		--> JOIN ���� �����͸� ���͸�
 WHERE A.ITEMCODE IS NOT NULL
   AND A.INOUTFLAG = 'I'
   AND B.ITEMTYPE = 'ROH'		--> JOIN ���� �ϼ��� �����͸� ���͸�
/* -> AND B.ITEMTYPE = 'ROH'�� JOIN �ȿ� ���°Ŷ� ������ �������ͼ� WHERE���� �ٴ°Ŷ��� �˻� ����� ���̰� �ִ�. 
   -> ** �߰��Ǵ� ����� ITEMCODE KFQS01-01�� TB_ItemMaster���� ���� �������̴�.
   -> 1. JOIN�ȿ� AND�� �̿��ؼ� 'ROH'�� ���͸��� ������ LEFT JOIN�� ���� ItemMaster���� ������ StockMMrec���� �ִ� ITEMCODE�� KFQS01-01�� �����͸� ITEMNAME��
	   . NULLó���ؼ� ����� ���� ������ش�.
   -> 2. WHERE���� 'ROH'�� ���͸��� ��쿡�� LEFT JOIN�� ���� ��µ� �����͵� �� KFQS01-01�� �����Ͱ� ���͸��ȴ�. ��, KFQS01-01�� ItemMaster ���̺� ������� �ʱ�
       . ������ ITEMTYPE�� ���� ����. ���� ITEMTYPE <> 'ROH'�̱� ������ ���͸��Ǿ� �����Ͱ� ������ �ȴ�.
   ->  * LEFT JOIN�� ���� ���μ����� ���ؼ� �߻��ϴ� ����̴�. (FROM -> WHERE -> SELECT)
*/



/*********************** �ǽ� *********************************
���� ������ �� ��� �ݾ� ���ϱ�
��ID, ����, �����̸�, ���Ϻ� �� ���ݾ�.

  * GROUP BY�� JOIN�� ������ ����� �� �ִ°�?
*/
--> 1. �������̺�� � ���̺��� �����ؾ� �ұ�? --> ���� �ذ��� ���� ��ü���� �������� �帧�� �����ϴ� ���̺�

--> 2. ���� ���Ϻ� �� ���� GROUP BY
SELECT CUST_ID	   AS CUST_ID
	  ,FRUIT	   AS FRUIT
	  ,SUM(AMOUNT) AS FRUITPERSALECOUNT
  FROM T_SalesList
GROUP BY CUST_ID, FRUIT

--> 3. �ܰ��ݾװ� ������ ���ϰ� �� �ݾ��� ����. - 2���� ���� ���� ������ �Ǹż��� ���� �������̺�� ��� ���������� ǥ���ߴ�.
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

-- 3-2) 3-1�� �ٸ� ���. ����� ����.
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



/********************************** �ǽ� ***************************************
�� ���� �ݾ��� ���� ū ���� ǥ���ϼ���.
(ID, ���̸�, ���ּ�, ������ó, �� ���� �ݾ�)
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



--���� �� ���� �ݾ��� ���� ����. -- T_SalesList�� T_Fruit�� JOIN�ؼ� ������ �޾ƿ;� ��.
--TABLE�� F_TOTAL_PRICE �������� ������������ ������ �� ���� �����ִ� ������ ���� �̾ƿ�.
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

--2. MAX �����Լ��� ���� ���� ū ���� ���� �����͸� ���� �� ã��. -�����Ѱ�
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
                           GROUP BY A.CUST_ID, C.NAME, C.ADDRESS, C.PHONE) AS NEW_TABLE) -- @LI_MAX_VALUE�� �ִ��� ã�Ƽ� �Ҵ�����.

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

 --2. MAX �����Լ��� ���� ���� ū ���� ���� �����͸� ���� �� ã��. -����԰�
DECLARE @LI_MAXPRICE INT --  ���� �ݾ��� ���� ū ���� ���� ���� 

-- 1)���� ū ���� �� ã��
SELECT @LI_MAXPRICE = MAX(AA.TOTAL_PRICE)
  FROM (SELECT  A.CUST_ID
               ,SUM(A.AMOUNT * B.PRICE) AS TOTAL_PRICE
          FROM T_SalesList A JOIN T_FRUIT B
                        ON A.FRUIT = B.FRUIT
                      JOIN T_Customer C
                        ON A.CUST_ID = C.CUST_ID
       GROUP BY A.CUST_ID) AA

-- 2) ���� ū ������� ���� ���� ���� ���ϱ�.
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

 
 /************************************** �ǽ� *************************************************
 '2022-12-01'���� '2022-12-31' (12�� �Ѵް�)���� ���� ���� �ȸ� ������ ������ �Ǹ� ������ ���ϼ���. 
 ��, �Ǹż����� ���� ������ N���� ������ ǥ���� ��.

 �����̸�, �Ǹż���*/
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
GROUP BY A.FRUIT) AA						-- ���� @LI_MAX_FRUIT_SALES�� �ִ� �Ҵ�.

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



/************************ �ǽ� *******************************
���� �� ���űݾ��� 12����(120000)�� �Ѵ� ���� ������ ��ȸ�ϼ���.
(��ID, ���̸�, �ѱ��űݾ�)
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

--�� ������ SUM �����Լ� �ѹ��� �Ἥ ǥ���غ�����.
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
  . �ټ��� �˻� ����(��)�� ��ġ�� ���.
  . ��ȸ�� �ټ��� SELECT ����� �ϳ��� ��ġ�� ������ UNION�� ���.
  
UNION : �ߺ��Ǵ� ���� �ϳ��� ǥ��
UNION ALL : �ߺ��� �������� �ʰ� ��� ǥ��

***** ������ ��ȸ���� ������ �÷��� ���İ� ������ ��ġ�ؾ��Ѵ�. */

-- UNION (�ߺ��Ǵ� �����ʹ� �����ϰ� ǥ��)

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
-- �Ǹ� ����Ʈ �� 31��, ���� ����Ʈ �� 31��������, UNION�� ����� �� 57�� ���̴�. 
-- 2��° �÷��� �ߺ����� �����Ƿ� �Ǹ� ����Ʈ�� ���� ����Ʈ ������ �ߺ� �����ʹ� �������� ������
-- �Ǹ� ����Ʈ ������ ���� �ߺ��Ǵ� �����͵�� ���� ����Ʈ ������ ���� �ߺ��Ǵ� �����͵��� UNION�������� ���ܵ� ����̴�.
-- >> UNION�� �ߺ��� �����͸� �����ϰ� ǥ���Ѵ�. 


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





  --------- Ÿ��Ʋ ǥ���ϱ� ----------
  SELECT '�Ǹ�'     AS TITLE 
        ,DATE       AS DATE
	    ,CUST_ID    AS CSTINFO
	    ,FRUIT      AS FRUIT
	    ,AMOUNT     AS AMOUNT
    FROM T_SalesList  
UNION ALL		    
  SELECT '����'       AS TITLE
        ,ORDERDATE    AS DATE
  	    ,CUSTCODE     AS CUSTINFO
  	    ,FRUIT        AS FRUIT
  	    ,AMOUNT       AS AMOUNT
    FROM T_OrderList
ORDER BY DATE



/******************* �ǽ� **********************
�� �������
�Ǹ��̷� ���� ��ID�� ���� �̸��� ǥ���ϰ� 
�����̷� ���� �ŷ�ó���� ǥ��.
�� ID�� ���� ������ T_Customer���� ��������,
�ŷ�ó���� 10 : �븲, 20 : ����, 30 : �ϳ�, 40 : �������� ǥ���ϼ���. */
  SELECT '�Ǹ�'                              AS TITLE 
        ,A.DATE                              AS DATE
	    ,B.NAME                              AS CSTINFO
	    ,A.FRUIT                             AS FRUIT
	    ,A.AMOUNT                            AS AMOUNT
    FROM T_SalesList A LEFT JOIN T_Customer B
						      ON A.CUST_ID = B.CUST_ID
UNION ALL		    
  SELECT '����'                              AS TITLE
        ,ORDERDATE                           AS DATE
		,CASE CUSTCODE WHEN '10' THEN '�븲'
				       WHEN '20' THEN '����'
				       WHEN '30' THEN '�ϳ�'
				       WHEN '40' THEN '����' 
					   END                   AS CUSTINFO							   
  	    ,FRUIT                               AS FRUIT
  	    ,AMOUNT                              AS AMOUNT
    FROM T_OrderList




  /************************* �ǽ� *********************************
  ���ֳ����� �ֹ������� ���� ������ �Ǹűݾ�(���� * �ܰ�)�� 
  �ֹ�(����)�ݾ� (���ּ��� * �ܰ�)�� �߰��Ͽ� �����ּ���.
   * �÷� �̸��� INOUTPRICE ��� ǥ��
   * ���ֵ� �ݾ��� (-) ǥ��
   */
   SELECT '�Ǹ�'                             AS TITLE 
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
  SELECT '����'                              AS TITLE
        ,A.ORDERDATE                         AS DATE
		,CASE CUSTCODE WHEN '10' THEN '�븲'
				       WHEN '20' THEN '����'
				       WHEN '30' THEN '�ϳ�'
				       WHEN '40' THEN '����' 
					   END                   AS CUSTINFO							   
  	    ,A.FRUIT                             AS FRUIT
  	    ,A.AMOUNT                            AS AMOUNT
		,-1 * (A.AMOUNT * B.PRICE)			 AS INOUTPRICE
    FROM T_OrderList A LEFT JOIN T_Fruit B
							  ON A.FRUIT = B.FRUIT


/************************* �ǽ� *******************************
�ΰ��� ������� ���� ������ ���ں� ���� �ݾ��� �����ϼ���.

 1. UNION�� ����Ͽ� ���� �ݾ� ǥ��
 2. UNION�� ������� �ʰ� ���� �ݾ� ǥ��.

 ���� �ݾ� : �Ǹ��� �� �ݾ� - ���� �ݾ�

  . ǥ���� �÷� : DATE(����), MARGIN_DATE(�����ݾ�) */

-- 1) UNION �̿�

SELECT AA.DATE
	  ,SUM(INOUTPRICE) AS MARGIN_DATE
  FROM ( 	      SELECT '�Ǹ�'                              AS TITLE 
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
				  SELECT '����'                              AS TITLE
				        ,A.ORDERDATE                         AS DATE
						,CASE CUSTCODE WHEN '10' THEN '�븲'
								       WHEN '20' THEN '����'
								       WHEN '30' THEN '�ϳ�'
								       WHEN '40' THEN '����' 
									   END                   AS CUSTINFO							   
				  	    ,A.FRUIT                             AS FRUIT
				  	    ,A.AMOUNT                            AS AMOUNT
						,-1 * (A.AMOUNT * B.PRICE)			 AS INOUTPRICE
				    FROM T_OrderList A LEFT JOIN T_Fruit B
											  ON A.FRUIT = B.FRUIT) AA
GROUP BY AA.DATE


-- 2) UNION �̿� X -- T_OrderLIst, T_SalesList
-- ���� �ݾ� : �Ǹ��� �� �ݾ� - ���� �ݾ�
-- �Ǹ��� �� �ݾ� -> SalesList���� Price * Amount
-- ���� �ݾ� -> OrderList���� Price * Amount
-- ** Price �� Fruit���̺��� �̾ƿ;���.

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
