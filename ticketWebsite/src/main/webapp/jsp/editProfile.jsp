<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page import="com.db.DBManager" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Register</title>
	<link rel="stylesheet" href="../styles/editProfile.css">
</head>
<body>
   <h2> 회원정보 수정</h2>
   <br/>
     <form action="editProfile_check.jsp" method="post">
		<input type="password" name="pw" id="pw" placeholder="비밀번호"><br>
		<input type="text" name="name" id="name" placeholder="이름"><br>
		<input type="text" name="phone" id="phone" placeholder="전화번호"><br>
		<input type="text" name="addr" id="addr" placeholder="주소"><br>
		<input type="text" name="email" id="email" placeholder="이메일"><br>
		<input type="text" name="age" id="age" placeholder="나이"><br>
	성별<select name="sex">
		<option value="M">Male</option>
		<option value="F">Female</option>
	</select> <br/>
	관심사<select name="favor">
		<option value="music">music</option>
		<option value="sports">sports</option>
		<option value="movie">movie</option>
		<option value="concert">concert</option>
		<option value="concert">musical</option>
	</select> <br/>
		<input type="submit" value="회원정보 수정">
		<input type="button" value="취소" onclick="location.href='../mypage.html'">
	</form>


</body>
</html>