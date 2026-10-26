package controller;

import model.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/update-cart")
public class UpdateCartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        
        if (cart == null) {
            response.setStatus(400);
            return;
        }
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            if (quantity < 1) quantity = 1;
            if (quantity > 99) quantity = 99;
            
            for (CartItem item : cart) {
                if (item.getId() == id) {
                    item.setQuantity(quantity);
                    break;
                }
            }
            
            session.setAttribute("cart", cart);
            response.setStatus(200);
            
        } catch (NumberFormatException e) {
            response.setStatus(400);
        }
    }
}