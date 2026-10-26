package controller;

import connect.DBConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;      // THÊM: để kiểm tra sản phẩm tồn tại

@WebServlet("/delete-product")
public class DeleteProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        /* ======================
           KIỂM TRA ID (THÊM MỚI)
        ====================== */
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            request.getSession().setAttribute("error", "⚠️ Không tìm thấy ID sản phẩm!");
            response.sendRedirect("qlspham.jsp");
            return;
        }

        Connection conn = null;
        PreparedStatement checkPs = null;
        PreparedStatement deletePs = null;
        ResultSet rs = null;
        String productName = "";

        try {
            int id = Integer.parseInt(idStr);

            conn = DBConnection.getConnection();

            /* ======================
               KIỂM TRA SẢN PHẨM CÓ TỒN TẠI KHÔNG (THÊM MỚI)
            ====================== */
            String checkSql = "SELECT name FROM products WHERE id = ?";
            checkPs = conn.prepareStatement(checkSql);
            checkPs.setInt(1, id);
            rs = checkPs.executeQuery();

            if (!rs.next()) {
                request.getSession().setAttribute("error", "⚠️ Không tìm thấy sản phẩm cần xóa!");
                response.sendRedirect("qlspham.jsp");
                return;
            }
            
            productName = rs.getString("name");  // Lưu tên để hiển thị thông báo
            rs.close();
            checkPs.close();

            /* ======================
               KIỂM TRA RÀNG BUỘC KHÓA NGOẠI (THÊM MỚI)
               Kiểm tra xem sản phẩm có đang được tham chiếu trong order_items không
            ====================== */
            String checkOrderSql = "SELECT COUNT(*) FROM order_items WHERE product_id = ?";
            PreparedStatement checkOrderPs = conn.prepareStatement(checkOrderSql);
            checkOrderPs.setInt(1, id);
            ResultSet orderRs = checkOrderPs.executeQuery();
            
            if (orderRs.next() && orderRs.getInt(1) > 0) {
                request.getSession().setAttribute("error", "⚠️ Không thể xóa sản phẩm \"" + productName + "\" vì đã có trong đơn hàng!");
                response.sendRedirect("qlspham.jsp");
                orderRs.close();
                checkOrderPs.close();
                return;
            }
            orderRs.close();
            checkOrderPs.close();

            /* ======================
               XÓA SẢN PHẨM
            ====================== */
            String deleteSql = "DELETE FROM products WHERE id = ?";
            deletePs = conn.prepareStatement(deleteSql);
            deletePs.setInt(1, id);

            int result = deletePs.executeUpdate();
            deletePs.close();
            conn.close();

            /* ======================
               THÔNG BÁO KẾT QUẢ
            ====================== */
            if (result > 0) {
                request.getSession().setAttribute("success", "✅ Xóa sản phẩm \"" + productName + "\" thành công!");
            } else {
                request.getSession().setAttribute("error", "⚠️ Xóa sản phẩm thất bại!");
            }
            
            response.sendRedirect("qlspham.jsp");

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "⚠️ ID sản phẩm không hợp lệ!");
            response.sendRedirect("qlspham.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "⚠️ Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect("qlspham.jsp");
            
        } finally {
            // Đóng tài nguyên
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (checkPs != null) checkPs.close(); } catch (Exception e) {}
            try { if (deletePs != null) deletePs.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    /* ======================
       XỬ LÝ POST - CHUYỂN HƯỚNG VỀ GET (THÊM MỚI)
       (Để tránh gửi request POST xóa)
    ====================== */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // Chuyển hướng về doGet để xử lý
        doGet(request, response);
    }
}