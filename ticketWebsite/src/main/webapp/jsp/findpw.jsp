<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page import="com.db.DBManager" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Find Password</title>
	<link rel="stylesheet" href="../styles/findpw.css">
</head>
<body>
   <h2> 비밀번호 찾기</h2>
   <br/>
     <form action="findpw_check.jsp" method="post">
     	<h4> 비밀번호를 찾을 아이디와 이름을 입력하세요.</h4>
		<input type="text" name="id" id="id" placeholder="아이디"><br>
		<input type="text" name="name" id="name" placeholder="이름"><br>
		<input type="submit" value="비밀번호 찾기">
		<input type="button" value="취소" onclick="location.href='login.jsp'">
	</form>


</body>
</html>