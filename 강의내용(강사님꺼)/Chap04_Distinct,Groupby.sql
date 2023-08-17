/****************************************************
1. ������ �պ� �˻� (DISTINCT)

  - �÷��� ������ �� �ߺ� �Ǿ� ���� ��� �ߺ� �� ������ �� 
    �պ��Ͽ� �˻�. */

-- �츮 ȸ�翡�� �����ϴ� ��� ǰ���� ������ ��Ÿ������.

-- ǰ�� ������ ���̺� ���� ǰ�� ���� �� ǥ���ϸ� �ǰڱ���. 
SELECT DISTINCT ITEMTYPE
  FROM TB_ItemMaster


-- ���� �� KG �� ǰ���� ������ ��ȸ �ϼ���.
-- ǰ�� ������ ���̺��� BASEUNIT(����) �� KG �� �������� 
-- ITEMTYPE (����) �� ���� �� �˻�

SELECT DISTINCT ITEMTYPE
  FROM TB_ItemMaster
 WHERE BASEUNIT = 'KG'


/* ���� �÷� �� �պ� �� �ƴ� ���� �÷��� �պ��� ����
 
 
 -- ���� �� KG �� ������ ǰ�� ���� �� â�� �� �����ּ��� 

 ITEMTYPE : ǰ�� ����
 WHCODE : â��. 
*/
SELECT DISTINCT ITEMTYPE,
				WHCODE
  FROM TB_ItemMaster
 WHERE BASEUNIT = 'KG' 


  -- 1. �츮 ȸ�翡�� �����ϴ� ���ǰ�� ��ȸ
  SELECT * FROM TB_ItemMaster

  -- 2. �츮 ȸ���� ��� ǰ���� ���� �� ����Ʈ
  SELECT ITEMTYPE FROM TB_ItemMaster

  -- 3. ǰ���� ������  ����
 SELECT DISTINCT ITEMTYPE FROM TB_ItemMaster
  
  -- 4. ������ KG �� ����  �� ��ȸ
  SELECT DISTINCT ITEMTYPE FROM TB_ItemMaster WHERE BASEUNIT = 'KG'

  -- 5. ������ KG �� ǰ�� ������ ����� ���ִ� â�� �����ּ���.
  SELECT DISTINCT ITEMTYPE,
				  WHCODE
    FROM TB_ItemMaster WHERE BASEUNIT = 'KG'


/************** �ǽ� **********************
ǰ�� ������ ���̺� ���� 
BOXSPEC (����԰�) �� 'DS-PLT' �� ���� �ϴ� ǰ�� ���� ������ â�� �� ��Ÿ������.

= ǰ�� ������ ���̺� ���� BOXSPEC �� 'DS-PLT' �� �����ϴ� ITEMTYPE �� WHCODE �� 
  ������ �˻� */

SELECT DISTINCT ITEMTYPE, 
				WHCODE 
  FROM TB_ItemMaster
WHERE BOXSPEC LIKE 'DS-PLT%'



-- 1. �԰� �� DS-PLT �� ���� �ϴ� ��� ǰ��
SELECT DISTINCT ITEMTYPE, WHCODE
  FROM TB_ItemMaster
WHERE BOXSPEC LIKE 'DS-PLT%'



/*******************************************************************************************
2. ������ �պ� �˻� GROUP BY  �߿䵵 **********
  . GROUP BY ���ǿ� ���� �ش� �÷��� ������ �� ����. 
  . * GROUP BY �� ���յ� ��� ���� ��ȸ�������� �ξ� �˻� ����(HAVING)
  . * ���� �Լ� �� ����Ͽ� ���� �����͸� ���� �Ҽ� �ִ� ����� ���� */


-- GROUP BY �� �⺻ ����

  SELECT ITEMTYPE
    FROM TB_ItemMaster
GROUP BY ITEMTYPE
--* GROUP BY ���� ���� �÷� �� ��ȸ �� �� ����. 
  SELECT ITEMTYPE
    FROM TB_ItemMaster
GROUP BY ITEMSPEC


-- WHERE �� �� GROUP BY 
   SELECT ITEMTYPE
     FROM TB_ItemMaster
    WHERE BASEUNIT = 'KG'
 GROUP BY ITEMTYPE


 -- GROUP BY ���� ���� �÷� �� ��ȸ �� �� ���� ���.
 SELECT ITEMTYPE
       ,WHCODE
   FROM TB_ItemMaster
  WHERE BASEUNIT = 'KG'
GROUP BY ITEMTYPE


--[POINT 1]
/********** �ǽ� *********************************************
TB_StockMM : ������ ��� ���̺� 
STOCKQTY : ���� ��� ����
INDATE   : ��� �԰� ����. 

TB_StockMM ���̺��� 
STOCKQTY �� ������ �� 1500 �̻��� ������ �� ������
INDATE �� ������ �� '2022-03-01' ���� '2022-03-31' �� ������ ��
INDATE �� ITEMCODE �� ǥ���ϼ���. 
 
-- '2022-03-01' ���� '2022-03-31' ���̿� 1500 �� �̻� ���� ���ں� ǰ�� ����Ʈ
*/

SELECT INDATE,
	   ITEMCODE
  FROM TB_StockMM
 WHERE STOCKQTY >= 1500
   AND INDATE BETWEEN '2022-03-01' AND '2022-03-31'
GROUP BY INDATE , ITEMCODE


--[POINT 2]
/* GROUP BY ��� ���� �� �˻� HAVING
MAXSTOCK : �ִ� ���緮
ITEMTYPE : ǰ�� ����
INSPFLAG : �˻� ����

ǰ�� ������ ���̺� ����  (TB_ITEMMASTER)
MAXSTOCK �� 10 �� �ʰ� �ϴ� ������ ��
ITEMTYPE �� INSPFLAG �� ��Ÿ���� 
INSPFLAG �� I �� ������ �� ǥ���ϼ���.

-- ǰ�� �߿� �ִ� ���緮�� 10 �ʰ��ϴ� ǰ���� ������ �˻� ���θ� ��Ÿ������ 
   (* �� �˻翩�� ��  I �ΰ�).
*/
  SELECT ITEMTYPE , INSPFLAG
    FROM TB_ItemMaster
   WHERE MAXSTOCK > 10
GROUP BY ITEMTYPE, INSPFLAG
  HAVING INSPFLAG = 'I'


-- ���� * HAVING �� ���ؼ� ������ ���� �÷� �� �ݵ�� GROUP BY �� ���¿��� �Ѵ�. 
  SELECT ITEMTYPE , INSPFLAG
    FROM TB_ItemMaster
   WHERE MAXSTOCK > 10
GROUP BY ITEMTYPE, INSPFLAG
  HAVING INSPFLAG = 'I'


/**************************  ���⼭ ��� ***********************************/
-- [POINT 1]

SELECT INDATE,
	   ITEMCODE
  FROM TB_StockMM
 WHERE STOCKQTY >= 1500
   AND INDATE BETWEEN '2022-03-01' AND '2022-03-31'
GROUP BY INDATE , ITEMCODE


-- �� ������ �Ʒ��� ����. 
SELECT DISTINCT INDATE, ITEMCODE
  FROM TB_StockMM
 WHERE STOCKQTY >= 1500
   AND INDATE BETWEEN '2022-03-01' AND '2022-03-31'

-- �� POINT 2 
  SELECT ITEMTYPE , INSPFLAG
    FROM TB_ItemMaster
   WHERE MAXSTOCK > 10
GROUP BY ITEMTYPE, INSPFLAG
  HAVING INSPFLAG = 'I'
 

-- �� ��� �� �Ʒ� �� ����. 
SELECT DISTINCT ITEMTYPE , INSPFLAG
    FROM TB_ItemMaster
   WHERE MAXSTOCK > 10
    AND INSPFLAG = 'I' 


-- �׷��ٸ� �� GROUP BY �� ����ϴ� ���ϱ�?????

/**********************************************************************************************
3. ���� �Լ�
 - Ư�� �÷��� ���� �࿡ �ִ� �����͸� ���� �� �ϳ��� ����� ��ȯ�ϴ� �Լ�.

  . SUM()   :  �����ϴ� �÷��� ������ �� ��� ���Ѵ�.
  . MIN()   :  �����ϴ� �÷��� ������ �� �ּ� ���� ��Ÿ����.  
  . MAX()   :  �����ϴ� �÷��� ������ �� �ִ� ���� ��Ÿ����. 
  . COUNT() :  �����ϴ� �÷��� �� ������ ��Ÿ����. 
  . AVG()   :  �����ϴ� �÷��� ������ ���� ����� ��Ÿ����. 
*/


-- ǰ�� ������ ���̺� ���� ITEMTYPE �� FERT �� ������ �� UNITCOST �� ? 
-- UNITCOST : �ܰ�.
SELECT SUM(UNITCOST) 
  FROM TB_ItemMaster
 WHERE ITEMTYPE = 'FERT'

SELECT UNITCOST
  FROM TB_ItemMaster
 WHERE ITEMTYPE  = 'FERT'


-- COUNT() �Լ� : ������ ���� ����
SELECT COUNT(*) AS CNT
  FROM TB_ItemMaster


-- AVG() �Լ� : ���
-- TB_StockMM : ������ ��� ���̺�
-- ������ ��� �� ��� ������ ��Ÿ������.
SELECT AVG(STOCKQTY)
  FROM TB_StockMM


-- MAX() , MIN () 
-- ������ �� �߿� �ִ밪�� �ּҰ�. 


SELECT MAX(UNITCOST) 
  FROM TB_ItemMaster  
-- ǰ�� �� �ܰ��� ���� ���� �ݾ� 

SELECT MIN(UNITCOST) 
  FROM TB_ItemMaster  
-- ǰ�� �� �ܰ��� ���� ���� �ݾ�. 




-- ���� �Լ� �� ȥ���Ͽ� ��� �� ���
-- ǰ�񸶽��� ���� ǰ�� ���� �� 
-- (�� ����) �� (�ܰ� �� �� ��) �� (�ܰ��� �ּҰ�) �� ��ȸ. 

SELECT ITEMTYPE ,
       COUNT(*)       AS ITEMCNT,
	   SUM(UNITCOST)  AS COSTSUM,
	   MIN(UNITCOST)  AS MINCOST
  FROM TB_ItemMaster
 GROUP BY ITEMTYPE

-- GROUP BY �ϴ� �迡 ǰ�� �������� COUNT : ���� ���� , SUM : ���� , MIN : �ּ� ��
-- �� ���ؼ� ���� �����ٰ�. 



-- ���� �Լ� �� ����� ����� ��ȸ ���� (HAVING)





  SELECT ITEMTYPE      AS ITEMTYPE
    FROM TB_ItemMaster
GROUP BY ITEMTYPE 
 HAVING SUM(UNITCOST) > 100


  SELECT ITEMTYPE      AS ITEMTYPE,
  	     COUNT(*)      AS ROWCNT,
  	     SUM(UNITCOST) AS SUM_COST,
  	     MIN(UNITCOST) AS MIN_COST
    FROM TB_ItemMaster
GROUP BY ITEMTYPE 
  HAVING SUM(UNITCOST) > 100

-- GROUP BY �� ���� �� ��� �� HAVING ���ǿ� ���� �Լ��� ����� ���. 
-- GROUP BY �� ��� ���� ���� �÷� �� ����� �� �ִ�.

 /* 
	UNITCOST : �ܰ� 
	ITEMTYPE : ǰ������

    ǰ�񸶽��� ���̺��� UNITCOST �� 10 �̻��� �����͸� ���� �� ��. 
	ITEMTYPE ���� UNITCOST �� �� �� 100 �� �ʰ��ϴ� ���� 
	ITEMTYPE, UNITCOST ����, UNITCOST �� �ִ밪 �� ��Ÿ���ÿ�
	 * ���ı����� �ܰ��� �� ������������ ��Ÿ������
 */ 

   SELECT ITEMTYPE,
		  SUM(UNITCOST) AS SUM_UNITCOST,
		  MAX(UNITCOST)
     FROM TB_ItemMaster
    WHERE UNITCOST >= 10
 GROUP BY ITEMTYPE
   HAVING SUM(UNITCOST) > 100
 ORDER BY SUM_UNITCOST

/* ������ ���̽� �� ó�� ����. 
   ******** FROM -> WHERE -> GROUP BY -> HAVING -> ORDER BY ����.
   1. ǰ�� ������ ���� UNITCOST �� 10 �̻��� �� ���� ( WHERE )
   2. 1 ���� ����� ������ ���� ITEMTYPE �÷� �� ���� ó��.  (GROUP BY)
   3. 2 �� ������ �����ϸ鼭 UNITCOST �� �� �� 100 �ʰ� �ϴ� �� ���� ( HAVING )
   4. 3 ���� ���� �� �÷� ITEMTYPE ǥ��
      3 ���� ���� �� �÷��� �������� UNITCOST �����Լ� SUM ���� -> SUM_UNITCOST �÷���Ī �ο�
	  3 ���� ���� �� �÷��� �������� UNITCOST �����Լ� MAX ����
   5. 4 ���� �Ϸ�� ������ �� 4�� �� �Ϸ�� ������ ���̺��� �÷� �� �������� ���� (  ORDER BY )
*/


-- ���� ? 
-- �Ʒ� SQL �� �� ������ �ȵɱ� ? 
-- STOCKQTY �� ���� ū ���� ã�Ƴ� ��� �� �Һи���. 
-- �� ���� ����� �����Ƿ� ó������ �ʴ´�. 
SELECT ITEMCODE 
  FROM TB_StockMM
 WHERE MAX(STOCKQTY) > 10

/*********** ����
���� �Լ� �� GROUP BY �� �Բ� ��� �� ��� ȿ���� ũ��
���� �Լ��� ��� ������ ������� ���� ��� GROPUP BY / DISTINCT �� 
ū ���̰� ����. 
*/

--[POINT 3]
/******* �ǽ�
TB_STOCKMMREC  : ���� ��� ���� �̷�
INOUTFLAG      : ���� ����   I : �԰�
WHCODE         : â�� �ڵ�

TB_STOCKMMREC ���̺� �� ������ ��  INOUTFLAG �� 'I' �̰� 
INOUTQTY �� 1000 ���� ū ������ ����
INOUTDATE �� WHCODE �� Ƚ�� �� ��Ÿ���� (���� �� â�� �԰� Ƚ��)
INOUTDATE �������� �������� ��ȸ �ϼ���.

2. ���� Ƚ�� �� 2�� �̻��� ������ �� ��ȸ �� ������
*/
SELECT INOUTDATE
      ,WHCODE
	  ,COUNT(*)    AS CNT
  FROM TB_StockMMrec 
 WHERE INOUTFLAG = 'I'
   AND INOUTQTY > 1000
GROUP BY INOUTDATE, WHCODE
  HAVING COUNT(*) >= 2
ORDER BY INOUTDATE
  