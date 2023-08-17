/* 1. LIKE      *****
   . 데이터를 포함하는 행 조회
   . WHERE 조건에 검색하고자 하는 데이터의 일부 만 입력하여
     해당 조건 을 만족시키는 모든 데이터 를 조회 ('%')
*/

-- 품목 마스터 테이블에서 ITEMCODE 컬럼의 데이터 중 'E' 가 포함된
-- 데이터 를 모두 검색 하세요.

-- 1) ITEMCODE 의 데이터 가 E 를 포함하면 조회
SELECT * 
  FROM TB_ItemMaster
 WHERE ITEMCODE LIKE '%E%'

 -- 2) ITEMCODE 의 데이터 가 E 로 시작하면 조회.
SELECT * 
  FROM TB_ItemMaster
 WHERE ITEMCODE LIKE 'AA%'

 -- 3) ITEMCODE 의 데이터 가 E 로 끝나는 데이터 조회
 SELECT *
   FROM TB_ItemMaster
  WHERE ITEMCODE LIKE '%E'


/*****************************************************************************************
2. NULL  이 아닌 데이터 조회 및 NULL 인 데이터 조회 (IS NULL, IS NOT NULL)
   NULL : 데이터 가 없고 비어있는 상태, 값자체가 주어지지 않은 상태.
*/

-- 품목마스터 테이블에서 MAXSTOCK 컬럼의 데이터 가 NULL 처리 된 행을 모두 검색.
SELECT *
  FROM TB_ItemMaster
 WHERE MAXSTOCK IS NULL

-- 품목마스터 테이블에서 MAXSTOCK 컬럼의 데이터 가 NULL 이 아닌 행을 모두 검색.
SELECT * 
  FROM TB_ItemMaster
 WHERE MAXSTOCK IS NOT NULL

 /************* 실습 **********************
 품목 마스터 에서 
 BOXSPEC 컬럼의 데이터 가 '01' 로 끝나면서 NULL 상태가 아닌 
 PLANTCODE, ITEMCODE, ITEMNAME, BOXSPEC  컬럼의 행을 검색 하세요. 
 
 BOXSPEC : 포장단위 규격
 */

SELECT *
  FROM TB_ItemMaster
 WHERE BOXSPEC IS NOT NULL
   AND BOXSPEC LIKE '%01'


/***********************************************************************************
 3. 검색 결과 를 정렬. (ORDER BY , ASC, DESC)
  . 테이블에서 검색 한 결과 를 조건에 따라 정렬하여 나타낸다. 
  . 오름 차순의 경우 (ASC) 를 사용.  * NULL 상태의 값이 최 상위에 나타난다. 
  . 내림 차순의 경우 (DESC) 를 사용

*/

-- 품목 마스터 테이블의 ITEMTYPE = 'HALB' 인 (품목 유형이 반제품) 
-- ITEMCODE, ITEMTYPE 컬럼의 데이터를 ITEMCODE 컬럼 데이터 기준으로 오름차순하여 조회
  SELECT ITEMCODE ,
  	     ITEMTYPE
    FROM TB_ItemMaster
   WHERE ITEMTYPE = 'HALB'
ORDER BY ITEMCODE





/* ** ORDER BY 절에 컬럼이 추가 될 경우 왼쪽 부터 순차적으로 우선 순위를 가진다. 
  품목 마스터 테이블 에서 ITEMTYPE = 'HALB' 인 
  ITEMCODE,ITEMTYPE, WHCODE, BOXSPEC 컬럼을 
  ITEMTYPE 의 값이 같다면 WHCODE 순서로, WHCODE 값이 같다면 BOXSPEC 순서로 정렬 */

  SELECT ITEMCODE,
		 ITEMTYPE, 
		 WHCODE, 
		 BOXSPEC
    FROM TB_ItemMaster
   WHERE ITEMTYPE = 'HALB'
ORDER BY ITEMTYPE, WHCODE, BOXSPEC

-- * 조회 대상에 없는 컬럼 의 데이터 정렬 조건 추가하기. 
-- 데이터를 확인 할 수 없지만 ORDER BY  의 순서대로 정렬 된다. 


-- 품목마스터 테이블 에서 ITEMTYPE = 'HALB' 인 
-- ITEMTYPE, WHCODE, BOXSPEC 컬럼 을 
-- ITEMCODE 순서대로 정렬하라. 

SELECT ITEMTYPE
      ,WHCODE
	  ,BOXSPEC
  FROM TB_ItemMaster
 WHERE ITEMTYPE = 'HALB'
ORDER BY ITEMCODE 



-- ** 역 순으로 정렬 하기 DESC
-- 품목 마스터 테이블에서  ITEMCODE, ITEMNAME 컬럼을 조회 하는데
-- ITEMCODE 컬럼데이터 역순으로 (내림차순) 조회 
  SELECT * 
    FROM TB_ItemMaster
ORDER BY ITEMCODE DESC


/* 오름차순 과 내림 차순 을 혼용 하여 사용하는 예
   
   품목마스터 테이블 에 있는 모든 데이터 중에 
   ITEMTYPE 는 오름차순으로 , WHCDOE 는 내림차순으로 , INSPFLAG 는 오름차순으로 정렬. */

  SELECT ITEMCODE, 
         ITEMTYPE, 
		 WHCODE, 
		 INSPFLAG
    FROM TB_ItemMaster
ORDER BY ITEMTYPE ASC, WHCODE DESC, INSPFLAG


/****** 실습 ********
 품목 마스터 테이블 에서 
 MATERIALGRADE 컬럼의 값이 NULL 이고 
 CARTYPE 컬럼의 값이 MD, RB, TL 이 아니면서
 ITEMCODE 컬럼 값이 '001' 을 포함하고
 UNITCOST 컬럼 값이 0 인 행의 
 모든 컬럼 을 
 ITEMNAME 컬럼기준 내림차순, WHCODE 컬럼기준 오름차순 으로 검색 하세요. 
 
 MATERIALGRADE : 자재 등급. 
 CARTYPE  : 차종 
 UNITCOST : 단가
 ITEMCODE : 품번 
 ITEMNAME : 품명
 */
 
 SELECT * 
   FROM TB_ItemMaster
  WHERE MATERIALGRADE IS NULL
    AND CARTYPE NOT IN ('MD','RB','TL')
	AND UNITCOST = 0
    AND ITEMCODE LIKE '%001%'
ORDER BY ITEMNAME DESC, WHCODE ASC


/********************************************************************************************
4. 검색된 데이터 중에 조회된 행의 상위 N 개의 데이터를 표현. TOP
*/


-- 품목 마스터테이블 에서  최대 적재량이 값을 가지고있고
-- 최대 적재량이 제일 큰 품목의 코드 를 검색하세요
  SELECT TOP(1) ITEMCODE
    FROM TB_ItemMaster
   WHERE MAXSTOCK IS NOT NULL
ORDER BY MAXSTOCK DESC


-- 상위 N 개의 데이터를 조회 
   SELECT TOP(10) *
     FROM TB_ItemMaster
 ORDER BY MAXSTOCK DESC

 
 /******* 실습 ***************************
   TB_StockMMrec (자재 입출 이력 테이블)
   INOUTFLAG : 입고 I, 출고 O
   INOUTQTY : 입/출 수량. 

   TB_StockMMrec 테이블에서 INOUTFLAG 가 'O' 인 데이터 중.
   INOUTDATE 가 가장 최근 상위 10개 품목의
   ITEMCODE, INOUTQTY 를 조회하세요.
     * 자재 출고 이력 중 가장 최근 출고 10개의 이력의 품목 과 수량 */
   SELECT TOP(10) ITEMCODE
				 ,INOUTQTY
     FROM TB_StockMMrec
    WHERE INOUTFLAG = 'O' 
 ORDER BY INOUTDATE DESC    



