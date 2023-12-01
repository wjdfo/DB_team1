<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page language="java" contentType="text/html; charset=EUC-KR" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="EUC-KR">
    <title>Login</title>
    <link rel="stylesheet" href="../styles/login.css">
</head>
<body>
    <div class="login-container">
        <%
            if (request.getMethod().equalsIgnoreCase("post")) {
                String id = request.getParameter("id");
                String password = request.getParameter("password");
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    String jdbcURL = "jdbc:oracle:thin:@localhost:1521:orcl";
                    String dbUser = "concertTicket";
                    String dbPassword = "concertTicket";

                    Class.forName("oracle.jdbc.driver.OracleDriver");
                    conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

                    // Creating the SQL query to check login credentials
                    String sql = "SELECT * FROM CUSTOMER WHERE customer_id =? AND pw=?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, id);
                    pstmt.setString(2, password);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        // Login successful -> go on ticketing.jsp
                        out.println("<h2>Login Successful!</h2>");
                        response.sendRedirect("ticketing.jsp");
                    } else {
                        // Login failed
                        out.println("<h2>Login Failed. Please input again.</h2>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                	// Closing the resources
                	rs.close();
                	pstmt.close();
                	conn.close();
                }
            }
        %>

        <form id="loginForm" class="login-form" method="post">
            <h2>Login</h2>
            <div class="input-group">
                <label for="id">ID:</label>
                <input type="text" id="id" name="id" required>
            </div>
            <div class="input-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit">Login</button>
            <p id="error" class="error-message"></p>
        </form>
    </div>
</body>
</html>
