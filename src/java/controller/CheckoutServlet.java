package controller;

import connect.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;

import model.CartItem;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        // Kiểm tra đăng nhập
        String user = (String) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy thông tin từ form
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");      // THÊM
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Chống null
        if (fullname == null) fullname = "";
        if (email == null) email = "";                     // THÊM
        if (phone == null) phone = "";
        if (address == null) address = "";

        fullname = fullname.trim();
        email = email.trim();                              // THÊM
        phone = phone.trim();
        address = address.trim();

        // Kiểm tra rỗng (chỉ các trường bắt buộc)
        if (fullname.isEmpty() || email.isEmpty() || phone.isEmpty() || address.isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
            return;
        }

        // Kiểm tra số điện thoại
        if (!phone.matches("0\\d{9}")) {
            request.setAttribute("error", "Số điện thoại không hợp lệ (phải bắt đầu bằng 0 và có 10 số)!");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
            return;
        }

        // Lấy giỏ hàng
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        // Tính tổng tiền
        double total = 0;
        for (CartItem item : cart) {
            total += item.getPrice() * item.getQuantity();
        }

        Connection conn = null;
        PreparedStatement ps = null;
        PreparedStatement itemPs = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            // Insert order (thêm cột email)
            String sql = "INSERT INTO orders (fullname, email, phone, address, total, username, status) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, fullname);
            ps.setString(2, email);        // THÊM
            ps.setString(3, phone);
            ps.setString(4, address);
            ps.setDouble(5, total);
            ps.setString(6, user);
            ps.setString(7, "pending");

            ps.executeUpdate();

            // Lấy order_id
            rs = ps.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) {
                orderId = rs.getInt(1);
            }

            // Insert order_items
            String itemSql = "INSERT INTO order_items (order_id, product_name, price, quantity) VALUES (?, ?, ?, ?)";
            itemPs = conn.prepareStatement(itemSql);
            for (CartItem item : cart) {
                itemPs.setInt(1, orderId);
                itemPs.setString(2, item.getName());
                itemPs.setDouble(3, item.getPrice());
                itemPs.setInt(4, item.getQuantity());
                itemPs.executeUpdate();
            }

            // Xóa giỏ hàng
            session.removeAttribute("cart");

            // Chuyển đến trang thành công
            response.sendRedirect("success.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi thanh toán: " + e.getMessage());
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (itemPs != null) itemPs.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}