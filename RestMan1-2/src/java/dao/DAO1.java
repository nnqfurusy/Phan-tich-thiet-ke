package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DAO1 {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/restman1"
            + "?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = ""; // XAMPP mac dinh: root, khong mat khau

    protected static Connection con;

    public DAO1() {
        try {
            if (con == null || con.isClosed() || !con.isValid(2)) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            }
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Khong tim thay MySQL JDBC driver. "
                    + "Hay chep file mysql-connector-j-*.jar vao web/WEB-INF/lib", e);
        } catch (SQLException e) {
            throw new RuntimeException("Khong ket noi duoc CSDL restman1. "
                    + "Hay bat MySQL trong XAMPP va import file database/restman1.sql", e);
        }
    }
}
