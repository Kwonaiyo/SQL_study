-- ���� ������ â�� ����� �����ͺ��̽� ����.
USE MyFirstDataBase

-- ������ F5 �Ǵ� ����� �ʷϻ� ȭ��ǥ(����) Ŭ��
-- �巡�׸� ���� �� ���� �� ������ �κи� ���� ����.

/*************************************************************************
- SELECT     *****
 . �����ͺ��̽� ���� ���̺��� ���ϴ� �����͸� �����ϴ� ��ɾ�. 
 . ���� �⺻���� SQL ���������� �����ͺ��̽� � �� �߿䵵�� ���� ���� �����̹Ƿ�
   �� �����Ұ�.

 SELECT [�÷��� �̸� �� ������ ����] 
   FROM [���̺��̸�]
  WHERE [����]
**************************************************************************/
-- 1. �⺻���� SELECT ����
-- 1) SELECT �θ� ����.
   SELECT 87
    
-- 2) SELECT FROM ���� ����
SELECT * FROM TB_ITEMMASTER
-- * : �ֽ��͸���ũ ���̺��� ��� �÷��� ������ ����.

/**************************************************************************
2. Ư�� �÷��� ������ �� ��ȸ
  . TB_ITEMMASTER ���̺��� ITEMCODE(ǰ��), ITEMNAME(ǰ��) �� ������ ��� 
    �˻��Ͻÿ�. */

	SELECT ITEMCODE,
	       ITEMNAME 
      FROM TB_ITEMMASTER;

/********************************************** �ǽ� ***********************
TB_ITEMMASTER ���̺��� 
ITEMCODE(ǰ��), WHCODE(â���ڵ�), BASEUNIT(����), MAKEDATE(�����Ͻ�) �÷��� ��ȸ�ϴ� ������ �ۼ��� ������.
*/

SELECT ITEMCODE
      ,WHCODE
	  ,BASEUNIT
	  ,MAKEDATE
  FROM TB_ITEMMASTER;


/****************************************************************************
2. ��Ī �ֱ�.
 - �÷� �Ǵ� ���̺� ��Ī�� �־� ������ �÷��� �̸����� �����Ͽ� ��ȸ �ϴ� ���.
 - AS ��� Ű����� ���� �� �� ������ �����ϰ� �������ε� ǥ�� ����. 


 ITECODE �÷��� IT_CD �� ��Ÿ����,
 ITEMNAME �÷��� IT_NM �� ��Ÿ����.
*/

SELECT ITEMCODE AS IT_CD,
       ITEMNAME IT_NM
  FROM TB_ITEMMASTER 



/************************************************************************************
3. WHERE ��. 
  . �˻� ������ �Է� �Ͽ� ���ϴ� �����͸� ��ȸ �Ѵ�. 

  . SQL ���� ���ڿ��� ' Ȭ����ǥ �� �����Ѵ�.

*/

-- 3-1 ǰ�񸶽���(TB_ITEMMASTER) ���̺��� 
-- BASEUNIT(����) �� 'EA' �� ��� �÷��� �˻�. 

SELECT *
  FROM TB_ITEMMASTER
 WHERE BASEUNIT = 'EA'
 

 --3-2 ǰ�񸶽��� ���̺��� 
 -- BASEUNIT(����) �� EA �ΰͰ� ITEMTYPE(ǰ������) �� HALB ��
 -- ��� �÷��� �˻��ϼ���.

SELECT * 
  FROM TB_ITEMMASTER
 WHERE BASEUNIT = 'EA'
   AND ITEMTYPE = 'HALB'


-- 3-3 ǰ�� ������ ���̺� ���� 
-- ITEMTYPE(ǰ������) �� HALB �Ǵ� OM �� ��� �÷��� ������ ����
-- �˻��ϼ���.
SELECT * 
  FROM TB_ItemMaster
 WHERE ITEMTYPE = 'HALB'
    OR ITEMTYPE = 'OM'

SELECT *
  FROM TB_ITEMMASTER
 WHERE (ITEMTYPE = 'HALB' OR ITEMTYPE = 'OM')


 
/*********** ���� ********
�÷��� �ٸ� �˻� ���ǿ� OR �� ���Ǵ� ���
BASEUNIT �� EA �� �ƴϸ� ITEMTYPE �� HALB �� �ƴ� ������ �� ��ȸ�� �� 
�ִ�.
*/
SELECT * 
  FROM TB_ITEMMASTER
 WHERE BASEUNIT  = 'EA'
    OR ITEMTYPE = 'HALB'



/************** �ǽ� ******************************
ǰ�� ������ ���̺��� 
WHCDOE(â���ڵ�) �� 'WH003' �̰� 'WH008' �� ������ ��
BASEUNIT(����) �� 'KG' �� 
ITEMCODE(ǰ��), WHCODE(â��) , BASEUNIT(����)
�÷��� ��ȸ �ϼ��� */ 
SELECT ITEMCODE,
       WHCODE,  
	   BASEUNIT
 FROM TB_ITEMMASTER
WHERE BASEUNIT = 'KG'
  AND (WHCODE = 'WH003' OR WHCODE = 'WH008')



/*********************************************************************
4. ���� �������� ��� 
  . �˻� ���ǿ� ���� �� ����(����) �� ���� ������ �Է��Ͽ� ���ϴ� ����� ��ȸ
    ������ �Ⱓ�̳� ���ڸ� �˻� ������ ������ ���� ���ص� �˻� �����ϰ� 
	�ð� ������ �˻��� ���� �ϴ�.
*/

 -- ** �Ⱓ ���� ���� �˻�
 -- Ư�� ���� �������� �Ⱓ�� ���� �Ǿ��ִ� ���� ���۰� ���� �� �������� �˻��Ҽ��ִ�.
 -- EDITDATE : ����ڰ� �����ϴ� �Ͻ�

 SELECT *
   FROM TB_ItemMaster
  WHERE EDITDATE >= '2020-08-01'
    AND EDITDATE <= '2023-01-01'


-- �� �� �Է� �� ���� ����
-- MAXSTOCK : ǰ�� ���� �ִ� ���� ��(�ִ� ���)
 SELECT * 
   FROM TB_ItemMaster
  WHERE MAXSTOCK > 10
    AND MAXSTOCK <= 20;

SELECT * 
   FROM TB_ItemMaster
  WHERE MAXSTOCK > '10'
    AND MAXSTOCK <= '20';



-- ** ���� ���� ���� �˻�
-- INSPFLAG : ���԰˻� ���� 
SELECT *
  FROM TB_ItemMaster
 WHERE INSPFLAG = 'U'

-- �˻� ���ΰ� U �� �ƴѰ��� ��� �˻�
SELECT *
  FROM TB_ItemMaster 
 WHERE INSPFLAG <> 'U'

SELECT * 
  FROM TB_ItemMaster
 WHERE MAXSTOCK <> 10


-- ** INSPFLAG �÷� �� B ���� U ���� �� ���� ���� ������ ��ȸ
SELECT * 
  FROM TB_ItemMaster
 WHERE INSPFLAG > 'A'
   AND INSPFLAG <= 'U'
   
-- ***** BETWEEN ���� ������ ��.
-- * �ʰ� �� �̸� ������ ���� �� �� ����. 
-- ǰ�� ������ ���̺� ���� MAXSTOCK �� 10 �̻� 20���� �� ������ �� ��� �˻�
SELECT *  
  FROM TB_ItemMaster
 WHERE MAXSTOCK BETWEEN 10 AND 20


 /** �ǽ� **

WHCODE : â�� �ڵ� ,  UNITCOST : �ܰ�,  INSPFLAG : �˻翩�� (I : �˻�)
PLANTCODE : �����ڵ� 


ǰ�� ������ ���̺� ���� 
WHCODE �� WH002 ~ WH005 �̸�
UNITCOST �� 1000 �� �ʰ��ϴ� ���� ������ 
INSPFLAG �� I �� �ƴ� ������ ����
PLANTCODE, ITEMCODE, WHCODE, UNITCOST, INSPFLAG �÷��� ��ȸ �ϼ���. */

SELECT PLANTCODE,
	   ITEMCODE,
	   UNITCOST,
	   INSPFLAG
  FROM TB_ITEMmaster
 WHERE WHCODE BETWEEN 'WH002' AND 'WH005'
   AND UNITCOST > 1000
   AND INSPFLAG <> 'I'



/**************************************************************************************
 5. Ư�� �÷� �˻� ���� N ���� �����Ͽ� ��ȸ (IN , NOT IN)  �󵵼� ***
   - Ư�� �÷��� �����ϰ� �ִ� ������ �� �˻��ϰ��� �ϴ� ������ ������ ���. 
*/

/*
	ǰ�� ������ ���̺� ���� 
	ITEMCODE �� ITEMTYPE , MAXSTOCK �÷��� ��ȸ �ϴµ�.
	MAXSTOCK �� ���� 1 �̻� 3000 ������ �� �߿� 
	ITEMTYPE �� 'FERT' 'HALB' �� ������ �� ��ȸ

	FERT : ����ǰ , HALB : ����ǰ.
*/

SELECT ITEMCODE, 
	   ITEMTYPE, 
	   MAXSTOCK
  FROM TB_ItemMaster
 WHERE MAXSTOCK BETWEEN 1 AND 3000
   AND ITEMTYPE IN ('FERT','HALB') -- (ITEMTYPE = 'FERT' OR ITEMTYPE = 'HALB')


/* �÷��� ������ �� Ư�� �����͸� ���� �ϰ� �˻� NOT IN

	ǰ�� ������ ���� 
	ITEMCODE, ITEMTYPE, MAXSTOCK �÷��� ��ȸ�ϴµ�
	MAXSTOCK �� ���� 1 �̻� 3000 ���� �̰� 
	ITETTPYE �� 'FERT' ,'HALB' �� �ƴѵ����͸� ��ȸ
*/
SELECT * 
  FROM TB_ItemMaster
 WHERE MAXSTOCK BETWEEN 1 AND 3000
   AND ITEMTYPE NOT IN ('FERT','HALB') -- AND (ITEMTYPE <> 'FERT' AND ITETYPE <> 'HALB')



/* �ǽ� *****************************
  ǰ�� ������ ���̺� ���� 
  CARTYPE �÷��� ���� TL, LM �̰�
  WHCODE �÷��� ���� WH004 ~ WH007 ���̿� �ִ°� ��
  ITEMTYPE �� HALB �� �ƴ� 
  ITEMCODE, ITENAME, ITEMTYPE, WHCODE, CARTYPE �÷��� ������ �� ��� �˻��ϼ���.

  CARTYPE : ����
  WHCODE  : â�� 
*/
SELECT ITEMCODE, 
	   ITEMNAME, 
	   ITEMTYPE, 
	   WHCODE, 
	   CARTYPE 
  FROM TB_ItemMaster
 WHERE CARTYPE IN ('TL','LM')
   AND WHCODE BETWEEN 'WH004' AND 'WH007'
   AND ITEMTYPE <> 'HALB'
   

