package controller;

import dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // lấy dữ liệu
        String hoten = request.getParameter("hoten");
if(hoten == null) hoten = "";
hoten = hoten.trim();

String username = request.getParameter("username");
if(username == null) username = "";
username = username.trim();

String email = request.getParameter("email");
if(email == null) email = "";
email = email.trim();

String sodienthoai = request.getParameter("sodienthoai");
if(sodienthoai == null) sodienthoai = "";
sodienthoai = sodienthoai.trim();

String diachi = request.getParameter("diachi");
if(diachi == null) diachi = "";
diachi = diachi.trim();

String password = request.getParameter("password");
if(password == null) password = "";
password = password.trim();

String confirmPassword = request.getParameter("confirmPassword");
if(confirmPassword == null) confirmPassword = "";
confirmPassword = confirmPassword.trim();
// kiểm tra rỗng hoặc toàn space
if(hoten.isEmpty()
        || username.isEmpty()
        || email.isEmpty()
        || sodienthoai.isEmpty()
        || diachi.isEmpty()
        || password.isEmpty()
        || confirmPassword.isEmpty()) {

    request.setAttribute(
            "error",
            "Không được để trống hoặc nhập khoảng trắng!");

    request.getRequestDispatcher("register.jsp")
            .forward(request, response);

    return;
}
// mật khẩu tối thiểu 6 ký tự
if(password.length() < 6){

    request.setAttribute(
            "error",
            "Mật khẩu phải có ít nhất 6 ký tự!");

    request.getRequestDispatcher("register.jsp")
            .forward(request, response);

    return;
}

/* ======================
   PHẢI CÓ 1 CHỮ IN HOA
====================== */

boolean hasUpperCase = false;

for(char c : password.toCharArray()){

    if(Character.isUpperCase(c)){

        hasUpperCase = true;
        break;
    }
}

if(!hasUpperCase){

    request.setAttribute(
            "error",
            "Mật khẩu phải có ít nhất 1 chữ in hoa!");

    request.getRequestDispatcher("register.jsp")
            .forward(request, response);

    return;
}
        // kiểm tra mật khẩu
        if (!password.equals(confirmPassword)) {

            request.setAttribute(
                    "error",
                    "Mật khẩu nhập lại không khớp!");

            request.getRequestDispatcher("register.jsp")
                    .forward(request, response);

            return;
        }

        UserDAO dao = new UserDAO();

        // kiểm tra email tồn tại
        if (dao.checkEmailExists(email)) {

            request.setAttribute(
                    "error",
                    "Email đã tồn tại!");

            request.getRequestDispatcher("register.jsp")
                    .forward(request, response);

            return;
        }

        // đăng ký
        boolean check = dao.register(
                hoten,
                username,
                email,
                sodienthoai,
                diachi,
                password
        );

        if (check) {

            response.sendRedirect("login.jsp");

        } else {

            request.setAttribute(
                    "error",
                    "Đăng ký thất bại! Kiểm tra database.");

            request.getRequestDispatcher("register.jsp")
                    .forward(request, response);
        }
    }
}