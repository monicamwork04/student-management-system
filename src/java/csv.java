
import DB.JDBC;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author acer
 */
@WebServlet("/csv")
public class csv extends HttpServlet {

    private String escapeCSV(String value) {
        if (value == null) {
            return "";
        }

        return "\"" + value.replace("\"", "\"\"") + "\"";
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader(
            "Content-Disposition",
            "attachment; filename=\"SD_csv.csv\""
        );

        StringBuilder csvData = new StringBuilder();

        csvData.append("ID,NAME,DOB,TIME,GENDER,COURSE\n");

        String sql = "{CALL dbo.sp_s1_get}";

        try (Connection con = JDBC.con();
             CallableStatement cs = con.prepareCall(sql);
             ResultSet rs = cs.executeQuery()) {

            while (rs.next()) {
                csvData.append(escapeCSV(rs.getString("id"))).append(",");
                csvData.append(escapeCSV(rs.getString("name"))).append(",");
                csvData.append(escapeCSV(
                    rs.getString("dob")
                )).append(",");
                csvData.append(escapeCSV(
                    rs.getString("stud_time")
                )).append(",");
                csvData.append(escapeCSV(rs.getString("gen"))).append(",");
                csvData.append(escapeCSV(rs.getString("cou"))).append("\r\n");
            }

            response.getOutputStream().write(
                csvData.toString().getBytes(StandardCharsets.UTF_8)
            );
            response.getOutputStream().flush();

      } catch (Exception e) {
    throw new ServletException("Unable to export student records.", e);
}
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "CSV export servlet";
    }
}
