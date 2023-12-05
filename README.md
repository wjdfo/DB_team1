# DB_team1
KNU comp0322-005

공연 티켓 예약 시스템


1. Application 제작 환경

•	IDE : Eclipse IDE for Enterprise

•	Language : Java (JSP), HTML, CSS

•	DBMS : Oracle SQL

•	OS : Windows

•	Server : Tomcat v8.5 Server (local 환경)


2. 실행 방법

•	git clone https://github.com/wjdfo/DB_team1

• src/main/java/com/db/DBManager.java 파일을 열리고 DB_USER / DB_PASSWORD를 설치된 데이타베이스의 이름/비밀번호로 바꾸기

•	Team1/DB_team1/ticketWebsite/src/main/webapp/index.html 파일에서 서버 실행 


3. 사용 방법

•	홈페이지(로그인 전 페이지)에서 navigator bar를 클릭하면 introPage로 이동. 사용자가 로그인해야 다른 기능을 이용할 수 있음

•	ID가 없으면 회원가입 후 이용

•	로그인 : 일반 사용자 로그인 후 여러 기능 이용

•	로그인 : 관리자 ( ID : 10000 / PW : comp322 ) 로그인 후 여러 조회 기능 이용

•	로그인 : 블랙리스트에 등록된 사용자의 경우, 데이터베이스에서 사용자 블랙리스트 정보 가져오기. (예: ID : 196 / PW : dkr3d05)

•	티켓 예매 기능: 마이 페이지에서 뮤지컬/콘서트/스포츠/뮤직/영화 중 원하는 장르 선택 => 출력된 공연 리스트 중에 “예약불가”로 표시된 공연들은 티켓 예매 기간이 지나갔다는 의미 => “예약하기” 버튼 클릭 => 좌석 선택 => 결제방법 선택 => “결제하기” 버튼 클릭 => 예매 성공 => 예매내역 확인

•	동시에 2개 이상 ID는 같은 공연, 같은 좌석을 예약하는 경우 먼저 1개 ID가 예약 성공한다면 남은 ID를 예약 불가, 해당 좌석을 계속 선택하면 페이지가 멈춤. 다른 좌석을 선택 시 정상적으로 예매 가능

•	추천 기능: 마이 페이지에서 “추천 공연” 버튼을 클릭하면 5개 추천 공연을 확인할 수 있음 => “좌석 선택” 클릭하면 원하는 공연의 좌석 선택 단계로 이동

•	회원 정보 수정, 회원탈퇴: 정보를 변경하거나 회원탈퇴 후 관리자 기능을 이용하여 확인하거나 데이타베이스 확인


4. 사용자가 알아야 할 내용

•	HTML에서 JSP로 입력값을 넘겨줄 때, 인코딩 방식이 달라서 한글이 깨지는 문제가 발생

-> request.setCharacterEncoding("UTF-8"); 코드를 이용해 해결

•	이 시스템은 티켓 오픈일과 마감일을 현재 날짜와 비교하기 때문에 모든 티켓이 만료되는 경우가 있다. 그 때 DB의 concert 테이블의 tic_start, tic_end, con_date 업그레이드해야 함
