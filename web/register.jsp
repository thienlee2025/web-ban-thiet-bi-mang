<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>Đăng ký tài khoản</title>

<link rel="stylesheet"
href="CSS/register.css?v=4">

</head>

<body>

<div class="register-box">

    <h2>
        🛒 Đăng ký tài khoản
    </h2>

    <%
    String error =
    (String) request.getAttribute("error");

    if(error != null){
    %>

    <div class="error-box">
        <%= error %>
    </div>

    <%
    }
    %>

    <form action="register"
          method="post">

        <input type="text"
               name="hoten"
               placeholder="Họ và tên"
               required>

        <input type="text"
               name="username"
               placeholder="Tên đăng nhập"
               required>

        <input type="email"
               name="email"
               placeholder="Email"
               required>

        <input type="text"
               name="sodienthoai"
               placeholder="Số điện thoại"
               required>

        <textarea name="diachi"
                  placeholder="Địa chỉ"
                  required></textarea>

        <input type="password"
               name="password"
               placeholder="Mật khẩu"
               required>

        <input type="password"
               name="confirmPassword"
               placeholder="Nhập lại mật khẩu"
               required>

        <button type="submit">
            Đăng ký
        </button>

    </form>

    <!-- LOGIN LINK -->

    <div class="login-link">

        Đã có tài khoản?

        <a href="login.jsp">
            Đăng nhập ngay
        </a>

    </div>

</div>

</body>
</html>