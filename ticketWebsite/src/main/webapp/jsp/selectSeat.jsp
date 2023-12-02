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
	<%	
		//receive login_id from login.jsp 
	    Integer received_login_id = (Integer) session.getAttribute("login_id");
    	int login_id = received_login_id != null ? received_login_id : -1; 
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
                    availableSeats.add(availableSeatsResult.getInt("Seat_num"));
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
                    concertName = concertInfoResult.getString("Concert_Name");
                    concertPrice = concertInfoResult.getInt("Price");
                    con_date = concertInfoResult.getDate("Con_date");
                    place = concertInfoResult.getString("Place");
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
    <h2>Ticket Reservation</h2>
    <p>Customer ID : <%= login_id %></p>
    <p>Concert Name: <%= concertName %></p>
    <p>Concert Date: <%= con_date %></p>
    <p>Price: <%= concertPrice %>¿ø</p>
    <h3>Available seat:</h3>
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
    <p id="selectedSeatDisplay">Select Seat: </p>
    
	<!-- Payment Method Section -->
    <div id="paymentMethod" style="display: none;">
        <h3>Select Payment Method:</h3>
        <form action="updateDatabase.jsp" method="post" id="paymentForm">
            <label><input type="radio" name="payment" value="CASH"> CASH</label><br>
            <label><input type="radio" name="payment" value="CARD"> CARD</label><br>
            <input type="hidden" id="selectedSeatInput" name="selectedSeat" value="">
            <input type="hidden" name="concertID" value="<%= concertID %>">
            <input type="hidden" name="login_id" value="<%= login_id %>">
            <button type="submit">Submit Payment</button>
        </form>
    </div>
    
    <% 
	    // Retrieve the message from updateDatabase.jsp through session
	    String reservationMessage = (String) session.getAttribute("reservationMessage");
	    session.removeAttribute("reservationMessage"); //Clear the message from the session
	    // Display the message
	    if (reservationMessage != null) {
	        out.println("<h2>" + reservationMessage + "</h2>");
	    }
	%>
    <script>
        function selectSeat(seat) {
            var selectedSeatDisplay = document.getElementById('selectedSeatDisplay');
            var seatElement = document.getElementById('seat' + seat);

            if (seatElement.classList.contains('unavailable')) {
                selectedSeatDisplay.textContent = 'Cannot select this seat.';
            } else {
                selectedSeatDisplay.textContent = 'Select Seat: ' + seat;
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
