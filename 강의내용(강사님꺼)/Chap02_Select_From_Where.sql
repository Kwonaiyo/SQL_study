-- 쿼리 편집기 창에 사용할 데이터베이스 변경.
USE MyFirstDataBase

-- 실행은 F5 또는 상단의 초록색 화살표(실행) 클릭
-- 드래그를 통한 블럭 지정 후 선택한 부분만 실행 가능.

/*************************************************************************
- SELECT     *****
 . 데이터베이스 내의 테이블에서 원하는 데이터를 추출하는 명령어. 
 . 가장 기본적인 SQL 구문이지만 데이터베이스 운영 시 중요도가 가장 높은 문법이므로
   잘 숙지할것.

 SELECT [컬럼의 이름 및 데이터 정보] 
   FROM [테이블이름]
  WHERE [조건]
**************************************************************************/
-- 1. 기본적인 SELECT 형식
-- 1) SELECT 로만 실행.
   SELECT 87
    
-- 2) SELECT FROM 으로 실행
SELECT * FROM TB_ITEMMASTER
-- * : 애스터리스크 테이블의 모든 컬럼의 내용을 선택.

/**************************************************************************
2. 특정 컬럼의 데이터 만 조회
  . TB_ITEMMASTER 테이블에서 ITEMCODE(품목), ITEMNAME(품명) 의 정보를 모두 
    검색하시오. */

	SELECT ITEMCODE,
	       ITEMNAME 
      FROM TB_ITEMMASTER;

/********************************************** 실습 ***********************
TB_ITEMMASTER 테이블에서 
ITEMCODE(품목), WHCODE(창고코드), BASEUNIT(단위), MAKEDATE(생성일시) 컬럼을 조회하는 구문을 작성해 보세요.
*/

SELECT ITEMCODE
      ,WHCODE
	  ,BASEUNIT
	  ,MAKEDATE
  FROM TB_ITEMMASTER;


/****************************************************************************
2. 별칭 주기.
 - 컬럼 또는 테이블에 별칭을 주어 지정한 컬럼의 이름으로 변경하여 조회 하는 기능.
 - AS 라는 키워드로 설정 할 수 있으며 생략하고 띄워쓰기로도 표현 가능. 


 ITECODE 컬럼을 IT_CD 로 나타내고,
 ITEMNAME 컬럼을 IT_NM 로 나타내기.
*/

SELECT ITEMCODE AS IT_CD,
       ITEMNAME IT_NM
  FROM TB_ITEMMASTER 



/************************************************************************************
3. WHERE 절. 
  . 검색 조건을 입력 하여 원하는 데이터만 조회 한다. 

  . SQL 에서 문자열은 ' 홑따옴표 로 정의한다.

*/

-- 3-1 품목마스터(TB_ITEMMASTER) 테이블에서 
-- BASEUNIT(단위) 가 'EA' 인 모든 컬럼을 검색. 

SELECT *
  FROM TB_ITEMMASTER
 WHERE BASEUNIT = 'EA'
 

 --3-2 품목마스터 테이블에서 
 -- BASEUNIT(단위) 가 EA 인것과 ITEMTYPE(품목유형) 이 HALB 인
 -- 모든 컬럼을 검색하세요.

SELECT * 
  FROM TB_ITEMMASTER
 WHERE BASEUNIT = 'EA'
   AND ITEMTYPE = 'HALB'


-- 3-3 품목 마스터 테이블 에서 
-- ITEMTYPE(품목유형) 이 HALB 또는 OM 인 모든 컬럼의 데이터 행을
-- 검색하세요.
SELECT * 
  FROM TB_ItemMaster
 WHERE ITEMTYPE = 'HALB'
    OR ITEMTYPE = 'OM'

SELECT *
  FROM TB_ITEMMASTER
 WHERE (ITEMTYPE = 'HALB' OR ITEMTYPE = 'OM')


 
/*********** 주의 ********
컬럼이 다른 검색 조건에 OR 이 사용되는 경우
BASEUNIT 가 EA 가 아니며 ITEMTYPE 이 HALB 가 아닌 데이터 가 조회될 수 
있다.
*/
SELECT * 
  FROM TB_ITEMMASTER
 WHERE BASEUNIT  = 'EA'
    OR ITEMTYPE = 'HALB'



/************** 실습 ******************************
품목 마스터 테이블에서 
WHCDOE(창고코드) 가 'WH003' 이고 'WH008' 인 데이터 중
BASEUNIT(단위) 가 'KG' 인 
ITEMCODE(품목), WHCODE(창고) , BASEUNIT(단위)
컬럼을 조회 하세요 */ 
SELECT ITEMCODE,
       WHCODE,  
	   BASEUNIT
 FROM TB_ITEMMASTER
WHERE BASEUNIT = 'KG'
  AND (WHCODE = 'WH003' OR WHCODE = 'WH008')



/*********************************************************************
4. 관계 연산자의 사용 
  . 검색 조건에 시작 과 종료(범위) 에 대한 정보를 입력하여 원하는 결과를 조회
    보통은 기간이나 숫자를 검색 하지만 문자의 정렬 기준도 검색 가능하고 
	시간 단위도 검색이 가능 하다.
*/

 -- ** 기간 관계 연산 검색
 -- 특정 문자 데이터의 기간이 설정 되어있는 값에 시작과 종료 를 조건으로 검색할수있다.
 -- EDITDATE : 사용자가 수정하는 일시

 SELECT *
   FROM TB_ItemMaster
  WHERE EDITDATE >= '2020-08-01'
    AND EDITDATE <= '2023-01-01'


-- 수 를 입력 한 관계 연산
-- MAXSTOCK : 품목 별로 최대 적재 량(최대 재고량)
 SELECT * 
   FROM TB_ItemMaster
  WHERE MAXSTOCK > 10
    AND MAXSTOCK <= 20;

SELECT * 
   FROM TB_ItemMaster
  WHERE MAXSTOCK > '10'
    AND MAXSTOCK <= '20';



-- ** 문자 관계 연산 검색
-- INSPFLAG : 수입검사 여부 
SELECT *
  FROM TB_ItemMaster
 WHERE INSPFLAG = 'U'

-- 검사 여부가 U 가 아닌값을 모두 검색
SELECT *
  FROM TB_ItemMaster 
 WHERE INSPFLAG <> 'U'

SELECT * 
  FROM TB_ItemMaster
 WHERE MAXSTOCK <> 10


-- ** INSPFLAG 컬럼 이 B 부터 U 까지 의 값을 가진 내역을 조회
SELECT * 
  FROM TB_ItemMaster
 WHERE INSPFLAG > 'A'
   AND INSPFLAG <= 'U'
   
-- ***** BETWEEN 관계 연산자 절.
-- * 초과 와 미만 범위는 설정 할 수 없다. 
-- 품목 마스터 테이블 에서 MAXSTOCK 에 10 이상 20이하 인 데이터 를 모두 검색
SELECT *  
  FROM TB_ItemMaster
 WHERE MAXSTOCK BETWEEN 10 AND 20


 /** 실습 **

WHCODE : 창고 코드 ,  UNITCOST : 단가,  INSPFLAG : 검사여부 (I : 검사)
PLANTCODE : 공장코드 


품목 마스터 테이블 에서 
WHCODE 가 WH002 ~ WH005 이며
UNITCOST 가 1000 을 초과하는 값을 가지고 
INSPFLAG 가 I 가 아닌 데이터 행의
PLANTCODE, ITEMCODE, WHCODE, UNITCOST, INSPFLAG 컬럼을 조회 하세요. */

SELECT PLANTCODE,
	   ITEMCODE,
	   UNITCOST,
	   INSPFLAG
  FROM TB_ITEMmaster
 WHERE WHCODE BETWEEN 'WH002' AND 'WH005'
   AND UNITCOST > 1000
   AND INSPFLAG <> 'I'



/**************************************************************************************
 5. 특정 컬럼 검색 조건 N 개로 지정하여 조회 (IN , NOT IN)  빈도수 ***
   - 특정 컬럼이 포함하고 있는 데이터 중 검색하고자 하는 조건이 많을때 사용. 
*/

/*
	품목 마스터 테이블 에서 
	ITEMCODE 와 ITEMTYPE , MAXSTOCK 컬럼을 조회 하는데.
	MAXSTOCK 의 수가 1 이상 3000 이하인 것 중에 
	ITEMTYPE 이 'FERT' 'HALB' 인 데이터 만 조회

	FERT : 완제품 , HALB : 반제품.
*/

SELECT ITEMCODE, 
	   ITEMTYPE, 
	   MAXSTOCK
  FROM TB_ItemMaster
 WHERE MAXSTOCK BETWEEN 1 AND 3000
   AND ITEMTYPE IN ('FERT','HALB') -- (ITEMTYPE = 'FERT' OR ITEMTYPE = 'HALB')


/* 컬럼의 데이터 중 특정 데이터를 제외 하고 검색 NOT IN

	품목 마스터 에서 
	ITEMCODE, ITEMTYPE, MAXSTOCK 컬럼을 조회하는데
	MAXSTOCK 의 수가 1 이상 3000 이하 이고 
	ITETTPYE 이 'FERT' ,'HALB' 가 아닌데이터만 조회
*/
SELECT * 
  FROM TB_ItemMaster
 WHERE MAXSTOCK BETWEEN 1 AND 3000
   AND ITEMTYPE NOT IN ('FERT','HALB') -- AND (ITEMTYPE <> 'FERT' AND ITETYPE <> 'HALB')



/* 실습 *****************************
  품목 마스터 테이블 에서 
  CARTYPE 컬럼의 값이 TL, LM 이고
  WHCODE 컬럼의 값이 WH004 ~ WH007 사이에 있는것 중
  ITEMTYPE 이 HALB 가 아닌 
  ITEMCODE, ITENAME, ITEMTYPE, WHCODE, CARTYPE 컬럼의 데이터 를 모두 검색하세요.

  CARTYPE : 차종
  WHCODE  : 창고 
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
   

