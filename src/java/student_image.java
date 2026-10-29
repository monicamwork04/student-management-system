import DB.JDBC;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/student_image")
public class student_image extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");

        if (id == null || !id.matches("\\d+")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                               "Invalid student ID");
            return;
        }

        String sql = "SELECT img FROM dbo.tbl_stud1 WHERE id = ?";

        try (Connection con = JDBC.con();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, Integer.parseInt(id));

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    byte[] image = rs.getBytes("img");

                    if (image != null && image.length > 0) {
                        // Set the image type based on its actual format.
                        String contentType =
                            java.net.URLConnection.guessContentTypeFromStream(
                                new java.io.ByteArrayInputStream(image));

                        response.setContentType(
                            contentType != null ? contentType : "image/jpeg");

                        response.setContentLength(image.length);
                        response.setHeader("Cache-Control", "no-store");
                        response.getOutputStream().write(image);
                    } else {
                        response.sendError(
                            HttpServletResponse.SC_NOT_FOUND,
                            "Image not found");
                    }
                } else {
                    response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Student not found");
                }
            }

        } catch (Exception ex) {
            getServletContext().log("Unable to load student image", ex);

            if (!response.isCommitted()) {
                response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load image");
            }
        }
    }
}