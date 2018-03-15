<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import= "CSCI201Assignment3.Database, com.google.gson.Gson" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<%	
		String stringData = "";
		Gson gson = new Gson();
		Database data = (Database)(session.getAttribute("userList"));
		try {
			stringData = gson.toJson(data);
			
		} catch(Exception e) {
			e.getMessage();
		}
	
	%>
	<script>
		console.log(<%= session.getAttribute("userIndex") %>);
	    function validate() { 
	    		var userList = <%= stringData %>;
		    	var valid = false;
	    		var username = document.getElementById("username").value;
	    		var password = document.getElementById("password").value;
	    		
	    		if(username == "") {
	    			valid = false;
	    		}
	    		if(password == "") {
	    			valid = false;
	    		}
		   	for(var i = 0; i < userList.users.length; i++) {
		    		if(userList.users[i].username == username)
		    			if(userList.users[i].password == password) {
		    				var xhttp = new XMLHttpRequest();
			    			var index = i;
			    			xhttp.open("POST", "UserIndex?index=" + index, false);
						xhttp.send();
		    				return true;
		    			}
		    }
	    		document.getElementById("error_msg").innerHTML = "Login failed - please try again or sign up for an account on LibraMate";
	    		return valid;
	    }
    </script>


<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="login.css">
<title>LibraMate Login</title>
</head>
<body>
	<div id="top">
		<div id="title"> <a href="home.jsp"><h1>LibraMate</h1></a></div>
	</div>
	<div class="main">
		<div id="text">
			<form  id="form" name="loginForm" method="POST" action="search.jsp" onsubmit="return validate()">
				<h1>Login</h1>
				<h3>Username</h3>
				<input type="text" name="username" id="username">
				<h3>Password</h3>
				<input type="text" name="password" id="password"> <br/>
				<p id="error_msg"></p> </br>
				<button type="submit"> Submit </button> 
			</form>
		</div>
	</div>
</body>
</html>