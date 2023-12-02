<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page import="com.db.DBManager" %>
<%@ page language="java" contentType="text/html; charset=EUC-KR" %>
<%
    String concertID = request.getParameter("concertID");
    String login_id = request.getParameter("login_id");
    String selectedSeat = request.getParameter("selectedSeat");
    String paymentMethod = request.getParameter("payment");

    Connection conn = null;
    Statement stmt = null;

    try {
        conn = DBManager.getConnection();
        stmt = conn.createStatement();

        // Update SEAT table in DB
        String reserveSeatQuery = "UPDATE SEAT SET Available = 'X' WHERE Concert_ID = " + concertID + " AND Seat_num = " + selectedSeat;
        stmt.executeUpdate(reserveSeatQuery);

        // Record the reservation info in the RECEIPT table
        String recordReceiptQuery = "INSERT INTO RECEIPT VALUES (" + concertID + ", " + login_id + ", " + selectedSeat + ", '" + paymentMethod + "')";
        stmt.executeUpdate(recordReceiptQuery);

        // Update HISTORY in the RECOMMENDATION table 
        String updateHistoryQuery = "UPDATE RECOMMENDATION SET History = (SELECT Concert_Name FROM CONCERT WHERE Concert_ID = " + concertID + ") WHERE CUSTOMER_ID = " + login_id;
        stmt.executeUpdate(updateHistoryQuery);

        // send message to selectSeat.jsp
        session.setAttribute("reservationMessage", "Reservation Successful!");
        response.sendRedirect("selectSeat.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        // send message to selectSeat.jsp
        session.setAttribute("reservationMessage", "Reservation Failed. Please try again.");
        response.sendRedirect("selectSeat.jsp");
    } finally {
        try {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
%>
