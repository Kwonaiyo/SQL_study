/* 하위 쿼리 (서브 쿼리) ******* SUB QUERY
  - 쿼리 안에 쿼리
  - 일반적으로 SELECT 절
			     FROM 절
			    WHERE 절
	에 사용된다. 
	
	장점 : SQL 구문 안에서 유연하게 다른 SQL 구문을 만들어
	       사용 할 수 있다. 
	단점 : 쿼리가 복잡해진다. 


	1. 서브쿼리는 괄호 로 감싸서 사용
	2. 서브쿼리는 단일 행 또는 복수 행 비교 연산자와 함께 사용 가능
	3. 서브쿼리 에서는 ORDER BY 구문은 사용할 수 없다. 
*/



/***********************************************************************************/
-- 서브 쿼리를 통한 데이터 조회  (WHERE 절)
/* TB_StockMMrec : 자재 재고 입출고 이력
   TB_ItemMaster : 품목 의 리스트 (품목마스터)
   PONO          : 자재를 발주한 번호

   자재 재고 입출고 이력 테이블에서 PONO 가 'PO202106270001' 인 ITEMCODE
   의 정보를 
   품목 마스터 테이블에서 조회 하여 
   ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE 컬럼으로 데이터를 검색 */

-- 1. 발주 번호 의 단일품목 코드 에 대한 내용 품목 마스터 에서 조회
SELECT ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE 
  FROM TB_ItemMaster
 WHERE ITEMCODE = (SELECT ITEMCODE
					 FROM TB_StockMMrec
					WHERE PONO = 'PO202106270001')

-- 2. 발주 번호 의 단일품목 코드 를 제외한 내용 품목 마스터 에서 조회
SELECT ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE 
  FROM TB_ItemMaster
 WHERE ITEMCODE <> (SELECT ITEMCODE
					 FROM TB_StockMMrec
					WHERE PONO = 'PO202106270001')
					
-- 3. 입고 및 품목 코드 정보가 있는 복수의 품목 코드 정보를 품목 마스터 에서 조회
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


 -- 4. 하위쿼리 복수개의 품목코드를 제외한 품목 마스터 내용 조회.
 SELECT ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE 
  FROM TB_ItemMaster
 WHERE ITEMCODE NOT IN (SELECT DISTINCT ITEMCODE
					 FROM TB_StockMMrec
					WHERE INOUTFLAG = 'I'
					  AND ITEMCODE IS NOT NULL)

-- WHERE 조건 에 '=' 연산자 가 있을경우 복수개의 조건을 대입 할 수 없다. (IN, NNOT IN )

/****** 실습 ********
TB_StockMMrec : 자재 입출 이력 테이블
ITEMCODE : 품목 코드 
INOUTQTY : 입출 수량
CARTYPE  : 차종
INOUTFLAG : 입/출 구분 (I : 입고) 

자재 입출이력 테이블 에서 
ITEMCODE 가 값을 가지고 있고 
INOUTQTY 가 1000 개 이상이면서 
INOUTFLAG 가 I 인 ITEMCODE 리스트 를 병합하고
ITEMCODE 관련 정보를 품목 마스터 에서 
ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE 내역으로 조회 해 보세요 */
SELECT ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE
  FROM TB_ItemMaster
 WHERE ITEMCODE IN (SELECT DISTINCT ITEMCODE
				      FROM TB_StockMMrec
					 WHERE INOUTFLAG = 'I'
					   AND ITEMCODE IS NOT NULL
					   AND INOUTQTY >= 1000)


/* 하위 쿼리의 하위 쿼리

***** 실습 시나리오 *****
TB_STOCKMM : 자재 재고 테이블
TB_StockMMrec : 자재 입출 이력 테이블
TB_ITEMMASTER : 품목 마스터 (품목 리스트)

MATLOTNO : 자재 LOT NO (수량의 묶음단위)

자재 재고 테이블에서 STOCKQTY 가 3000 보다 큰 MATLOTNO 의 값으로 
자재 재고 이력 테이블 에서 ITEMCODE 를 찾아내고 해당 품목에 대한 정보를
품목 마스터 에서 조회 하여 
ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE 컬럼으로 검색 

*/


-- 1. 자재 재고 테이블에서 3000개 보다 큰 LOTNO 찾기
SELECT MATLOTNO 
  FROM TB_StockMM 
 WHERE STOCKQTY > 3000

-- 2. 재고 이력 테이블 에서 LOTNO 의 이력을 조회
SELECT * 
  FROM TB_StockMMrec
 WHERE MATLOTNO = (SELECT MATLOTNO 
				     FROM TB_StockMM 
				    WHERE STOCKQTY > 3000)

-- 3. 2 에서 조회 된 품목의 정보를 조회.
SELECT ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE
  FROM TB_ItemMaster
 WHERE ITEMCODE IN ( SELECT ITEMCODE 
					   FROM TB_StockMMrec
					  WHERE MATLOTNO = (SELECT MATLOTNO 
					 				     FROM TB_StockMM 
					 				    WHERE STOCKQTY > 3000))






/***********************************************************************************/
-- 서브 쿼리를 통한 데이터 조회  (SELECT 절)

/*
   자재 재고 테이블에서 ITEMCODE, INDATE, MATLOTNO 컬럼의 데이터 를 검색 하고 
   자재 재고 입출 이력 테이블 에서 자재 재고 테이블에서 조회한 MATLOTNO 컬럼의 데이터를 포함하고 
   INOUTFLAG = 'OUT' 인 데이터를 가지는 INOUTDATE 컬럼을 조회.
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

-- 수행 단계
-- 1. 
SELECT ITEMCODE,
	   INDATE,
	   MATLOTNO
  FROM TB_StockMM


-- 2. 수행 로직. SUB 쿼리
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
 


 --3.수행 로직
 SELECT ITEMCODE,
	   INDATE,
	   MATLOTNO,
	   (SELECT INOUTDATE
	      FROM TB_StockMMrec 
		 WHERE MATLOTNO  = A.MATLOTNO 
		  ) AS INDATE
  FROM TB_StockMM A
--결과 에 서브쿼리 결과를 하나씩 붙인다. 
-- ***** 주의 : 기준 이 되는 테이블 TB_StockMM 에서 1번 조회 실행 후 
--              SUB 쿼리 가 9번 실행 되므로 총 10번의 검색 연산이 실행된다. 



/********************************************************************************************
-- 하위 쿼리 (FROM) 
  . FROM 절에 오는 테이블 위치에 테이블 형식처럼 임시 테이블로 가공되 데이터를 쿼리로 작성 할수 있다. 
  . 가공한 데이터를 테이블 형식으로 사용 할 수 있다. 
  . 테이블의 묶음단위 뒤에는 반드시 임시테이블의 이름을 부여 해야 한다.  */


  SELECT WHCODE FROM TB_ItemMaster

 SELECT WHCODE
   FROM (SELECT ITEMCODE,
		        ITEMNAME,
        	    ITEMTYPE,
        	    BASEUNIT
           FROM TB_ItemMaster
          WHERE ITEMTYPE = 'FERT') TB_TEMP


-- POINT 3 의 실습 내용으로 
-- COUNT 집계 함수 를 한번만 사용해서 같은 결과를 내는 서브쿼리 작성
SELECT INOUTDATE
      ,WHCODE
	  ,COUNT(*)    AS CNT
  FROM TB_StockMMrec 
 WHERE INOUTFLAG = 'I'
   AND INOUTQTY > 1000
GROUP BY INOUTDATE, WHCODE
  HAVING COUNT(*) >= 2
ORDER BY INOUTDATE
  
-- 위의 결과 를 HAVING 을 쓰지 않고 같은 결과로 만들어 보기 
-- 집게함수 를 한번만사용하는 방법
 

-- 1. 전체 데이터의 집계 수량 산출.
SELECT INOUTDATE, 
	   WHCODE,
	   COUNT(*) AS DATEPERWHCODE_CNT
  FROM TB_StockMMrec
 WHERE INOUTFLAG = 'I'
   AND INOUTQTY > 1000
GROUP BY INOUTDATE, WHCODE
   
-- 2. 산출된 결과 를 임시테이블로 FROM 절의 서브쿼리 로 사용하여 조회
SELECT *
  FROM (SELECT INOUTDATE, 
			   WHCODE,
	           COUNT(*) AS DATEPERWHCODE_CNT
		  FROM TB_StockMMrec
		 WHERE INOUTFLAG = 'I'
		   AND INOUTQTY > 1000
	  GROUP BY INOUTDATE, WHCODE) A
WHERE DATEPERWHCODE_CNT >= 2