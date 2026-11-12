package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Supplier1;

/**
 * Truy van nha cung cap (bang Supplier1).
 */
public class SupplierDAO1 extends DAO1 {

    public SupplierDAO1() {
        super();
    }

    /**
     * Tim cac nha cung cap co ten chua tu khoa
     */
    public List<Supplier1> searchSupplier(String key) {
        List<Supplier1> result = new ArrayList<>();
        String sql = "SELECT * FROM Supplier1 WHERE supplierName LIKE ? ORDER BY id";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + (key == null ? "" : key.trim()) + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Supplier1 s = new Supplier1();
                    s.setId(rs.getInt("id"));
                    s.setSupplierName(rs.getString("supplierName"));
                    s.setAddress(rs.getString("address"));
                    s.setPhoneNumber(rs.getString("phoneNumber"));
                    s.setEmail(rs.getString("email"));
                    result.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * Them nha cung cap moi
     */
    public boolean addNewSupplier(Supplier1 supplier) {
        String sql = "INSERT INTO Supplier1 (supplierName, address, phoneNumber, email) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, supplier.getSupplierName());
            ps.setString(2, supplier.getAddress());
            ps.setString(3, supplier.getPhoneNumber());
            ps.setString(4, supplier.getEmail());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    supplier.setId(keys.getInt(1));
                }
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
