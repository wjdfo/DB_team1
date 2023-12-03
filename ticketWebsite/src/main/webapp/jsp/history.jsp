<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page import="com.db.DBManager" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>History</title>
	<link rel="stylesheet" href="../styles/history.css">
</head>
<body>
	<h2>예매내역</h2>
	<div class = "history-container">
		<% 
			String id = (String) session.getAttribute("login_id");
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
				conn = DBManager.getConnection();
				String sql = 
						"select c.concert_name, c.con_date, c.place, r.no_seat, c.price, r.payment"
						+ " from receipt r, concert c where c.concert_id = r.concert_id and r.customer_id = ?"
						+ " order by c.con_date";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, id);
				rs = pstmt.executeQuery();
		%>
			<table cellspacing = "30">
		<%
				ResultSetMetaData rsmd = rs.getMetaData();
				int cnt = rsmd.getColumnCount();
				if (cnt >= 1){
					out.println("<th align = \"center\">공연 이름</th>");
					out.println("<th align = \"center\">날짜</th>");
					out.println("<th align = \"center\">장소</th>");
					out.println("<th align = \"center\">좌석 번호</th>");
					out.println("<th align = \"center\">가격</th>");
					out.println("<th align = \"center\">결제 방식</th>");
				}
				
				while (rs.next()){
					out.println("<tr>");
					out.println("<td align = \"center\">"+rs.getString(1)+"</td>");
					out.println("<td align = \"center\">"+rs.getString(2).substring(0,10)+"</td>");
					out.println("<td align = \"center\">"+rs.getString(3)+"</td>");
					out.println("<td align = \"center\">"+rs.getString(4)+"</td>");
					out.println("<td align = \"center\">"+rs.getString(5)+"</td>");
					out.println("<td align = \"center\">"+rs.getString(6)+"</td>");
					out.println("</tr>");
				}
				out.println("</table>");
			}catch(SQLException e){
				e.printStackTrace();
			}
			
		%>
		<h4>문의 사항은 admin@admin.com으로 문의해주세요.</h4>
		
		<div class = "back-to-main">
			<a href = "../mypage.html">메인 페이지로 돌아가기</a>
		</div>
	</div>
	
</body>
</html>