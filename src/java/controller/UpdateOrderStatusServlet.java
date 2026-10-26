package controller;

import connect.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/update-order-status")
public class UpdateOrderStatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Lấy tham số
        String idStr = request.getParameter("id");
        String status = request.getParameter("status");

        // Kiểm tra ID
        if (idStr == null || idStr.trim().isEmpty()) {
            request.getSession().setAttribute("error", "Không tìm thấy ID đơn hàng!");
            response.sendRedirect("orders.jsp");
            return;
        }

        // Kiểm tra status
        if (status == null || status.trim().isEmpty()) {
            request.getSession().setAttribute("error", "Trạng thái không hợp lệ!");
            response.sendRedirect("orders.jsp");
            return;
        }

        // Danh sách trạng thái hợp lệ
        String[] validStatuses = {"pending", "confirmed", "shipping", "completed", "cancelled"};
        boolean isValid = false;
        for (String s : validStatuses) {
            if (s.equals(status)) {
                isValid = true;
                break;
            }
        }

        if (!isValid) {
            request.getSession().setAttribute("error", "Trạng thái không hợp lệ!");
            response.sendRedirect("orders.jsp");
            return;
        }

        Connection conn = null;
        PreparedStatement checkPs = null;
        PreparedStatement updatePs = null;
        ResultSet rs = null;

        try {
            int id = Integer.parseInt(idStr);
            conn = DBConnection.getConnection();

            // Kiểm tra đơn hàng tồn tại
            String checkSql = "SELECT id FROM orders WHERE id = ?";
            checkPs = conn.prepareStatement(checkSql);
            checkPs.setInt(1, id);
            rs = checkPs.executeQuery();

            if (!rs.next()) {
                request.getSession().setAttribute("error", "Không tìm thấy đơn hàng #" + id + "!");
                response.sendRedirect("orders.jsp");
                return;
            }
            rs.close();
            checkPs.close();

            // Cập nhật trạng thái
            String updateSql = "UPDATE orders SET status = ? WHERE id = ?";
            updatePs = conn.prepareStatement(updateSql);
            updatePs.setString(1, status);
            updatePs.setInt(2, id);

            int result = updatePs.executeUpdate();
            updatePs.close();
            conn.close();

            // Thông báo kết quả
            if (result > 0) {
                String statusText = getStatusText(status);
                request.getSession().setAttribute("success", "Đã cập nhật đơn hàng #" + id + " sang trạng thái: " + statusText);
            } else {
                request.getSession().setAttribute("error", "Cập nhật trạng thái thất bại!");
            }

            response.sendRedirect("orders.jsp");

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID đơn hàng không hợp lệ!");
            response.sendRedirect("orders.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect("orders.jsp");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (checkPs != null) checkPs.close(); } catch (Exception e) {}
            try { if (updatePs != null) updatePs.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private String getStatusText(String status) {
        if (status == null) return "Chờ xác nhận";
        switch (status) {
            case "pending": return "🟠 Chờ xác nhận";
            case "confirmed": return "🔵 Đã xác nhận";
            case "shipping": return "🟣 Đang giao hàng";
            case "completed": return "🟢 Hoàn thành";
            case "cancelled": return "❌ Đã hủy";
            default: return "⚪ " + status;
        }
    }
}