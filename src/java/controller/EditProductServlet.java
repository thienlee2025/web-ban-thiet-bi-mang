package controller;

import connect.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/edit-product")
public class EditProductServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String image = request.getParameter("image");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String quantityStr = request.getParameter("quantity");

        if (name == null) name = "";
        if (priceStr == null) priceStr = "";
        if (image == null) image = "";
        if (description == null) description = "";
        if (category == null) category = "";
        if (quantityStr == null) quantityStr = "0";

        name = name.trim();
        priceStr = priceStr.trim();
        image = image.trim();
        category = category.trim();
        quantityStr = quantityStr.trim();

        if (name.isEmpty() || priceStr.isEmpty() || category.isEmpty()) {
            session.setAttribute("error", "Tên, giá và danh mục không được để trống!");
            response.sendRedirect("edit-product.jsp?id=" + id);
            return;
        }

        double price;
        try {
            price = Double.parseDouble(priceStr);
            if (price <= 0) throw new Exception();
        } catch (Exception e) {
            session.setAttribute("error", "Giá sản phẩm không hợp lệ!");
            response.sendRedirect("edit-product.jsp?id=" + id);
            return;
        }

        int quantity = Integer.parseInt(quantityStr);
        if (quantity < 0) quantity = 0;
        
        // Nếu quantity = 0 -> Hết hàng, > 0 -> Còn hàng
        String status = (quantity == 0) ? "Hết hàng" : "Còn hàng";
        
        if (image.isEmpty()) image = "default.jpg";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            // Kiểm tra trùng tên (trừ chính nó)
            ps = conn.prepareStatement("SELECT id FROM products WHERE name = ? AND id != ?");
            ps.setString(1, name);
            ps.setInt(2, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                session.setAttribute("error", "Sản phẩm \"" + name + "\" đã tồn tại!");
                response.sendRedirect("edit-product.jsp?id=" + id);
                return;
            }
            rs.close();
            ps.close();

            // Cập nhật sản phẩm
            String sql = "UPDATE products SET name=?, price=?, image=?, description=?, category=?, status=?, quantity=? WHERE id=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setDouble(2, price);
            ps.setString(3, image);
            ps.setString(4, description);
            ps.setString(5, category);
            ps.setString(6, status);
            ps.setInt(7, quantity);
            ps.setInt(8, id);

            int result = ps.executeUpdate();

            if (result > 0) {
                session.setAttribute("success", "✅ Cập nhật sản phẩm \"" + name + "\" thành công!");
                response.sendRedirect("qlspham.jsp");
            } else {
                session.setAttribute("error", "Cập nhật thất bại!");
                response.sendRedirect("edit-product.jsp?id=" + id);
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect("edit-product.jsp?id=" + id);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}