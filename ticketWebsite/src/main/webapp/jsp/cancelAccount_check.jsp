<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page import="com.db.DBManager" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>cancelAccount_check</title>
</head>
<body>
     <%
            Connection conn = null;
    	    Statement stmt = null;
            ResultSet rs = null;
            String sql = "";
            StringBuffer sb = null;
            
            String id = (String) session.getAttribute("login_id");
            String pw = "";
            
 			request.setCharacterEncoding("UTF-8");
		    String input_pw = request.getParameter("pw");
            

            try {
                    conn = DBManager.getConnection();
                    stmt = conn.createStatement();
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            
            sb = new StringBuffer();
        	sb.append("SELECT pw\n");
        	sb.append("FROM customer\n");
        	sb.append("WHERE customer_id = " + id);
        	sql = sb.toString();
        	rs = stmt.executeQuery(sql);
        	while(rs.next()){
        		pw = rs.getString(1);	
        	}
        	
        	if(pw.compareTo(input_pw) != 0){
        		out.println("비밀번호가 일치하지 않습니다. <br>");
        		out.println("<a href=\"cancelAccount.jsp\"> << 뒤로 돌아가기</a> ");
        	}
        	else if(pw.compareTo(input_pw) == 0){
        		try {
    	            sb = new StringBuffer();
    	            sb.append("DELETE FROM CUSTOMER WHERE CUSTOMER_ID = " + id); 
    	            sql = sb.toString();
    	            stmt.executeUpdate(sql);
    	            out.println("회원탈퇴가 완료되었습니다. <br>");
    	            out.println("<a href=\"../index.html\"> << 홈으로 돌아가기</a> ");
    	         }catch (SQLException e) {
    	            e.printStackTrace();
    	         }
        	}
        	
            	
        %>


</body>
</html>