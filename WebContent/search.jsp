<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import= "CSCI201Assignment3.Database, com.google.gson.Gson" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Search LibraMate</title>
	<link rel="stylesheet" type="text/css" href="search.css">
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
			document.querySelector("#radiobuttons").querySelector("#title").checked = true;
			document.querySelector("#profilePic").style.display = "inline-block";
		}
		searchAPI();
	}
	
	
	function validate() {
		if(document.getElementById("icon").src == "http://localhost:8080/LibraMate/images/userIcon.png") {
			document.getElementById("form").setAttribute("action", "userSearch.jsp");
			return true;
		}
		else if(document.libra_form.search.value.trim() == "") {
			return false;
		}
		else if(document.getElementById("icon").src == "http://localhost:8080/LibraMate/images/bookIcon.png")
			return true;
		else {
			return true;
		}
	}
		
		
	function searchAPI() {
			//loading page for books
			var type = "<%=request.getParameter("filtering")%>";
			var search = "<%=request.getParameter("search")%>";
			if(search == null || search == "null"){
				document.querySelector("#searchbar").value = "";
				return false;
			}
			if(type == "intitle") {
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
			var xhttp = new XMLHttpRequest();
			var requeststr = "https://www.googleapis.com/books/v1/volumes?q=";
			requeststr += type + ":" + search + "&maxResults=12&printType=books";
			xhttp.open("GET", requeststr, false);
			xhttp.send();
			var response = xhttp.responseText;
			json = JSON.parse(response);//parse into json
			var booksArr = document.querySelectorAll(".books"); // .innerHTML += (i + json.items[i].volumeInfo.title);
			var size;
			if(json.totalItems > 12) {
				size = 12;
			}
			else {
				size = json.totalItems;
			}
			for(var i = 0; i < size; i++) {
				var book = booksArr[i];
				book.querySelector(".hidden").style.visibility = "visible";
				//book.querySelector(".by").style.visibility = "visible";
				if(!json.items[i].volumeInfo.hasOwnProperty("imageLinks") || !json.items[i].volumeInfo.imageLinks.hasOwnProperty("thumbnail"))
					book.querySelector("img").src = "images/noimage.png";
				else {
					book.querySelector("img").src = json.items[i].volumeInfo.imageLinks.thumbnail;
				}
				book.querySelector("h4").innerHTML = json.items[i].volumeInfo.title;
				if(json.items[i].volumeInfo.hasOwnProperty("authors")) 
					book.querySelector(".author").innerHTML = json.items[i].volumeInfo.authors[0];
				else
					book.querySelector(".by").style.visibility = "hidden";
				book.querySelector("h6").innerHTML = json.items[i].selfLink;
			
			}
		}
		
		function displayInfoPage(bookInfo) {
			var form = document.createElement("form");
			form.setAttribute("method", "POST");
			form.setAttribute("action", "info.jsp");
			
			var bookData = document.createElement("input");
			bookData.setAttribute("type", "hidden");
			bookData.setAttribute("name", "bookData");
			bookData.setAttribute("value", bookInfo);
			
			var search = document.createElement("input");
			search.setAttribute("type", "text");
			search.setAttribute("name", "search");
			search.setAttribute("value", "<%=request.getParameter("search")%>");
		   
			var filtering = document.createElement("input"); 
			filtering.setAttribute("type", "text");
			filtering.setAttribute("name", "filtering"); 
			filtering.setAttribute("value", "<%=request.getParameter("filtering")%>"); 
			
			form.appendChild(bookData);
			form.appendChild(search);
			form.appendChild(filtering);
			document.body.appendChild(form);
			form.submit();
		}
		
	
	</script>
</head> 

<body onload="loadPage();">
	<div id="top">
		<div id="title"> <a href="home.jsp"><h1>LibraMate</h1></a></div>
		<form id="form" name="libra_form" method="POST" action="search.jsp" onsubmit="return validate();"> 
		<div id="search">
			<input id="searchbar" type="text" name="search" placeholder="Search" value="<%=request.getParameter("search")%>">
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
		<div id="profilePic" style="display:none;">
			<a href="userProfile.jsp"><img id="profImage"></a>
		</div>
	</div>
	<div class="main">
		<table id="bookDisplay">
			<tr> 
				<td>
					<div class = "books">
						<img class="hidden">
						<h4  onclick='displayInfoPage(this.parentElement.querySelector("h6").innerHTML);'></h4>
						<h5 class="by">by </h5><h5 class="author"></h5>
						<h6></h6>
					</div>	
				</td>
				<td>
					<div class = "books">
						<img class="hidden">
						<h4  onclick='displayInfoPage(this.parentElement.querySelector("h6").innerHTML);'></h4>
						<h5 class="by">by </h5><h5 class="author"></h5>
						<h6></h6>
					</div>	
				</td>
				<td>
					<div class = "books">
						<img class="hidden">
						<h4  onclick='displayInfoPage(this.parentElement.querySelector("h6").innerHTML);'></h4>
						<h5 class="by">by </h5><h5 class="author"></h5>
						<h6></h6>
					</div>	
				</td>
				<td>
					<div class = "books">
						<img class="hidden"> 
						<h4  onclick='displayInfoPage(this.parentElement.querySelector("h6").innerHTML);'></h4>
						<h5 class="by">by </h5><h5 class="author"></h5>
						<h6></h6>
					</div>	
				</td>
			</tr>
			<tr>
				<td>
					<div class = "books">
						<img class="hidden">
						<h4  onclick='displayInfoPage(this.parentElement.querySelector("h6").innerHTML);'></h4>
						<h5 class="by">by </h5><h5 class="author"></h5>
						<h6></h6>
					</div>	
				</td>
				<td>
					<div class = "books">
						<img class="hidden">
						<h4  onclick='displayInfoPage(this.parentElement.querySelector("h6").innerHTML);'></h4>
						<h5 class="by">by </h5><h5 class="author"></h5>
						<h6></h6>
					</div>	
				</td>
				<td>
					<div class = "books">
						<img class="hidden">
						<h4  onclick='displayInfoPage(this.parentElement.querySelector("h6").innerHTML);'></h4>
						<h5 class="by">by </h5><h5 class="author"></h5>
						<h6></h6>
					</div>	
				</td>
				<td>
					<div class = "books">
						<img class="hidden">
						<h4  onclick='displayInfoPage(this.parentElement.querySelector("h6").innerHTML);'></h4>
						<h5 class="by">by </h5><h5 class="author"></h5>
						<h6></h6>
					</div>	
				</td>	
			</tr>
			<tr>
				<td>
					<div class = "books">
						<img class="hidden">
						<h4  onclick='displayInfoPage(this.parentElement.querySelector("h6").innerHTML);'></h4>
						<h5 class="by">by </h5><h5 class="author"></h5>
						<h6></h6>
					</div>	
				</td>
				<td>
					<div class = "books">
						<img class="hidden">
						<h4  onclick='displayInfoPage(this.parentElement.querySelector("h6").innerHTML);'></h4>
						<h5 class="by">by </h5><h5 class="author"></h5>
						<h6></h6>
					</div>	
				</td>
				<td>
					<div class = "books">
						<img class="hidden">
						<h4  onclick='displayInfoPage(this.parentElement.querySelector("h6").innerHTML);'></h4>
						<h5 class="by">by </h5><h5 class="author"></h5>
						<h6></h6>
					</div>	
				</td>
				<td>
					<div class = "books">
						<img class="hidden">
						<h4  onclick='displayInfoPage(this.parentElement.querySelector("h6").innerHTML);'></h4>
						<h5 class="by">by </h5><h5 class="author"></h5>
						<h6></h6>
					</div>	
				</td>
			</tr>
			
		</table>
	</div>
</body>
</html>