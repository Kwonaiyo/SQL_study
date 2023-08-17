/******************* ��������(��������) ************
  - ���� ���� ����..
  - �Ϲ������� 
		SELECT�� / FROM�� /	WHERE��
    �� ���ȴ�. ( SELECT ��������, FROM ��������, WHERE ��������)

	���� : SQL���� �ȿ��� �����ϰ� �ٸ� SQL������ ����� ����� �� �ִ�.
	���� : ������ ����������. 

	1. ���������� ��ȣ()�� ���μ� ���.
	2. ���������� ������ �Ǵ� ������ �� �����ڿ� �Բ� ��� ����.
	3. ������������ ORDER BY������ ����� �� ����. 
*/

-- ���������� ���� ������ ��ȸ
/* TB_StockMMrec : ���� ��� ����� �̷� ���̺�
   TB_ItemMaster : ǰ���� ����Ʈ ���� ���̺�(ǰ�񸶽��� ���̺�)
   PONO			 : ���� ���� ��ȣ

   ���� ��� ����� �̷� ���̺��� PONO�� 'PO202106270001'�� ITEMCODE�� ������
   ǰ�񸶽��� ���̺��� ��ȸ�Ͽ� ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE �÷����� �����͸� �˻��ϼ���. 
*/
--1. ���ֹ�ȣ�� ����ǰ���ڵ忡 ���� ������ ǰ�񸶽��Ϳ��� ��ȸ.
	SELECT ITEMCODE,
		   ITEMNAME,
		   ITEMTYPE,
		   CARTYPE
	FROM TB_ItemMaster
	WHERE ITEMCODE = ( SELECT ITEMCODE
						 FROM TB_StockMMrec
						WHERE PONO = 'PO202106270001' )

--2. ���ֹ�ȣ�� ����ǰ���ڵ带 ������ ������ ǰ�񸶽��Ϳ��� ��ȸ.
    SELECT ITEMCODE,
		   ITEMNAME,
		   ITEMTYPE,
		   CARTYPE
	FROM TB_ItemMaster
	WHERE ITEMCODE <> ( SELECT ITEMCODE
						  FROM TB_StockMMrec
					 	 WHERE PONO = 'PO202106270001' )

--3. �԰� �� ǰ���ڵ� ������ �ִ� ������ ǰ���ڵ� ������ ǰ�񸶽��Ϳ��� ��ȸ
    SELECT ITEMCODE,
		   ITEMNAME,
		   ITEMTYPE,
		   CARTYPE
	FROM TB_ItemMaster
	WHERE ITEMCODE IN ( SELECT ITEMCODE
						  FROM TB_StockMMrec
					 	 WHERE INOUTFLAG = 'I'
						   AND ITEMCODE IS NOT NULL)

--4. �������� �������� ǰ���ڵ带 ������ ǰ�񸶽��� ���� ��ȸ.
	SELECT ITEMCODE,
		   ITEMNAME,
		   ITEMTYPE,
		   CARTYPE
	FROM TB_ItemMaster
	WHERE ITEMCODE NOT IN ( SELECT ITEMCODE
					     	  FROM TB_StockMMrec
		     			 	 WHERE INOUTFLAG = 'I'
			    			   AND ITEMCODE IS NOT NULL)

--// WHERE���ǿ� '=' �����ڰ� ���� ��� �������� ������ ������ �� ����. (IN, NOT IN�� ����ؾ� ��.)


/****************** �ǽ� **********************
���� ���� �̷����̺��� ITEMCODE�� ���� ������ �ְ�, INOUTQTY�� 1000�� �̻��̸鼭 INOUTFLAG�� 'I'�� ITEMCODE ����Ʈ�� �����ϰ�
ITEMCODE ���� ������ ǰ�񸶽��Ϳ��� ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE �������� ��ȸ�غ�����. */

SELECT ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE
  FROM TB_ItemMaster
 WHERE ITEMCODE IN (SELECT DISTINCT ITEMCODE
							   FROM TB_StockMMrec
				              WHERE ITEMCODE IS NOT NULL
							    AND INOUTQTY >= 1000
							    AND INOUTFLAG = 'I' )


/* ���������� ��������

************** �ǽ� �ó����� *****************
TB_StockMM : ���� ��� ���̺�
TB_StockMMrec : ���� �����̷� ���̺�
TB_ItemMaster : ǰ�񸶽��� ���̺�(ǰ�񸮽�Ʈ ���̺�)

MATLOTNO : ���� LOT NO(������ ��������)

���� ��� ���̺��� STOCKQTY�� 3000���� ū MATLOTNO�� ������
���� ����̷� ���̺��� ITEMCODE�� ã�Ƴ���
�ش� ǰ�� ���� ������ ǰ�񸶽��Ϳ��� ��ȸ�Ͽ�
ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE �÷����� �˻��ϼ���. */

SELECT ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE
  FROM TB_ItemMaster
 WHERE ITEMCODE IN ( SELECT ITEMCODE
					  FROM TB_StockMMrec
					 WHERE MATLOTNO = (SELECT MATLOTNO
										 FROM TB_StockMM
										WHERE STOCKQTY > 3000))
-- 1. ���� ��� ���̺��� 3000������ ū LOTNO ã��
SELECT MATLOTNO
  FROM TB_StockMM
 WHERE STOCKQTY > 3000

 -- 2. ��� �̷� ���̺��� LOTNO�� �̷��� ��ȸ
 SELECT *
   FROM TB_StockMMrec
  WHERE MATLOTNO =  (SELECT MATLOTNO
					   FROM TB_StockMM
					  WHERE STOCKQTY > 3000)

-- 3. 2���� ��ȸ�� ǰ���� ������ ��ȸ.
 SELECT ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE
  FROM TB_ItemMaster
 WHERE ITEMCODE IN ( SELECT ITEMCODE
					  FROM TB_StockMMrec
					 WHERE MATLOTNO = (SELECT MATLOTNO
										 FROM TB_StockMM
										WHERE STOCKQTY > 3000))


/****************************************************************************/
-- ���������� ���� ������ ��ȸ ( SELECT�� )

/*
	���� ��� ���̺��� ITEMCODE, INDATE, MATLOTNO �÷��� �����͸� �˻��Ѱ��� ��������
	���� ��� �����̷� ���̺��� ���� ��� ���̺��� ��ȸ�� MATLOTNO �÷��� �����͸� �����ϰ�
	INOUTFLAG = 'OUT'�� �����͸� ������ INOUTDATE �÷��� ��ȸ�ϼ���. */
	
--[POINT 4]
SELECT A.ITEMCODE,
	   A.INDATE,
	   A.MATLOTNO,
	   (SELECT INOUTDATE
	      FROM TB_StockMMrec
		 WHERE MATLOTNO = A.MATLOTNO
		   AND INOUTFLAG = 'OUT') AS INDATE
FROM TB_StockMM A

--����ܰ�.
--1. 
SELECT ITEMCODE,
       INDATE,
       MATLOTNO
  FROM TB_StockMM

--2. 
SELECT INOUTDATE
  FROM TB_StockMMrec
 WHERE MATLOTNO = -- ����ܰ� 1���� ��ȸ�� MATLOTNO(9��)�� ���� �����Ͽ� ����.
   AND INOUTFLAG = 'OUT'

--3.
SELECT A.ITEMCODE,
	   A.INDATE,
	   A.MATLOTNO,
	   (SELECT INOUTDATE
	      FROM TB_StockMMrec
		 WHERE MATLOTNO = A.MATLOTNO
		   AND INOUTFLAG = 'OUT') AS INDATE
FROM TB_StockMM A
-- ����� �������� ����� �ϳ��� ���δ�.
-- ***** ����! ������ �Ǵ� ���̺� TB_StockMM���� 1�� ��ȸ ���� �� 
--			   SUB������ 9�� ����ǹǷ� �� 10���� �˻� ������ ����ȴ�. 



/***********************************************************************************
  �������� (FROM��)
  . FROM���� ���� ���̺� ��ġ�� ���̺� ����ó�� �ӽ� ���̺�� ������ �����͸� ������ �ۼ��� �� �ִ�. 
  . ������ �����͸� ���̺� �������� ����� �� �ִ�. 
  . ���̺��� �������� �ڿ��� �ݵ�� �ӽ����̺��� �̸��� �ο��ؾ� �Ѵ�. */

  SELECT *
  FROM (SELECT ITEMCODE,
               ITEMNAME,
               ITEMTYPE,
			   BASEUNIT
	     FROM TB_ItemMaster
	    WHERE ITEMTYPE = 'FERT') A


-- POINT 3�� �ǽ� �������� COUNT �����Լ��� �ѹ��� ����ؼ� ���� ����� ���� �������� �ۼ��ϱ�.
     SELECT INOUTDATE,
      	    WHCODE,
	  	    COUNT(*) AS CNT
       FROM TB_StockMMrec
      WHERE INOUTFLAG = 'I'
        AND INOUTQTY > 1000
   GROUP BY INOUTDATE, WHCODE
     HAVING COUNT(*) >= 2
   ORDER BY INOUTDATE ASC

-- ���� ����� HAVING�� ���� �ʰ� ���� ����� ������..
-- �����Լ��� �ѹ��� ����ϴ� ���.

-- 1. ��ü �������� ������� ����.
	SELECT INOUTDATE,
	       WHCODE,
	       COUNT(*) AS DATEPERWHCODE_CNT
	 FROM TB_StockMMrec
	WHERE INOUTFLAG = 'I'
      AND INOUTQTY > 1000
 GROUP BY INOUTDATE, WHCODE

-- 2. ����� ����� �ӽ����̺�� FROM���� ���������� ����Ͽ� ��ȸ.
SELECT * 
  FROM ( SELECT INOUTDATE,
	            WHCODE,
                COUNT(*) AS DATEPERWHCODE_CNT
           FROM TB_StockMMrec
          WHERE INOUTFLAG = 'I'
            AND INOUTQTY > 1000
       GROUP BY INOUTDATE, WHCODE) AS A
 WHERE DATEPERWHCODE_CNT >= 2
