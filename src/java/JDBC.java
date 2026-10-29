
package DB;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class JDBC {

    private static final String URL =
        "jdbc:sqlserver://localhost:1433;"
        + "databaseName=newDB;"
        + "encrypt=true;"
        + "trustServerCertificate=true;";

    private static final String USER = "moni";
    private static final String PASSWORD = "moni3204";

    public static Connection con() throws Exception {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    public static void main(String[] args) {
        try (Connection con = JDBC.con()) {
            System.out.println("Database connected successfully!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
