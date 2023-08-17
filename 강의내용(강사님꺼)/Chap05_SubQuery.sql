/* ���� ���� (���� ����) ******* SUB QUERY
  - ���� �ȿ� ����
  - �Ϲ������� SELECT ��
			     FROM ��
			    WHERE ��
	�� ���ȴ�. 
	
	���� : SQL ���� �ȿ��� �����ϰ� �ٸ� SQL ������ �����
	       ��� �� �� �ִ�. 
	���� : ������ ����������. 


	1. ���������� ��ȣ �� ���μ� ���
	2. ���������� ���� �� �Ǵ� ���� �� �� �����ڿ� �Բ� ��� ����
	3. �������� ������ ORDER BY ������ ����� �� ����. 
*/



/***********************************************************************************/
-- ���� ������ ���� ������ ��ȸ  (WHERE ��)
/* TB_StockMMrec : ���� ��� ����� �̷�
   TB_ItemMaster : ǰ�� �� ����Ʈ (ǰ�񸶽���)
   PONO          : ���縦 ������ ��ȣ

   ���� ��� ����� �̷� ���̺��� PONO �� 'PO202106270001' �� ITEMCODE
   �� ������ 
   ǰ�� ������ ���̺��� ��ȸ �Ͽ� 
   ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE �÷����� �����͸� �˻� */

-- 1. ���� ��ȣ �� ����ǰ�� �ڵ� �� ���� ���� ǰ�� ������ ���� ��ȸ
SELECT ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE 
  FROM TB_ItemMaster
 WHERE ITEMCODE = (SELECT ITEMCODE
					 FROM TB_StockMMrec
					WHERE PONO = 'PO202106270001')

-- 2. ���� ��ȣ �� ����ǰ�� �ڵ� �� ������ ���� ǰ�� ������ ���� ��ȸ
SELECT ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE 
  FROM TB_ItemMaster
 WHERE ITEMCODE <> (SELECT ITEMCODE
					 FROM TB_StockMMrec
					WHERE PONO = 'PO202106270001')
					
-- 3. �԰� �� ǰ�� �ڵ� ������ �ִ� ������ ǰ�� �ڵ� ������ ǰ�� ������ ���� ��ȸ
SELECT ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE 
  FROM TB_ItemMaster
 WHERE ITEMCODE IN (SELECT DISTINCT ITEMCODE
					 FROM TB_StockMMrec
					WHERE INOUTFLAG = 'I'
					  AND ITEMCODE IS NOT NULL)

SELECT ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE 
  FROM TB_ItemMaster
 WHERE ITEMCODE = '202008-B1-1'
SELECT ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE 
  FROM TB_ItemMaster
 WHERE ITEMCODE = '33210-029-00C'
SELECT ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE 
  FROM TB_ItemMaster
 WHERE ITEMCODE = 'KFQS01-01'


 -- 4. �������� �������� ǰ���ڵ带 ������ ǰ�� ������ ���� ��ȸ.
 SELECT ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE 
  FROM TB_ItemMaster
 WHERE ITEMCODE NOT IN (SELECT DISTINCT ITEMCODE
					 FROM TB_StockMMrec
					WHERE INOUTFLAG = 'I'
					  AND ITEMCODE IS NOT NULL)

-- WHERE ���� �� '=' ������ �� ������� �������� ������ ���� �� �� ����. (IN, NNOT IN )

/****** �ǽ� ********
TB_StockMMrec : ���� ���� �̷� ���̺�
ITEMCODE : ǰ�� �ڵ� 
INOUTQTY : ���� ����
CARTYPE  : ����
INOUTFLAG : ��/�� ���� (I : �԰�) 

���� �����̷� ���̺� ���� 
ITEMCODE �� ���� ������ �ְ� 
INOUTQTY �� 1000 �� �̻��̸鼭 
INOUTFLAG �� I �� ITEMCODE ����Ʈ �� �����ϰ�
ITEMCODE ���� ������ ǰ�� ������ ���� 
ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE �������� ��ȸ �� ������ */
SELECT ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE
  FROM TB_ItemMaster
 WHERE ITEMCODE IN (SELECT DISTINCT ITEMCODE
				      FROM TB_StockMMrec
					 WHERE INOUTFLAG = 'I'
					   AND ITEMCODE IS NOT NULL
					   AND INOUTQTY >= 1000)


/* ���� ������ ���� ����

***** �ǽ� �ó����� *****
TB_STOCKMM : ���� ��� ���̺�
TB_StockMMrec : ���� ���� �̷� ���̺�
TB_ITEMMASTER : ǰ�� ������ (ǰ�� ����Ʈ)

MATLOTNO : ���� LOT NO (������ ��������)

���� ��� ���̺��� STOCKQTY �� 3000 ���� ū MATLOTNO �� ������ 
���� ��� �̷� ���̺� ���� ITEMCODE �� ã�Ƴ��� �ش� ǰ�� ���� ������
ǰ�� ������ ���� ��ȸ �Ͽ� 
ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE �÷����� �˻� 

*/


-- 1. ���� ��� ���̺��� 3000�� ���� ū LOTNO ã��
SELECT MATLOTNO 
  FROM TB_StockMM 
 WHERE STOCKQTY > 3000

-- 2. ��� �̷� ���̺� ���� LOTNO �� �̷��� ��ȸ
SELECT * 
  FROM TB_StockMMrec
 WHERE MATLOTNO = (SELECT MATLOTNO 
				     FROM TB_StockMM 
				    WHERE STOCKQTY > 3000)

-- 3. 2 ���� ��ȸ �� ǰ���� ������ ��ȸ.
SELECT ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE
  FROM TB_ItemMaster
 WHERE ITEMCODE IN ( SELECT ITEMCODE 
					   FROM TB_StockMMrec
					  WHERE MATLOTNO = (SELECT MATLOTNO 
					 				     FROM TB_StockMM 
					 				    WHERE STOCKQTY > 3000))






/***********************************************************************************/
-- ���� ������ ���� ������ ��ȸ  (SELECT ��)

/*
   ���� ��� ���̺��� ITEMCODE, INDATE, MATLOTNO �÷��� ������ �� �˻� �ϰ� 
   ���� ��� ���� �̷� ���̺� ���� ���� ��� ���̺��� ��ȸ�� MATLOTNO �÷��� �����͸� �����ϰ� 
   INOUTFLAG = 'OUT' �� �����͸� ������ INOUTDATE �÷��� ��ȸ.
*/

-- [.POINT 4]
SELECT A.ITEMCODE,
	   A.INDATE,
	   A.MATLOTNO							 AS MATLOTNO ,
	  
	  (SELECT INOUTDATE
	      FROM TB_StockMMrec 
		 WHERE MATLOTNO  = A.MATLOTNO 
		   AND INOUTFLAG = 'OUT')			AS INDATE

  FROM TB_StockMM A

-- ���� �ܰ�
-- 1. 
SELECT ITEMCODE,
	   INDATE,
	   MATLOTNO
  FROM TB_StockMM


-- 2. ���� ����. SUB ����
SELECT INOUTDATE
	      FROM TB_StockMMrec 
		 WHERE MATLOTNO  = 'LTROH1459097100001'
	

--LTROH1438534870001
--LTROH2130262570001
--LTROH1459097100001
--LTROH1132574030001
--LTROH1650200500001
--LT_R2021082012481881
--LOTR2021070817274225
--LTROH2134195800002
--LTROH1556377070001
 


 --3.���� ����
 SELECT ITEMCODE,
	   INDATE,
	   MATLOTNO,
	   (SELECT INOUTDATE
	      FROM TB_StockMMrec 
		 WHERE MATLOTNO  = A.MATLOTNO 
		  ) AS INDATE
  FROM TB_StockMM A
--��� �� �������� ����� �ϳ��� ���δ�. 
-- ***** ���� : ���� �� �Ǵ� ���̺� TB_StockMM ���� 1�� ��ȸ ���� �� 
--              SUB ���� �� 9�� ���� �ǹǷ� �� 10���� �˻� ������ ����ȴ�. 



/********************************************************************************************
-- ���� ���� (FROM) 
  . FROM ���� ���� ���̺� ��ġ�� ���̺� ����ó�� �ӽ� ���̺�� ������ �����͸� ������ �ۼ� �Ҽ� �ִ�. 
  . ������ �����͸� ���̺� �������� ��� �� �� �ִ�. 
  . ���̺��� �������� �ڿ��� �ݵ�� �ӽ����̺��� �̸��� �ο� �ؾ� �Ѵ�.  */


  SELECT WHCODE FROM TB_ItemMaster

 SELECT WHCODE
   FROM (SELECT ITEMCODE,
		        ITEMNAME,
        	    ITEMTYPE,
        	    BASEUNIT
           FROM TB_ItemMaster
          WHERE ITEMTYPE = 'FERT') TB_TEMP


-- POINT 3 �� �ǽ� �������� 
-- COUNT ���� �Լ� �� �ѹ��� ����ؼ� ���� ����� ���� �������� �ۼ�
SELECT INOUTDATE
      ,WHCODE
	  ,COUNT(*)    AS CNT
  FROM TB_StockMMrec 
 WHERE INOUTFLAG = 'I'
   AND INOUTQTY > 1000
GROUP BY INOUTDATE, WHCODE
  HAVING COUNT(*) >= 2
ORDER BY INOUTDATE
  
-- ���� ��� �� HAVING �� ���� �ʰ� ���� ����� ����� ���� 
-- �����Լ� �� �ѹ�������ϴ� ���
 

-- 1. ��ü �������� ���� ���� ����.
SELECT INOUTDATE, 
	   WHCODE,
	   COUNT(*) AS DATEPERWHCODE_CNT
  FROM TB_StockMMrec
 WHERE INOUTFLAG = 'I'
   AND INOUTQTY > 1000
GROUP BY INOUTDATE, WHCODE
   
-- 2. ����� ��� �� �ӽ����̺�� FROM ���� �������� �� ����Ͽ� ��ȸ
SELECT *
  FROM (SELECT INOUTDATE, 
			   WHCODE,
	           COUNT(*) AS DATEPERWHCODE_CNT
		  FROM TB_StockMMrec
		 WHERE INOUTFLAG = 'I'
		   AND INOUTQTY > 1000
	  GROUP BY INOUTDATE, WHCODE) A
WHERE DATEPERWHCODE_CNT >= 2