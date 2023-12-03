<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page import="com.db.DBManager" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Blacklist</title>
</head>
<body>
	<h2>블랙리스트 정보</h2>
	<div class = "blacklist-container">
		<%
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String id = (String) session.getAttribute("login_id");
			
			try {
				conn = DBManager.getConnection();
				String sql = "select black_start, reason from blacklist where customer_id = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, id);
				rs = pstmt.executeQuery();
				
				if (rs.next()){
					String black_start = rs.getString(1).substring(0,10);
					String reason = rs.getString(2);
					
					out.println("시작일: "+black_start);
					out.println("</br>");
					out.println("사유 : " + reason);
					out.println("</br>");
				}}catch (SQLException e) {
					e.printStackTrace();
				}
		%>
		<br/>
		<br/>
		<h4>문의 사항은 admin@admin.com으로 문의해주세요.</h4>
	
		<div class = "back-to-login">
			<a href = "login.jsp">로그인 페이지로 돌아가기</a>
		</div>
	</div>
</body>
</html>