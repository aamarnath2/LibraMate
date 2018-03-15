<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import= "CSCI201Assignment3.Database, com.google.gson.Gson" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Search LibraMate</title>
	<link rel="stylesheet" type="text/css" href="userSearch.css">
	<script defer src="https://use.fontawesome.com/releases/v5.0.8/js/all.js"></script>
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
	var userList = <%= stringData %>;
	var index = <%= session.getAttribute("userIndex") %>;
	console.log(index);
	function loadPage() {
		if(index > -1) {
			document.querySelector("#profImage").src = userList.users[index].imageURL;
			document.querySelector("#profilePic").style.display = "inline-block";
		}
		searchUsers();
	}
	
	
	function validate() {
		if(document.libra_form.search.value.trim() == "" && document.getElementById("icon").src == "http://localhost:8080/LibraMate/images/userIcon.png") {
			return true;
		}
		else if(document.libra_form.search.value.trim() == "") {
			return false;
		}
		else if(document.getElementById("icon").src == "http://localhost:8080/LibraMate/images/userIcon.png")
			return true;
		else {
			document.getElementById("form").setAttribute("action", "search.jsp");
			return true;
		}
	}
		
	function searchUsers() {
		
		var search = "<%=request.getParameter("search")%>";
		if(search == null || search == "null"){
			document.querySelector("#searchbar").value = "";
			return false;
		}
		var count = 0;
		for(var i = 0; i < userList.users.length && count < 12; i++){
			if(userList.users[i].username.startsWith(search) && i !=index)
			{
				var x = document.createElement("div");
				x.setAttribute("class", "users");
				var img = document.createElement("img");
				img.src = userList.users[i].imageURL;
				img.setAttribute("class", "userImage"); 
				var memberName = document.createElement("h3");
				memberName.innerHTML = "@" + userList.users[i].username;
				memberName.setAttribute("class", "username");
				var data = document.createElement("h6");
				data.setAttribute("id", "hidden");
				data.innerHTML = i;
				data.style.display = "none";
				img.onclick = function() {
					displayUser(this);
				}
				x.appendChild(data);
				x.appendChild(img);
				x.appendChild(memberName);
				document.getElementById("main").appendChild(x); 
				count++;
			}
		}
		
		if(count == 0) {
			var none = document.createElement("h1");
			none.setAttribute("id", "none");
			document.getElementById("main").append(none);
			console.log(userList);
			none.innerHTML = "No Users Found!";
		}
	}
	
	function displayUser(currUser)
	{ 
		console.log(currUser.parentElement);
		var form = document.createElement("form");
		form.setAttribute("method", "POST");
		form.setAttribute("action", "memberProfile.jsp");
		
		var memberIndex = document.createElement("input");
		memberIndex.setAttribute("type", "hidden");
		memberIndex.setAttribute("value", currUser.parentElement.querySelector("#hidden").innerHTML);
		memberIndex.setAttribute("name", "memberIndex");
		console.log(memberIndex.value);
		form.appendChild(memberIndex);
		document.body.appendChild(form);
		form.submit();
	}  
	
	</script>
</head> 

<body onload="loadPage();">
	<div id="top">
		<div id="title"> <a href="home.jsp"><h1>LibraMate</h1></a></div>
		<form id="form" name="libra_form" method="POST" action="userSearch.jsp" onsubmit="return validate();"> 
		<div id="search">
			<input id="searchbar" type="text" name="search" placeholder="Search" value="<%=request.getParameter("search")%>">
			<div id="searchIconPic">
				<script>
					function toggleIcon() {
						 if(document.getElementById("icon").src == "http://localhost:8080/LibraMate/images/userIcon.png") {
							 document.getElementById("icon").src = "images/bookIcon.png";
							 document.getElementById("radiobuttons").style.display = "inline"
						 } 
						 else{
							 document.getElementById("icon").src = "images/userIcon.png";
							 document.getElementById("radiobuttons").style.display = "none";
						 }
					} 
				</script>
				<span><img id="icon" src="images/userIcon.png" onclick="toggleIcon();"></span>
			</div>
		</div>
		<div id="buttonTable">
			<table id="radiobuttons" style="display:none">
				<tr>
					<td> <input type="radio" id="title" name= "filtering" value="intitle" checked="true"> Title  </td>
					<td> <input type="radio" id="isbn" name= "filtering" value="isbn"> ISBN </td>
				</tr>
				<tr>
					<td> <input type="radio" id="author" name= "filtering" value="inauthor"> Author </td>
					<td> <input type="radio" id="subject" name="filtering" value="subject"> Genre </td>
				</tr>
			</table>
		</div>	
		</form>
		<div id="profilePic" style="display:none">
			<a href="userProfile.jsp"><img id="profImage"></a>
		</div>
	</div>
	<div id="main">
	
	</div>
</body>
</html>