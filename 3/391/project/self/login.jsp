<html>
<head></head>
<body>
	Your info has been received:
	<br><br>
	<%
		String sName = 	request.getParameter("Username");
		out.print(sName);
	%>
	<br>
	<%	
		String sPassword = request.getParameter("Password");
		out.println(sPassword);
	%>
</body>
</html>
