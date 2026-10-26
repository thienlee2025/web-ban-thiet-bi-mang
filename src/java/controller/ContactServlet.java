package controller;

import connect.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        // lấy username đã đăng nhập
        String username = (String) session.getAttribute("user");

        // =========================
        // LẤY DỮ LIỆU TỪ FORM
        // =========================
        String subject = request.getParameter("subject");   // THÊM: Lấy chủ đề
        String message = request.getParameter("message");

        // chống null
        if (subject == null) {
            subject = "";
        }
        if (message == null) {
            message = "";
        }

        subject = subject.trim();
        message = message.trim();

        // kiểm tra đăng nhập
        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // kiểm tra chủ đề
        if (subject.isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn chủ đề liên hệ!");
            request.getRequestDispatcher("contact.jsp").forward(request, response);
            return;
        }

        // kiểm tra nội dung
        if (message.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập nội dung liên hệ!");
            request.getRequestDispatcher("contact.jsp").forward(request, response);
            return;
        }

        Connection conn = null;

        try {

            conn = DBConnection.getConnection();

            /* ===========================
               LẤY THÔNG TIN USER
            =========================== */
            
            // SỬA: Tên cột phù hợp với database của bạn
            // Cột: hoten, email, sodienthoai
            String userSql = "SELECT hoten, email, sodienthoai FROM users WHERE username = ? OR email = ?";
            
            PreparedStatement userPs = conn.prepareStatement(userSql);
            userPs.setString(1, username);
            userPs.setString(2, username); // THÊM: Tìm theo cả email

            var rs = userPs.executeQuery();

            String fullname = "";
            String email = "";
            String phone = "";

            if (rs.next()) {
                fullname = rs.getString("hoten") != null ? rs.getString("hoten") : "";
                email = rs.getString("email") != null ? rs.getString("email") : "";
                phone = rs.getString("sodienthoai") != null ? rs.getString("sodienthoai") : "";
            }

            rs.close();
            userPs.close();

            /* ===========================
               LƯU CONTACT (ĐÃ THÊM SUBJECT)
            =========================== */
            
            // THÊM cột subject vào câu lệnh SQL
            String sql = "INSERT INTO contacts (fullname, email, phone, subject, message) VALUES (?, ?, ?, ?, ?)";
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, fullname);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, subject);   // THÊM: Lưu chủ đề
            ps.setString(5, message);

            ps.executeUpdate();

            ps.close();
            conn.close();

            request.setAttribute("success", "✅ Gửi liên hệ thành công! Chúng tôi sẽ phản hồi sớm nhất.");
            request.getRequestDispatcher("contact.jsp").forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();
            
            request.setAttribute("error", "❌ Lỗi gửi liên hệ: " + e.getMessage());
            request.getRequestDispatcher("contact.jsp").forward(request, response);
        }
    }
}