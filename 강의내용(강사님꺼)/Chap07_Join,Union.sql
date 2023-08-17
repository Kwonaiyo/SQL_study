/*******************************************************************************
1. ���̺� �� ������ ���� �� ��ȸ (JOIN)
 
  JOIN : �� �̻��� ���̺��� ���� �ؼ� �����͸� �˻��ϴ� ��� 
        . ���̺��� ���� ���� �ϱ� ���ؼ��� �ϳ� �̻��� �÷��� �����ϰ� �־�� ��.
	ON : �� ���̺��� ���� �� ���� �÷� ���� �� ���� ���̺��� ���� ���.


  - JOIN �� ���� 
   . ���� ���� (INNER JOIN) : JOIN. �� �̻��� ���̺��� ���� �Ǿ����� �ݵ�� 
                              �����̺� ���ÿ� ���� ���� �ؾ� �Ѵ�. 
							  �ϳ��� ���̺��̶� �����Ͱ� ������� �����Ͱ� ǥ������ 
							  �ʴ´�. 

   . �ܺ� ���� (OUTER JOIN) : LEFT JOIN, RIGHT JOIN, FULL JOIN
							  �ΰ� �̻��� ���̺� �� ���� �Ǿ��� ��� 
							  �ϳ��� ���̺� �����Ͱ� ������ �ϴ��� �����Ͱ� 
							  ǥ�� �Ǵ� JOIN
*/

/* 
   T_Customer  : ��
   T_SalesList : �Ǹ� �̷�  

   T_Customer ���̺� �� T_SalesList ���̺� ���� 
   ���� ��ID, ���̸�, �Ǹ�����, ����, �Ǹ� ������ ǥ���ϼ���.*/
SELECT * FROM T_Custmer
SELECT * FROM T_SalesList

-- ��������� JOIN ���� ON �� �Ἥ ǥ���ϴ� ���.
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
-- JOIN : T_Customer ���̺��� �������� ��ȸ ������, T_SalesList ���̺� 
--        5�� �̼� �� ���� �����Ͱ� �����Ƿ� ǥ�� ���� ����.



-- JOIN ���̺� �� ���������� �ۼ��Ͽ� ���� 
-- . ��ȸ�� ���ϴ� ������ �� ������ �ӽ� ���̺� ���·� JOIN ���� �ϼ�.
SELECT *
  FROM T_Custmer A JOIN (SELECT CUST_ID
                               ,FURIT
							   ,DATE
						   FROM T_SalesList
						  WHERE DATE < '2022-12-02') B
					 ON A.CUST_ID = B.CUST_ID


/***** OUTER JOIN *********************************
1. LEFT JOIN 
  . ���ʿ� �ִ� ���̺��� �����͸� �������� �����ʿ� �ִ� ���̺���
    �����͸� �˻� �� ���� �ϰ� ,�����Ͱ� ���� ��� NULL �� ǥ�� �ȴ�.
*/

--  �� ���� �Ǹ� �̷��� ��ȸ�� ������. 
SELECT A.CUST_ID
      ,A.NAME
	  ,ISNULL(B.FURIT,'�Ǹ��̷¾���') AS FRUIT
	  ,ISNULL(B.AMOUNT,0) AS AMOUNT
	  ,B.DATE
  FROM T_Custmer A LEFT JOIN T_SalesList B
						  ON A.CUST_ID = B.CUST_ID

-- ISNULL �κ��� CASE WHEN ���� �����ؼ� ǥ���� ������.
SELECT A.CUST_ID
      ,A.NAME
	  ,CASE WHEN B.FURIT IS NULL THEN '�Ǹ��̷¾���'
								 ELSE B.FURIT END    AS FRUIT

	  ,CASE WHEN B.AMOUNT IS NULL THEN 0 
								  ELSE B.AMOUNT END  AS AMOUNT
	  ,B.DATE
  FROM T_Custmer A LEFT JOIN T_SalesList B
						  ON A.CUST_ID = B.CUST_ID


-- LEFT JOIN �� �Ἥ ���� ���̺��� �Ǹ��̷� ���̺��. 
-- �Ʒ��� SQL ���� 5 �̼� �� ǥ���� �ɱ� ? 
SELECT A.CUST_ID
	  ,B.NAME
	  ,A.FURIT
	  ,A.AMOUNT
  FROM T_SalesList A LEFT JOIN T_Custmer B	
							ON A.CUST_ID = B.CUST_ID


-- RIGHT JOIN 
-- �����ʿ� �ִ� ���̺��� �����͸� �������� ���ʿ� �ִ� ���̺��� 
-- �����͸� �˻��ϰ� ���� ���̺� �����Ͱ� ������� NULL 

-- ���� �Ǹ���Ȳ. (���� �Ǹ� �̷��� ��� �����ʹ� ���;��Ѵ�.)
SELECT B.CUST_ID
      ,B.NAME
	  ,A.FURIT
	  ,A.AMOUNT
  FROM T_SalesList  A RIGHT JOIN T_Custmer B
							  ON A.CUST_ID = B.CUST_ID


-- �Ǹ� ��Ȳ�� �� ���� (�Ǹ� �̷¿� ���� ���� ��Ÿ�� �ʿ䰡 ����.)
SELECT A.CUST_ID
      ,A.NAME
	  ,B.FURIT
	  ,B.AMOUNT
  FROM T_Custmer  A RIGHT JOIN T_SalesList B
							  ON A.CUST_ID = B.CUST_ID


-- ������ ǥ���� JOIN 
-- JOIN ���� ���� �ʰ� ���̺��� ���� �� WHERE ���� �����÷� ����. 
SELECT *
  FROM T_Custmer A , T_SalesList B
 WHERE A.CUST_ID = B.CUST_ID
   AND B.DATE > '2020-01-01'


/***************************** ���� JOIN 
 . ���� �� ������ �� ���� ���̺� ������ 
 ���� ���̺�� ���� ���̺� ���� ���� JOIN ���� �����͸� ǥ���� �� �ִ�.
*/

-- ������ �Ǹ� ��Ȳ�� 
-- �Ǹ�����, ���̸�, ����ó, �ǸŰ���, ���ϴܰ�, �Ǹűݾ� ���� ��Ÿ������

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
 /********** �ǽ� **********************
 TB_StockMMrec : ���� ���� �̷� ���̺� 
 TB_ItemMaster : ǰ�� ������
 INOUTFLAG :  �԰� ����  , I : �԰�
 ITEMTYPE  :  ǰ������ , ROH : ������

 ���� ���� �̷� ���̺� (A) ���� ITEMCODE  �� NULL �� �ƴϰ� ,
 INOUTFLAG �� I �� 
 ǰ�� ������ ���̺� (B) ���� ITEMTYPE �� 'ROH' �� ����
 A.INOUTDATE,  A.INOUTSEQ,  A.MATLOTNO,  A.ITEMCODE,  B.ITEMNAME 
 �� ������ ��Ÿ ������. 
    - ���� �÷� A.ITEMCODE, B.ITEMCODE */
   
   SELECT A.INOUTDATE
         ,A.INOUTSEQ
		 ,A.MATLOTNO
		 ,A.ITEMCODE
		 ,B.ITEMNAME
     FROM TB_StockMMrec A  JOIN TB_ItemMaster B
								 ON A.ITEMCODE = B.ITEMCODE  
							    --AND B.ITEMTYPE = 'ROH' -- JOIN ���� �����͸� ���͸�
	WHERE A.ITEMCODE IS NOT NULL
	  AND A.INOUTFLAG = 'I'
	  AND B.ITEMTYPE = 'ROH'  -- JOIN ���Ŀ� �ϼ��� �����͸� ���͸�. 

/* ǰ�� ������ ITEMTYPE= 'ROH' ������ �߰� �� 
   ���� �԰��̷� ���̺��� ITEMCODE �÷��� NULL ������ ���� �������

   1. JOIN ������ ������ �ٶ� ���� LEFT JOIN ���� ���Ͽ� 
           �����԰����� �̷� �� ITEMCODE �� ǥ�� �ǰ�
   2. WHERE ���� ������ �ٶ� ���� LEFT JOIN ���� ���� ��� 
           ���Ŀ� ������ ���� �ǹǷ� ���͸� �Ǿ�ǥ�� �� */


/********************* �ǽ� *************************************
 �����Ǹ� �̷¿��� �� �� ������ �� ��� �ݾ� ���ϱ� 
 ��ID, �� ��, �����̸�, ���Ϻ� �� ��� �ݾ�. 
*/

-- ������ �ǵ� GROUP BY �� JOIN �� ������ ����� �� �ִ°� ? 

-- 1. �������̺�� �����ؾ� �� ���̺��� �����ϱ� ?  
--   �������̺� :���� �ذ��� ���� ��ü���� �帧�� �����͸� �����ϴ�
--               ���̺� 
-- ���� �Ǹ� �̷� ���̺��� ���� ���̺� �� �ϱ� ����. 


-- 2. ���� ���� �� �� ���� GROUP BY
  SELECT CUST_ID     AS CUST_ID,
		 FURIT       AS FURIT,
		 SUM(AMOUNT) AS FP_SALECNT
    FROM T_SalesList
GROUP BY CUST_ID, FURIT


-- 3.�ܰ� �ݾ� �� ������ ���ϰ� �� �ݾ��� ����. 
--     2 ���� ���� ���� ������ �Ǹż��� ���� �������̺�� ��� ���������� ǥ��. 
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


 -- Ǯ�� ���� 2)

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


/************************************ �ǽ� ***********************************

�� ���� �ݾ��� ���� ū ���� ǥ���ϼ���. 
(ID, ���̸�, ���ּ�, �� ����ó, �� ���� �ݾ�) 
****************************************************************/

-- 1�� ��� 
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
 







-- 2�� ��� (MAX ���� �Լ��� ���� ���� ū ���� ���� ������ �������� ã��)
DECLARE @LI_MAXPRICEW INT --  ���� �ݾ��� ���� ū ���� ���� ���� 

-- 1.���� ū ���� �� ã��
SELECT @LI_MAXPRICEW = MAX(AA.TOTAL_PRICE)
  FROM (SELECT  SUM(A.AMOUNT * B.PRICE) AS TOTAL_PRICE
          FROM T_SalesList A JOIN T_FRUIT B
							   ON A.FURIT = B.FRUIT
							 JOIN T_Custmer C
							   ON A.CUST_ID = C.CUST_ID
	    GROUP BY A.CUST_ID) AA

-- 2. ���� ū ������� ���� ���� ���� ���ϱ�.
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


/*************************** �ǽ� *************************
2022-12-01 �Ϻ��� 2022-12-31 (����)
���� ���� ���� �ȸ� ������ ���� �� �Ǹ� ������ ���ϼ���

�����̸�, �Ǹż��� 

 * �� �Ǹ� ������ ���� ������ N ���� ������ ǥ���Ұ� */

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



/***************************************************** �ǽ� *********************

�� �� �� ���� �ݾ��� 12���� (120000) �� �Ѵ� ���� ������ ��ȸ �ϼ���
(�� ID,  ���̸�,   �� ���� �ݾ�)*/

   SELECT A.CUST_ID,
		  B.NAME,
		  SUM(A.AMOUNT * C.PRICE) AS TOTALPRICE
     FROM T_SalesList A LEFT JOIN T_Custmer B
							   ON A.CUST_ID = B.CUST_ID
					    LEFT JOIN T_Fruit C 
						       ON A.FURIT = C.FRUIT

	GROUP BY A.CUST_ID, B.NAME
      HAVING SUM(A.AMOUNT * C.PRICE) > 120000

-- �� ������ SUM �����Լ� �ѹ��� �Ἥ ǥ�� �� ������.
 
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
 . �ټ��� �˻� ����(��) �� ��ġ�� ���. 
 . ��ȸ �� �ټ��� SELECT ����� �ϳ��� ��ġ�� ������ (UNION) �� ���. 
 
 UNION : �ߺ��Ǵ� ���� �ϳ��� ǥ��. 
 UNION ALL : �ߺ� �� ���� ���� �ʰ� ��� ǥ��. 

 ***** ������ ��ȸ���� ������ �÷��� ���İ� ������ ��ġ �ؾ��Ѵ�. 
 */

 -- UNION (�ߺ��Ǵ� ������ �� �����ϰ� ǥ��)
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
-- �� �� ��� �� 
-- �Ǹ� ����Ʈ �� �� 31�� 
-- ���� ����Ʈ �� �� 31�� ����

-- �Ʒ� ���� �� ���� ���� ����Ʈ �� �ߺ� �����Ͱ� 4�� ������ Ȯ���� ���ִ�
SELECT ORDERDATE AS DATE
      ,CUSTCODE  AS CUSTINFO
	  ,FRUIT     AS FRUIT
	  ,AMOUNT    AS AMOUNT
	  ,COUNT(*)
  FROM T_ORDERLIST
GROUP BY  ORDERDATE,CUSTCODE ,FRUIT,AMOUNT   

-- * UNION �� �ߺ��� �����͸� �����ϰ� ���ļ� ǥ���Ѵ�.






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



---------- Ÿ��Ʋ ǥ���ϱ�. 
 SELECT '�Ǹ�'    AS TITLE
	   ,DATE      AS DATE
       ,CUST_ID   AS CSTINFO
	   ,FURIT     AS FRUIT
	   ,AMOUNT    AS AMONT
   FROM T_SalesList
UNION ALL
SELECT '����'    AS TITLE
	  ,ORDERDATE AS DATE
      ,CUSTCODE  AS CUSTINFO
	  ,FRUIT     AS FRUIT
	  ,AMOUNT    AS AMOUNT
  FROM T_ORDERLIST
ORDER BY DATE




/******** �ǽ� ******** 
�� ��� ���� 

�Ǹ��̷� ���� �� ID �� ���� �̸��� ǥ���ϰ�. 
�����̷� ���� �ŷ�ó ���� ��ü���� ǥ��.
�� ID �� ���� ���� T_Custmer ���� �������� 
�ŷ�ó ���� 10 : �븲, 20 : ����, 30 : �ϳ� , 40 : ����
���� ǥ�� �ϼ���.
*/
 SELECT '�Ǹ�'      AS TITLE
	   ,A.DATE      AS DATE
       ,B.NAME      AS CSTINFO
	   ,A.FURIT     AS FRUIT
	   ,A.AMOUNT    AS AMONT
   FROM T_SalesList A LEFT JOIN T_Custmer B
							 ON A.CUST_ID = B.CUST_ID
UNION ALL
SELECT '����'								   AS TITLE
	  ,ORDERDATE							   AS DATE
      ,CASE CUSTCODE WHEN '10' THEN '�븲'
				     WHEN '20' THEN '����'
					 WHEN '30' THEN '�ϳ�'
					 WHEN '40' THEN '����' END AS CUSTINFO
	  ,FRUIT								   AS FRUIT
	  ,AMOUNT								   AS AMOUNT
  FROM T_ORDERLIST
ORDER BY DATE