
import DB.JDBC;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Date;
import java.sql.Time;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/stu_update")
@MultipartConfig
public class stu_update extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String gen = request.getParameter("gen");
        String cou = request.getParameter("cou");
        String dob = request.getParameter("dob");
        String time = request.getParameter("time");

        if (id == null || id.trim().isEmpty()
                || name == null || name.trim().isEmpty()
                || gen == null || cou == null
                || dob == null || time == null
                || dob.trim().isEmpty() || time.trim().isEmpty()) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Please provide all required student details."
            );
            return;
        }

        try {
            Date sqlDob = Date.valueOf(dob.trim());
            Time sqlTime = Time.valueOf(time.trim());

            Part imagePart = request.getPart("img");

            boolean hasNewImage =
                    imagePart != null && imagePart.getSize() > 0;

            String sql;

            if (hasNewImage) {
                sql = "UPDATE dbo.tbl_stud1 " +
                      "SET name = ?, gen = ?, cou = ?, dob = ?, " +
                      "stud_time = ?, img = ? WHERE id = ?";
            } else {
                sql = "UPDATE dbo.tbl_stud1 " +
                      "SET name = ?, gen = ?, cou = ?, dob = ?, " +
                      "stud_time = ? WHERE id = ?";
            }

            try (Connection con = JDBC.con();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, name.trim());
                ps.setString(2, gen.trim());
                ps.setString(3, cou.trim());
                ps.setDate(4, sqlDob);
                ps.setTime(5, sqlTime);

                if (hasNewImage) {
                    try (InputStream imageStream =
                                 imagePart.getInputStream()) {

                        ps.setBinaryStream(6, imageStream,
                                           imagePart.getSize());
                        ps.setString(7, id.trim());

                        int rows = ps.executeUpdate();

                        if (rows == 0) {
                            response.sendRedirect(
                                request.getContextPath()
                                + "/student.jsp?editError=1"
                            );
                            return;
                        }
                    }
                } else {
                    ps.setString(6, id.trim());

                    int rows = ps.executeUpdate();

                    if (rows == 0) {
                        response.sendRedirect(
                            request.getContextPath()
                            + "/student.jsp?editError=1"
                        );
                        return;
                    }
                }
            } catch (Exception ex) {
                Logger.getLogger(stu_update.class.getName()).log(Level.SEVERE, null, ex);
            }

            response.sendRedirect(
                request.getContextPath()
                + "/student.jsp?updated=1"
            );

        } catch (IllegalArgumentException ex) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid date or time format."
            );
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendError(
            HttpServletResponse.SC_METHOD_NOT_ALLOWED,
            "Please update student details through the student form."
        );
    }
}
