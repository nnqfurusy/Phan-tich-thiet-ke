package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Customer1;
import model.Member1;
import model.WarehouseStaff1;

/**
 * Xu ly dang nhap (bang Account1).
 */
public class MemberDAO1 extends DAO1 {

    public MemberDAO1() {
        super();
    }

    /**
     * Kiem tra username/password. Neu dung thi gan id, role vao member.
     */
    public boolean checkLogin(Member1 member) {
        String sql = "SELECT id, role FROM Account1 "
                + "WHERE username = ? AND password = ? AND accountStatus = 'active'";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, member.getUsername());
            ps.setString(2, member.getPassword());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    member.setId(rs.getInt("id"));
                    member.setRole(rs.getString("role"));
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Lay thong tin nhan vien kho tuong ung voi tai khoan da dang nhap. */
    public WarehouseStaff1 getWarehouseStaff(Member1 member) {
        String sql = "SELECT e.* FROM Employee1 e JOIN Account1 a ON a.employeeId = e.id WHERE a.id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, member.getId());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    WarehouseStaff1 staff = new WarehouseStaff1();
                    staff.setId(rs.getInt("id"));
                    staff.setFullName(rs.getString("fullName"));
                    staff.setPhoneNumber(rs.getString("phoneNumber"));
                    staff.setEmail(rs.getString("email"));
                    staff.setPosition(rs.getString("position"));
                    staff.setMember(member);
                    return staff;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** Lay thong tin khach hang tuong ung voi tai khoan da dang nhap. */
    public Customer1 getCustomer(Member1 member) {
        String sql = "SELECT c.* FROM Customer1 c JOIN Account1 a ON a.customerId = c.id WHERE a.id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, member.getId());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer1 customer = new Customer1();
                    customer.setId(rs.getInt("id"));
                    customer.setFullName(rs.getString("fullName"));
                    customer.setPhoneNumber(rs.getString("phoneNumber"));
                    customer.setEmail(rs.getString("email"));
                    customer.setNote(rs.getString("note"));
                    customer.setMember(member);
                    return customer;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
