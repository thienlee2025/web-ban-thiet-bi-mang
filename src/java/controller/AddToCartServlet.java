package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;
import java.util.*;

import model.CartItem;
import connect.DBConnection;

@WebServlet("/add-to-cart")
public class AddToCartServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        String name = "";
        String image = "";
        double finalPrice = 0;

        try {
            Connection conn = DBConnection.getConnection();

            PreparedStatement ps = conn.prepareStatement(
                "SELECT name, image, price, discount_percent FROM products WHERE id=?"
            );

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                name = rs.getString("name");
                image = rs.getString("image");

                double price = rs.getDouble("price");
                int discount = rs.getInt("discount_percent");

                finalPrice = price;

                if (discount > 0) {
                    finalPrice = price - (price * discount / 100.0);
                }
            }

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        HttpSession session = request.getSession();

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null) {
            cart = new ArrayList<>();
        }

        boolean found = false;

        for (CartItem item : cart) {
            if (item.getId() == id) {
                item.setQuantity(item.getQuantity() + quantity);
                found = true;
                break;
            }
        }

        if (!found) {
            cart.add(new CartItem(id, name, finalPrice, image, quantity));
        }

        session.setAttribute("cart", cart);

        response.sendRedirect("products.jsp");
    }
}