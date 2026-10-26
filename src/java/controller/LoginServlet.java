package controller;

import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Lấy dữ liệu từ form
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Chống null
        if (username == null) username = "";
        if (password == null) password = "";

        // Xóa space
        username = username.trim();
        password = password.trim();

        // Kiểm tra rỗng
        if (username.isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "Không được để trống tên đăng nhập hoặc mật khẩu!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();

        // SỬA: gọi phương thức loginWithUsername thay vì login
        if (dao.loginWithUsername(username, password)) {

            // Lấy role
            String role = dao.getRoleByUsername(username);

            HttpSession session = request.getSession();

            // Lưu session
            session.setAttribute("user", username);
            session.setAttribute("role", role);

            // Chuyển hướng theo role
            if (role != null && role.equals("admin")) {
                response.sendRedirect("dashboard.jsp");
            } else {
                String redirect = (String) session.getAttribute("redirect");
                if (redirect != null) {
                    session.removeAttribute("redirect");
                    response.sendRedirect(redirect);
                } else {
                    response.sendRedirect("products.jsp");
                }
            }

        } else {
            request.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}