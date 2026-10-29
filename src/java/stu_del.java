
import DB.JDBC;
import java.io.IOException;
import java.sql.Connection;
import java.sql.CallableStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/stu_del")
public class stu_del extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");

        if (id == null || !id.trim().matches("\\d+")) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Valid student ID is required."
            );
            return;
        }

        String sql = "{CALL dbo.sp_s1_delete(?)}";

        try (Connection con = JDBC.con();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setString(1, id.trim());
            cs.execute();

            response.sendRedirect(
                request.getContextPath() + "/student.jsp?deleted=1"
            );

        } catch (Exception e) {
            getServletContext().log("Error deleting one student", e);

            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to delete student. Check the GlassFish server log."
            );
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendError(
            HttpServletResponse.SC_METHOD_NOT_ALLOWED,
            "Use the Delete button on the student page."
        );
    }
}
