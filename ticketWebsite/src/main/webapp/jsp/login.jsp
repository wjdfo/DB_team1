<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page import="com.db.DBManager" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <link rel="stylesheet" href="../styles/login.css">
</head>
<body>
    <div class="login-container">
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                if (request.getMethod().equalsIgnoreCase("post")) {
                    String id = request.getParameter("id");
                    String password = request.getParameter("password");
                    
                    session.setAttribute("login_id", id); // 다른 곳에서도 login한 id 정보를 쓰기 위해 session에 넣었습니다.

                    conn = DBManager.getConnection();

                    // Creating the SQL query to check login credentials
                    String sql = "SELECT * FROM CUSTOMER WHERE customer_id = ? AND pw = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, id);
                    pstmt.setString(2, password);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        // Login successful -> go to mypage.html
                        out.println("<h2>Login Successful!</h2>");
                        response.sendRedirect("../mypage.html");
                        int loginId = Integer.parseInt(id);
                        session.setAttribute("login_id", loginId); // Store login_id in session and send to selectSeat.jsp
                        response.sendRedirect("selectSeat.jsp");
                    } else {
                        // Login failed
                        out.println("<h2>Login Failed. Please input again.</h2>");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
            	try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            if (request.getParameter("find_password") != null) {
                response.sendRedirect("findpw.jsp");
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
            <h5>Forgot Password?</h5>
            <a href="<%=request.getRequestURI()%>?find_password=true" class="find-password">Find Password</a>
            <p id="error" class="error-message"></p>
        </form>
    </div>
</body>
</html>
