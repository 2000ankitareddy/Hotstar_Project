import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;

public class HotstarServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String type = request.getParameter("type");

        response.setContentType("text/html");

        if ("movies".equals(type)) {
            response.getWriter().println("<h2 style='color:white'>Movies Page</h2>");
        } else if ("sports".equals(type)) {
            response.getWriter().println("<h2 style='color:white'>Sports Page</h2>");
        } else if ("tv".equals(type)) {
            response.getWriter().println("<h2 style='color:white'>TV Shows Page</h2>");
        } else {
            response.getWriter().println("<h2 style='color:white'>Welcome to Hotstar</h2>");
        }
    }
}
