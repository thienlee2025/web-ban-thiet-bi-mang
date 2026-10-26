package model;

public class CartItem {
    private int id;
    private String name;
    private double price;
    
    private int quantity;
    private String image;

    public CartItem(int id, String name, double price, String image, int quantity) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.image = image;
        this.quantity = quantity;
    }

    public CartItem() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }


    public int getId() { return id; }
    public String getName() { return name; }
    public double getPrice() { return price; }
  
    public int getQuantity() { return quantity; }
    public String getImage() { return image;
}
    
    public void setImage(String image) {
    this.image = image;
}

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public void setId(int aInt) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public void setName(String string) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public void setPrice(double finalPrice) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}