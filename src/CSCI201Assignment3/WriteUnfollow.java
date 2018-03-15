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
 * Servlet implementation class WriteUnfollow
 */
@WebServlet("/WriteUnfollow")
public class WriteUnfollow extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		int currIndex = Integer.parseInt(request.getParameter("userIndex"));
		int otherIndex = Integer.parseInt(request.getParameter("otherIndex"));
		Database userList = (Database)request.getSession().getAttribute("userList");
		
		String followingRemove = userList.users.get(currIndex).getUsername();
		String followersRemove = userList.users.get(otherIndex).getUsername();
		
		userList.users.get(currIndex).removeFollowing(followersRemove);
		userList.users.get(otherIndex).removeFollowers(followingRemove);
		
		request.getSession().setAttribute("userList", userList);
		
		String filePath = getServletContext().getRealPath("/sample.json");
		Gson gson = new Gson();
		FileWriter fw = new FileWriter(filePath);
		fw.write(gson.toJson(userList));
		fw.flush();
		fw.close();
	}


}
