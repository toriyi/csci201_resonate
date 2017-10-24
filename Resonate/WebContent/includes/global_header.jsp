<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%
/*
if (request.getSession().getAttribute("login") == null) { 
	bool loggedin = false;
	
}*/
String referer = request.getRequestURL().toString();
String[] refParts = referer.split("/");
String pageName = refParts[refParts.length - 1].split("\\.")[0];
if (pageName.equals("Resonate")) pageName = "index";

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Resonate</title>
		<link rel="stylesheet" type="text/css" href="includes/css/main.css" />
		<% // Links a stylesheet based on the name of the page we're on, to make css per page seperated and (hopefully) neater. %>
		<link rel="stylesheet" type="text/css" href="includes/css/<%= pageName %>.css" />
		<script type="text/javascript" src="includes/js/jquery-3.2.1.min.js"></script>
		<script type="text/javascript" src="includes/js/main.js"></script>
		
		<!-- Bootstrap -->
		<script src="includes/js/popper.min.js"></script>
		<link rel="stylesheet" href="includes/css/bootstrap/bootstrap.min.css" />
		<script src="includes/js/bootstrap/bootstrap.min.js"></script>
	</head>
	<body>
		<div id="navbar">
			<img id="logo" src="images/logo.png" />
			<ul>
				<li id="loginBtn" onClick="loginPopup();"><a href="#">Login</a></li>
				<li>Browse Projects</li>
			</ul>
			<div id="loginPopup">
				<form>
					<div><p>Username: </p><input type="text" name="uname" /></div>
					<div class="spacer"></div>
					<div><p>Password: </p><input type="password" name="pw" /></div>
					<div class="spacer"></div>
					<div><input type="submit" value="Login" /></div>
				</form>
			</div>
		</div>