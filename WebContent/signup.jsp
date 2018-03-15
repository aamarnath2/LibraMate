<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import= "CSCI201Assignment3.Database, com.google.gson.Gson"%>
   
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
	function validate() { 
			document.getElementById("username_err").innerHTML = "";
			document.getElementById("password_err").innerHTML = "";
			document.getElementById("imageURL_err").innerHTML = "";
			var userList = <%= stringData %>;
	    		var valid = true;
	    		var username = document.getElementById("username").value;
	    		var password = document.getElementById("password").value;
	    		var imageURL = document.getElementById("imageURL").value;
	    		
	    		if(username == "") {
	    			document.getElementById("username_err").innerHTML =  "Entry cannot be empty";
	    			valid = false;
	    		}

	    		
	    		if(password == "") {
	    			document.getElementById("password_err").innerHTML = "Entry cannot be empty";
	    			valid = false;
	    		}
	    		if(imageURL == "") {
	    			document.getElementById("imageURL_err").innerHTML = "Entry cannot be empty";
	    			valid = false;
	    		}
	    		
	   	 	for(var i = 0; i < userList.users.length; i++) {
    				if(userList.users[i].username == username) {
	    				document.getElementById("username_err").innerHTML = "Username Taken";
	    				valid = false;
    				}	
    			}
	   	 	
	    		if(valid) {
	    			var index = userList.users.length;
	    			var xhttp = new XMLHttpRequest();
	    			var userrequeststr = "username=" + username + "&password=" + password + "&imageURL=" + imageURL;
	    			xhttp.open("POST", "Validation?"+ userrequeststr, false);
	    			xhttp.send();
	    		} 
	    		return valid;
	    }
    </script>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="signup.css">
<title>LibraMate Sign up</title>
</head>
<body>
	<div id="top">
		<div id="title"> <a href="home.jsp"><h1>LibraMate</h1></a></div>
	</div>
	<div class="main">
		<div id="text">
			<form  id="form" name="signUpForm" method="POST" action="search.jsp" onsubmit="return validate();">
				<h1>Sign Up</h1>
				<h3>Username</h3>
				<input type="text" name="username" id="username">
				<span class="errors" id="username_err"></span> <br/>
				<h3>Password</h3>
				<input type="text" name="password" id="password">
				<span class="errors" id="password_err"></span> <br/>
				<h3>Image URL</h3>
				<input type="url" name="imageURL" id="imageURL">
				<span class="errors" id="imageURL_err"></span> <br/>
				<button type="submit"> Sign Up </button>
			</form>
		</div>
	</div>
</body>
</html>