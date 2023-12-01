<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page import="com.db.DBManager" %>
<%@ page language="java" contentType="text/html; charset=EUC-KR" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>cancelAccount</title>
</head>
<body>
   <h2> 회원탈퇴를 하시려면 비밀번호를 입력하세요.</h2>
   <br/>
     <form action="cancelAccount_check.jsp" method="post">
		<input type="password" name="pw" id="pw" placeholder="비밀번호"><br>
		<input type="submit" value="회원탈퇴">
		<input type="button" value="취소" onclick="location.href='../mypage.html'">
	</form>


</body>
</html>