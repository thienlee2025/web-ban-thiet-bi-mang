<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Tech Shop</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Arial, Helvetica, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .login-box {
            width: 420px;
            max-width: 100%;
            background: white;
            padding: 40px 35px;
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            animation: fadeIn 0.4s ease;
        }
        
        .login-box h2 {
            text-align: center;
            color: #ff6600;
            margin-bottom: 30px;
            font-size: 32px;
            font-weight: 700;
        }
        
        .error-message {
            background: #fee2e2;
            color: #dc2626;
            padding: 12px 15px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 14px;
            text-align: center;
            border: 1px solid #fecaca;
        }
        
        .warning-message {
            background: #fff3e6;
            color: #ff6600;
            padding: 12px 15px;
            border-radius: 12px;
            margin-bottom: 20px;
            text-align: center;
            border: 1px solid #ffd7b8;
        }
        
        .input-group {
            margin-bottom: 20px;
        }
        
        .input-group label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }
        
        .input-group label i {
            color: #ff6600;
            margin-right: 8px;
        }
        
        .input-group input {
            width: 100%;
            padding: 14px 16px;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.3s;
            background: #f9fafb;
        }
        
        .input-group input:focus {
            outline: none;
            border-color: #ff6600;
            background: white;
            box-shadow: 0 0 0 3px rgba(255,102,0,0.1);
        }
        
        button {
            width: 100%;
            padding: 14px;
            background: #ff6600;
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
        }
        
        button:hover {
            background: #e65c00;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255,102,0,0.3);
        }
        
        .register-link {
            text-align: center;
            margin-top: 25px;
            font-size: 14px;
            color: #666;
        }
        
        .register-link a {
            color: #ff6600;
            text-decoration: none;
            font-weight: 600;
            margin-left: 5px;
        }
        
        .register-link a:hover {
            text-decoration: underline;
        }
        
        .forgot-password {
            text-align: center;
            margin-top: 15px;
        }
        
        .forgot-password a {
            color: #999;
            font-size: 13px;
            text-decoration: none;
        }
        
        .forgot-password a:hover {
            color: #ff6600;
            text-decoration: underline;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @media (max-width: 480px) {
            .login-box { padding: 30px 25px; }
            .login-box h2 { font-size: 28px; }
        }
    </style>
</head>
<body>

<div class="login-box">
    
    <h2><i class="fa fa-lock"></i> Đăng nhập</h2>
    
    <%
        String error = (String) request.getAttribute("error");
        if (error != null && !error.trim().isEmpty()) {
    %>
        <div class="error-message">
            <i class="fa fa-exclamation-circle"></i> <%= error %>
        </div>
    <%
        }
    %>
    
    <%
        String msg = request.getParameter("message");
        if ("login_required".equals(msg)) {
    %>
        <div class="warning-message">
            <i class="fa fa-warning"></i> Vui lòng đăng nhập trước khi thanh toán!
        </div>
    <%
        }
    %>
    
    <!-- SỬA: action gửi đến login servlet, name="username" thay vì email -->
    <form action="login" method="post">
        
        <div class="input-group">
            <label><i class="fa fa-user"></i> Tên đăng nhập</label>
            <input type="text" name="username" placeholder="Nhập tên đăng nhập" required>
        </div>
        
        <div class="input-group">
            <label><i class="fa fa-key"></i> Mật khẩu</label>
            <input type="password" name="password" placeholder="Nhập mật khẩu" required>
        </div>
        
        <button type="submit">
            <i class="fa fa-sign-in-alt"></i> Đăng nhập
        </button>
        
    </form>
    
    <div class="register-link">
        Chưa có tài khoản?
        <a href="register.jsp"><i class="fa fa-user-plus"></i> Đăng ký ngay</a>
    </div>
    
    <div class="forgot-password">
        <a href="forgot-password.jsp"><i class="fa fa-question-circle"></i> Quên mật khẩu?</a>
    </div>
    
</div>

</body>
</html>