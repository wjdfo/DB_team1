<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page import="com.db.DBManager" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Admin Page</title>
	<link rel="stylesheet" href="../styles/admin_func.css">
</head>
<body>
	<div class = "aggr-container">
		<%
			Connection conn = null;
		    PreparedStatement pstmt = null;
	 	    ResultSet rs = null;
	 	   	int i = 0;
	 	    String sql = null;
	 	    String opt = null;
	    	conn = DBManager.getConnection();
	    	
	    	request.setCharacterEncoding("UTF-8");
			
			if (request.getParameter("Opt").compareTo("concert") == 0){
				if (request.getParameter("sub_option").compareTo("All") == 0){ //전체 공연 매출 확인
					out.println("<h2>전체 공연 매출 확인</h2>");
					sql = "SELECT C.CONCERT_NAME, C.CON_DATE, SUM(S.PRICE) FROM SALE_REPORT S, CONCERT C"
					   		+ " WHERE S.CONCERT_ID = C.CONCERT_ID GROUP BY C.CONCERT_NAME, C.CON_DATE"
					   		+ " ORDER BY SUM(S.PRICE) DESC";
					pstmt = conn.prepareStatement(sql);
					rs = pstmt.executeQuery();
					
					out.println("<table cellspacing = \"20\">");
					out.println("<th align = \"center\">공연 이름</th>");
					out.println("<th align = \"center\">공연 날짜</th>");
					out.println("<th align = \"center\">총 판매 가격</th>");
					
					while(rs.next()){
						out.println("<tr>");
						out.println("<td align = \"center\">"+rs.getString(1)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(2).substring(0,10)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(3)+"</td>");
						i++;
					}
				}
				else if (request.getParameter("sub_option").compareTo("Top") == 0){
					out.println("<h2>Top-K 매출 확인</h2>");
					opt = request.getParameter("Input");
					sql = "SELECT ROWNUM AS RANK, CONCERT_NAME, SUM_PRICE FROM (SELECT C.CONCERT_NAME, C.CON_DATE, SUM(S.PRICE) AS SUM_PRICE"
							 + " FROM SALE_REPORT S, CONCERT C WHERE S.CONCERT_ID = C.CONCERT_ID GROUP BY C.CONCERT_NAME, C.CON_DATE"
							 + " ORDER BY SUM(S.PRICE) DESC) WHERE ROWNUM <= ?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, opt);
					rs = pstmt.executeQuery();
					
					out.println("<table cellspacing = \"20\">");
					out.println("<th align = \"center\">순위</th>");
					out.println("<th align = \"center\">공연 이름</th>");
					out.println("<th align = \"center\">총 판매 가격</th>");
					
					while(rs.next()){
						out.println("<tr>");
						out.println("<td align = \"center\">"+rs.getString(1)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(2)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(3)+"</td>");
						i++;
					}
					
				}
				else if (request.getParameter("sub_option").compareTo("Seat") == 0){
					out.println("<h2>좌석 판매 정보</h2>");
					sql = "SELECT C.CONCERT_ID, C.CONCERT_NAME, C.CON_DATE, COUNT(*) AS Selled_ticket_EA"
							+ " FROM CONCERT C, SALE_REPORT S WHERE C.CONCERT_ID = S.CONCERT_ID"
							+ " GROUP BY C.CONCERT_ID, C.CONCERT_NAME, C.CON_DATE ORDER BY Selled_ticket_EA DESC";
					pstmt = conn.prepareStatement(sql);
					rs = pstmt.executeQuery();
					
					out.println("<table cellspacing = \"20\">");
					out.println("<th align = \"center\">공연 ID</th>");
					out.println("<th align = \"center\">공연 이름</th>");
					out.println("<th align = \"center\">공연 날짜</th>");
					out.println("<th align = \"center\">판매 좌석 수</th>");
					
					while(rs.next()){
						out.println("<tr>");
						out.println("<td align = \"center\">"+rs.getString(1)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(2)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(3).substring(0,10)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(4)+"</td>");
						i++;
					}
				}
				else if (request.getParameter("sub_option").compareTo("con_Id") == 0){
					out.println("<h2>공연 ID로 공연 확인</h2>");
					opt = request.getParameter("Input");
					sql = "select concert_id, concert_name, con_date from concert where concert_id = ?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, opt);
					rs = pstmt.executeQuery();
					
					out.println("<table cellspacing = \"20\">");
					out.println("<th align = \"center\">공연 ID</th>");
					out.println("<th align = \"center\">공연 이름</th>");
					out.println("<th align = \"center\">공연 날짜</th>");
					
					while(rs.next()){
						out.println("<tr>");
						out.println("<td align = \"center\">"+rs.getString(1)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(2)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(3).substring(0,10)+"</td>");
						i++;
					}
				}
				else if (request.getParameter("sub_option").compareTo("avg_con") == 0){
					out.println("<h2>공연별 평균 판매 가격 확인</h2>");
					sql = "select c.concert_name, round(avg(s.price), 1) as avg_price from sale_report s, concert c "
					   		+ "where s.concert_id = c.concert_id group by c.concert_name order by avg_price DESC";
					pstmt = conn.prepareStatement(sql);
					rs = pstmt.executeQuery();
					
					out.println("<table cellspacing = \"20\">");
					out.println("<th align = \"center\">공연 이름</th>");
					out.println("<th align = \"center\">평균 판매 가격</th>");
					
					while(rs.next()){
						out.println("<tr>");
						out.println("<td align = \"center\">"+rs.getString(1)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(2)+"</td>");
						i++;
					}
				}
				
			}
			else if (request.getParameter("Opt").compareTo("blacklist") == 0){
				if (request.getParameter("sub_option").compareTo("user_Id") == 0){
					out.println("<h2>블랙리스트 ID 검색</h2>");
					opt = request.getParameter("Input");
					sql = "select * from blacklist where customer_id = ?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, opt);
					rs = pstmt.executeQuery();
					
					out.println("<table cellspacing = \"20\">");
					out.println("<th align = \"center\">사용자 ID</th>");
					out.println("<th align = \"center\">전화번호</th>");
					out.println("<th align = \"center\">날짜</th>");
					out.println("<th align = \"center\">사유</th>");
					
					while(rs.next()){
						out.println("<tr>");
						out.println("<td align = \"center\">"+rs.getString(1)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(2)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(3).substring(0,10)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(4)+"</td>");
						i++;
					}
				}	
				else if (request.getParameter("sub_option").compareTo("Reason") == 0){
					out.println("<h2>블랙리스트 사유 검색</h2>");
					String[] a = {"지속적인 취소", "티켓 재판매", "일치하지 않은 정보", "지속적인 불참", "가짜 티켓", "스팸 또는 과도한 요청"};
					opt = request.getParameter("Input");
					sql = "select c.name, c.sex, c.age, b.reason, b.black_start from blacklist b, customer c where c.customer_id = b.customer_id and b.reason"
						+ " in (?)";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1,a[Integer.valueOf(opt)-1]);
					rs = pstmt.executeQuery();
					
					out.println("<table cellspacing = \"20\">");
					out.println("<th align = \"center\">사용자 이름</th>");
					out.println("<th align = \"center\">성별</th>");
					out.println("<th align = \"center\">나이</th>");
					out.println("<th align = \"center\">사유</th>");
					out.println("<th align = \"center\">시작 날짜</th>");
					
					while(rs.next()){
						out.println("<tr>");
						out.println("<td align = \"center\">"+rs.getString(1)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(2)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(3)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(4)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(5).substring(0,10)+"</td>");
						i++;
					}
				}
				else if (request.getParameter("sub_option").compareTo("Date") == 0){
					out.println("<h2>블랙리스트 시작 날짜 검색</h2>");
					opt = request.getParameter("Input");
					sql = "select c.name, b.phone, c.addr, c.email, b.black_start from blacklist b, customer c where black_start <= to_date('"+opt+"', 'yyyy-mm-dd') and b.customer_id = c.customer_id order by b.black_start";
					pstmt = conn.prepareStatement(sql);
					rs = pstmt.executeQuery();
					
					out.println("<table cellspacing = \"20\">");
					out.println("<th align = \"center\">사용자 이름</th>");
					out.println("<th align = \"center\">전화번호</th>");
					out.println("<th align = \"center\">주소</th>");
					out.println("<th align = \"center\">이메일</th>");
					out.println("<th align = \"center\">시작 날짜</th>");
					
					while(rs.next()){
						out.println("<tr>");
						out.println("<td align = \"center\">"+rs.getString(1)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(2)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(3)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(4)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(5).substring(0,10)+"</td>");
						i++;
					}
				}
			}
			else if (request.getParameter("Opt").compareTo("customer") == 0){
				if (request.getParameter("sub_option").compareTo("Name") == 0){
					out.println("<h2>사용자 이름 검색</h2>");
					opt = request.getParameter("Input");
					out.println("!!! "+ opt + "!!!");
					sql = "select * from customer where name LIKE '%"+opt+"%'";
					pstmt = conn.prepareStatement(sql);	
					rs = pstmt.executeQuery();
					
					out.println("<table cellspacing = \"20\">");
					out.println("<th align = \"center\">사용자 ID</th>");
					out.println("<th align = \"center\">이름</th>");
					out.println("<th align = \"center\">전화번호</th>");
					out.println("<th align = \"center\">주소</th>");
					out.println("<th align = \"center\">이메일</th>");
					out.println("<th align = \"center\">나이</th>");
					out.println("<th align = \"center\">성별</th>");
					out.println("<th align = \"center\">선호 장르</th>");
					
					while(rs.next()){
						out.println("<tr>");
						out.println("<td align = \"center\">"+rs.getString(1)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(2)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(3)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(4)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(5)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(6)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(7)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(8)+"</td>");
						i++;
					}
				}
				else if (request.getParameter("sub_option").compareTo("His") == 0){
					out.println("<h2>사용자 ID로 구매 내역 검색</h2>");
					opt = request.getParameter("Input");
					sql = "select con.concert_id, con.concert_name, sum(con.price), count(*) from concert con, customer c, receipt r"
					   		+ " where con.concert_id = r.concert_id and r.customer_id = c.customer_id and c.customer_id = ? group by con.concert_id, con.concert_name";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, opt);
					rs = pstmt.executeQuery();
					
					out.println("<table cellspacing = \"20\">");
					out.println("<th align = \"center\">공연 ID</th>");
					out.println("<th align = \"center\">공연 이름</th>");
					out.println("<th align = \"center\">총 가격</th>");
					out.println("<th align = \"center\">ticket EA</th>");
					
					while(rs.next()){
						out.println("<tr>");
						out.println("<td align = \"center\">"+rs.getString(1)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(2)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(3)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(4)+"</td>");
						i++;
					}
				}
				else if (request.getParameter("sub_option").compareTo("Aggr") == 0){
					out.println("<h2>사용자별 구매 내역 집계</h2>");
					sql = "select c.customer_id, c.name, sum(con.price), count(*) from receipt r, customer c, concert con "
					   		+ "where c.customer_id = r.customer_id and r.concert_id = con.concert_id group by c.name, c.customer_id order by sum(con.price) desc";
					pstmt = conn.prepareStatement(sql);
					rs = pstmt.executeQuery();
					
					out.println("<table cellspacing = \"20\">");
					out.println("<th align = \"center\">사용자 ID</th>");
					out.println("<th align = \"center\">이름</th>");
					out.println("<th align = \"center\">소비한 금액</th>");
					out.println("<th align = \"center\">구매한 티켓 수</th>");
					
					while(rs.next()){
						out.println("<tr>");
						out.println("<td align = \"center\">"+rs.getString(1)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(2)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(3)+"</td>");
						out.println("<td align = \"center\">"+rs.getString(4)+"</td>");
						i++;
					}
				}
			}
			else {
				out.println("<h3>기록이 없습니다.</h3>");
			}
			
			if ( i == 0 ){
				out.println("<h3>검색 결과가 없습니다.</h3>");
			}
			else {
				String temp = String.valueOf(i);
				out.println("<h3>검색 결과 총 " + temp + "건</h3>");
			}
			
		%>
	</div>
<div class = "return">
<a href = "Admin.jsp">관리자 페이지</a>
</div>
</body>
</html>