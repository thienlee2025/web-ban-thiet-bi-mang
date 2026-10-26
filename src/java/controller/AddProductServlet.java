package controller;

import connect.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/add-product")
public class AddProductServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // Lấy dữ liệu từ form
        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String image = request.getParameter("image");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String quantityStr = request.getParameter("quantity");
        String status = request.getParameter("status");

        // Chống null
        if (name == null) name = "";
        if (priceStr == null) priceStr = "";
        if (image == null) image = "";
        if (description == null) description = "";
        if (category == null) category = "";
        if (quantityStr == null) quantityStr = "0";

        name = name.trim();
        priceStr = priceStr.trim();
        image = image.trim();
        description = description.trim();
        category = category.trim();
        quantityStr = quantityStr.trim();

        // Kiểm tra rỗng
        if (name.isEmpty() || priceStr.isEmpty() || category.isEmpty()) {
            request.setAttribute("error", "Tên sản phẩm, giá và danh mục không được để trống!");
            request.getRequestDispatcher("add-product.jsp").forward(request, response);
            return;
        }

        // Kiểm tra giá
        double price;
        try {
            price = Double.parseDouble(priceStr);
            if (price <= 0) {
                request.setAttribute("error", "Giá sản phẩm phải lớn hơn 0!");
                request.getRequestDispatcher("add-product.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Giá sản phẩm không hợp lệ!");
            request.getRequestDispatcher("add-product.jsp").forward(request, response);
            return;
        }

        // Xử lý số lượng và trạng thái
        int quantity = Integer.parseInt(quantityStr);
        if (quantity < 0) quantity = 0;
        
        // Nếu quantity = 0 -> Hết hàng, > 0 -> Còn hàng (ghi đè status từ form)
        if (quantity == 0) {
            status = "Hết hàng";
        } else {
            status = "Còn hàng";
        }

        // Ảnh mặc định
        if (image.isEmpty()) {
            image = "default.jpg";
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            // Kiểm tra trùng tên
            String checkSql = "SELECT id FROM products WHERE name = ?";
            ps = conn.prepareStatement(checkSql);
            ps.setString(1, name);
            rs = ps.executeQuery();
            if (rs.next()) {
                request.setAttribute("error", "Sản phẩm \"" + name + "\" đã tồn tại!");
                request.getRequestDispatcher("add-product.jsp").forward(request, response);
                return;
            }
            rs.close();
            ps.close();

            // Thêm sản phẩm
            String sql = "INSERT INTO products (name, price, image, description, category, status, quantity) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setDouble(2, price);
            ps.setString(3, image);
            ps.setString(4, description);
            ps.setString(5, category);
            ps.setString(6, status);
            ps.setInt(7, quantity);

            int result = ps.executeUpdate();

            if (result > 0) {
                session.setAttribute("success", "✅ Thêm sản phẩm \"" + name + "\" thành công!");
                response.sendRedirect("qlspham.jsp");
            } else {
                request.setAttribute("error", "Thêm sản phẩm thất bại!");
                request.getRequestDispatcher("add-product.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("add-product.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}