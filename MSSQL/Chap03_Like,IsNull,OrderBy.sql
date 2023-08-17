/* 1. LIKE		-	�� �� ����(*****)
    . �����͸� �����ϴ� �� ��ȸ
	. WHERE ���ǿ� �˻��ϰ��� �ϴ� �������� �Ϻθ� �Է��Ͽ�
	. �ش� ������ ������Ű�� ��� �����͸� ��ȸ. ('%')
*/

-- ǰ�񸶽��� ���̺��� ITEMCODE �÷��� ������ �� 'E'�� ���Ե� �����͸� ��� �˻��ϼ���.

-- 1) ITEMCODE�� �����Ͱ� 'E'�� �����ϸ� ��ȸ...
	SELECT *
	  FROM TB_ItemMaster
	 WHERE ITEMCODE LIKE '%E%'

-- 2) ITEMCODE�� �����Ͱ� 'E'�� �����ϸ� ��ȸ...
	SELECT *
	  FROM TB_ItemMaster
	 WHERE ITEMCODE LIKE 'E%' 

-- 3) ITEMCODE�� �����Ͱ� 'E'�� ������ ��ȸ..
	 SELECT *
	   FROM TB_ItemMaster
	  WHERE ITEMCODE LIKE '%E'			--> %�� ���ڿ��� *�� ���� �����ε�

/*********************************************************************************
2. NULL�� �ƴ� ������ ��ȸ �� NULL�� ������ ��ȸ (IS NULL, IS NOT NULL)
   NULL : �����Ͱ� ���� ����ִ� ����, �� ��ü�� �־����� ���� ����
*/

-- ǰ�񸶽��� ���̺��� MAXSTOCK �÷��� �����Ͱ� NULL ó���� ���� ��� �˻��ϱ�
	SELECT *
	  FROM TB_ItemMaster
	 WHERE MAXSTOCK IS NULL

-- ǰ�񸶽��� ���̺��� MAXSTOCK �÷��� �����Ͱ� NULL ó������ ���� ���� ��� �˻��ϱ�
	SELECT *
	  FROM TB_ItemMaster
	 WHERE MAXSTOCK IS NOT NULL


/***************************** �ǽ� ************************************************
ǰ�񸶽��Ϳ���
BOXSPEC �÷��� �����Ͱ� '01'�� �����鼭 NULL�� �ƴ�
PLANTCODE, ITEMCODE, ITEMNAME, BOXSPEC �÷��� ���� �˻��ϼ���.

BOXSPEC : ������� �԰�, 
*/
	SELECT PLANTCODE,
		   ITEMCODE,
		   ITEMNAME,
		   BOXSPEC
	  FROM TB_ItemMaster
	 WHERE BOXSPEC LIKE '%01' AND BOXSPEC IS NOT NULL


/*************************************************************************************
3. �˻� ����� ����(ORDER BY, ASC, DESC)
 . ���̺��� �˻��� ����� ���ǿ� ���� �����Ͽ� ��Ÿ����.
 . �������� : ASC		--	NULL ������ ���� �ֻ����� ��Ÿ����.
 . �������� : DESC
	* default ���� ASC
*/

-- ǰ�񸶽��� ���̺��� ITEMTYPE = 'HALB'�� ( ǰ�� ������ ����ǰ)
-- ITEMCODE, ITEMTYPE �÷��� �����͸� ITEMCODE �÷� ������ �������� ������������ ��ȸ�ϼ���.
	  SELECT ITEMCODE,
	  	     ITEMNAME,
			 ITEMTYPE
	    FROM TB_ItemMaster
	   WHERE ITEMTYPE = 'HALB'
	ORDER BY ITEMCODE ASC 



/** ORDER BY���� �÷��� �߰��� ��� ���ʺ��� ���������� �켱������ ������. 	 
    ǰ�񸶽��� ���̺��� ITEMTYPE = 'HALB'��
	ITEMCODE, ITEMTYPE, WHCODE, BOXSPEC �÷��� 
	ITEMTYPE�� ���� ���ٸ� WHCODE ������, WHCODE���� ���ٸ� BOXSPEC ������ �����ϼ���. *//
	SELECT ITEMCODE,
		   ITEMTYPE,
		   WHCODE,
		   BOXSPEC
	  FROM TB_ItemMaster
	 WHERE ITEMTYPE = 'HALB'
  ORDER BY ITEMTYPE, WHCODE, BOXSPEC
  
/* ��ȸ��� ���� �÷��� ������ �������� �߰��ϱ�.
�����͸� Ȯ���Ҽ��� ������ ORDER BY�� ������� ���ĵȴ�. 

ǰ�񸶽��� ���̺��� ITEMTYPE = 'HALB'��
ITEMTYPE, WHCODE , BOXSPEC �÷���
ITEMCODE ������� �����ϼ���. */
   SELECT ITEMTYPE,
  	      WHCODE,
  	      BOXSPEC
     FROM TB_ItemMaster
    WHERE ITEMTYPE = 'HALB'
 ORDER BY ITEMCODE
 

 /** �������� �����ϱ�
  ǰ�񸶽��� ���̺��� ITEMCODE, ITEMNAME �÷��� ��ȸ�ϴµ�
  ITEMCODE �÷� �����͸� �������� ��������(��������) �����ϼ���.
*/
    SELECT *
      FROM TB_ItemMaster
  ORDER BY ITEMCODE DESC


/*���������� ���������� ȥ���Ͽ� ����ϴ� ��
  ǰ�񸶽��� ���̺� �ִ� ��� �������߿�,
  ITEMTYPE�� ������������, WHCODE�� ������������, INSPFLAG�� ������������ �����ϼ���. */
    	SELECT ITEMCODE,
			   ITEMTYPE,
			   WHCODE,
			   INSPFLAG
    	  FROM TB_ItemMaster
	  ORDER BY ITEMTYPE ASC, WHCODE DESC, INSPFLAG


/*********************** �ǽ� ************************************
ǰ�񸶽��� ���̺��� 
MATERIALGRADE �÷��� ���� NULL�̰�,
CARTYPE �÷��� ���� MD, RB, TL�� �ƴϸ鼭
ITEMCODE �÷� ���� '001'�� �����ϰ� 
UNITCOST �÷� ���� 0�� ����
��� �÷���
ITEMNAME �÷����� ��������, WHCODE �÷����� ������������ ��ȸ�ϼ���.

MATERIALGRADE : ���� ���
CARTYPE : ����
UNITCOST : �ܰ�
ITEMCODE : ǰ��
ITEMNAME : ǰ��
*/
	     SELECT *
	       FROM TB_ItemMaster
	      WHERE MATERIALGRADE IS NULL
	        AND CARTYPE NOT IN ('MD', 'RB', 'TL')
	        AND ITEMCODE LIKE '%001%'
	        AND UNITCOST = 0
	   ORDER BY ITEMNAME DESC, WHCODE ASC



/*********************************************************************
4. �˻��� ������ �� ��ȸ�� ���� ���� n���� �����͸� ǥ��. TOP(n)
�����۸����� ���̺���, MAXSTOCK�� ���� NULL�� �ƴ� ��� �ڷ�� �� MAXSTOCK�� ���� ���� ū ������ 3���� �����Ͻÿ�.
-- (ǰ�� ���������̺� ���� �ִ� ���緮�� ���� �������ְ� �ִ� ���緮�� ���� ū ǰ���� �ڵ� �� �˻��ϼ���.)
*/
   SELECT TOP(3) *
     FROM TB_ItemMaster
    WHERE MAXSTOCK IS NOT NULL
 ORDER BY MAXSTOCK DESC

-- ���� 10���� �����͸� ��ȸ
	SELECT TOP(10) * 
	  FROM TB_ItemMaster 
  ORDER BY MAXSTOCK DESC

/*************************** �ǽ� ************************************
  T_StockMMrec : ���� ���� �̷� ���̺�
  INOUTFLAG : �԰�-I, ���-O
  INOUTQTY : �������
  
  T_StockMMrec ���̺��� INOUTFLAG�� 'O'�� ������ ��,
  INOUTDATE�� ���� �ֱٿ� �߻��� ���� 10�� ǰ����
  ITEMCODE, INOUTQTY�� ��ȸ�ϼ���
	* ���� ��� �̷� �� ���� �ֱ� ���� 10���� �̷��� ǰ��� ���� */
     SELECT TOP(10) ITEMCODE,
				    INOUTQTY
       FROM TB_StockMMrec
      WHERE INOUTFLAG = 'O'
   ORDER BY INOUTDATE DESC

