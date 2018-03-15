<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"  import= "CSCI201Assignment3.Database, com.google.gson.Gson"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="memberProfile.css">
<title>Profile Page</title>
</head>
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
	
	function loadPage() {
		var memberIndex = <%= request.getParameter("memberIndex") %>;
		//must be a user to access this page
		
		if(index > -1) {
			document.querySelector("#profilePic").style.display = "inline-block";
			document.querySelector("#profImage").src = userList.users[index].imageURL;
		}
		else if(index == -1) {
			console.log(index);
			document.querySelector("#followButton").onclick = "";
			document.querySelector("#unfollowButton").onclick = "";
			document.querySelector("#unfollowButton").style.display = "none";
		}
		document.querySelector("#searchbar").value = "";
		document.querySelector("#mainProfilePic").src = userList.users[memberIndex].imageURL;
		document.querySelector("h2").innerHTML += userList.users[memberIndex].username;
		document.querySelector("#urlibrary").innerHTML = userList.users[memberIndex].username + "'s Library";
		
		loadFollowersAndFollowing();
		
		if( userList.users[memberIndex].library.favorite.length > 0) {
			for(var i = 0; i < userList.users[memberIndex].library.favorite.length; i++) {
				var xhttp = new XMLHttpRequest();
				var search = userList.users[memberIndex].library.favorite[i];
				var requeststr = "https://www.googleapis.com/books/v1/volumes?q=";
				requeststr += "intitle:" + search + "&maxResults=1&printType=books";
				xhttp.open("GET", requeststr, false);
				xhttp.send();
				var response = xhttp.responseText;
				json = JSON.parse(response);
				var favDiv = document.createElement("div");
				favDiv.setAttribute("class", "libraryDiv");
				var favBook = document.createElement("img");
				if(!json.items[0].volumeInfo.hasOwnProperty("imageLinks") || !json.items[0].volumeInfo.imageLinks.hasOwnProperty("thumbnail"))
					favBook.src = "images/noimage.png";
				else {
					favBook.src = json.items[0].volumeInfo.imageLinks.thumbnail;
				}
				favDiv.appendChild(favBook);
				var title = document.createElement("h3");
				title.innerHTML = search;
				favDiv.appendChild(title);
				var author = document.createElement("h4");
				author.innerHTML = "by " + json.items[0].volumeInfo.authors;
				favDiv.appendChild(author);
				document.querySelector("#favorite").appendChild(favDiv);
			}
		}
	}

	function loadFollowersAndFollowing() {
		var memberIndex = <%= request.getParameter("memberIndex") %>;
		document.querySelector("#followers").innerHTML = "";
		if( userList.users[memberIndex].followers.length > 0) {
			for(var i = 0; i < userList.users[memberIndex].followers.length; i++) {
				if(index > -1) {
					if(userList.users[memberIndex].followers[i] == userList.users[index].username){
						document.querySelector("#followButton").style.display = "none";
						document.querySelector("#unfollowButton").style.display = "inline-block";
					}
					else{ 
						document.querySelector("#followButton").style.display = "inline-block";
						document.querySelector("#unfollowButton").style.display = "none";
					}
				}
				var follower = document.createElement("h2");
				follower.innerHTML = "@" + userList.users[memberIndex].followers[i];
				document.querySelector("#followers").appendChild(follower)
				//document.querySelector("#followers").innerHtml = 
			}
		} 
		
		document.querySelector("#following").innerHTML = "";
		if( userList.users[memberIndex].following.length > 0) {
			for(var i = 0; i < userList.users[memberIndex].following.length; i++) {
				var follow = document.createElement("h2");
				follow.innerHTML = "@" + userList.users[memberIndex].following[i];
				document.querySelector("#following").appendChild(follow);
				//document.querySelector("#followers").innerHtml = 
			}
		}
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
	
	
	function followFunc() {
		var memberIndex = <%= request.getParameter("memberIndex") %>;
		if(index > -1) {
		//	document.querySelector("#followButton").style.display = "none";
		//	document.querySelector("#unfollowButton").style.display = "inline-block";
			for(var i = 0; i < userList.users[index].following.length; i++){
				if(userList.users[index].following[i] == userList.users[memberIndex].username) {
					return false;
				}
			}
			console.log("heyyy");
			userList.users[index].following.push(userList.users[memberIndex].username);
			userList.users[memberIndex].followers.push(userList.users[index].username);
			var xhttp = new XMLHttpRequest();
			xhttp.open("POST", "WriteFollowers?userIndex=" + index + "&otherIndex=" + memberIndex , false);
			xhttp.send();
			loadFollowersAndFollowing();
			return true; 
			}
	}
	
	function unfollowFunc(){
		var memberIndex = <%= request.getParameter("memberIndex") %>;
		var followingRemove;
		var followersRemove;
		if(index > -1) {
			document.querySelector("#unfollowButton").style.display = "none";
			document.querySelector("#followButton").style.display = "inline-block";
			for(var i = 0; i < userList.users[index].following.length; i++) {
				if(userList.users[index].following[i] == userList.users[memberIndex].username){
					userList.users[index].following.splice(i,1);
					followingRemove = userList.users[i].username;
					break;
				}
			}
			for(var i = 0; i < userList.users[memberIndex].followers.length; i++) {
				if(userList.users[memberIndex].followers[i] == userList.users[index].username){
					userList.users[memberIndex].followers.splice(i,1);
					followersRemove = userList.users[i].username;
					break;
				}
			}
			var xhttp = new XMLHttpRequest();
			xhttp.open("POST", "WriteUnfollow?userIndex=" + index + "&otherIndex=" + memberIndex, false);
			xhttp.send();
			loadFollowersAndFollowing();
			console.log(userList.users[memberIndex]);
			console.log(userList.users[index]);
		}
	}
	</script>
	
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
		<div id="profilePic" style="display:none;">
			<a href="userProfile.jsp"><img id="profImage"></a>
		</div>
	</div>
	<div id="main">
		<span id="leftSide">
			<img id="mainProfilePic">
			<div id="followerDiv">
				<h2>@</h2>
				<div class="tab">
					<button class="tablinks"  id="defaultopenFollowing" onclick="openFollowsTab(event, 'following')">Following</button>
  					<button class="tablinks" onclick="openFollowsTab(event, 'followers')">Followers</button>
				</div>
				<div id="following" class="tabcontent"></div>
				<div id="followers" class="tabcontent"></div>	
				
				<script>
				
				document.getElementById("defaultopenFollowing").click();
				
				function openFollowsTab(evt, tabName) {
				    // Declare all variables
				    var i, tabcontent, tablinks;

				    // Get all elements with class="tabcontent" and hide them
				    tabcontent = document.querySelector("#leftSide").getElementsByClassName("tabcontent");
				    for (i = 0; i < tabcontent.length; i++) {
				        tabcontent[i].style.display = "none";
				    }

				    // Get all elements with class="tablinks" and remove the class "active"
				    tablinks = document.querySelector("#leftSide").getElementsByClassName("tablinks");
				    for (i = 0; i < tablinks.length; i++) {
				        tablinks[i].className = tablinks[i].className.replace(" active", "");
				    }

				    // Show the current tab, and add an "active" class to the button that opened the tab
				    document.getElementById(tabName).style.display = "block";
				    evt.currentTarget.className += " active";
				}
				
				</script>
			</div>
		</span>
		<span id= "rightSide" > 
				<button id="followButton" type="submit" onclick="followFunc()">Follow</button>
				<button id="unfollowButton" type="submit" onclick="unfollowFunc()" style="display:none;">Unfollow</button> 	
				<h1 id="urlibrary">  </h1>
				<div id="library">
					<div class="tab">
	  					<button class="tablinks">Favorites</button>
					</div>
					<div id="favorite" class="tabcontent"></div>
				</div>
		</span>
		
		
	</div>
</body>
</html>