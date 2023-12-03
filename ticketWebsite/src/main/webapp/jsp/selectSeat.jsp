<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page import="com.db.DBManager" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ticket Reservation</title>
    <link rel="stylesheet" href="../styles/selectSeat.css">
</head>
<body>
    <%  //received login_id from login.jsp
        String received_login_id = (String) session.getAttribute("login_id");
        int login_id = -1;
        if (received_login_id != null && !received_login_id.isEmpty()) {
            login_id = Integer.parseInt(received_login_id);
        }
    %>
    <%!
        public List<Integer> getAvailableSeats(int concertID) {
            List<Integer> availableSeats = new ArrayList<>();
            Connection conn = null;
            Statement stmt = null;
            try {
                conn = DBManager.getConnection();
                stmt = conn.createStatement();
                String getAvailableSeatsQuery = "SELECT Seat_num FROM SEAT WHERE Concert_ID = " + concertID + " AND Available = 'O'";
                ResultSet availableSeatsResult = stmt.executeQuery(getAvailableSeatsQuery);
                while (availableSeatsResult.next()) {
                    availableSeats.add(availableSeatsResult.getInt(1));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            return availableSeats;
        }
    %>

    <%
        int concertID = -1;
        String concertIDstr = request.getParameter("concertID");
        if (concertIDstr != null && !concertIDstr.isEmpty()) {
            try {
                concertID = Integer.parseInt(concertIDstr);
            } catch (NumberFormatException e) {
                e.printStackTrace(); 
            }
        }
        // Retrieve available seats for the selected concert
        List<Integer> availableSeats = getAvailableSeats(concertID);
        Connection conn = null;
        Statement stmt = null;
        String concertName = "";
        int concertPrice = -1;
        String place = "";
        java.util.Date con_date = null;
        try {
            conn = DBManager.getConnection();
            stmt = conn.createStatement();
            try {
                //Retrieve concert info
                String getConcertInfoQuery = "SELECT Concert_Name, Price, Con_date, Place FROM CONCERT WHERE Concert_ID = " + concertID;
                ResultSet concertInfoResult = stmt.executeQuery(getConcertInfoQuery);

                if (concertInfoResult.next()) {
                    concertName = concertInfoResult.getString(1);
                    concertPrice = concertInfoResult.getInt(2);
                    con_date = concertInfoResult.getDate(3);
                    place = concertInfoResult.getString(4);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    %>

    <!-- HTML -->
    <div class="reservation-container">
	    <div class="section_1" style="text-align: center;">
	        <h2 style="text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.5); font-weight: bold; color: #333;">티켓 예약</h2>
	    </div>
	    <div class="section_2" style="width: 50%;  margin: 0 auto; background-color: #f2f2f2; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);text-align: center;">
	    	<p>고객 ID : <%= login_id %></p>
		    <p>공연 이름: <%= concertName %></p>
		    <p>진행 날짜: <%= con_date %></p>
		    <p>가격: <%= concertPrice %>원</p>
	    </div>
	    <div class="section_3" >
		    <h3 style="margin-left: 30%;color: rgb(255, 0, 128);">좌석 정보:</h3>
		    <div class="seat-selection">
		        <% 
		            int totalSeats = 50;
		            for (int seat = 1; seat <= totalSeats; seat++) {
		                boolean isAvailable = availableSeats.contains(seat);
		                String seatClass = isAvailable ? "available" : "unavailable";
		            %>
		                 <div id="seat<%= seat %>" class="seat <%= seatClass %>" onclick="selectSeat(<%= seat %>)">
		                    <%= seat %>
		                 </div>
		            <% 
		            }
		        %>
		    </div>
		    <p id="selectedSeatDisplay"  style="text-align: center;"> </p>
		</div>
	    
	    
	    <div class="section_4">
		    <div id="paymentMethod" style="display: none;">
		        <h3 style="margin-left: 30%;color: rgb(255, 0, 128);">결제 방법을 선택하세요:</h3>
		        <form method="post" id="paymentForm">
		            <label><input type="radio" name="payment" value="CASH"> CASH</label><br>
		            <label><input type="radio" name="payment" value="CARD"> CARD</label><br>
		            <input type="hidden" id="selectedSeatInput" name="selectedSeat" value="">
		            <button type="submit">결제하기</button>
		        </form>
		    </div>
	    </div>
	    
    
    <%
        // update database
		if (request.getMethod().equalsIgnoreCase("post")) {
		    String selectedSeatStr = request.getParameter("selectedSeat");
		    String paymentMethod = request.getParameter("payment");
		
		    boolean reservationSuccess = false;
		
		    try {
		        conn = DBManager.getConnection();
		        stmt = conn.createStatement();
		
		        int selectedSeat = -1; 
		        if (selectedSeatStr != null && !selectedSeatStr.isEmpty()) {
		            try {
		                selectedSeat = Integer.parseInt(selectedSeatStr);
		            } catch (NumberFormatException e) {
		                e.printStackTrace(); 
		            }
		        }
		        
		        if (selectedSeat != -1) {
		        	String reserveSeatQuery = "UPDATE SEAT SET Available = 'X' WHERE Concert_ID = " + concertID + " AND Seat_num = " + selectedSeat + " AND Available = 'O'";
	                int rowsUpdated = stmt.executeUpdate(reserveSeatQuery);
	                
	                if (rowsUpdated > 0) {
	                    reservationSuccess = true;

	                    String recordReceiptQuery = "INSERT INTO RECEIPT VALUES (" + concertID + ", " + login_id + ", " + selectedSeat + ", '" + paymentMethod + "')";
	                    stmt.executeUpdate(recordReceiptQuery);

	                    String updateHistoryQuery = "UPDATE RECOMMENDATION SET History = (SELECT Concert_Name FROM CONCERT WHERE Concert_ID = " + concertID + ") WHERE CUSTOMER_ID = " + login_id;
	                    stmt.executeUpdate(updateHistoryQuery);
	                    
	                    out.println("<h2 style=\"color: red; text-align: center;\">티켓 예약 성공</h2>");
	                }
	            } else {
	                out.println("<h2 style=\"color: red; text-align: center;\">좌석 선택이 잘못되었습니다!</h2>");
	            }

	            if (stmt != null) stmt.close();
	            if (conn != null) conn.close();
	            
				// After the reservation -> go to MyPage
	            if (reservationSuccess) { %>
	                <div class="section_5" style="text-align: center;">
	                    <a href="../mypage.html"><button style="padding: 10px 20px; font-size: 13px; background-color: #0078d0; color: #fff; border: none; border-radius: 4px; cursor: pointer; transition: background-color 0.3s;">메인 페이지로 돌아가기</button></a>
	                </div>
	            <% }
	        } catch (SQLException ex) {
	            ex.printStackTrace();
	        }
	    }
	%>
	</div>

    <script>
        function selectSeat(seat) {
            var selectedSeatDisplay = document.getElementById('selectedSeatDisplay');
            var seatElement = document.getElementById('seat' + seat);

            if (seatElement.classList.contains('unavailable')) {
                selectedSeatDisplay.textContent = '해당 좌석을 예약할 수 없습니다. 다른 좌석을 선택하세요';
            } else {
                selectedSeatDisplay.textContent = '선택한 좌석: ' + seat;
                showPaymentMethod();
                document.getElementById('selectedSeatInput').value = seat;
            }
        }

        function showPaymentMethod() {
            var paymentMethodSection = document.getElementById('paymentMethod');
            paymentMethodSection.style.display = 'block';
        }
    </script>

</body>
</html>
