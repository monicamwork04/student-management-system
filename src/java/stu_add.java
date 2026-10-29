
package main;

import DB.JDBC;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/stu_add")
@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024
)
public class stu_add extends HttpServlet {

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            // Read values using the names in student.jsp
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String gen = request.getParameter("gen");
            String cou = request.getParameter("cou");
            String dob = request.getParameter("dob");
            String time = request.getParameter("time");

            // Validate required fields
            if (id == null || id.trim().isEmpty()
                    || name == null || name.trim().isEmpty()
                    || gen == null || gen.trim().isEmpty()
                    || cou == null || cou.trim().isEmpty()
                    || dob == null || dob.trim().isEmpty()
                    || time == null || time.trim().isEmpty()) {

                response.getWriter().println(
                    "Error: Please fill in all student fields."
                );
                return;
            }

            int studentId;

            try {
                studentId = Integer.parseInt(id.trim());
                if (studentId <= 0) {
                    throw new NumberFormatException();
                }
            } catch (NumberFormatException ex) {
                response.getWriter().println(
                    "Error: Student ID must be a positive integer."
                );
                return;
            }

            name = name.trim();

            if (name.length() > 100) {
                response.getWriter().println(
                    "Error: Name must not exceed 100 characters."
                );
                return;
            }

            if (!"Male".equals(gen) && !"Female".equals(gen)) {
                response.getWriter().println(
                    "Error: Please select a valid gender."
                );
                return;
            }

            if (!"java".equals(cou)) {
                response.getWriter().println(
                    "Error: Please select a valid course."
                );
                return;
            }

            java.sql.Date dobValue =
                java.sql.Date.valueOf(
                    java.time.LocalDate.parse(dob)
                );

            java.sql.Time timeValue =
                java.sql.Time.valueOf(
                    java.time.LocalTime.parse(time)
                );

            // Read image using the name in student.jsp
            Part filePart = request.getPart("img");

            if (filePart == null || filePart.getSize() == 0) {
                response.getWriter().println(
                    "Error: Please select a student image."
                );
                return;
            }

            if (filePart.getSize() > 5L * 1024 * 1024) {
                response.getWriter().println(
                    "Error: Image must not exceed 5 MB."
                );
                return;
            }

            String contentType = filePart.getContentType();

            if (contentType == null
                    || !contentType.toLowerCase().startsWith("image/")) {
                response.getWriter().println(
                    "Error: Please upload a valid image."
                );
                return;
            }

            // Call SQL Server stored procedure
            String sql =
                "{CALL dbo.sp_s1_insert(?, ?, ?, ?, ?, ?, ?)}";

            try (Connection con = JDBC.con()) {

                if (con == null || con.isClosed()) {
                    throw new SQLException(
                        "Database connection is unavailable."
                    );
                }

                try (CallableStatement cs = con.prepareCall(sql);
                     InputStream inputStream =
                         filePart.getInputStream()) {

                    cs.setInt(1, studentId);
                    cs.setString(2, name);
                    cs.setString(3, gen);
                    cs.setString(4, cou);
                    cs.setDate(5, dobValue);
                    cs.setBinaryStream(
                        6, inputStream, filePart.getSize()
                    );
                    cs.setTime(7, timeValue);

                    cs.execute();
                }
            }

            // Successful insertion
            response.sendRedirect(
                request.getContextPath() + "/student.jsp?success=1"
            );

        } catch (IllegalArgumentException ex) {
            response.getWriter().println(
                "Invalid student details: " + ex.getMessage()
            );

        } catch (Exception ex) {
            log("Error inserting student details", ex);

            response.getWriter().println(
                "Unable to save student details. Check the server log."
            );
        }
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
            request.getContextPath() + "/student.jsp"
        );
    }

    @Override
    public String getServletInfo() {
        return "Student insertion servlet";
    }
}
