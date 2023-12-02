<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page import="com.db.DBManager" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register_check</title>
</head>
<body>
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


     <%
            Connection conn = null;
    	    Statement stmt = null;
            ResultSet rs = null;
            String sql = "";
            
            request.setCharacterEncoding("UTF-8");
            
            String id = (String) session.getAttribute("login_id");
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
            
            
            if(input_name == "" || input_phone == "" || input_addr == "" ||
               input_pw == "" || input_email == "" ||input_age == "" || input_sex == "" ||	
               input_favor == ""){
            	out.println("공백인 정보가 있습니다. 다시 입력해주세요. <br>");
            	out.println("<a href=\"editProfile.jsp\"> << 뒤로 돌아가기</a> ");
            }
            
            else if(age_check(input_age) == false){
            	out.println("잘못된 나이입니다. 나이는 숫자만 가능합니다. <br>");
            	out.println("<a href=\"editProfile.jsp\"> << 뒤로 돌아가기</a> ");
            }
            
            else{
            try {
                StringBuffer sb = new StringBuffer();
                sb.append("UPDATE CUSTOMER \n");
                sb.append("SET name = '" + input_name + "', \n");
                sb.append(" phone = '" + input_phone + "', \n");
                sb.append(" addr = '" + input_addr + "', \n");
                sb.append(" pw = '" + input_pw + "', \n");
                sb.append(" email = '" + input_email + "', \n");
                sb.append(" age = '" + input_age + "', \n");
                sb.append(" sex = '" + input_sex + "', \n");
                sb.append(" favor = '" + input_favor + "' \n");
                sb.append(" WHERE CUSTOMER_ID = " + id);
                sql = sb.toString();
                stmt.executeUpdate(sql);
                out.println("회원정보 수정이 완료되었습니다! <br>");
            	out.println("<a href=\"login.jsp\"> << 로그인 메뉴로 돌아가기</a> ");
             }catch (SQLException e) {
                e.printStackTrace();
          }
            }
            
            	
        %>


</body>
</html>