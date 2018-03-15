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
 * Servlet implementation class WriteReadLibrary
 */
@WebServlet("/WriteFavoriteLibrary")
public class WriteFavoriteLibrary extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String title = request.getParameter("title");
		int currIndex = Integer.parseInt(request.getParameter("currIndex"));
		Database userList = (Database)request.getSession().getAttribute("userList");
		System.out.println(title);
		System.out.println(userList);
		
		userList.users.get(currIndex).getLibrary().getFavorite().add(title);
		
		request.getSession().setAttribute("userList", userList);
		
		String filePath = getServletContext().getRealPath("/sample.json");
		Gson gson = new Gson();
		FileWriter fw = new FileWriter(filePath);
		fw.write(gson.toJson(userList));
		fw.flush();
		fw.close();
	}

}
