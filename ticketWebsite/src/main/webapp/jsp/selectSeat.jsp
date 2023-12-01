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
            } finally {
                // Close resources
                try {
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return availableSeats;
        }
    %>

    <%
        int concertID = Integer.parseInt(request.getParameter("concertID"));
        // Retrieve available seats for the selected concert
        List<Integer> availableSeats = getAvailableSeats(concertID);
    %>

    <%-- HTML --%>
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

    <%-- Payment method selection section --%>
    <% 
        // Java code for payment method selection and database updates
        // This involves handling user input for payment and updating the database with the selected seat and payment method
        // You'll need to implement this section based on your provided logic
        // ...
    %>

    <script>
        // JavaScript code for seat selection interaction (if needed)
        // This may include handling user click on seats, displaying payment options, etc.
        // ...
    </script>
</body>
</html>
