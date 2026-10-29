
import DB.JDBC;
import java.io.IOException;
import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/stu_edit")
public class stu_edit extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");

        if (id == null || id.trim().isEmpty()) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Student ID is required."
            );
            return;
        }

        String sql = "{CALL dbo.sp_s1_get_one(?)}";

        try (Connection con = JDBC.con();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setString(1, id.trim());

            try (ResultSet rs = cs.executeQuery()) {

                if (rs.next()) {
                    request.setAttribute("id", rs.getString("id"));
                    request.setAttribute("name", rs.getString("name"));
                    request.setAttribute("gen", rs.getString("gen"));
                    request.setAttribute("cou", rs.getString("cou"));

                    java.sql.Date dob = rs.getDate("dob");
                    request.setAttribute(
                        "dob", dob == null ? "" : dob.toString()
                    );

                    java.sql.Time studentTime = rs.getTime("stud_time");
                    request.setAttribute(
                        "time",
                        studentTime == null ? "" : studentTime.toString()
                    );

                    // The image remains in the database.
                    // Do not convert VARBINARY image bytes to a String.
                    request.setAttribute("hasImage",
                        rs.getBytes("img") != null);

                    RequestDispatcher rd =
                        request.getRequestDispatcher("/stuedit.jsp");

                    rd.forward(request, response);

                } else {
                    response.sendRedirect(
                        request.getContextPath()
                        + "/student.jsp?editError=1"
                    );
                }
            }

        } catch (Exception e) {
            getServletContext().log("Error loading student for editing", e);
            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to load student details. Check the server log."
            );
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        doPost(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Edit student";
    }
}
