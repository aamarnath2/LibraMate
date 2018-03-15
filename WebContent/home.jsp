<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.io.FileReader, java.io.FileWriter, java.io.FileNotFoundException, 
    java.io.IOException, com.google.gson.JsonParseException, com.google.gson.JsonSyntaxException, 
    com.google.gson.Gson, com.google.gson.stream.JsonReader, com.google.gson.GsonBuilder, CSCI201Assignment3.Database"%>

    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>LibraMate Home</title>
	<link rel="stylesheet" type="text/css" href="home.css">
	<%
	Gson gson = new Gson(); //declare Gson object
	Database userList = null;
	FileReader fr = null; // Declare appropriate readers necessary for File I/O
	JsonReader reader = null;
	try {
		String filepath = getServletContext().getRealPath("/sample.json");
		fr = new FileReader(filepath);
		reader = new JsonReader(fr);
		userList = gson.fromJson(reader, Database.class);
	} catch(JsonSyntaxException jse) {
		System.out.println(jse.getMessage() + '\n');
	} catch(JsonParseException jpe) {
		System.out.println(jpe.getMessage() + '\n');
	} catch(FileNotFoundException fnfre) {
		System.out.println("That file could not be found." + '\n');
	}
	session.setAttribute("userList",  userList);
	session.setAttribute("userIndex", -1);
%>

<script>
	function signUp() {
		var form = document.getElementById("form");
		form.setAttribute("type", "submit");
		form.setAttribute("action", "signup.jsp");
		form.submit();
	}
	
	function login() {
		var form = document.getElementById("form");
		form.setAttribute("type", "submit");
		form.setAttribute("action", "login.jsp");
		form.submit();
	}
	
	function validate() {
		if(document.libra_form.search.value.trim() == "") {
			return false;
		}
		form.submit();
		return true;
	}
	</script>
</head>
<body>
	<div class="main">
		<div id="text">
		<div id="title"> <a href="home.jsp"><h1>LibraMate</h1></a></div>
		<form id="form" name="libra_form" method="POST" action="search.jsp" onsubmit="return validate();"> 
			<div id="searchbar">
				<input id="search" type="text" name="search" placeholder="Search" value=""> 
				<img id="searchIcon" src="images/Magnifying_glass.png">
			</div>
			<table>
				<tr>
					<td> <input type="radio" name= "filtering" value="intitle" checked=true> Title  </td>
					<td> <input type="radio" name= "filtering" value="isbn"> ISBN </td>
				</tr>
				<tr>
					<td> <input type="radio" name= "filtering" value="inauthor"> Author </td>
					<td> <input type="radio" name="filtering" value="subject"> Genre </td>
				</tr>
			</table>
			<div id="userButtons">
				<div><button type="button" onclick="signUp()">SIGN UP</button></div>
				<div><button type="button" onclick="login()">LOGIN</button></div>
			</div>
		</form>
		</div>
	</div>
</body>
</html>