package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import model.IngredientReceipt1;
import model.IngredientReceiptDetail1;

/**
 * Luu hoa don nhap nguyen lieu (bang IngredientReceipt1 + IngredientReceiptDetail1).
 */
public class IngredientReceiptDAO1 extends DAO1 {

    public IngredientReceiptDAO1() {
        super();
    }

    /**
     * Luu hoa don va cac dong chi tiet trong mot transaction.
     */
    public boolean saveImportReceipt(IngredientReceipt1 receipt) {
        String sqlReceipt = "INSERT INTO IngredientReceipt1 "
                + "(receiptStatus, receivedAt, totalValue, warehouseStaffId, supplierId) VALUES (?, ?, ?, ?, ?)";
        String sqlDetail = "INSERT INTO IngredientReceiptDetail1 "
                + "(quantity, purchasePrice, ingredientReceiptId, ingredientId) VALUES (?, ?, ?, ?)";
        LocalDateTime now = LocalDateTime.now().withNano(0);
        try {
            con.setAutoCommit(false);
            try (PreparedStatement ps = con.prepareStatement(sqlReceipt, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, receipt.getReceiptStatus());
                ps.setTimestamp(2, Timestamp.valueOf(now));
                ps.setDouble(3, receipt.getTotalValue());
                ps.setInt(4, receipt.getWarehouseStaff().getId());
                ps.setInt(5, receipt.getSupplier().getId());
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        receipt.setId(keys.getInt(1));
                    }
                }
            }
            try (PreparedStatement ps = con.prepareStatement(sqlDetail, Statement.RETURN_GENERATED_KEYS)) {
                for (IngredientReceiptDetail1 d : receipt.getIngredientReceiptDetail()) {
                    ps.setDouble(1, d.getQuantity());
                    ps.setDouble(2, d.getPurchasePrice());
                    ps.setInt(3, receipt.getId());
                    ps.setInt(4, d.getIngredient().getId());
                    ps.executeUpdate();
                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (keys.next()) {
                            d.setId(keys.getInt(1));
                        }
                    }
                }
            }
            con.commit();
            receipt.setReceivedAt(now);
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                con.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            receipt.setId(0);
        } finally {
            try {
                con.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }
}
