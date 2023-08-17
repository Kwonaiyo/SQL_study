/***********************************************************************************
	1. ������ �պ� �˻� (Distinct)	-	�߿䵵 **********
		 - �÷��� �����Ͱ� �ߺ��Ǿ����� ��� �ߺ��� �����͸� �պ��Ͽ� �˻�.
*/

-- �츮 ȸ�翡�� �����ϴ� ��� ǰ���� ������ ��Ÿ������. 

-- ǰ�񸶽��� ���̺��� ǰ�� ������ ǥ���ϸ� �ǰڱ���..
	SELECT DISTINCT ITEMTYPE
			   FROM TB_ItemMaster

-- ������ KG�� ǰ���� ������ ��ȸ�ϼ���.
	SELECT DISTINCT ITEMTYPE
			   FROM TB_ItemMaster
			  WHERE BASEUNIT = 'KG'


/* ���� �÷��� �պ��� �ƴ� ���� �÷��� �պ��� ����

 . ������ KG�� ������ ǰ�� ������ â�� �����ּ���.

*/
SELECT DISTINCT ITEMTYPE,
				WHCODE
		   FROM TB_ItemMaster
		  WHERE BASEUNIT = 'KG'



/************************* �ǽ� ***************************
ǰ�� ���������̺���
BOXSPEC(����԰�)�� 'DS-PLT'�� �����ϴ� ǰ����� ������ â�� ��Ÿ������.
*/
	SELECT DISTINCT ITEMTYPE,
				    WHCODE
			   FROM TB_ItemMaster
			  WHERE BOXSPEC LIKE 'DS-PLT%'

			  

/***********************************************************
	2. ������ �պ� �˻� GROUP BY	-	�߿䵵 ***********
	 . GROUP BY ���ǿ� ���� �ش� �÷��� �����͸� ����.
	 . * GROUP BY�� ���յ� ������� ��ȸ�������� �ξ� �˻� ����.(HAVING)
	 . * ���� �Լ��� ����Ͽ� ���� �����͸� ������ �� �ִ� ����� ����. */

-- GROUP BY�� �⺻ ����.
	SELECT ITEMTYPE			-->>  FROM ���̷jŸ�� �����Ϳ���(FROM) --> ITEMTYPE���� �׷�ȭ�� ��(GROUP BY) --> ITEMTYPE�� ���(SELECT)
	  FROM TB_ItemMaster
  GROUP BY ITEMTYPE
  -- * GROUP BY ���� ���� �÷��� ��ȸ�� �� ����. 

  SELECT ITEMTYPE		
	  FROM TB_ItemMaster
  GROUP BY ITEMSPEC		-->> ����..! ITEMSPEC�� GROUP BY�� ����Ʈ���� ITEMTYPE�� ����.


-- WHERE���� GROUP BY
	  SELECT ITEMTYPE
	    FROM TB_ItemMaster
 	   WHERE BASEUNIT = 'KG'
	GROUP BY ITEMTYPE		-->>	FROM -> WHERE -> GROUP BY -> SELECT

-- GROUP BY���� ���� �÷��� ��ȸ�� �� ���� ���.
	SELECT ITEMTYPE,
		   WHCODE
	  FROM  TB_ItemMaster
	 WHERE BASEUNIT = 'KG'
  GROUP BY ITEMTYPE


--[POINT 1]
/***************** �ǽ� *******************************
  TB_StockMM : ������ ��� ���̺�
  STOCKQTY : ���� ��� ����
  INDATE   : ��� �԰� ��¥ 

  TB_StockMM ���̺���
  STOCKQTY�� �����Ͱ� 1500 �̻��� �����͸� ������
  INDATE�� �����Ͱ� '2022-03-01'���� '2022-03-31'�� ������ ��
  INDATE�� ǰ���� ǥ���ϼ���. */

  SELECT INDATE, ITEMCODE
    FROM TB_StockMM
   WHERE STOCKQTY >= 1500
 	 AND (INDATE >= '2022-03-01' AND INDATE <= '2022-03-31')
GROUP BY INDATE, ITEMCODE

--[POINT 2]
/* GROUP BY ������� ��˻�. HAVING

ǰ�񸶽��� ���̺���
MAXSTOCK�� 10�� �ʰ��ϴ� ������ ��
ITEMTYPE�� INSPFLAG�� ��Ÿ����
INSPFLAG�� 'I'�� �����͸� ǥ���ϼ���

MAXSTOCK : �ִ� ���緮
ITEMTYPE : ǰ�� ����
INSPFLAG : �˻� ����

-->> ǰ�� �߿� �ִ� ���緮�� 10�� �ʰ��ϴ� ǰ���� ������ �˻� ���θ� ��Ÿ������(*�� �˻翩�δ� I�� ��)
*/
	 SELECT ITEMTYPE,
	        INSPFLAG
	   FROM TB_ItemMaster
	  WHERE MAXSTOCK > 10
   GROUP BY ITEMTYPE, INSPFLAG
     HAVING INSPFLAG = 'I'		-->> FROM -> WHERE -> GROUP BY -> HAVING -> SELECT

-- * ���� *
-- HAVING�� ���ؼ� ������ ���� �÷��� �ݵ�� GROUP BY�� ���¿��� �Ѵ�. 
	 SELECT ITEMTYPE,
	        INSPFLAG
	   FROM TB_ItemMaster
	  WHERE MAXSTOCK > 10
   GROUP BY ITEMTYPE, INSPFLAG
     HAVING INSPFLAG = 'I'

/****************** ���⼭ ��� **********************/
--POINT 1
SELECT INDATE, ITEMCODE
    FROM TB_StockMM
   WHERE (INDATE >= '2022-03-01' AND INDATE <= '2022-03-31')
 	 AND STOCKQTY >= 1500
GROUP BY INDATE, ITEMCODE

--�� ������ �Ʒ��� ����. 
SELECT DISTINCT INDATE, ITEMCODE
FROM TB_StockMM
WHERE STOCKQTY >= 1500
  AND (INDATE BETWEEN '2022-03-01' AND '2022-03-31')

--�� POINT 2
   SELECT ITEMTYPE, 
          INSPFLAG
     FROM TB_ItemMaster 
    WHERE MAXSTOCK > 10
 GROUP BY ITEMTYPE, INSPFLAG
   HAVING INSPFLAG = 'I'

--�� ����� �Ʒ��� ����.
 SELECT DISTINCT ITEMTYPE, INSPFLAG
            FROM TB_ItemMaster
           WHERE MAXSTOCK > 10
             AND INSPFLAG = 'I'
			 
-- �׷��ٸ� �� GROUP BY�� ����ϴ� ���ϱ�??(������ GROUP BY�� DISTINCT���� ���ҽ��� ���� �� ������ƸԴ´�.)
		-->> �����Լ��� ���� ���̱� ����. (�� ���� ����ϴ°��� �ƴϴ�. �����Լ��� GROUP BY�� ���� ������ �� �� �ִ�.)
/***********************************************************************************
3. ���� �Լ�
 - Ư�� �÷��� ���� �࿡ �ִ� �����͸� ���� �� �ϳ��� ����� ��ȯ�ϴ� �Լ�.

 . SUM() : �����ϴ� �÷��� �����͸� ��� ���Ѵ�.
 . MIN() : �����ϴ� �÷��� ������ �� �ּڰ��� ��Ÿ����.
 . MAX() : �����ϴ� �÷��� ������ �� �ִ��� ��Ÿ����.
 . COUNT() : �����ϴ� �÷��� �� ������ ��Ÿ����.
 . AVG() : �����ϴ� �÷��� �����͵��� ����� ��Ÿ����.
*/


-- ǰ�񸶽��� ���̺��� ITEMTYPE�� FERT�� �������� UNITCOST ���� ���ϼ���
-- UNITCOST : �ܰ�
SELECT SUM(UNITCOST) AS SUMMMM
  FROM TB_ItemMaster
 WHERE ITEMTYPE = 'FERT'

-- COUNT() �Լ�
SELECT COUNT(*) AS _COUNT
  FROM TB_ItemMaster

-- AVG() �Լ�
-- TB_StockMM : ������ ��� ���̺�
-- ������ ����� ��� ������ ��Ÿ������.
SELECT AVG(STOCKQTY) AS _AVERAGE
      FROM TB_StockMM

-- MAX(), MIN()
-- �����͵� �߿��� �ִ�, �ּڰ��� ã�� �� �ִ�.
SELECT MAX(UNITCOST) AS _MAX_COST
 FROM TB_ItemMaster		-->> ǰ�� �� �ܰ�(UNITCOST)�� ���� ���� ���� ��Ÿ��.

SELECT MIN(UNITCOST) AS _MIN_COST
  FROM TB_ItemMaster	-->> ǰ�� �� �ܰ�(UNITCOST)�� ���� ���� ���� ��Ÿ��.




-- �����Լ��� ȥ���Ͽ� ����� ���
-- ǰ�� ������ �ܰ��� ���հ� �ּڰ��� ��ȸ�غ���.
    SELECT ITEMTYPE,
		   COUNT(*)		 AS ITEMCNT,
		   SUM(UNITCOST) AS COSTSUM,
	       MIN(UNITCOST) AS COSTMIN
      FROM TB_ItemMaster
  GROUP BY ITEMTYPE

-- GROUP BY (����)�ϴ±迡 ǰ�� �������� COUNT : ���� ����, SUM : ����, MIN : �ּڰ��� ���ؼ� ���� �����ٰ�..



-- �����Լ��� ����� ����� ��ȸ ����(HAVING)
	SELECT ITEMTYPE			 AS ITEMTYPE,
		   COUNT(*)			 AS ROWCNT,
		   SUM(UNITCOST)	 AS SUM_COST,
		   MIN(UNITCOST)	 AS MIN_COST
	  FROM TB_ItemMaster
  GROUP BY ITEMTYPE
	HAVING COUNT(*) > 100

-- GROUP BY�� ���յ� ����� HAVING ���ǿ� ���� �Լ��� ����� ���.
-- GROUP BY�� ������� ���� �÷��� ����� �� �ִ�. 




/*
	UNITCOST : �ܰ�, ITEMTYPE : ǰ������

	ǰ�񸶽��� ���̺��� UNITCOST�� 10 �̻��� �����͸� ���� �� �߿���
	ITEMTTYPE���� UNITCOST�� ���� 100�� �ʰ��ϴ� ����
	ITEMTYPE, UNITCOST�� �հ� UNITCOST�� �ִ��� ��Ÿ���ÿ�.
	 * ���ı����� �ܰ��� �� ������������ ��Ÿ������.
*/
	SELECT ITEMTYPE,
		   SUM(UNITCOST) AS SUM_UNITCOST,
		   MAX(UNITCOST) AS MAX_UNITCOST
	  FROM TB_ItemMaster
	 WHERE UNITCOST >= 10
  GROUP BY ITEMTYPE
	HAVING SUM(UNITCOST) > 100
   -- ORDER BY SUM(UNITCOST) ASC  -->> �̷��� �ص� ������, �̷��� �Ǹ� SUM �Լ��� �� �� �� ȣ���ϰ� �ȴ�..
  ORDER BY SUM_UNITCOST ASC


/* �����ͺ��̽��� ó�� ����.
   FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY  
   1. ǰ�񸶽��Ϳ���(FROM) UNITCOST�� 10 �̻��� ���� ���� (WHERE)
   2. 1���� ����� ITEMTYPE�� ���� ó���Ѵ�. (GROUP BY)
   3. 2�� ������ �����ϸ鼭, UNITCOST�� ���� 100�� �ʰ��ϴ� ���� �����Ѵ�. (HAVING)
   4. 3���� ����� �÷� ITEMTYPE�� ǥ���ϰ�, 
	  3���� ����� �÷��� �������� UNITCOST �����Լ� SUM�� ����. - �÷��� SUM_UNITCOST�� ��Ī �ο�
	  3���� ����� �÷��� �������� UNITCOST �����Լ� MAX�� ����. - �÷��� MAX_UNITCOST�� ��Ī �ο�	(SELECT)
   5. 4���� �Ϸ�� �����͸� SUM_UNITCOST �������� ������������ ����.	(ORDER BY)
*/



-- ����; �Ʒ� SQL�� �� ������ �ȵɱ�?
-->> STOCKQTY�� ���� ū ���� ã�Ƴ� ����� �Һи��ϴ�. �� ���� ����� �����Ƿ� ó������ �ʴ´�. 
--( WHERE�������� ���迡 ���� ������ ���� ������ �����Լ��� ����� �� ����. )
	SELECT ITEMCODE
	  FROM TB_StockMM
	 WHERE MAX(STOCKQTY) > 10


/************ ���� **************
�����Լ��� GROUP BY�� �Բ� ����� ��� ȿ���� ũ��. ���� �Լ��� ��� ������ ������� ���� ��� GROUP BY�� DISTINCT�� ū ���̰� ����. 
*/

--[POINT 3]
/************ �ǽ� **************
TB_STOCKMMREC : ������� �����̷� ���̺�
INOUTFLAG : ���� ����

T_STOCKMMREC ���̺��� ������ �� INOUTFLAG�� 'I'�̰�,
INOUTQTY�� 1000���� ū ���������� 
INOUTDATE�� WHCODE�� Ƚ���� ��Ÿ����, (���ں� â�� �԰� Ƚ��)
INOUTDATE �������� ������������ ��ȸ�ϼ���. 

** + ���� Ƚ���� 2�� �̻��� �����͸� ��ȸ�ϼ��� 
*/

     SELECT INOUTDATE,
      	    WHCODE,
	  	    COUNT(*) AS CNT
       FROM TB_StockMMrec
      WHERE INOUTFLAG = 'I'
        AND INOUTQTY > 1000
   GROUP BY INOUTDATE, WHCODE
-- + HAVING COUNT(*) >= 2
   ORDER BY INOUTDATE ASC


