<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page import="com.db.DBManager" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>findpw_check</title>
</head>
<body>
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
            String pw = "";
            String query_name = "";

            try {
                    conn = DBManager.getConnection();
                    stmt = conn.createStatement();
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            if(input_id == "" || input_name == ""){
                 	out.println("공백인 정보가 있습니다. 다시 입력해주세요. <br>");
                 	out.println("<a href=\"findpw.jsp\"> << 뒤로 돌아가기</a> ");
                 }
            
            else{
       
           	 if(id_dup_check(input_id) == true){
                out.println("존재하지 않는 아이디입니다. <br>");
             	out.println("<a href=\"findpw.jsp\"> << 뒤로 돌아가기</a> ");
             }
            
            
           	 else if(id_dup_check(input_id) == false){
            	try {
                    sql = "SELECT pw, name " + 
       	                 " FROM customer " + 
       	                 " WHERE customer_id = " + input_id;
       	            rs = stmt.executeQuery(sql);
                    rs.next();
                    pw = rs.getString(1); 
                    query_name = rs.getString(2);
                    if(input_name.compareTo(query_name) != 0){
                    out.println("이름이 일치하지 않습니다. <br>");
                	out.println("<a href=\"findpw.jsp\"> << 뒤로 돌아가기</a> ");
                    }
                    if(input_name.compareTo(query_name) == 0){
                        out.println("비밀번호는 " + pw + " 입니다. <br>");
                    	out.println("<a href=\"login.jsp\"> << 로그인 화면으로 </a> ");
                        }
                 }catch (SQLException e) {
                    e.printStackTrace();
              }
            	
            }
            }
            	
        %>


</body>
</html>