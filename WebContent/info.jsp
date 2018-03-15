<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import= "CSCI201Assignment3.Database, com.google.gson.Gson"%>
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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Book Information Page</title>
		<link rel="stylesheet" type="text/css" href="info.css">
		<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
		<script defer src="https://use.fontawesome.com/releases/v5.0.8/js/all.js"></script>
		<script>
		var userList = <%= stringData %>;
		
		var index = <%= session.getAttribute("userIndex") %>;
		
		
		
		
			function loadPage() {
				if(index > -1) {
					document.querySelector("#profImage").src = userList.users[index].imageURL;
					document.querySelector("#radiobuttons").querySelector("#title").checked = true;
					document.querySelector("#profilePic").style.display = "inline-block";
					document.getElementById("dropdown").style.display = "inline-block";
				}
				
				
				var selfLink = "<%=request.getParameter("bookData")%>";
				var type = "<%=request.getParameter("filtering")%>";
				var xhttp = new XMLHttpRequest();
				var requeststr = selfLink;
				xhttp.open("GET", requeststr, false);
				xhttp.send();
				var response = xhttp.responseText;
				json = JSON.parse(response); //parse into json
				console.log(type);
				
				if(type == "intitle") {
					console.log("hi");
					document.querySelector("#radiobuttons").querySelector("#title").checked = "true";
				}
				else if(type == "inauthor") {
					document.querySelector("#radiobuttons").querySelector("#author").checked = "true";
				}
				else if(type == "isbn") {
					document.querySelector("#radiobuttons").querySelector("#isbn").checked = "true";
				}
				else if(type == "subject") {
					document.querySelector("#radiobuttons").querySelector("#subject").checked = "true";
				}
				
				document.querySelector(".main").querySelector("#text").querySelector("h1").innerHTML = json.volumeInfo.title;
				if(json.volumeInfo.hasOwnProperty("authors")) 
					document.querySelector("h2").innerHTML = "by " + json.volumeInfo.authors;
				if(json.volumeInfo.hasOwnProperty("publisher"))
					document.querySelector("#publishedBy").innerHTML = json.volumeInfo.publisher;
				if(json.volumeInfo.hasOwnProperty("description"))
					document.querySelector("p").innerHTML = json.volumeInfo.description;
				else
					document.querySelector("p").innerHTML = "Not Available";
				if(json.volumeInfo.hasOwnProperty("imageLinks")) {
					if(!json.volumeInfo.imageLinks.hasOwnProperty("large"))
						document.querySelector("#img").querySelector("img").src = json.volumeInfo.imageLinks.thumbnail;
					else	
						document.querySelector("#img").querySelector("img").src = json.volumeInfo.imageLinks.large;
				}
				else {
					document.querySelector("#img").querySelector("img").src = "images/noimage.png";
				}
				var starRating = json.volumeInfo.averageRating;
				for(var i = 0; i< 5; i++) {
					if(starRating > 0.5) {
						document.querySelector("#rating").innerHTML += "<i class='material-icons' style='font-size:60px;'>star</i>";
						starRating--;
					}
					else if(starRating > 0){
						document.querySelector("#rating").innerHTML += "<i class='material-icons' style='font-size:60px;'>star_half</i>";
						starRating--;
					}
					else {
						document.querySelector("#rating").innerHTML += "<i class='material-icons' style='font-size:60px;'>star_border </i>";
					}
				} 
			}	
		
			function validate() {
				if(document.getElementById("icon").src == "http://localhost:8080/LibraMate/images/userIcon.png") {
					document.getElementById("form").setAttribute("action", "userSearch.jsp");
					return true;
				}
				else if(document.libra_form.search.value.trim() == "") {
					return false;
				}
				else {
					return true;
				}
			}	
		
		</script>
	</head>
	<body onload="loadPage();">
		<div id="wrapper">
		<div id="top">
			<div id="title"> <a href="home.jsp"><h1>LibraMate</h1></a></div>
			<form id="form" name="libra_form" method="POST" action="search.jsp" onsubmit="return validate();"> 
		 		<div id="search">
					<div id="searchbar"> <input id="searchbar" type="text" name="search" placeholder="Search" value="<%=request.getParameter("search")%>"> </div>
					<div id="searchIconPic">
						<script>
							function toggleIcon() {
								 if(document.getElementById("icon").src == "http://localhost:8080/LibraMate/images/bookIcon.png") {
									 document.getElementById("icon").src = "images/userIcon.png";
									 document.getElementById("radiobuttons").style.display = "none";
								 } 
								 else{
									 document.getElementById("icon").src = "images/bookIcon.png";
									 document.getElementById("radiobuttons").style.display = "inline"
								 }
							} 
						</script>
						<span><img id="icon" src="images/bookIcon.png" onclick="toggleIcon();"></span>
					</div>
				</div>
				<div id="buttonTable">
					<table id="radiobuttons">
						<tr>
							<td> <input type="radio" id="title" name= "filtering" value="intitle"> Title  </td>
							<td> <input type="radio" id="isbn" name= "filtering" value="isbn"> ISBN </td>
						</tr>
						<tr>
							<td> <input type="radio" id="author" name= "filtering" value="inauthor"> Author </td>
							<td> <input type="radio" id="subject" name="filtering" value="subject"> Genre </td>
					</tr>
				</table>
				</div>	
			</form>
			<div id="profilePic" style="display: none;">
				<a href="userProfile.jsp"><img id="profImage"></a>
			</div>
		</div>
		<div class="main">
			<div id="img">
				<img> </img> 
				<script>
					function toggle() {
					    document.getElementById("myDropdown").classList.toggle("show");
					}
					
					function addToRead() {
						console.log(userList);
						var title = document.querySelector(".main").querySelector("#text").querySelector("h1").innerHTML;
						for(var i=0; i<userList.users[index].library.read.length; i++)
						{
							if(title == userList.users[index].library.read[i])
								return false;
						}
						userList.users[index].library.read.push(title);
						var xhttp = new XMLHttpRequest();
		    				xhttp.open("POST", "WriteReadLibrary?title="+ title + "&currIndex=" + index, false);
		    				xhttp.send();
						return true;
					}
					
					function addToFavorites() {
						console.log(userList);
						var title = document.querySelector(".main").querySelector("#text").querySelector("h1").innerHTML;
						for(var i=0; i<userList.users[index].library.favorite.length; i++)
						{
							if(title == userList.users[index].library.favorite[i])
								return false;
						}
						userList.users[index].library.favorite.push(title);
						var xhttp = new XMLHttpRequest();
		    				xhttp.open("POST", "WriteFavoriteLibrary?title="+ title + "&currIndex=" + index, false);
		    				xhttp.send();
						return true;
					}
				</script>
				<div id="dropdown" style="display:none;"> 
					<div id="dropbutton"> <button  onclick="toggle()" class="dropbtn">Add to Library</button> </div>
					<div id="fontawesomeicon"><i class="fas fa-caret-down" style="font-size:40px; background-color:black; color:white; height:65px; width:80px; margin-top:20px; display:inline-block; overflow: hidden;"></i></div>
					<div id="myDropdown" class="dropdown-content">
						<button type="button" onclick="addToRead()">Read</a>
						<button type="button" onclick="addToFavorites()">Favorites</a>
				 	</div>
				</div>
			</div>	
			<div id="text">
				<h1></h1>
				<h2></h2>
				<h3 id="publisher">Publisher: </h3> <h3 id="publishedBy"> </h3>
				<h3>Description: </h3>
				<p></p>
				<h3>Rating: </h3>
				<div id="rating"></div>
			 </div>
		</div>
		</div>
	</body>
</html>


