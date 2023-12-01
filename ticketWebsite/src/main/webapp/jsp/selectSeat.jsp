<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page import="com.db.DBManager" %>
<%@ page language="java" contentType="text/html; charset=EUC-KR" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="EUC-KR">
    <title>Ticket Reservation</title>
    <link rel="stylesheet" href="../styles/selectSeat.css">
</head>
<body>
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
        int concertID = Integer.parseInt(request.getParameter("concertID"));
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
    <p>Concert Name: <%= concertName %></p>
    <p>Concert Date: <%= con_date %></p>
    <h3>Available seat:</h3>
    <div class="seat-selection">
        <% 
            int totalSeats = 50;
            for (int seat = 1; seat <= totalSeats; seat++) {
                boolean isAvailable = availableSeats.contains(seat);
                String seatClass = isAvailable ? "available" : "unavailable";
	        %>
		        <div class="seat <%= seatClass %>">
		            <%= seat %>
		        </div>
	        <% 
            }
        %>
    </div>

</body>
</html>
