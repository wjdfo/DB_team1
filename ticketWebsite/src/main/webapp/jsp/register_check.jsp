<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page import="com.db.DBManager" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Register_check</title>
	<script>
	function showAlertAndRedirect(message, url) {
        alert(message);
        window.location.href = url;
    }
    </script>
</head>
<body>
	<%!
		public boolean id_check(String input_id){
		boolean check = true;
		int input_id_int = Integer.parseInt(input_id);
		if(input_id_int < 1 || input_id_int > 9999) {
            check = false;
         }
		return check;
	}
	%>
	<%!
		public boolean age_check(String input_age){
		boolean check = true;
		int input_age_int = Integer.parseInt(input_age);
		if(input_age_int < 1 || input_age_int > 200) {
            check = false;
         }
		return check;
	}
	%>
	<%!
		public boolean id_dup_check(String input_id){
		boolean check = true;
		String sql = "";
		Connection conn = null;
 	    Statement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBManager.getConnection();
            stmt = conn.createStatement();
 	   } catch (Exception e) {
  	      e.printStackTrace();
 	   }
    
		
		 try {
	            sql = "SELECT * " + 
	                 " FROM customer " + 
	                 " WHERE customer_id = " + input_id;
	            rs = stmt.executeQuery(sql);
	            if(rs.isBeforeFirst() == true) {
	             check = false;
	             return check;
	            }
	         }catch (SQLException e) {
	            e.printStackTrace();
	      }
   
		return check;
	}
	%>

     <%
            Connection conn = null;
    	    Statement stmt = null;
            ResultSet rs = null;
            String sql = "";
            
            request.setCharacterEncoding("UTF-8");
            
            String input_id = request.getParameter("id");
            String input_name = request.getParameter("name");
            String input_phone = request.getParameter("phone");
            String input_addr = request.getParameter("addr");
            String input_pw = request.getParameter("pw");
            String input_email = request.getParameter("email");
            String input_age = request.getParameter("age");
            String input_sex = request.getParameter("sex");
            String input_favor = request.getParameter("favor");

            try {
                    conn = DBManager.getConnection();
                    stmt = conn.createStatement();
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            
            if(input_id == "" || input_name == "" || input_phone == "" || input_addr == "" ||
               input_pw == "" || input_email == "" ||input_age == "" || input_sex == "" ||	
               input_favor == ""){
            	%>
                <script>
                showAlertAndRedirect("공백인 정보가 있습니다. 다시 입력해주세요.", "register.jsp");
                </script>
            <% 
            }
            
            else if (id_check(input_id) == false) { %>
            <script>
                showAlertAndRedirect("잘못된 아이디입니다. 1~9999 사이의 숫자만 가능합니다.", "register.jsp");
            </script>
        <% } else if (age_check(input_age) == false) { %>
            <script>
                showAlertAndRedirect("잘못된 나이입니다. 나이는 숫자만 가능합니다.", "register.jsp");
            </script>
        <% } else if (id_dup_check(input_id) == false) { %>
            <script>
                showAlertAndRedirect("이미 가입된 아이디입니다.", "register.jsp");
            </script>
        <% }
            
            else if(id_dup_check(input_id) == true){
            try {
                StringBuffer sb = new StringBuffer();
                sb.append("INSERT INTO customer VALUES (" + input_id);
                sb.append(", '" + input_name + "','" + input_phone + "','");
                sb.append(input_addr + "','" + input_pw + "','" + input_email + "',");
                sb.append(input_age + ",'" + input_sex + "','" + input_favor + "')");
                sql = sb.toString();
                stmt.executeUpdate(sql);
                out.println("회원가입이 완료되었습니다! <br>");
            	out.println("<a href=\"login.jsp\"> << 로그인 메뉴로 돌아가기</a> ");
             }catch (SQLException e) {
                e.printStackTrace();
          }
            }
            	
        %>


</body>
</html>