package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Dish1;

/**
 * Truy van mon an (bang Dish1).
 */
public class DishDAO1 extends DAO1 {

    public DishDAO1() {
        super();
    }

    /**
     * Tim cac mon an co ten chua tu khoa
     */
    public List<Dish1> searchDish(String key) {
        List<Dish1> result = new ArrayList<>();
        String sql = "SELECT * FROM Dish1 WHERE foodName LIKE ? ORDER BY id";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + (key == null ? "" : key.trim()) + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(toDish(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * Lay thong tin chi tiet mot mon an theo id. Khong co -> null.
     */
    public Dish1 getDish(int id) {
        String sql = "SELECT * FROM Dish1 WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return toDish(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Dish1 toDish(ResultSet rs) throws SQLException {
        Dish1 dish = new Dish1();
        dish.setId(rs.getInt("id"));
        dish.setFoodName(rs.getString("foodName"));
        dish.setFoodCategory(rs.getString("foodCategory"));
        dish.setDescription(rs.getString("description"));
        dish.setImage(rs.getString("image"));
        dish.setUnit(rs.getString("unit"));
        dish.setPrice(rs.getDouble("price"));
        return dish;
    }
}
