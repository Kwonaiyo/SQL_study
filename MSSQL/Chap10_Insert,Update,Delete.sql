/* INSERT
	- ���̺� �����͸� ���
	- INSERT�� �⺻ ����
	  . INSERT INTO <���̺�> (���̸�1, ���̸�2, ...) VALUES (��1, ��2, ...) 
*/

-- 1-1. �����̺� �����͸� ����غ���.
SELECT * FROM T_Customer
INSERT INTO T_Customer (CUST_ID,   NAME,       PHONE)
			    VALUES (7,         '��â��',   '7777-7777')  -- * NULL�� ������� �ʴ� �÷����� ������ ���� �־����.

-- 1-2. ��� �÷��� �����͸� ����Ҷ��� �÷��� �̸��� ������ �� �ִ�.
INSERT INTO T_Customer VALUES(8, '��ȿ��', '1981', '����', '888-8888')

-- 1-3. ���̺��� ����.(���� �� �����͸� �����Ͽ� �ű� ���̺� ����)
SELECT * INTO T_CUSTOMER2 FROM T_Customer

-- 1-5 SELECT�� ���� �ټ��� ������ ���.
INSERT INTO T_CUSTOMER2 (CUST_ID,	NAME,	BIRTH,	ADDRESS)
				  SELECT CUST_ID,   NAME,   BIRTH,  ADDRESS
				    FROM T_Customer
				   WHERE CUST_ID > 3

-- 1-6 ������ ���� ���
DECLARE @LA_NAME VARCHAR(10) = '�ҷ�'
INSERT INTO T_CUSTOMER2(CUST_ID, NAME) VALUES (20, @LA_NAME)

-- 1-7 ������ ���� ���2
DECLARE @LS_NAME2 VARCHAR(10) = 'TTTT'
INSERT INTO T_CUSTOMER2 (CUST_ID, NAME,		 BIRTH, ADDRESS)
				  SELECT CUST_ID, @LS_NAME2, BIRTH, ADDRESS
					FROM T_Customer
				   WHERE CUST_ID <=3

/******** UPDATE
  - ���̺��� �����͸� ����
  - UPDATE�� �⺻ ����
  - UPDATE <���̺�>
       SET ���̸�1 = ��1,
	       ���̸�2 = ��2,
		   ���̸�3 = ��3
	 WHERE [����]
*/
	
-- ����� �ܰ��� �����ؾ� �Ǵ� ���� ������ .. 
	UPDATE T_Fruit
	   SET PRICE = 2500
	 WHERE FRUIT = '���'

SELECT * FROM T_Fruit

-- ���ڸ� ���ϱ�
-- ��� ������ ������ ���纸�� 500�� �λ��� ���.
UPDATE T_Fruit
   SET PRICE += 500


UPDATE T_Fruit
   SET PRICE = NULL
 WHERE FRUIT = '���'


/****************** DELETE
���̺��� ���� �����͸� ����
*/

SELECT * FROM T_CUSTOMER2

DELETE T_CUSTOMER2
 WHERE CUST_ID = 18

DELETE T_CUSTOMER2
 WHERE CUST_ID BETWEEN 10 AND 15


/*************** DELETE�� UPDATE�� ������ �ʼ��� Ȯ���ؾ� �Ѵ�!! **************/


-- ���� �����͸� �����ع����� ���?
-- ��� �����͸� �̿��ؼ� �����ϴ� ����ۿ� ���� .. ��� �����Ͱ� ���ٸ�?.....

-- �׷��ٸ� DELETE, UPDATE, INSERT�� �̸� �����غ��� Ȯ���� �� ������ �� �ִ� ����� ������? --> Ʈ�����(TRANSACTION)


/************* Ʈ����� ******************
  . Ʈ����� (TRANSACTION)
    - ������ ���� ���� ���� �Ǵ� ���� (BEGIN TRAN, COMMIT, ROLLBACK)
	- �������� �ϰ���
	  . ������ ������ �߻��ϴ� �������� 10���� �����Ͱ� ����(INSERT, UPDATE, DELETE)�ɶ�
	    �߰��� 5��°���� ������ �߻��Ͽ� Ʈ������� �������� ���Ұ��.
	- Ʈ������� ������(�ݸ���)
	  . �ϳ��� Ʈ������� ����ǰ� ������ �Ǵٸ� Ʈ������� ������ �� ����.

	  BEGIN TRAN
	    rollback		-> begin tran�� ���󺹱�.
	      commit		-> begin tran�� ����.
*/

BEGIN TRAN
DELETE T_CUSTOMER2

SELECT * FROM T_CUSTOMER2 --> T_CUSTOMER2 ���̺��� ���� ���ư���!
rollback --> �����͸� �ٽ� �����..

SELECT * FROM T_CUSTOMER2 --> �����Ͱ� �ٽ� ��Ƴ���.
---------
BEGIN TRAN
DELETE T_CUSTOMER2
 WHERE CUST_ID < 10			--> CUST_ID�� 10���� ���� �����͸� ������� ��.

SELECT * FROM T_CUSTOMER2   --> ���������� �Ϸ���� Ȯ��
COMMIT						--> ���� ����.

-->> BEGIN TRAN : rollback�̳� COMMIT�� ���ö����� �����͸� ����� �ִ�.
-->> ���� rollback�̳� COMMIT�� ���ͼ� Ʈ������� ���� �Ϸ�ɶ����� T_CUSTOMER2�� ���̺��� �ǵ帱 �� ����.(�ٸ� Ʈ������� ���� �Ұ�)
