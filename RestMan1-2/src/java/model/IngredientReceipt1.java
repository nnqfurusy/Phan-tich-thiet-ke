package model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class IngredientReceipt1 {
    private int id;
    private LocalDateTime receivedAt;
    private String receiptStatus;
    private WarehouseStaff1 warehouseStaff;
    private Supplier1 supplier;
    private List<IngredientReceiptDetail1> ingredientReceiptDetail;

    public IngredientReceipt1() {
        ingredientReceiptDetail = new ArrayList<>();
        receiptStatus = "paid";
    }

    /** Tao hoa don nhap moi cho nha cung cap va nhan vien kho da chon. */
    public IngredientReceipt1(Supplier1 supplier, WarehouseStaff1 warehouseStaff) {
        this();
        this.supplier = supplier;
        this.warehouseStaff = warehouseStaff;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public LocalDateTime getReceivedAt() {
        return receivedAt;
    }

    public void setReceivedAt(LocalDateTime receivedAt) {
        this.receivedAt = receivedAt;
    }

    public String getReceiptStatus() {
        return receiptStatus;
    }

    public void setReceiptStatus(String receiptStatus) {
        this.receiptStatus = receiptStatus;
    }

    public WarehouseStaff1 getWarehouseStaff() {
        return warehouseStaff;
    }

    public void setWarehouseStaff(WarehouseStaff1 warehouseStaff) {
        this.warehouseStaff = warehouseStaff;
    }

    public Supplier1 getSupplier() {
        return supplier;
    }

    public void setSupplier(Supplier1 supplier) {
        this.supplier = supplier;
    }

    public List<IngredientReceiptDetail1> getIngredientReceiptDetail() {
        return ingredientReceiptDetail;
    }

    public void setIngredientReceiptDetail(List<IngredientReceiptDetail1> ingredientReceiptDetail) {
        this.ingredientReceiptDetail = ingredientReceiptDetail;
    }

    /**
     * Them mot nguyen lieu vao hoa don. Neu nguyen lieu da co voi cung don gia
     * thi cong don so luong, nguoc lai them dong moi.
     */
    public void addDetail(IngredientReceiptDetail1 detail) {
        for (IngredientReceiptDetail1 d : ingredientReceiptDetail) {
            if (d.getIngredient().getId() == detail.getIngredient().getId()
                    && d.getPurchasePrice() == detail.getPurchasePrice()) {
                d.setQuantity(d.getQuantity() + detail.getQuantity());
                return;
            }
        }
        ingredientReceiptDetail.add(detail);
    }

    /** Tong tien hoa don = tong thanh tien cac dong. */
    public double getTotalValue() {
        double total = 0;
        for (IngredientReceiptDetail1 d : ingredientReceiptDetail) {
            total += d.getLineTotal();
        }
        return total;
    }
}
