<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page import="com.db.DBManager" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Recommendation</title>
</head>
<body>
	<div class = "Recommendation_container">
	<% 
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String history = "";
		String favor = "";
		String id = (String) session.getAttribute("login_id");
		try {
			conn = DBManager.getConnection();
			String sql = "select history from recommendation where customer_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				history = rs.getString(1);
				out.println("<h4>최근 예매한 콘서트 : "+history+"</h4>");
			}
			
			sql = "SELECT Favor FROM CUSTOMER WHERE Customer_ID = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) favor = rs.getString(1);
			
			
			out.println("<h4>선호 장르 : "+favor+"</h4>");
			
			sql = "SELECT Concert_Name, tic_start, tic_end, con_date, price, place, concert_ID FROM (SELECT * FROM CONCERT WHERE Genre = '" + favor + "' ORDER BY dbms_random.value) WHERE ROWNUM <= 5";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			out.println("<table cellspacing = \"30\">");
			out.println("<th align = \"center\">공연 이름</th>");
			out.println("<th align = \"center\">예매 시작일</th>");
			out.println("<th align = \"center\">예매 종료일</th>");
			out.println("<th align = \"center\">공연 날짜</th>");
			out.println("<th align = \"center\">가격</th>");
			out.println("<th align = \"center\">장소</th>");
			out.println("<th align = \"center\">예매하기</th>");
			
			while(rs.next()){
				out.println("<tr>");
				out.println("<td align = \"center\">"+rs.getString(1)+"</td>");
				out.println("<td align = \"center\">"+rs.getString(2).substring(0,10)+"</td>");
				out.println("<td align = \"center\">"+rs.getString(3).substring(0,10)+"</td>");
				out.println("<td align = \"center\">"+rs.getString(4).substring(0,10)+"</td>");
				out.println("<td align = \"center\">"+rs.getString(5)+"</td>");
				out.println("<td align = \"center\">"+rs.getString(6)+"</td>");
	%>
		<td align = "center">
			<a href = "selectSeat.jsp?concertID=<%= rs.getString(7) %>">좌석 선택</a>
		</td>
	<%
				out.println("</tr>");
			}
			out.println("</table>");
			
		}catch(SQLException e){
			e.printStackTrace();
		}
		
	%>
		</br>
		</br>
		
		<div class = "back-to-main">
			<a href = "../mypage.html">메인 페이지로 돌아가기</a>
		</div>
	</div>
</body>
</html>