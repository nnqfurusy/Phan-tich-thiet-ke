package model;

public class IngredientReceiptDetail1 {
    private int id;
    private Ingredient1 ingredient;
    private double quantity;
    private double purchasePrice;

    public IngredientReceiptDetail1() {
    }

    /** Tao mot dong chi tiet: nguyen lieu, so luong nhap, don gia nhap. */
    public IngredientReceiptDetail1(Ingredient1 ingredient, double quantity, double purchasePrice) {
        this.ingredient = ingredient;
        this.quantity = quantity;
        this.purchasePrice = purchasePrice;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Ingredient1 getIngredient() {
        return ingredient;
    }

    public void setIngredient(Ingredient1 ingredient) {
        this.ingredient = ingredient;
    }

    public double getQuantity() {
        return quantity;
    }

    public void setQuantity(double quantity) {
        this.quantity = quantity;
    }

    public double getPurchasePrice() {
        return purchasePrice;
    }

    public void setPurchasePrice(double purchasePrice) {
        this.purchasePrice = purchasePrice;
    }

    /** Thanh tien cua dong = so luong x don gia nhap. */
    public double getLineTotal() {
        return quantity * purchasePrice;
    }
}
