/*
	- View
	  . ���� ���Ǵ� SELECT ������ �̸� �����ΰ�, ���̺�ó�� ȣ���Ͽ� ����� �� �ֵ��� ���� ���.

	  . SQL SERVER�� VIEW�� �ϳ��� ���̺�κ��� Ư�� �÷��鸸 �����ְų� Ư�� ���ǿ� �´� ���� �����ִµ� ���� �� ������,
	  . �ΰ� �̻��� ���̺��� �����Ͽ� VIEW�� ����ڿ��� �����ִµ� �̿��� �� �ִ�. 
	  
	  . *** VIEW�� �⺻Ű�� ������ �����͸� ����, ����, ���� �۾��� ���� ***

	  . ���Ȼ��� ������ ���̺� �� �Ϻ� �÷��� �����ϰų� ���� �۾��� ������ ������ ����� �� �ִ�. 
*/


-- VIEW�� �ۼ�
-- ���ϰ��� ���ں� �Ǹ�, ���� ����Ʈ�� VIEW�� ����� VIEW�� ȣ���Ͽ� �����͸� ǥ���ϼ���.

CREATE VIEW V_FRUIT_ORDERSALE_LIST AS
(
-- VIEW�� ���� ǥ���� ����.
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
)

-- V_FRUIT_ORDERSALE_LIST �� ȣ��
SELECT DATE			   AS DATE
	  ,CSTINFO
	  ,SUM(INOUTPRICE) AS DAYPRICE
  FROM V_FRUIT_ORDERSALE_LIST
GROUP BY DATE, CSTINFO



/********************* �ǽ� *****************************
������ ���� V_FRUIT_ORDERSALE_LIST�� �̿��Ͽ� 
���ϰ��Կ��� ���ֱݾ��� ���� ���Ҵ� ��ü�� ���ֱݾ��� �����ϼ���.
*/
  SELECT TOP(1) *
    FROM ( SELECT CSTINFO		    AS CST
		         ,SUM(INOUTPRICE) AS DAYPRICE
             FROM V_FRUIT_ORDERSALE_LIST
         GROUP BY CSTINFO) A
ORDER BY A.DAYPRICE ASC

-- 0) ��ü�� ���ֱݾ� ����Ʈ�� VIEW�� ����
CREATE VIEW V_ORDERPERCUST_PRICE AS
(
SELECT CSTINFO
       	    ,SUM(INOUTPRICE) AS TOTAL_ORDERPRICE
       FROM V_FRUIT_ORDERSALE_LIST
       WHERE TITLE = '����'
       GROUP BY CSTINFO
)

-- 1) ��ü���� ���� ���� �ݾ��� ���� ���� ����
SELECT*
FROM V_ORDERPERCUST_PRICE
WHERE TOTAL_ORDERPRICE = (SELECT MIN(TOTAL_ORDERPRICE) AS MAXPRICE
							FROM V_ORDERPERCUST_PRICE)



/******** KEY �÷��� ������ VIEW�� DATE ��� ���� ����. ******/

--VIEW ����(�� ����)
CREATE VIEW V_CUSTOMER AS
(
	SELECT CUST_ID, NAME 
	  FROM T_Customer
	 WHERE CUST_ID > 2
)

SELECT * FROM V_CUSTOMER

--VIEW�� ������ ���(INSERT INTO)
INSERT INTO V_CUSTOMER (CUST_ID, NAME)
				VALUES (6, '������')
--> ������ �信 �����Ͱ� ��ϵǴ°� �ƴ϶� T_Customer�� ��ϵ�.
SELECT * FROM T_Customer

--VIEW ����(DROP VIEW)
DROP VIEW V_CUSTOMER




/***************************** �ǽ� *********************************
�Ʒ� POINT5�� �����Ͽ�
	1. ���ں� �� �Ǹűݾ��� view�� �����	(V_DAY_SALELIST)
	2. ���ں� �� ���ֱݾ��� view�� ���� ��  (V_DAY_ORDERLIST)

	������ VIEW�� ����
	�Ǹ�, ���ֵ� ��ü ������ ������ ���ϼ���.

	ǥ���� �÷� : TOTALMARGIN(�Ѹ���)

	1-1) UNION�� ���
	1-2) JOIN�� ���
*/
-- [Chap07_POINT 5] UNION �� ���� �ʰ� JOIN ���� ǥ��

-- 1.���� �� �� �Ǹ� �ݾ� ����
SELECT A.DATE                 AS DATE,
      SUM(A.AMOUNT * B.PRICE) AS INOUTPRICE
  FROM T_SalesList A LEFT JOIN T_Fruit B 
                     ON A.FRUIT = B.FRUIT
GROUP BY  A.DATE

-- 2. ���� �� �� ���� �ݾ� ����
SELECT A.ORDERDATE            AS DATE,
      SUM(A.AMOUNT * B.PRICE) AS INOUTPRICE
  FROM T_OrderList A LEFT JOIN T_Fruit B 
                     ON A.FRUIT = B.FRUIT
GROUP BY A.ORDERDATE


-- 3. �� �Ǹűݾ� �� �� ���� �ݾ� �� ����.

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

CREATE VIEW V_DAY_SALELIST AS		-- ���ں� �� �Ǹűݾ� �� ����
(
SELECT A.DATE                 AS DATE,
      SUM(A.AMOUNT * B.PRICE) AS INOUTPRICE
  FROM T_SalesList A LEFT JOIN T_Fruit B 
                     ON A.FRUIT = B.FRUIT
GROUP BY  A.DATE
)

CREATE VIEW V_DAY_ORDERLIST AS		-- ���ں� �� ���ֱݾ� �� ����
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

