package CSCI201Assignment3;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.ws.Response;

import com.google.gson.Gson;
import com.google.gson.JsonParseException;
import com.google.gson.JsonSyntaxException;
import com.google.gson.stream.JsonReader;

/**
 * Servlet implementation class Validation
 */
@WebServlet("/Validation")
public class Validation extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String imageUrl = request.getParameter("imageURL");
		
		Database userList = (Database)(request.getSession().getAttribute("userList"));
		
		String path = getServletContext().getRealPath("/sample.json");
		
		User newUser = new User(username, password, imageUrl);
		userList.users.add(newUser);
		

		String filePath = getServletContext().getRealPath("/sample.json");
		Gson gson = new Gson();
		FileWriter fw = new FileWriter(filePath);
		fw.write(gson.toJson(userList));
		fw.flush();
		fw.close();
		
		
		request.getSession().setAttribute("userList", userList);
		request.getSession().setAttribute("userIndex", userList.users.size()-1);
	} 
}