<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page import="com.db.DBManager" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <title>Movie Reservation</title>
    <link rel="stylesheet" href="../styles/musical.css">
</head>
<body>
	<h2>영화 티켓 예약</h2>
	<h3 style="margin-left: 20%;">다가오는 영화들</h3>
	<div class="concerts-container">
	    <%
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        try {
	            conn = DBManager.getConnection();
	            String query = "SELECT Concert_ID, Concert_Name, Con_date, Tic_start, Tic_end, Place, Price FROM CONCERT WHERE genre='movie'";
	            pstmt = conn.prepareStatement(query);
	            rs = pstmt.executeQuery();
	            while (rs.next()) {
	                int concertID = rs.getInt("Concert_ID");
	                String concertName = rs.getString("Concert_Name");
	                java.sql.Date conDate = rs.getDate("Con_date");
	                java.sql.Date ticStart = rs.getDate("Tic_start");
	                java.sql.Date ticEnd = rs.getDate("Tic_end");
	                String place = rs.getString("Place");
	
	                // Formatting dates
	                java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("dd/MM/yyyy");
	                String formattedConDate = dateFormat.format(conDate);
	                
	                java.text.SimpleDateFormat dateFormat2 = new java.text.SimpleDateFormat("dd/MM");
	                String formattedTicStart = dateFormat2.format(ticStart);
	                String formattedTicEnd = dateFormat2.format(ticEnd);
	    %>
	    <div class="concert-info">
		    <div class="concert-details">
		        <div>
		            <div class="concert-date">
		                <%= formattedConDate %>
		            </div>
		            <div class="concertName">
		                <%= concertName %>
		            </div>
		        </div>
		        <div>
		            <div class="ticket-time">
		                예매가능: <%= formattedTicStart %> - <%= formattedTicEnd %>
		            </div>
		            <div class="place">
		                <%= place %>
		            </div>
		        </div>
		    </div>
		    <div class="buy-ticket">
		        <a href="selectSeat.jsp?concertID=<%= concertID %>">예약하기</a>
		    </div>
		</div>
	    <%
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        } finally {
	            // Close resources
	            try {
	                if (rs != null) rs.close();
	                if (pstmt != null) pstmt.close();
	                if (conn != null) conn.close();
	            } catch (SQLException ex) {
	                ex.printStackTrace();
	            }
	        }
	    %>
	</div>
	
</body>
</html>