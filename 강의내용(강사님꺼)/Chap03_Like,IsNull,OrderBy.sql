/* 1. LIKE      *****
   . �����͸� �����ϴ� �� ��ȸ
   . WHERE ���ǿ� �˻��ϰ��� �ϴ� �������� �Ϻ� �� �Է��Ͽ�
     �ش� ���� �� ������Ű�� ��� ������ �� ��ȸ ('%')
*/

-- ǰ�� ������ ���̺��� ITEMCODE �÷��� ������ �� 'E' �� ���Ե�
-- ������ �� ��� �˻� �ϼ���.

-- 1) ITEMCODE �� ������ �� E �� �����ϸ� ��ȸ
SELECT * 
  FROM TB_ItemMaster
 WHERE ITEMCODE LIKE '%E%'

 -- 2) ITEMCODE �� ������ �� E �� �����ϸ� ��ȸ.
SELECT * 
  FROM TB_ItemMaster
 WHERE ITEMCODE LIKE 'AA%'

 -- 3) ITEMCODE �� ������ �� E �� ������ ������ ��ȸ
 SELECT *
   FROM TB_ItemMaster
  WHERE ITEMCODE LIKE '%E'


/*****************************************************************************************
2. NULL  �� �ƴ� ������ ��ȸ �� NULL �� ������ ��ȸ (IS NULL, IS NOT NULL)
   NULL : ������ �� ���� ����ִ� ����, ����ü�� �־����� ���� ����.
*/

-- ǰ�񸶽��� ���̺��� MAXSTOCK �÷��� ������ �� NULL ó�� �� ���� ��� �˻�.
SELECT *
  FROM TB_ItemMaster
 WHERE MAXSTOCK IS NULL

-- ǰ�񸶽��� ���̺��� MAXSTOCK �÷��� ������ �� NULL �� �ƴ� ���� ��� �˻�.
SELECT * 
  FROM TB_ItemMaster
 WHERE MAXSTOCK IS NOT NULL

 /************* �ǽ� **********************
 ǰ�� ������ ���� 
 BOXSPEC �÷��� ������ �� '01' �� �����鼭 NULL ���°� �ƴ� 
 PLANTCODE, ITEMCODE, ITEMNAME, BOXSPEC  �÷��� ���� �˻� �ϼ���. 
 
 BOXSPEC : ������� �԰�
 */

SELECT *
  FROM TB_ItemMaster
 WHERE BOXSPEC IS NOT NULL
   AND BOXSPEC LIKE '%01'


/***********************************************************************************
 3. �˻� ��� �� ����. (ORDER BY , ASC, DESC)
  . ���̺��� �˻� �� ��� �� ���ǿ� ���� �����Ͽ� ��Ÿ����. 
  . ���� ������ ��� (ASC) �� ���.  * NULL ������ ���� �� ������ ��Ÿ����. 
  . ���� ������ ��� (DESC) �� ���

*/

-- ǰ�� ������ ���̺��� ITEMTYPE = 'HALB' �� (ǰ�� ������ ����ǰ) 
-- ITEMCODE, ITEMTYPE �÷��� �����͸� ITEMCODE �÷� ������ �������� ���������Ͽ� ��ȸ
  SELECT ITEMCODE ,
  	     ITEMTYPE
    FROM TB_ItemMaster
   WHERE ITEMTYPE = 'HALB'
ORDER BY ITEMCODE





/* ** ORDER BY ���� �÷��� �߰� �� ��� ���� ���� ���������� �켱 ������ ������. 
  ǰ�� ������ ���̺� ���� ITEMTYPE = 'HALB' �� 
  ITEMCODE,ITEMTYPE, WHCODE, BOXSPEC �÷��� 
  ITEMTYPE �� ���� ���ٸ� WHCODE ������, WHCODE ���� ���ٸ� BOXSPEC ������ ���� */

  SELECT ITEMCODE,
		 ITEMTYPE, 
		 WHCODE, 
		 BOXSPEC
    FROM TB_ItemMaster
   WHERE ITEMTYPE = 'HALB'
ORDER BY ITEMTYPE, WHCODE, BOXSPEC

-- * ��ȸ ��� ���� �÷� �� ������ ���� ���� �߰��ϱ�. 
-- �����͸� Ȯ�� �� �� ������ ORDER BY  �� ������� ���� �ȴ�. 


-- ǰ�񸶽��� ���̺� ���� ITEMTYPE = 'HALB' �� 
-- ITEMTYPE, WHCODE, BOXSPEC �÷� �� 
-- ITEMCODE ������� �����϶�. 

SELECT ITEMTYPE
      ,WHCODE
	  ,BOXSPEC
  FROM TB_ItemMaster
 WHERE ITEMTYPE = 'HALB'
ORDER BY ITEMCODE 



-- ** �� ������ ���� �ϱ� DESC
-- ǰ�� ������ ���̺���  ITEMCODE, ITEMNAME �÷��� ��ȸ �ϴµ�
-- ITEMCODE �÷������� �������� (��������) ��ȸ 
  SELECT * 
    FROM TB_ItemMaster
ORDER BY ITEMCODE DESC


/* �������� �� ���� ���� �� ȥ�� �Ͽ� ����ϴ� ��
   
   ǰ�񸶽��� ���̺� �� �ִ� ��� ������ �߿� 
   ITEMTYPE �� ������������ , WHCDOE �� ������������ , INSPFLAG �� ������������ ����. */

  SELECT ITEMCODE, 
         ITEMTYPE, 
		 WHCODE, 
		 INSPFLAG
    FROM TB_ItemMaster
ORDER BY ITEMTYPE ASC, WHCODE DESC, INSPFLAG


/****** �ǽ� ********
 ǰ�� ������ ���̺� ���� 
 MATERIALGRADE �÷��� ���� NULL �̰� 
 CARTYPE �÷��� ���� MD, RB, TL �� �ƴϸ鼭
 ITEMCODE �÷� ���� '001' �� �����ϰ�
 UNITCOST �÷� ���� 0 �� ���� 
 ��� �÷� �� 
 ITEMNAME �÷����� ��������, WHCODE �÷����� �������� ���� �˻� �ϼ���. 
 
 MATERIALGRADE : ���� ���. 
 CARTYPE  : ���� 
 UNITCOST : �ܰ�
 ITEMCODE : ǰ�� 
 ITEMNAME : ǰ��
 */
 
 SELECT * 
   FROM TB_ItemMaster
  WHERE MATERIALGRADE IS NULL
    AND CARTYPE NOT IN ('MD','RB','TL')
	AND UNITCOST = 0
    AND ITEMCODE LIKE '%001%'
ORDER BY ITEMNAME DESC, WHCODE ASC


/********************************************************************************************
4. �˻��� ������ �߿� ��ȸ�� ���� ���� N ���� �����͸� ǥ��. TOP
*/


-- ǰ�� ���������̺� ����  �ִ� ���緮�� ���� �������ְ�
-- �ִ� ���緮�� ���� ū ǰ���� �ڵ� �� �˻��ϼ���
  SELECT TOP(1) ITEMCODE
    FROM TB_ItemMaster
   WHERE MAXSTOCK IS NOT NULL
ORDER BY MAXSTOCK DESC


-- ���� N ���� �����͸� ��ȸ 
   SELECT TOP(10) *
     FROM TB_ItemMaster
 ORDER BY MAXSTOCK DESC

 
 /******* �ǽ� ***************************
   TB_StockMMrec (���� ���� �̷� ���̺�)
   INOUTFLAG : �԰� I, ��� O
   INOUTQTY : ��/�� ����. 

   TB_StockMMrec ���̺��� INOUTFLAG �� 'O' �� ������ ��.
   INOUTDATE �� ���� �ֱ� ���� 10�� ǰ����
   ITEMCODE, INOUTQTY �� ��ȸ�ϼ���.
     * ���� ��� �̷� �� ���� �ֱ� ��� 10���� �̷��� ǰ�� �� ���� */
   SELECT TOP(10) ITEMCODE
				 ,INOUTQTY
     FROM TB_StockMMrec
    WHERE INOUTFLAG = 'O' 
 ORDER BY INOUTDATE DESC    



