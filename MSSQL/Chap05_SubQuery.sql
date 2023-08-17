/******************* 서브쿼리(하위쿼리) ************
  - 쿼리 안의 쿼리..
  - 일반적으로 
		SELECT절 / FROM절 /	WHERE절
    에 사용된다. ( SELECT 서브쿼리, FROM 서브쿼리, WHERE 서브쿼리)

	장점 : SQL구문 안에서 유연하게 다른 SQL구문을 만들어 사용할 수 있다.
	단점 : 쿼리가 복잡해진다. 

	1. 서브쿼리는 괄호()로 감싸서 사용.
	2. 서브쿼리는 단일행 또는 복수행 비교 연산자와 함께 사용 가능.
	3. 서브쿼리에서 ORDER BY구문은 사용할 수 없다. 
*/

-- 서브쿼리를 통한 데이터 조회
/* TB_StockMMrec : 자재 재력 입출고 이력 테이블
   TB_ItemMaster : 품목의 리스트 관리 테이블(품목마스터 테이블)
   PONO			 : 자재 발주 번호

   자재 재고 입출고 이력 테이블에서 PONO가 'PO202106270001'인 ITEMCODE의 정보를
   품목마스터 테이블에서 조회하여 ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE 컬럼으로 데이터를 검색하세요. 
*/
--1. 발주번호의 단일품목코드에 대한 내용을 품목마스터에서 조회.
	SELECT ITEMCODE,
		   ITEMNAME,
		   ITEMTYPE,
		   CARTYPE
	FROM TB_ItemMaster
	WHERE ITEMCODE = ( SELECT ITEMCODE
						 FROM TB_StockMMrec
						WHERE PONO = 'PO202106270001' )

--2. 발주번호의 단일품목코드를 제외한 내용을 품목마스터에서 조회.
    SELECT ITEMCODE,
		   ITEMNAME,
		   ITEMTYPE,
		   CARTYPE
	FROM TB_ItemMaster
	WHERE ITEMCODE <> ( SELECT ITEMCODE
						  FROM TB_StockMMrec
					 	 WHERE PONO = 'PO202106270001' )

--3. 입고 및 품목코드 정보가 있는 복수의 품목코드 정보를 품목마스터에서 조회
    SELECT ITEMCODE,
		   ITEMNAME,
		   ITEMTYPE,
		   CARTYPE
	FROM TB_ItemMaster
	WHERE ITEMCODE IN ( SELECT ITEMCODE
						  FROM TB_StockMMrec
					 	 WHERE INOUTFLAG = 'I'
						   AND ITEMCODE IS NOT NULL)

--4. 하위쿼리 복수개의 품목코드를 제외한 품목마스터 내용 조회.
	SELECT ITEMCODE,
		   ITEMNAME,
		   ITEMTYPE,
		   CARTYPE
	FROM TB_ItemMaster
	WHERE ITEMCODE NOT IN ( SELECT ITEMCODE
					     	  FROM TB_StockMMrec
		     			 	 WHERE INOUTFLAG = 'I'
			    			   AND ITEMCODE IS NOT NULL)

--// WHERE조건에 '=' 연산자가 있을 경우 복수개의 조건을 대입할 수 없다. (IN, NOT IN을 사용해야 함.)


/****************** 실습 **********************
자재 입출 이력테이블에서 ITEMCODE가 값을 가지고 있고, INOUTQTY가 1000개 이상이면서 INOUTFLAG가 'I'인 ITEMCODE 리스트를 병합하고
ITEMCODE 관련 정보를 품목마스터에서 ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE 내역으로 조회해보세요. */

SELECT ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE
  FROM TB_ItemMaster
 WHERE ITEMCODE IN (SELECT DISTINCT ITEMCODE
							   FROM TB_StockMMrec
				              WHERE ITEMCODE IS NOT NULL
							    AND INOUTQTY >= 1000
							    AND INOUTFLAG = 'I' )


/* 하위쿼리의 하위쿼리

************** 실습 시나리오 *****************
TB_StockMM : 자재 재고 테이블
TB_StockMMrec : 자재 입출이력 테이블
TB_ItemMaster : 품목마스터 테이블(품목리스트 테이블)

MATLOTNO : 자재 LOT NO(수량의 묶음단위)

자재 재고 테이블에서 STOCKQTY가 3000보다 큰 MATLOTNO의 값으로
자재 재고이력 테이블에서 ITEMCODE를 찾아내고
해당 품목에 대한 정보를 품목마스터에서 조회하여
ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE 컬럼으로 검색하세요. */

SELECT ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE
  FROM TB_ItemMaster
 WHERE ITEMCODE IN ( SELECT ITEMCODE
					  FROM TB_StockMMrec
					 WHERE MATLOTNO = (SELECT MATLOTNO
										 FROM TB_StockMM
										WHERE STOCKQTY > 3000))
-- 1. 자재 재고 테이블에서 3000개보다 큰 LOTNO 찾기
SELECT MATLOTNO
  FROM TB_StockMM
 WHERE STOCKQTY > 3000

 -- 2. 재고 이력 테이블에서 LOTNO의 이력을 조회
 SELECT *
   FROM TB_StockMMrec
  WHERE MATLOTNO =  (SELECT MATLOTNO
					   FROM TB_StockMM
					  WHERE STOCKQTY > 3000)

-- 3. 2에서 조회된 품목의 정보를 조회.
 SELECT ITEMCODE, ITEMNAME, ITEMTYPE, CARTYPE
  FROM TB_ItemMaster
 WHERE ITEMCODE IN ( SELECT ITEMCODE
					  FROM TB_StockMMrec
					 WHERE MATLOTNO = (SELECT MATLOTNO
										 FROM TB_StockMM
										WHERE STOCKQTY > 3000))


/****************************************************************************/
-- 서브쿼리를 통한 데이터 조회 ( SELECT절 )

/*
	자재 재고 테이블에서 ITEMCODE, INDATE, MATLOTNO 컬럼의 데이터를 검색한것을 바탕으로
	자재 재고 입출이력 테이블에서 자재 재고 테이블에서 조회한 MATLOTNO 컬럼의 데이터를 포함하고
	INOUTFLAG = 'OUT'인 데이터를 가지는 INOUTDATE 컬럼을 조회하세요. */
	
--[POINT 4]
SELECT A.ITEMCODE,
	   A.INDATE,
	   A.MATLOTNO,
	   (SELECT INOUTDATE
	      FROM TB_StockMMrec
		 WHERE MATLOTNO = A.MATLOTNO
		   AND INOUTFLAG = 'OUT') AS INDATE
FROM TB_StockMM A

--수행단계.
--1. 
SELECT ITEMCODE,
       INDATE,
       MATLOTNO
  FROM TB_StockMM

--2. 
SELECT INOUTDATE
  FROM TB_StockMMrec
 WHERE MATLOTNO = -- 수행단계 1에서 조회된 MATLOTNO(9행)을 각각 대입하여 돈다.
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
-- 결과에 서브쿼리 결과를 하나씩 붙인다.
-- ***** 주의! 기준이 되는 테이블 TB_StockMM에서 1번 조회 실행 후 
--			   SUB쿼리가 9번 실행되므로 총 10번의 검색 연산이 실행된다. 



/***********************************************************************************
  하위쿼리 (FROM절)
  . FROM절에 오는 테이블 위치에 테이블 형식처럼 임시 테이블로 가공된 데이터를 쿼리로 작성할 수 있다. 
  . 가공한 데이터를 테이블 형식으로 사용할 수 있다. 
  . 테이블의 묶은단위 뒤에는 반드시 임시테이블의 이름을 부여해야 한다. */

  SELECT *
  FROM (SELECT ITEMCODE,
               ITEMNAME,
               ITEMTYPE,
			   BASEUNIT
	     FROM TB_ItemMaster
	    WHERE ITEMTYPE = 'FERT') A


-- POINT 3의 실습 내용으로 COUNT 집계함수를 한번만 사용해서 같은 결과를 내는 서브쿼리 작성하기.
     SELECT INOUTDATE,
      	    WHCODE,
	  	    COUNT(*) AS CNT
       FROM TB_StockMMrec
      WHERE INOUTFLAG = 'I'
        AND INOUTQTY > 1000
   GROUP BY INOUTDATE, WHCODE
     HAVING COUNT(*) >= 2
   ORDER BY INOUTDATE ASC

-- 위의 결과를 HAVING을 쓰지 않고 같은 결과로 만들어보기..
-- 집계함수를 한번만 사용하는 방법.

-- 1. 전체 데이터의 집계수량 산출.
	SELECT INOUTDATE,
	       WHCODE,
	       COUNT(*) AS DATEPERWHCODE_CNT
	 FROM TB_StockMMrec
	WHERE INOUTFLAG = 'I'
      AND INOUTQTY > 1000
 GROUP BY INOUTDATE, WHCODE

-- 2. 산출된 결과를 임시테이블로 FROM절의 서브쿼리로 사용하여 조회.
SELECT * 
  FROM ( SELECT INOUTDATE,
	            WHCODE,
                COUNT(*) AS DATEPERWHCODE_CNT
           FROM TB_StockMMrec
          WHERE INOUTFLAG = 'I'
            AND INOUTQTY > 1000
       GROUP BY INOUTDATE, WHCODE) AS A
 WHERE DATEPERWHCODE_CNT >= 2
