package CSCI201Assignment3;

import java.io.FileWriter;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

/**
 * Servlet implementation class WriteFollowers
 */
@WebServlet("/WriteFollowers")
public class WriteFollowers extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int currIndex = Integer.parseInt(request.getParameter("userIndex"));
		int otherIndex = Integer.parseInt(request.getParameter("otherIndex"));
		Database userList = (Database)request.getSession().getAttribute("userList");
		
		String currUsername = userList.users.get(currIndex).getUsername();
		String otherUsername = userList.users.get(otherIndex).getUsername();
		
		userList.users.get(otherIndex).addFollowers(currUsername);
		userList.users.get(currIndex).addFollowing(otherUsername);
		request.getSession().setAttribute("userList", userList);
		request.getSession().setAttribute("userIndex", currIndex);
		String filePath = getServletContext().getRealPath("/sample.json");
		Gson gson = new Gson();
		FileWriter fw = new FileWriter(filePath);
		fw.write(gson.toJson(userList));
		fw.flush();
		fw.close();
	}

}
