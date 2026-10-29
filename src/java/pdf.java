
import DB.JDBC;
import java.io.IOException;
import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Types;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.itextpdf.text.Document;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Image;
import com.itextpdf.text.Element;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfPCell;

@WebServlet("/pdf")
public class pdf extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/pdf");
        response.setHeader(
            "Content-Disposition",
            "attachment; filename=\"Student_Report.pdf\""
        );

        Document document = new Document(PageSize.A4.rotate());

        try {
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            Paragraph title = new Paragraph("STUDENT DETAILS REPORT");
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);
            document.add(new Paragraph(" "));

            String sql = "{CALL dbo.sp_s1_get}";

            try (Connection con = JDBC.con();
                 CallableStatement cs = con.prepareCall(sql);
                 ResultSet rs = cs.executeQuery()) {

                ResultSetMetaData meta = rs.getMetaData();
                int columnCount = meta.getColumnCount();

                PdfPTable table = new PdfPTable(columnCount);
                table.setWidthPercentage(100);

                // Table headings
                for (int i = 1; i <= columnCount; i++) {
                    PdfPCell cell = new PdfPCell(
                        new Phrase(meta.getColumnLabel(i))
                    );
                    table.addCell(cell);
                }

                boolean hasRecords = false;

                while (rs.next()) {
                    hasRecords = true;

                    for (int i = 1; i <= columnCount; i++) {

                        String columnName =
                            meta.getColumnLabel(i);

                        if ("img".equalsIgnoreCase(columnName)) {

                            byte[] imageBytes = rs.getBytes(i);

                            if (imageBytes != null &&
                                imageBytes.length > 0) {

                                try {
                                    Image studentImage =
                                        Image.getInstance(imageBytes);

                                    studentImage.scaleToFit(80, 80);
                                    studentImage.setAlignment(
                                        Element.ALIGN_CENTER
                                    );

                                    PdfPCell imageCell =
                                        new PdfPCell(studentImage, true);

                                    imageCell.setHorizontalAlignment(
                                        Element.ALIGN_CENTER
                                    );
                                    imageCell.setVerticalAlignment(
                                        Element.ALIGN_MIDDLE
                                    );
                                    imageCell.setPadding(5);

                                    table.addCell(imageCell);

                                } catch (Exception imageError) {
                                    table.addCell("Invalid image");
                                }

                            } else {
                                table.addCell("No image");
                            }

                        } else {
                            Object value = rs.getObject(i);

                            PdfPCell cell = new PdfPCell(
                                new Phrase(
                                    value == null
                                        ? ""
                                        : value.toString()
                                )
                            );

                            table.addCell(cell);
                        }
                    }
                }

                if (hasRecords) {
                    document.add(table);
                } else {
                    document.add(
                        new Paragraph("No student records found.")
                    );
                }
            }

        } catch (Exception e) {
            throw new ServletException(
                "Unable to generate student PDF.", e
            );
        } finally {
            if (document.isOpen()) {
                document.close();
            }
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
        return "Student PDF export servlet";
    }
}
