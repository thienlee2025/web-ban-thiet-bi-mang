package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.util.List;

import model.CartItem;

@WebServlet("/remove-cart")
public class RemoveCartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        int id =
        Integer.parseInt(request.getParameter("id"));

        HttpSession session =
        request.getSession();

        List<CartItem> cart =
        (List<CartItem>) session.getAttribute("cart");

        if(cart != null){

            cart.removeIf(item ->
                item.getId() == id
            );

            session.setAttribute("cart", cart);
        }

        response.sendRedirect("cart.jsp");
    }
}