/***********************************************************************************
	1. 데이터 합병 검색 (Distinct)	-	중요도 **********
		 - 컬럼의 데이터가 중복되어있을 경우 중복된 데이터를 합병하여 검색.
*/

-- 우리 회사에서 관리하는 모든 품목의 유형을 나타내세요. 

-- 품목마스터 테이블에서 품목 유형을 표현하면 되겠구나..
	SELECT DISTINCT ITEMTYPE
			   FROM TB_ItemMaster

-- 단위가 KG인 품목의 유형을 조회하세요.
	SELECT DISTINCT ITEMTYPE
			   FROM TB_ItemMaster
			  WHERE BASEUNIT = 'KG'


/* 단일 컬럼의 합병이 아닌 여러 컬럼의 합병의 예시

 . 단위가 KG을 가지는 품목 유형별 창고를 보여주세요.

*/
SELECT DISTINCT ITEMTYPE,
				WHCODE
		   FROM TB_ItemMaster
		  WHERE BASEUNIT = 'KG'



/************************* 실습 ***************************
품목 마스터테이블에서
BOXSPEC(포장규격)이 'DS-PLT'로 시작하는 품목들의 유형별 창고를 나타내세요.
*/
	SELECT DISTINCT ITEMTYPE,
				    WHCODE
			   FROM TB_ItemMaster
			  WHERE BOXSPEC LIKE 'DS-PLT%'

			  

/***********************************************************
	2. 데이터 합병 검색 GROUP BY	-	중요도 ***********
	 . GROUP BY 조건에 따라 해당 컬럼의 데이터를 병합.
	 . * GROUP BY로 병합된 결과에서 조회조건으로 두어 검색 가능.(HAVING)
	 . * 집계 함수를 사용하여 병합 데이터를 연산할 수 있는 기능을 지원. */

-- GROUP BY의 기본 유형.
	SELECT ITEMTYPE			-->>  FROM 아이톔타입 마스터에서(FROM) --> ITEMTYPE으로 그룹화한 후(GROUP BY) --> ITEMTYPE을 출력(SELECT)
	  FROM TB_ItemMaster
  GROUP BY ITEMTYPE
  -- * GROUP BY 하지 않은 컬럼은 조회할 수 없다. 

  SELECT ITEMTYPE		
	  FROM TB_ItemMaster
  GROUP BY ITEMSPEC		-->> 에러..! ITEMSPEC로 GROUP BY된 리스트에는 ITEMTYPE이 없다.


-- WHERE절과 GROUP BY
	  SELECT ITEMTYPE
	    FROM TB_ItemMaster
 	   WHERE BASEUNIT = 'KG'
	GROUP BY ITEMTYPE		-->>	FROM -> WHERE -> GROUP BY -> SELECT

-- GROUP BY하지 않은 컬럼은 조회할 수 없는 경우.
	SELECT ITEMTYPE,
		   WHCODE
	  FROM  TB_ItemMaster
	 WHERE BASEUNIT = 'KG'
  GROUP BY ITEMTYPE


--[POINT 1]
/***************** 실습 *******************************
  TB_StockMM : 원자재 재고 테이블
  STOCKQTY : 현재 재고 수량
  INDATE   : 재고 입고 날짜 

  TB_StockMM 테이블에서
  STOCKQTY의 데이터가 1500 이상인 데이터를 가지고
  INDATE의 데이터가 '2022-03-01'부터 '2022-03-31'의 데이터 중
  INDATE별 품목을 표현하세요. */

  SELECT INDATE, ITEMCODE
    FROM TB_StockMM
   WHERE STOCKQTY >= 1500
 	 AND (INDATE >= '2022-03-01' AND INDATE <= '2022-03-31')
GROUP BY INDATE, ITEMCODE

--[POINT 2]
/* GROUP BY 결과에서 재검색. HAVING

품목마스터 테이블에서
MAXSTOCK이 10을 초과하는 데이터 중
ITEMTYPE별 INSPFLAG를 나타내고
INSPFLAG가 'I'인 데이터를 표현하세요

MAXSTOCK : 최대 적재량
ITEMTYPE : 품목 유형
INSPFLAG : 검사 여부

-->> 품목 중에 최대 적재량이 10을 초과하는 품목의 유형별 검사 여부를 나타내세요(*단 검사여부는 I인 것)
*/
	 SELECT ITEMTYPE,
	        INSPFLAG
	   FROM TB_ItemMaster
	  WHERE MAXSTOCK > 10
   GROUP BY ITEMTYPE, INSPFLAG
     HAVING INSPFLAG = 'I'		-->> FROM -> WHERE -> GROUP BY -> HAVING -> SELECT

-- * 주의 *
-- HAVING을 통해서 조건을 넣을 컬럼은 반드시 GROUP BY된 상태여야 한다. 
	 SELECT ITEMTYPE,
	        INSPFLAG
	   FROM TB_ItemMaster
	  WHERE MAXSTOCK > 10
   GROUP BY ITEMTYPE, INSPFLAG
     HAVING INSPFLAG = 'I'

/****************** 여기서 잠깐 **********************/
--POINT 1
SELECT INDATE, ITEMCODE
    FROM TB_StockMM
   WHERE (INDATE >= '2022-03-01' AND INDATE <= '2022-03-31')
 	 AND STOCKQTY >= 1500
GROUP BY INDATE, ITEMCODE

--의 내용은 아래와 같다. 
SELECT DISTINCT INDATE, ITEMCODE
FROM TB_StockMM
WHERE STOCKQTY >= 1500
  AND (INDATE BETWEEN '2022-03-01' AND '2022-03-31')

--또 POINT 2
   SELECT ITEMTYPE, 
          INSPFLAG
     FROM TB_ItemMaster 
    WHERE MAXSTOCK > 10
 GROUP BY ITEMTYPE, INSPFLAG
   HAVING INSPFLAG = 'I'

--의 결과는 아래와 같다.
 SELECT DISTINCT ITEMTYPE, INSPFLAG
            FROM TB_ItemMaster
           WHERE MAXSTOCK > 10
             AND INSPFLAG = 'I'
			 
-- 그렇다면 왜 GROUP BY를 사용하는 것일까??(심지어 GROUP BY가 DISTINCT보다 리소스를 조금 더 많이잡아먹는다.)
		-->> 집계함수와 같이 쓰이기 때문. (꼭 같이 써야하는것은 아니다. 집계함수와 GROUP BY는 각각 별개로 쓸 수 있다.)
/***********************************************************************************
3. 집계 함수
 - 특정 컬럼의 여러 행에 있는 데이터를 연산 후 하나의 결과를 반환하는 함수.

 . SUM() : 병합하는 컬럼의 데이터를 모두 합한다.
 . MIN() : 병합하는 컬럼의 데이터 중 최솟값을 나타낸다.
 . MAX() : 병합하는 컬럼의 데이터 중 최댓값을 나타낸다.
 . COUNT() : 병합하는 컬럼의 행 개수를 나타낸다.
 . AVG() : 병합하는 컬럼의 데이터들의 평균을 나타낸다.
*/


-- 품목마스터 테이블에서 ITEMTYPE이 FERT인 데이터의 UNITCOST 합을 구하세요
-- UNITCOST : 단가
SELECT SUM(UNITCOST) AS SUMMMM
  FROM TB_ItemMaster
 WHERE ITEMTYPE = 'FERT'

-- COUNT() 함수
SELECT COUNT(*) AS _COUNT
  FROM TB_ItemMaster

-- AVG() 함수
-- TB_StockMM : 원자재 재고 테이블
-- 원자재 재고의 평균 수량을 나타내세요.
SELECT AVG(STOCKQTY) AS _AVERAGE
      FROM TB_StockMM

-- MAX(), MIN()
-- 데이터들 중에서 최댓값, 최솟값을 찾을 수 있다.
SELECT MAX(UNITCOST) AS _MAX_COST
 FROM TB_ItemMaster		-->> 품목 중 단가(UNITCOST)가 가장 높은 것을 나타냄.

SELECT MIN(UNITCOST) AS _MIN_COST
  FROM TB_ItemMaster	-->> 품목 중 단가(UNITCOST)가 가장 낮은 것을 나타냄.




-- 집계함수를 혼용하여 사용할 경우
-- 품목 유형별 단가의 총합과 최솟값을 조회해보자.
    SELECT ITEMTYPE,
		   COUNT(*)		 AS ITEMCNT,
		   SUM(UNITCOST) AS COSTSUM,
	       MIN(UNITCOST) AS COSTMIN
      FROM TB_ItemMaster
  GROUP BY ITEMTYPE

-- GROUP BY (병합)하는김에 품목 유형별로 COUNT : 행의 갯수, SUM : 총합, MIN : 최솟값을 구해서 같이 보여줄게..



-- 집계함수를 사용한 결과의 조회 조건(HAVING)
	SELECT ITEMTYPE			 AS ITEMTYPE,
		   COUNT(*)			 AS ROWCNT,
		   SUM(UNITCOST)	 AS SUM_COST,
		   MIN(UNITCOST)	 AS MIN_COST
	  FROM TB_ItemMaster
  GROUP BY ITEMTYPE
	HAVING COUNT(*) > 100

-- GROUP BY로 병합된 결과의 HAVING 조건에 집계 함수를 사용할 경우.
-- GROUP BY에 명시하지 않은 컬럼을 사용할 수 있다. 




/*
	UNITCOST : 단가, ITEMTYPE : 품목유형

	품목마스터 테이블에서 UNITCOST가 10 이상인 데이터를 가진 행 중에서
	ITEMTTYPE별로 UNITCOST의 합이 100을 초과하는 행의
	ITEMTYPE, UNITCOST의 합과 UNITCOST의 최댓값을 나타내시오.
	 * 정렬기준은 단가의 합 오름차순으로 나타내세요.
*/
	SELECT ITEMTYPE,
		   SUM(UNITCOST) AS SUM_UNITCOST,
		   MAX(UNITCOST) AS MAX_UNITCOST
	  FROM TB_ItemMaster
	 WHERE UNITCOST >= 10
  GROUP BY ITEMTYPE
	HAVING SUM(UNITCOST) > 100
   -- ORDER BY SUM(UNITCOST) ASC  -->> 이렇게 해도 되지만, 이렇게 되면 SUM 함수를 총 세 번 호출하게 된다..
  ORDER BY SUM_UNITCOST ASC


/* 데이터베이스의 처리 절차.
   FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY  
   1. 품목마스터에서(FROM) UNITCOST가 10 이상인 행을 추출 (WHERE)
   2. 1에서 추출된 ITEMTYPE을 병합 처리한다. (GROUP BY)
   3. 2의 내용을 수행하면서, UNITCOST의 합이 100을 초과하는 행을 추출한다. (HAVING)
   4. 3에서 추출된 컬럼 ITEMTYPE를 표현하고, 
	  3에서 추출된 컬럼을 기준으로 UNITCOST 집계함수 SUM을 실행. - 컬럼에 SUM_UNITCOST의 명칭 부여
	  3에서 추출된 컬럼을 기준으로 UNITCOST 집계함수 MAX을 실행. - 컬럼에 MAX_UNITCOST의 명칭 부여	(SELECT)
   5. 4에서 완료된 데이터를 SUM_UNITCOST 기준으로 오름차순으로 정렬.	(ORDER BY)
*/



-- 문제; 아래 SQL은 왜 수행이 안될까?
-->> STOCKQTY가 가장 큰 값을 찾아낼 대상이 불분명하다. 즉 비교할 대상이 없으므로 처리되지 않는다. 
--( WHERE절에서는 집계에 대한 기준이 없기 때문에 집계함수를 사용할 수 없다. )
	SELECT ITEMCODE
	  FROM TB_StockMM
	 WHERE MAX(STOCKQTY) > 10


/************ 정리 **************
집계함수는 GROUP BY와 함께 사용할 경우 효과가 크다. 집계 함수의 결과 조건을 사용하지 않을 경우 GROUP BY와 DISTINCT는 큰 차이가 없다. 
*/

--[POINT 3]
/************ 실습 **************
TB_STOCKMMREC : 자재재고 입출이력 테이블
INOUTFLAG : 입출 여부

T_STOCKMMREC 테이블의 데이터 중 INOUTFLAG가 'I'이고,
INOUTQTY가 1000보다 큰 데이터행을 
INOUTDATE별 WHCODE의 횟수로 나타내고, (일자별 창고 입고 횟수)
INOUTDATE 기준으로 오름차순으로 조회하세요. 

** + 입출 횟수가 2개 이상인 데이터만 조회하세요 
*/

     SELECT INOUTDATE,
      	    WHCODE,
	  	    COUNT(*) AS CNT
       FROM TB_StockMMrec
      WHERE INOUTFLAG = 'I'
        AND INOUTQTY > 1000
   GROUP BY INOUTDATE, WHCODE
-- + HAVING COUNT(*) >= 2
   ORDER BY INOUTDATE ASC


