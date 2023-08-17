/****************************************************
1. 데이터 합병 검색 (DISTINCT)

  - 컬럼의 데이터 가 중복 되어 있을 경우 중복 된 데이터 를 
    합병하여 검색. */

-- 우리 회사에서 관리하는 모든 품목의 유형을 나타내세요.

-- 품목 마스터 테이블 에서 품목 유형 을 표현하면 되겠구나. 
SELECT DISTINCT ITEMTYPE
  FROM TB_ItemMaster


-- 단위 가 KG 인 품목의 유형을 조회 하세요.
-- 품목 마스터 테이블에서 BASEUNIT(단위) 가 KG 인 데이터의 
-- ITEMTYPE (유형) 을 병합 후 검색

SELECT DISTINCT ITEMTYPE
  FROM TB_ItemMaster
 WHERE BASEUNIT = 'KG'


/* 단일 컬럼 의 합병 이 아닌 여러 컬럼의 합병의 예시
 
 
 -- 단위 가 KG 을 가지는 품목 유형 별 창고 를 보여주세요 

 ITEMTYPE : 품목 유형
 WHCODE : 창고. 
*/
SELECT DISTINCT ITEMTYPE,
				WHCODE
  FROM TB_ItemMaster
 WHERE BASEUNIT = 'KG' 


  -- 1. 우리 회사에서 관리하는 모든품목 조회
  SELECT * FROM TB_ItemMaster

  -- 2. 우리 회사의 모든 품목의 유형 을 리스트
  SELECT ITEMTYPE FROM TB_ItemMaster

  -- 3. 품목의 유형을  병합
 SELECT DISTINCT ITEMTYPE FROM TB_ItemMaster
  
  -- 4. 단위가 KG 인 유형  만 조회
  SELECT DISTINCT ITEMTYPE FROM TB_ItemMaster WHERE BASEUNIT = 'KG'

  -- 5. 단위가 KG 인 품목 유형이 적재될 수있는 창고를 보여주세요.
  SELECT DISTINCT ITEMTYPE,
				  WHCODE
    FROM TB_ItemMaster WHERE BASEUNIT = 'KG'


/************** 실습 **********************
품목 마스터 테이블 에서 
BOXSPEC (포장규격) 이 'DS-PLT' 로 시작 하는 품목 들의 유형별 창고 를 나타내세요.

= 품목 마스터 테이블 에서 BOXSPEC 이 'DS-PLT' 로 시작하는 ITEMTYPE 별 WHCODE 의 
  종류를 검색 */

SELECT DISTINCT ITEMTYPE, 
				WHCODE 
  FROM TB_ItemMaster
WHERE BOXSPEC LIKE 'DS-PLT%'



-- 1. 규격 이 DS-PLT 로 시작 하는 모든 품목
SELECT DISTINCT ITEMTYPE, WHCODE
  FROM TB_ItemMaster
WHERE BOXSPEC LIKE 'DS-PLT%'



/*******************************************************************************************
2. 데이터 합병 검색 GROUP BY  중요도 **********
  . GROUP BY 조건에 따라 해당 컬럼의 데이터 를 병합. 
  . * GROUP BY 로 병합된 결과 에서 조회조건으로 두어 검색 가능(HAVING)
  . * 집계 함수 를 사용하여 병합 데이터를 연산 할수 있는 기능을 지원 */


-- GROUP BY 의 기본 유형

  SELECT ITEMTYPE
    FROM TB_ItemMaster
GROUP BY ITEMTYPE
--* GROUP BY 하지 않은 컬럼 은 조회 할 수 없다. 
  SELECT ITEMTYPE
    FROM TB_ItemMaster
GROUP BY ITEMSPEC


-- WHERE 절 과 GROUP BY 
   SELECT ITEMTYPE
     FROM TB_ItemMaster
    WHERE BASEUNIT = 'KG'
 GROUP BY ITEMTYPE


 -- GROUP BY 하지 않은 컬럼 은 조회 할 수 없는 경우.
 SELECT ITEMTYPE
       ,WHCODE
   FROM TB_ItemMaster
  WHERE BASEUNIT = 'KG'
GROUP BY ITEMTYPE


--[POINT 1]
/********** 실습 *********************************************
TB_StockMM : 원자재 재고 테이블 
STOCKQTY : 현재 재고 수량
INDATE   : 재고 입고 일자. 

TB_StockMM 테이블에서 
STOCKQTY 의 데이터 가 1500 이상인 데이터 를 가지고
INDATE 의 데이터 가 '2022-03-01' 부터 '2022-03-31' 의 데이터 중
INDATE 별 ITEMCODE 을 표현하세요. 
 
-- '2022-03-01' 부터 '2022-03-31' 사이에 1500 개 이상 들어온 일자별 품목 리스트
*/

SELECT INDATE,
	   ITEMCODE
  FROM TB_StockMM
 WHERE STOCKQTY >= 1500
   AND INDATE BETWEEN '2022-03-01' AND '2022-03-31'
GROUP BY INDATE , ITEMCODE


--[POINT 2]
/* GROUP BY 결과 에서 재 검색 HAVING
MAXSTOCK : 최대 적재량
ITEMTYPE : 품목 유형
INSPFLAG : 검사 여부

품목 마스터 테이블 에서  (TB_ITEMMASTER)
MAXSTOCK 이 10 을 초과 하는 데이터 중
ITEMTYPE 별 INSPFLAG 를 나타내고 
INSPFLAG 가 I 인 데이터 를 표현하세요.

-- 품목 중에 최대 적재량이 10 초과하는 품목의 유형별 검사 여부를 나타내세요 
   (* 단 검사여부 는  I 인것).
*/
  SELECT ITEMTYPE , INSPFLAG
    FROM TB_ItemMaster
   WHERE MAXSTOCK > 10
GROUP BY ITEMTYPE, INSPFLAG
  HAVING INSPFLAG = 'I'


-- 주의 * HAVING 을 통해서 조건을 넣을 컬럼 은 반드시 GROUP BY 된 상태여야 한다. 
  SELECT ITEMTYPE , INSPFLAG
    FROM TB_ItemMaster
   WHERE MAXSTOCK > 10
GROUP BY ITEMTYPE, INSPFLAG
  HAVING INSPFLAG = 'I'


/**************************  여기서 잠깐 ***********************************/
-- [POINT 1]

SELECT INDATE,
	   ITEMCODE
  FROM TB_StockMM
 WHERE STOCKQTY >= 1500
   AND INDATE BETWEEN '2022-03-01' AND '2022-03-31'
GROUP BY INDATE , ITEMCODE


-- 의 내용은 아래와 같다. 
SELECT DISTINCT INDATE, ITEMCODE
  FROM TB_StockMM
 WHERE STOCKQTY >= 1500
   AND INDATE BETWEEN '2022-03-01' AND '2022-03-31'

-- 또 POINT 2 
  SELECT ITEMTYPE , INSPFLAG
    FROM TB_ItemMaster
   WHERE MAXSTOCK > 10
GROUP BY ITEMTYPE, INSPFLAG
  HAVING INSPFLAG = 'I'
 

-- 의 결과 는 아래 와 같다. 
SELECT DISTINCT ITEMTYPE , INSPFLAG
    FROM TB_ItemMaster
   WHERE MAXSTOCK > 10
    AND INSPFLAG = 'I' 


-- 그렇다면 왜 GROUP BY 를 사용하는 것일까?????

/**********************************************************************************************
3. 집계 함수
 - 특정 컬럼의 여러 행에 있는 데이터를 연산 후 하나의 결과를 반환하는 함수.

  . SUM()   :  병합하는 컬럼의 데이터 를 모두 합한다.
  . MIN()   :  병합하는 컬럼의 데이터 중 최소 값을 나타낸다.  
  . MAX()   :  병합하는 컬럼의 데이터 중 최대 값을 나타낸다. 
  . COUNT() :  병합하는 컬럼의 행 개수를 나타낸다. 
  . AVG()   :  병합하는 컬럼의 데이터 들의 평균을 나타낸다. 
*/


-- 품목 마스터 테이블 에서 ITEMTYPE 가 FERT 인 데이터 의 UNITCOST 합 ? 
-- UNITCOST : 단가.
SELECT SUM(UNITCOST) 
  FROM TB_ItemMaster
 WHERE ITEMTYPE = 'FERT'

SELECT UNITCOST
  FROM TB_ItemMaster
 WHERE ITEMTYPE  = 'FERT'


-- COUNT() 함수 : 데이터 행의 갯수
SELECT COUNT(*) AS CNT
  FROM TB_ItemMaster


-- AVG() 함수 : 평균
-- TB_StockMM : 원자재 재고 테이블
-- 원자재 재고 의 평균 수량을 나타내세요.
SELECT AVG(STOCKQTY)
  FROM TB_StockMM


-- MAX() , MIN () 
-- 데이터 들 중에 최대값과 최소값. 


SELECT MAX(UNITCOST) 
  FROM TB_ItemMaster  
-- 품목 중 단가가 가장 높은 금액 

SELECT MIN(UNITCOST) 
  FROM TB_ItemMaster  
-- 품목 중 단가가 가장 낮은 금액. 




-- 집계 함수 를 혼용하여 사용 할 경우
-- 품목마스터 에서 품목 유형 별 
-- (총 개수) 와 (단가 의 총 합) 과 (단가의 최소값) 을 조회. 

SELECT ITEMTYPE ,
       COUNT(*)       AS ITEMCNT,
	   SUM(UNITCOST)  AS COSTSUM,
	   MIN(UNITCOST)  AS MINCOST
  FROM TB_ItemMaster
 GROUP BY ITEMTYPE

-- GROUP BY 하는 김에 품목 유형별로 COUNT : 행의 갯수 , SUM : 총합 , MIN : 최소 값
-- 을 구해서 같이 보여줄게. 



-- 집계 함수 를 사용한 결과의 조회 조건 (HAVING)





  SELECT ITEMTYPE      AS ITEMTYPE
    FROM TB_ItemMaster
GROUP BY ITEMTYPE 
 HAVING SUM(UNITCOST) > 100


  SELECT ITEMTYPE      AS ITEMTYPE,
  	     COUNT(*)      AS ROWCNT,
  	     SUM(UNITCOST) AS SUM_COST,
  	     MIN(UNITCOST) AS MIN_COST
    FROM TB_ItemMaster
GROUP BY ITEMTYPE 
  HAVING SUM(UNITCOST) > 100

-- GROUP BY 로 병합 된 결과 의 HAVING 조건에 집계 함수를 사용할 경우. 
-- GROUP BY 에 명시 하지 않은 컬럼 을 사용할 수 있다.

 /* 
	UNITCOST : 단가 
	ITEMTYPE : 품목유형

    품목마스터 테이블에서 UNITCOST 가 10 이상인 데이터를 가진 행 중. 
	ITEMTYPE 별로 UNITCOST 의 합 이 100 을 초과하는 행의 
	ITEMTYPE, UNITCOST 의합, UNITCOST 의 최대값 을 나타내시오
	 * 정렬기준은 단가의 합 오름차순으로 나타내세요
 */ 

   SELECT ITEMTYPE,
		  SUM(UNITCOST) AS SUM_UNITCOST,
		  MAX(UNITCOST)
     FROM TB_ItemMaster
    WHERE UNITCOST >= 10
 GROUP BY ITEMTYPE
   HAVING SUM(UNITCOST) > 100
 ORDER BY SUM_UNITCOST

/* 데이터 베이스 의 처리 절차. 
   ******** FROM -> WHERE -> GROUP BY -> HAVING -> ORDER BY 순서.
   1. 품목 마스터 에서 UNITCOST 가 10 이상인 행 추출 ( WHERE )
   2. 1 에서 추출된 데이터 에서 ITEMTYPE 컬럼 을 병합 처리.  (GROUP BY)
   3. 2 의 내용을 병합하면서 UNITCOST 의 합 이 100 초과 하는 행 추출 ( HAVING )
   4. 3 에서 추출 된 컬럼 ITEMTYPE 표현
      3 에서 추출 된 컬럼을 기준으로 UNITCOST 집계함수 SUM 실행 -> SUM_UNITCOST 컬럼명칭 부여
	  3 에서 추출 된 컬럼을 기준으로 UNITCOST 집계함수 MAX 실행
   5. 4 에서 완료된 데이터 를 4에 서 완료된 데이터 테이블의 컬럼 을 기준으로 정렬 (  ORDER BY )
*/


-- 문제 ? 
-- 아래 SQL 은 왜 수행이 안될까 ? 
-- STOCKQTY 가 가장 큰 값을 찾아낼 대상 이 불분명함. 
-- 즉 비교할 대상이 없으므로 처리되지 않는다. 
SELECT ITEMCODE 
  FROM TB_StockMM
 WHERE MAX(STOCKQTY) > 10

/*********** 정리
집계 함수 는 GROUP BY 와 함께 사용 할 경우 효과가 크다
집계 함수의 결과 조건을 사용하지 않을 경우 GROPUP BY / DISTINCT 는 
큰 차이가 없다. 
*/

--[POINT 3]
/******* 실습
TB_STOCKMMREC  : 자재 재고 입출 이력
INOUTFLAG      : 입출 여부   I : 입고
WHCODE         : 창고 코드

TB_STOCKMMREC 테이블 의 데이터 중  INOUTFLAG 가 'I' 이고 
INOUTQTY 가 1000 보다 큰 데이터 행을
INOUTDATE 별 WHCODE 의 횟수 로 나타내고 (일자 별 창고 입고 횟수)
INOUTDATE 기준으로 오름차순 조회 하세요.

2. 입출 횟수 가 2개 이상인 데이터 만 조회 해 보세요
*/
SELECT INOUTDATE
      ,WHCODE
	  ,COUNT(*)    AS CNT
  FROM TB_StockMMrec 
 WHERE INOUTFLAG = 'I'
   AND INOUTQTY > 1000
GROUP BY INOUTDATE, WHCODE
  HAVING COUNT(*) >= 2
ORDER BY INOUTDATE
  