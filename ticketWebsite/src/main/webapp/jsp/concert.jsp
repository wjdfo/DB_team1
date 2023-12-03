<%@ page import="java.sql.*, java.io.*, java.util.*, java.time.LocalDate" %>
<%@ page import="com.db.DBManager" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <title>Concert Event Reservation</title>
    <link rel="stylesheet" href="../styles/musical.css">
</head>
<body>
	<h2>콘서트 티켓 예약</h2>
	<h3 style="margin-left: 20%;">다가오는 콘서트들</h3>
	<div class="concerts-container">
	    <%
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        try {
	            conn = DBManager.getConnection();
	            String query = "SELECT Concert_ID, Concert_Name, Con_date, Tic_start, Tic_end, Place, Price FROM CONCERT WHERE genre='concert'";
	            pstmt = conn.prepareStatement(query);
	            rs = pstmt.executeQuery();
	            while (rs.next()) {
	            	int concertID = rs.getInt(1);
	                String concertName = rs.getString(2);
	                java.sql.Date conDate = rs.getDate(3);
	                java.sql.Date ticStart = rs.getDate(4);
	                java.sql.Date ticEnd = rs.getDate(5);
	                String place = rs.getString(6);
	
	                // Formatting dates
	                java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("dd/MM/yyyy");
	                String formattedConDate = dateFormat.format(conDate);
	                
	                java.text.SimpleDateFormat dateFormat2 = new java.text.SimpleDateFormat("dd/MM");
	                String formattedTicStart = dateFormat2.format(ticStart);
	                String formattedTicEnd = dateFormat2.format(ticEnd);
	                
	                //check date
	                LocalDate today = LocalDate.now();
	                LocalDate ticketStartDate = ticStart.toLocalDate();
	                LocalDate ticketEndDate = ticEnd.toLocalDate();
	                if (today.isBefore(ticketStartDate) || today.isAfter(ticketEndDate)) {
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
	                            <span class="impossible-text" style = "color:red; font-size: 12px">예약 불가</span>
	                        </div>
	                    </div>
	                <%
	                }else{
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