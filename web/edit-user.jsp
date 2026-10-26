<%@ page contentType="text/html; charset=UTF-8"         // Định dạng file JSP, mã hóa UTF-8
         pageEncoding="UTF-8" %>                         // Mã hóa khi biên dịch file JSP

<%@ page import="java.sql.*" %>                          // Import thư viện SQL để làm việc với database
<%@ page import="connect.DBConnection" %>                // Import class kết nối database của project

<%
    // =========================
    // LẤY ID NGƯỜI DÙNG TỪ URL
    // =========================
    request.setCharacterEncoding("UTF-8");               // Đặt mã hóa tiếng Việt cho request
    response.setCharacterEncoding("UTF-8");              // Đặt mã hóa tiếng Việt cho response
    
    // Lấy tham số "id" từ URL (ví dụ: edit-user.jsp?id=8)
    // Integer.parseInt() chuyển chuỗi thành số nguyên
    int id = Integer.parseInt(request.getParameter("id"));
    
    // =========================
    // KHAI BÁO KẾT NỐI DATABASE
    // =========================
    Connection conn = null;                              // Khai báo kết nối database
    PreparedStatement ps = null;                         // Khai báo đối tượng truy vấn có tham số
    ResultSet rs = null;                                 // Khai báo đối tượng lưu kết quả truy vấn
    
    try {
        // Lấy kết nối database
        conn = DBConnection.getConnection();
        
        // Tạo câu lệnh SQL có tham số để lấy thông tin người dùng theo id
        ps = conn.prepareStatement(
            "SELECT * FROM users WHERE id=?"
        );
        
        ps.setInt(1, id);                                // Gán giá trị id vào tham số thứ nhất
        
        rs = ps.executeQuery();                          // Thực thi truy vấn và lấy kết quả
        
        // Nếu không tìm thấy người dùng (ResultSet rỗng)
        if (!rs.next()) {
            // Chuyển hướng về trang danh sách người dùng
            response.sendRedirect("users.jsp");
            return;                                      // Dừng không chạy code phía dưới
        }
        
    } catch (Exception e) {
        // Nếu có lỗi, in ra trang web
        out.println("Lỗi: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">                               <!-- Mã hóa ký tự tiếng Việt -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> <!-- Responsive -->
    <title>Sửa người dùng - Admin</title>                <!-- Tiêu đề trang -->
    
    <!-- Link CSS chính của admin -->
    <link rel="stylesheet" href="CSS/admin.css">
    <!-- Font Awesome icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <style>
        /* =========================
           CSS NỘI TUYẾN - Style cho form sửa người dùng
        ========================= */
        
        /* BODY - thiết lập nền và font chữ */
        body {
            margin: 0;                                   /* Xóa lề mặc định */
            padding: 0;                                  /* Xóa đệm mặc định */
            background: #f4f6f9;                         /* Màu nền xám nhạt */
            font-family: Arial, Helvetica, sans-serif;   /* Font chữ */
        }
        
        /* CONTENT - khung chứa form, canh giữa màn hình */
        .content {
            min-height: 100vh;                           /* Chiều cao tối thiểu bằng màn hình */
            display: flex;                               /* Dùng flex để canh giữa */
            justify-content: center;                     /* Canh giữa theo chiều ngang */
            align-items: center;                         /* Canh giữa theo chiều dọc */
            flex-direction: column;                      /* Xếp theo cột dọc */
            padding: 20px;                               /* Thêm đệm cho mobile */
        }
        
        /* FORM BOX - thẻ trắng chứa form */
        .form-box {
            width: 420px;                                /* Chiều rộng form 420px */
            background: white;                           /* Nền trắng */
            padding: 35px;                               /* Đệm trong 35px */
            border-radius: 16px;                         /* Bo góc 16px */
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);      /* Đổ bóng nhẹ */
        }
        
        /* TITLE - tiêu đề trang */
        h1 {
            margin-bottom: 25px;                         /* Khoảng cách dưới 25px */
            color: #111827;                              /* Màu xanh đen đậm */
            font-size: 28px;                             /* Cỡ chữ 28px */
        }
        
        /* INPUT và SELECT - các trường nhập liệu */
        input, select {
            width: 100%;                                 /* Chiều rộng 100% form */
            padding: 12px;                               /* Đệm 12px */
            margin-bottom: 16px;                         /* Khoảng cách dưới 16px */
            border: 1px solid #d1d5db;                   /* Viền xám nhạt */
            border-radius: 8px;                          /* Bo góc 8px */
            box-sizing: border-box;                      /* Đảm bảo padding không làm tràn */
            font-size: 15px;                             /* Cỡ chữ 15px */
            font-family: inherit;                        /* Kế thừa font từ body */
        }
        
        /* BUTTON - nút cập nhật */
        button {
            width: 100%;                                 /* Chiều rộng 100% form */
            padding: 13px;                               /* Đệm 13px */
            border: none;                                /* Không viền */
            border-radius: 8px;                          /* Bo góc 8px */
            background: #2563eb;                         /* Nền xanh dương */
            color: white;                                /* Chữ trắng */
            font-size: 15px;                             /* Cỡ chữ 15px */
            font-weight: bold;                           /* Chữ đậm */
            cursor: pointer;                             /* Con trỏ chuột thành bàn tay */
            transition: 0.3s;                            /* Hiệu ứng chuyển đổi 0.3s */
        }
        
        /* Hover vào nút */
        button:hover {
            background: #1d4ed8;                         /* Nền xanh đậm hơn */
        }
        
        /* BACK BUTTON - nút quay lại */
        .back-btn {
            display: inline-block;                       /* Hiển thị inline-block */
            margin-bottom: 20px;                         /* Khoảng cách dưới 20px */
            background: #111827;                         /* Nền xanh đen đậm */
            color: white;                                /* Chữ trắng */
            padding: 10px 18px;                          /* Đệm trên dưới 10px, trái phải 18px */
            border-radius: 8px;                          /* Bo góc 8px */
            text-decoration: none;                       /* Bỏ gạch chân */
            transition: 0.3s;                            /* Hiệu ứng chuyển đổi 0.3s */
        }
        
        /* Hover vào nút quay lại */
        .back-btn:hover {
            background: #1f2937;                         /* Nền xanh đen nhạt hơn */
        }
        
        /* Responsive cho màn hình nhỏ hơn 500px */
        @media (max-width: 500px) {
            .form-box {
                width: 95%;                              /* Form chiếm 95% màn hình */
                padding: 25px;                           /* Giảm padding */
            }
            h1 {
                font-size: 24px;                         /* Tiêu đề nhỏ lại */
            }
        }
    </style>
</head>
<body>

<div class="content">
    <div class="form-box">
        
        <!-- =========================
             NÚT QUAY LẠI TRANG DANH SÁCH NGƯỜI DÙNG
        ========================= -->
        <a href="users.jsp" class="back-btn">
            <i class="fa fa-arrow-left"></i>              <!-- Icon mũi tên trái -->
            Quay lại
        </a>
        
        <!-- =========================
             TIÊU ĐỀ TRANG
        ========================= -->
        <h1>
            ✏️ Sửa người dùng
        </h1>
        
        <!-- =========================
             FORM SỬA NGƯỜI DÙNG
             action="update-user" -> gửi đến UpdateUserServlet
             method="post" -> gửi dữ liệu ẩn
        ========================= -->
        <form action="update-user" method="post" accept-charset="UTF-8">
            
            <!-- =========================
                 INPUT HIDDEN - LƯU ID NGƯỜI DÙNG
                 (không hiển thị trên form, dùng để gửi lên servlet)
            ========================= -->
            <input type="hidden"
                   name="id"
                   value="<%= rs.getInt("id") %>">        <!-- Gửi id người dùng lên servlet -->
            
            <!-- =========================
                 HỌ TÊN
            ========================= -->
            <input type="text"
                   name="hoten"
                   value="<%= rs.getString("hoten") %>"   <!-- Điền sẵn họ tên hiện tại -->
                   placeholder="Họ tên"
                   required>                              <!-- Bắt buộc phải nhập -->
            
            <!-- =========================
                 EMAIL
            ========================= -->
            <input type="email"
                   name="email"
                   value="<%= rs.getString("email") %>"   <!-- Điền sẵn email hiện tại -->
                   placeholder="Email"
                   required>
            
            <!-- =========================
                 SỐ ĐIỆN THOẠI
            ========================= -->
            <input type="text"
                   name="sodienthoai"
                   value="<%= rs.getString("sodienthoai") %>" <!-- Điền sẵn SĐT hiện tại -->
                   placeholder="Số điện thoại"
                   required
                   pattern="[0-9]{10,11}"                 <!-- Chỉ cho phép 10-11 chữ số -->
                   title="Vui lòng nhập số điện thoại 10-11 chữ số">
            
            <!-- =========================
                 MẬT KHẨU
            ========================= -->
            <input type="password"
                   name="password"
                   value="<%= rs.getString("password") %>" <!-- Điền sẵn mật khẩu hiện tại -->
                   placeholder="Mật khẩu"
                   required>
            
            <!-- =========================
                 VAI TRÒ (ROLE) - DROPDOWN
            ========================= -->
            <select name="role">
                <!-- Option User (người dùng thường) -->
                <!-- Toán tử 3 ngôi: nếu role hiện tại là "user" thì thêm selected -->
                <option value="user"
                <%= rs.getString("role").equals("user") ? "selected" : "" %>>
                    👤 User
                </option>
                
                <!-- Option Admin (quản trị viên) -->
                <option value="admin"
                <%= rs.getString("role").equals("admin") ? "selected" : "" %>>
                    👑 Admin
                </option>
            </select>
            
            <!-- =========================
                 NÚT CẬP NHẬT NGƯỜI DÙNG
            ========================= -->
            <button type="submit">
                <i class="fa fa-save"></i>                <!-- Icon lưu -->
                Cập nhật người dùng
            </button>
            
        </form>
        
    </div>
</div>

</body>
</html>

<%
    // =========================
    // ĐÓNG TÀI NGUYÊN KẾT NỐI DATABASE
    // =========================
    try {
        if (rs != null) rs.close();      // Đóng ResultSet
        if (ps != null) ps.close();      // Đóng PreparedStatement
        if (conn != null) conn.close();  // Đóng Connection
    } catch (Exception e) {
        e.printStackTrace();             // In lỗi ra console
    }
%>