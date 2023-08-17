/* 1. LIKE		-	빈도 수 높음(*****)
    . 데이터를 포함하는 행 조회
	. WHERE 조건에 검색하고자 하는 데이터의 일부만 입력하여
	. 해당 조건을 만족시키는 모든 데이터를 조회. ('%')
*/

-- 품목마스터 테이블에서 ITEMCODE 컬럼의 데이터 중 'E'가 포함된 데이터를 모두 검색하세요.

-- 1) ITEMCODE의 데이터가 'E'를 포함하면 조회...
	SELECT *
	  FROM TB_ItemMaster
	 WHERE ITEMCODE LIKE '%E%'

-- 2) ITEMCODE의 데이터가 'E'로 시작하면 조회...
	SELECT *
	  FROM TB_ItemMaster
	 WHERE ITEMCODE LIKE 'E%' 

-- 3) ITEMCODE의 데이터가 'E'로 끝나면 조회..
	 SELECT *
	   FROM TB_ItemMaster
	  WHERE ITEMCODE LIKE '%E'			--> %는 문자에서 *과 같은 역할인듯

/*********************************************************************************
2. NULL이 아닌 데이터 조회 및 NULL인 데이터 조회 (IS NULL, IS NOT NULL)
   NULL : 데이터가 없는 비어있는 상태, 값 자체가 주어지지 않은 상태
*/

-- 품목마스터 테이블에서 MAXSTOCK 컬럼의 데이터가 NULL 처리된 행을 모두 검색하기
	SELECT *
	  FROM TB_ItemMaster
	 WHERE MAXSTOCK IS NULL

-- 품목마스터 테이블에서 MAXSTOCK 컬럼의 데이터가 NULL 처리되지 않은 행을 모두 검색하기
	SELECT *
	  FROM TB_ItemMaster
	 WHERE MAXSTOCK IS NOT NULL


/***************************** 실습 ************************************************
품목마스터에서
BOXSPEC 컬럼의 데이터가 '01'로 끝나면서 NULL이 아닌
PLANTCODE, ITEMCODE, ITEMNAME, BOXSPEC 컬럼의 행을 검색하세요.

BOXSPEC : 포장단위 규격, 
*/
	SELECT PLANTCODE,
		   ITEMCODE,
		   ITEMNAME,
		   BOXSPEC
	  FROM TB_ItemMaster
	 WHERE BOXSPEC LIKE '%01' AND BOXSPEC IS NOT NULL


/*************************************************************************************
3. 검색 결과를 정렬(ORDER BY, ASC, DESC)
 . 테이블에서 검색한 결과를 조건에 따라 정렬하여 나타낸다.
 . 오름차순 : ASC		--	NULL 상태의 값이 최상위에 나타난다.
 . 내림차순 : DESC
	* default 값은 ASC
*/

-- 품목마스터 테이블의 ITEMTYPE = 'HALB'인 ( 품목 유형이 반제품)
-- ITEMCODE, ITEMTYPE 컬럼의 데이터를 ITEMCODE 컬럼 데이터 기준으로 오름차순으로 조회하세요.
	  SELECT ITEMCODE,
	  	     ITEMNAME,
			 ITEMTYPE
	    FROM TB_ItemMaster
	   WHERE ITEMTYPE = 'HALB'
	ORDER BY ITEMCODE ASC 



/** ORDER BY절에 컬럼이 추가될 경우 왼쪽부터 순차적으로 우선순위를 가진다. 	 
    품목마스터 테이블에서 ITEMTYPE = 'HALB'인
	ITEMCODE, ITEMTYPE, WHCODE, BOXSPEC 컬럼을 
	ITEMTYPE의 값이 같다면 WHCODE 순서로, WHCODE값이 같다면 BOXSPEC 순서로 정렬하세요. *//
	SELECT ITEMCODE,
		   ITEMTYPE,
		   WHCODE,
		   BOXSPEC
	  FROM TB_ItemMaster
	 WHERE ITEMTYPE = 'HALB'
  ORDER BY ITEMTYPE, WHCODE, BOXSPEC
  
/* 조회대상에 없는 컬럼의 데이터 정렬조건 추가하기.
데이터를 확인할수는 없지만 ORDER BY의 순서대로 정렬된다. 

품목마스터 테이블에서 ITEMTYPE = 'HALB'인
ITEMTYPE, WHCODE , BOXSPEC 컬럼을
ITEMCODE 순서대로 정렬하세요. */
   SELECT ITEMTYPE,
  	      WHCODE,
  	      BOXSPEC
     FROM TB_ItemMaster
    WHERE ITEMTYPE = 'HALB'
 ORDER BY ITEMCODE
 

 /** 역순으로 정렬하기
  품목마스터 테이블에서 ITEMCODE, ITEMNAME 컬럼을 조회하는데
  ITEMCODE 컬럼 데이터를 기준으로 역순으로(내림차순) 정렬하세요.
*/
    SELECT *
      FROM TB_ItemMaster
  ORDER BY ITEMCODE DESC


/*오름차순과 내림차순을 혼용하여 사용하는 예
  품목마스터 테이블에 있는 모든 데이터중에,
  ITEMTYPE는 오름차순으로, WHCODE는 내림차순으로, INSPFLAG는 오름차순으로 정렬하세요. */
    	SELECT ITEMCODE,
			   ITEMTYPE,
			   WHCODE,
			   INSPFLAG
    	  FROM TB_ItemMaster
	  ORDER BY ITEMTYPE ASC, WHCODE DESC, INSPFLAG


/*********************** 실습 ************************************
품목마스터 테이블에서 
MATERIALGRADE 컬럼의 값이 NULL이고,
CARTYPE 컬럼의 값이 MD, RB, TL이 아니면서
ITEMCODE 컬럼 값이 '001'을 포함하고 
UNITCOST 컬럼 값이 0인 행의
모든 컬럼을
ITEMNAME 컬럼기준 내림차순, WHCODE 컬럼기준 오름차순으로 조회하세요.

MATERIALGRADE : 자재 등급
CARTYPE : 차종
UNITCOST : 단가
ITEMCODE : 품번
ITEMNAME : 품명
*/
	     SELECT *
	       FROM TB_ItemMaster
	      WHERE MATERIALGRADE IS NULL
	        AND CARTYPE NOT IN ('MD', 'RB', 'TL')
	        AND ITEMCODE LIKE '%001%'
	        AND UNITCOST = 0
	   ORDER BY ITEMNAME DESC, WHCODE ASC



/*********************************************************************
4. 검색된 데이터 중 조회된 행의 상위 n개의 데이터를 표현. TOP(n)
아이템마스터 테이블에서, MAXSTOCK의 값이 NULL이 아닌 모든 자료들 중 MAXSTOCK의 값이 가장 큰 순으로 3개를 추출하시오.
-- (품목 마스터테이블 에서 최대 적재량이 값을 가지고있고 최대 적재량이 제일 큰 품목의 코드 를 검색하세요.)
*/
   SELECT TOP(3) *
     FROM TB_ItemMaster
    WHERE MAXSTOCK IS NOT NULL
 ORDER BY MAXSTOCK DESC

-- 상위 10개의 데이터를 조회
	SELECT TOP(10) * 
	  FROM TB_ItemMaster 
  ORDER BY MAXSTOCK DESC

/*************************** 실습 ************************************
  T_StockMMrec : 자재 입출 이력 테이블
  INOUTFLAG : 입고-I, 출고-O
  INOUTQTY : 입출수량
  
  T_StockMMrec 테이블에서 INOUTFLAG가 'O'인 데이터 중,
  INOUTDATE가 가장 최근에 발생한 상위 10개 품목의
  ITEMCODE, INOUTQTY를 조회하세요
	* 자재 출고 이력 중 가장 최근 출고된 10개의 이력의 품목과 수량 */
     SELECT TOP(10) ITEMCODE,
				    INOUTQTY
       FROM TB_StockMMrec
      WHERE INOUTFLAG = 'O'
   ORDER BY INOUTDATE DESC

