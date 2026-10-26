<%@ page contentType="text/html; charset=UTF-8" %>      <!-- Định dạng file JSP, mã hóa UTF-8 -->
<%@ page import="java.sql.*" %>                          <!-- Import thư viện SQL để làm việc với database -->
<%@ page import="connect.DBConnection" %>                <!-- Import class kết nối database của project -->

<%
    // =========================
    // KIỂM TRA ĐĂNG NHẬP
    // =========================
    // Lấy tên đăng nhập của người dùng từ session (đã lưu khi đăng nhập)
    String user = (String) session.getAttribute("user");
    
    // Nếu chưa đăng nhập (user == null), chuyển hướng về trang đăng nhập
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;  // Dừng không chạy code phía dưới
    }
    
    // =========================
    // LẤY DANH SÁCH ĐƠN HÀNG CỦA NGƯỜI DÙNG
    // =========================
    Connection conn = DBConnection.getConnection();      // Lấy kết nối database
    
    // Tạo câu lệnh SQL có tham số
    // Lấy tất cả đơn hàng của người dùng (theo username), sắp xếp theo id giảm dần (mới nhất lên đầu)
    PreparedStatement ps = conn.prepareStatement(
        "SELECT * FROM orders " +
        "WHERE username=? " +
        "ORDER BY id DESC"
    );
    
    ps.setString(1, user);                               // Gán giá trị username vào tham số
    
    ResultSet rs = ps.executeQuery();                    // Thực thi truy vấn và lấy kết quả
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">                               <!-- Mã hóa ký tự tiếng Việt -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> <!-- THÊM: Responsive -->
    <title>Đơn hàng của tôi - Tech Shop</title>          <!-- Tiêu đề trang -->
    <link rel="stylesheet" href="CSS/cart.css">          <!-- Link file CSS (dùng chung với cart.css) -->
    
    <style>
        /* =========================
           CSS NỘI TUYẾN - Style bổ sung cho trang đơn hàng
        ========================= */
        
        /* Hộp chứa thông tin mỗi đơn hàng */
        .order-box {
            background: white;                           /* Nền trắng */
            padding: 20px;                               /* Đệm 20px */
            margin-bottom: 20px;                         /* Khoảng cách dưới 20px (cách đơn hàng sau) */
            border-radius: 12px;                         /* Bo góc 12px */
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);      /* Đổ bóng nhẹ */
        }
        
        /* Khung hiển thị trạng thái đơn hàng */
        .status {
            display: inline-block;                       /* Hiển thị inline-block để không chiếm full width */
            padding: 6px 14px;                           /* Đệm trên dưới 6px, trái phải 14px */
            border-radius: 20px;                         /* Bo góc tròn (dạng viên thuốc) */
            color: white;                                /* Chữ trắng */
            font-weight: bold;                           /* Chữ đậm */
            font-size: 14px;                             /* Cỡ chữ 14px */
        }
        
        /* Trạng thái: Chờ xác nhận (màu cam) */
        .pending {
            background: #ff9800;
        }
        
        /* Trạng thái: Đã xác nhận (màu xanh dương) */
        .confirmed {
            background: #2196f3;
        }
        
        /* Trạng thái: Đang giao hàng (màu tím) */
        .shipping {
            background: #9c27b0;
        }
        
        /* Trạng thái: Hoàn thành (màu xanh lá) */
        .completed {
            background: #28a745;
        }
        
        /* Nút tiếp tục mua hàng */
        .shop-btn {
            background: #ff6600;                         /* Nền cam */
            color: white;                                /* Chữ trắng */
            border: none;                                /* Không viền */
            padding: 12px 24px;                          /* Đệm 12x24px */
            border-radius: 8px;                          /* Bo góc 8px */
            cursor: pointer;                             /* Con trỏ chuột thành bàn tay */
            font-weight: bold;                           /* Chữ đậm */
            margin-top: 10px;                            /* Khoảng cách trên 10px */
        }
        
        .shop-btn:hover {
            background: #e65c00;                         /* Cam đậm hơn khi hover */
        }
        
        /* Thông báo khi chưa có đơn hàng nào */
        .no-orders {
            text-align: center;
            padding: 60px;
            background: white;
            border-radius: 12px;
            color: #666;
        }
        
        /* Responsive cho màn hình nhỏ */
        @media (max-width: 600px) {
            .order-box {
                padding: 15px;
            }
            .order-box p {
                font-size: 14px;
            }
        }
    </style>
</head>

<body>

<div class="cart-container">                             <!-- Khung chứa nội dung chính (dùng class giống cart.css) -->
    
    <!-- TIÊU ĐỀ TRANG -->
    <h2>📦 Đơn hàng của tôi</h2>
    
    <%
        // Biến kiểm tra xem có đơn hàng nào không
        boolean hasOrders = false;
        
        // Duyệt qua từng đơn hàng trong ResultSet
        while (rs.next()) {
            hasOrders = true;
            
            // Lấy trạng thái đơn hàng
            String status = rs.getString("status");
            
            // Nếu status null (chưa có), mặc định là "pending" (chờ xác nhận)
            if (status == null || status.isEmpty()) {    // SỬA: thêm kiểm tra isEmpty()
                status = "pending";
            }
    %>
    
    <!-- =========================
         HIỂN THỊ THÔNG TIN MỘT ĐƠN HÀNG
    ========================= -->
    <div class="order-box">
        
        <!-- MÃ ĐƠN HÀNG -->
        <h3>
            🧾 Đơn hàng #<%= rs.getInt("id") %>
        </h3>
        
        <!-- NGƯỜI NHẬN -->
        <p>
            👤 Người nhận:
            <b><%= rs.getString("fullname") != null ? rs.getString("fullname") : "N/A" %></b>  <!-- SỬA: xử lý null -->
        </p>
        
        <!-- SỐ ĐIỆN THOẠI -->
        <p>
            📞 SĐT:
            <%= rs.getString("phone") != null ? rs.getString("phone") : "N/A" %>
        </p>
        
        <!-- ĐỊA CHỈ GIAO HÀNG -->
        <p>
            📍 Địa chỉ:
            <%= rs.getString("address") != null ? rs.getString("address") : "N/A" %>
        </p>
        
        <!-- TỔNG TIỀN ĐƠN HÀNG -->
        <p>
            💰 Tổng tiền:
            <b><%= String.format("%,.0f", rs.getDouble("total")) %>₫</b>
        </p>
        
        <!-- NGÀY ĐẶT HÀNG -->
        <p>
            📅 Ngày đặt:
            <%= rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at") : "N/A" %>
        </p>
        
        <!-- TRẠNG THÁI ĐƠN HÀNG (có màu sắc theo trạng thái) -->
        <p>
            🚚 Trạng thái:
            <span class="status <%= status.toLowerCase() %>">  <!-- Gán class CSS theo status -->
                <%
                    // Chuyển đổi status thành text tiếng Việt
                    switch(status.toLowerCase()) {
                        case "pending": out.print("🟠 Chờ xác nhận"); break;
                        case "confirmed": out.print("🔵 Đã xác nhận"); break;
                        case "shipping": out.print("🟣 Đang giao hàng"); break;
                        case "completed": out.print("🟢 Hoàn thành"); break;
                        default: out.print("⚪ " + status);
                    }
                %>
            </span>
        </p>
        
    </div>
    
    <%
        } // Kết thúc while
        
        // Nếu không có đơn hàng nào
        if (!hasOrders) {
    %>
        <div class="no-orders">
            <i class="fa fa-box-open" style="font-size: 48px; color: #ccc; margin-bottom: 15px;"></i>
            <h3>📭 Bạn chưa có đơn hàng nào!</h3>
            <p>Hãy mua sắm ngay để nhận ưu đãi hấp dẫn.</p>
            <a href="products.jsp">
                <button class="shop-btn">🛒 Mua sắm ngay</button>
            </a>
        </div>
    <%
        }
    %>
    
    <!-- =========================
         NÚT TIẾP TỤC MUA HÀNG
    ========================= -->
    <a href="products.jsp">
        <button class="shop-btn">
            ← Tiếp tục mua hàng
        </button>
    </a>
    
</div>

</body>
</html>

<%
    // =========================
    // ĐÓNG TÀI NGUYÊN KẾT NỐI DATABASE
    // =========================
    try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }   // Đóng ResultSet
    try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }   // Đóng PreparedStatement
    try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); } // Đóng Connection
%>