package controller;

import connect.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;      // THÊM: để kiểm tra người dùng tồn tại

@WebServlet("/delete-user")
public class DeleteUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        /* ========== KIỂM TRA ID ========== */
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            request.getSession().setAttribute("error", "⚠️ Không tìm thấy ID người dùng!");
            response.sendRedirect("users.jsp");
            return;
        }

        /* ========== LẤY THÔNG TIN ADMIN HIỆN TẠI (THÊM MỚI) ========== */
        HttpSession session = request.getSession();
        String currentUser = (String) session.getAttribute("user");
        String currentRole = (String) session.getAttribute("role");

        Connection conn = null;
        PreparedStatement checkPs = null;
        PreparedStatement deletePs = null;
        ResultSet rs = null;
        String userName = "";

        try {
            int id = Integer.parseInt(idStr);
            conn = DBConnection.getConnection();

            /* ========== KIỂM TRA NGƯỜI DÙNG TỒN TẠI ========== */
            String checkSql = "SELECT hoten, role, username FROM users WHERE id = ?";
            checkPs = conn.prepareStatement(checkSql);
            checkPs.setInt(1, id);
            rs = checkPs.executeQuery();

            if (!rs.next()) {
                request.getSession().setAttribute("error", "⚠️ Không tìm thấy người dùng cần xóa!");
                response.sendRedirect("users.jsp");
                return;
            }

            userName = rs.getString("hoten");
            String userRole = rs.getString("role");
            String userUsername = rs.getString("username");

            /* ========== KHÔNG CHO XÓA ADMIN CUỐI CÙNG (THÊM MỚI) ========== */
            if ("admin".equals(userRole)) {
                // Đếm số lượng admin còn lại
                PreparedStatement countPs = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE role = 'admin'");
                ResultSet countRs = countPs.executeQuery();
                countRs.next();
                int adminCount = countRs.getInt(1);
                countRs.close();
                countPs.close();
                
                if (adminCount <= 1) {
                    request.getSession().setAttribute("error", "⚠️ Không thể xóa admin cuối cùng của hệ thống!");
                    response.sendRedirect("users.jsp");
                    return;
                }
            }

            /* ========== KHÔNG CHO XÓA CHÍNH MÌNH ========== */
            if (userUsername != null && userUsername.equals(currentUser)) {
                request.getSession().setAttribute("error", "⚠️ Bạn không thể xóa chính mình!");
                response.sendRedirect("users.jsp");
                return;
            }

            rs.close();
            checkPs.close();

            /* ========== KIỂM TRA RÀNG BUỘC KHÓA NGOẠI (THÊM MỚI) ========== */
            // Kiểm tra xem người dùng có đơn hàng nào không
            String checkOrderSql = "SELECT COUNT(*) FROM orders WHERE username = ?";
            PreparedStatement checkOrderPs = conn.prepareStatement(checkOrderSql);
            checkOrderPs.setString(1, userUsername);
            ResultSet orderRs = checkOrderPs.executeQuery();
            
            if (orderRs.next() && orderRs.getInt(1) > 0) {
                request.getSession().setAttribute("error", "⚠️ Không thể xóa người dùng \"" + userName + "\" vì đã có đơn hàng!");
                response.sendRedirect("users.jsp");
                orderRs.close();
                checkOrderPs.close();
                return;
            }
            orderRs.close();
            checkOrderPs.close();

            /* ========== XÓA NGƯỜI DÙNG ========== */
            String deleteSql = "DELETE FROM users WHERE id = ?";
            deletePs = conn.prepareStatement(deleteSql);
            deletePs.setInt(1, id);

            int result = deletePs.executeUpdate();
            deletePs.close();
            conn.close();

            /* ========== THÔNG BÁO KẾT QUẢ ========== */
            if (result > 0) {
                session.setAttribute("success", "✅ Đã xóa người dùng \"" + userName + "\" thành công!");
            } else {
                session.setAttribute("error", "⚠️ Xóa người dùng thất bại!");
            }
            
            response.sendRedirect("users.jsp");

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "⚠️ ID người dùng không hợp lệ!");
            response.sendRedirect("users.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "⚠️ Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect("users.jsp");
        } finally {
            // Đóng tài nguyên
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (checkPs != null) checkPs.close(); } catch (Exception e) {}
            try { if (deletePs != null) deletePs.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    /* ========== XỬ LÝ POST - CHUYỂN HƯỚNG VỀ GET ========== */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}