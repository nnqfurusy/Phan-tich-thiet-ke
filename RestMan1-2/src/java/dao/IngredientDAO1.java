package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Ingredient1;

/**
 * Truy van nguyen lieu (bang Ingredient1).
 */
public class IngredientDAO1 extends DAO1 {

    public IngredientDAO1() {
        super();
    }

    /**
     * Tim cac nguyen lieu co ten chua tu khoa
     */
    public List<Ingredient1> searchIngredient(String key) {
        List<Ingredient1> result = new ArrayList<>();
        String sql = "SELECT * FROM Ingredient1 WHERE ingredientName LIKE ? ORDER BY id";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + (key == null ? "" : key.trim()) + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Ingredient1 i = new Ingredient1();
                    i.setId(rs.getInt("id"));
                    i.setIngredientName(rs.getString("ingredientName"));
                    i.setUnit(rs.getString("unit"));
                    i.setPrice(rs.getDouble("price"));
                    i.setQuantityInStock(rs.getDouble("quantityInStock"));
                    i.setDescription(rs.getString("description"));
                    result.add(i);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * Them nguyen lieu moi (so luong ton = 0)
     */
    public boolean addNewIngredient(Ingredient1 ingredient) {
        String sql = "INSERT INTO Ingredient1 (ingredientName, unit, price, quantityInStock, description) "
                + "VALUES (?, ?, ?, 0, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, ingredient.getIngredientName());
            ps.setString(2, ingredient.getUnit());
            ps.setDouble(3, ingredient.getPrice());
            ps.setString(4, ingredient.getDescription());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    ingredient.setId(keys.getInt(1));
                }
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cong them so luong vua nhap vao ton kho va cap nhat don gia nhap gan nhat.
     */
    public boolean updateAmountInStock(Ingredient1 ingredient, double quantity, double purchasePrice) {
        String sql = "UPDATE Ingredient1 SET quantityInStock = quantityInStock + ?, price = ? WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDouble(1, quantity);
            ps.setDouble(2, purchasePrice);
            ps.setInt(3, ingredient.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
