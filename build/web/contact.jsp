<%@ page contentType="text/html; charset=UTF-8" %>      <!-- Định dạng file JSP, mã hóa UTF-8 -->
<%@ page import="java.sql.*" %>                          <!-- Import thư viện SQL để làm việc với database -->
<%@ page import="connect.DBConnection" %>                <!-- Import class kết nối database của project -->

<%
    // =========================
    // LẤY USER ĐĂNG NHẬP TỪ SESSION
    // =========================
    
    // Lấy tên đăng nhập của người dùng từ session (đã lưu khi đăng nhập)
    String username = (String) session.getAttribute("user");

    // =========================
    // KHỞI TẠO BIẾN LƯU THÔNG TIN USER
    // =========================
    String fullname = "";    // Biến lưu họ tên
    String email = "";       // Biến lưu email
    String phone = "";       // Biến lưu số điện thoại
    String address = "";     // Biến lưu địa chỉ

    // =========================
    // NẾU ĐÃ ĐĂNG NHẬP -> LẤY THÔNG TIN TỪ DATABASE
    // =========================
    Connection conn = null;          // Khai báo kết nối database
    PreparedStatement ps = null;     // Khai báo đối tượng truy vấn có tham số
    ResultSet rs = null;             // Khai báo đối tượng lưu kết quả truy vấn

    // Kiểm tra nếu người dùng đã đăng nhập (username không null và không rỗng)
    if (username != null && !username.trim().isEmpty()) {
        
        try {
            // Lấy kết nối database từ class DBConnection
            conn = DBConnection.getConnection();

            // Câu lệnh SQL: lấy thông tin người dùng theo username hoặc email
            // Các cột: hoten (họ tên), email, sodienthoai (số điện thoại), password (đang chứa địa chỉ)
            String sql = "SELECT hoten, email, sodienthoai, diachi FROM users WHERE username = ? OR email = ?";
            
            // Chuẩn bị câu lệnh SQL có tham số
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);   // Gán giá trị tham số thứ nhất
            ps.setString(2, username);   // Gán giá trị tham số thứ hai
            
            // Thực thi truy vấn và lưu kết quả
            rs = ps.executeQuery();

            // Nếu có dữ liệu trả về
            if (rs.next()) {
                // Lấy giá trị từng cột, nếu null thì gán chuỗi rỗng
                fullname = rs.getString("hoten") != null ? rs.getString("hoten") : "";
                email = rs.getString("email") != null ? rs.getString("email") : "";
                phone = rs.getString("sodienthoai") != null ? rs.getString("sodienthoai") : "";
                address = rs.getString("diachi") != null ? rs.getString("diachi") : ""; // password đang chứa địa chỉ
            }
            
        } catch (Exception e) {
            e.printStackTrace();  // In lỗi ra console nếu có
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">                                    <!-- Mã hóa ký tự tiếng Việt -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">  <!-- Responsive trên mobile -->
    <title>Liên hệ - Tech Shop</title>                       <!-- Tiêu đề trang -->
    <link rel="stylesheet" href="CSS/contact.css?v=5">       <!-- Link file CSS riêng cho trang liên hệ -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"> <!-- Font Awesome icons -->
    
    <style>
        /* CSS NỘI TUYẾN - Style bổ sung */
        
        /* Style cho input readonly (không cho sửa) */
        input[readonly] {
            background-color: #f8fafc;   /* Nền xám nhạt */
            cursor: not-allowed;         /* Con trỏ hình cấm */
            opacity: 0.8;                /* Làm mờ nhẹ */
        }
        
        /* Style cho thông báo khi chưa đăng nhập */
        .login-warning {
            background: #fff3e6;         /* Nền cam nhạt */
            color: #ff6600;              /* Chữ cam */
            padding: 15px;               /* Đệm 15px */
            border-radius: 12px;         /* Bo góc 12px */
            text-align: center;          /* Canh giữa chữ */
            margin-bottom: 20px;         /* Khoảng cách dưới 20px */
        }
        
        /* Link trong thông báo đăng nhập */
        .login-warning a {
            color: #2563eb;              /* Màu xanh dương */
            text-decoration: none;       /* Bỏ gạch chân */
            font-weight: bold;           /* Chữ đậm */
        }
        
        /* Hover vào link */
        .login-warning a:hover {
            text-decoration: underline;  /* Thêm gạch chân khi hover */
        }
        
        /* Card hiển thị thông tin người dùng khi đã đăng nhập */
        .info-card {
            background: #f0fdf4;         /* Nền xanh lá rất nhạt */
            border: 1px solid #bbf7d0;   /* Viền xanh lá nhạt */
            border-radius: 12px;         /* Bo góc 12px */
            padding: 15px;               /* Đệm 15px */
            margin-bottom: 20px;         /* Khoảng cách dưới 20px */
        }
        
        /* Tiêu đề trong info-card */
        .info-card h4 {
            color: #166534;              /* Màu xanh lá đậm */
            margin-bottom: 10px;         /* Khoảng cách dưới 10px */
            font-size: 14px;             /* Cỡ chữ 14px */
        }
        
        /* Đoạn văn trong info-card */
        .info-card p {
            color: #14532d;              /* Màu xanh lá đậm hơn */
            font-size: 13px;             /* Cỡ chữ 13px */
            margin: 5px 0;               /* Lề trên dưới 5px */
        }
        
        /* Responsive cho màn hình nhỏ hơn 768px */
        @media (max-width: 768px) {
            .menu a {
                font-size: 13px;         /* Chữ nhỏ lại */
                padding: 6px 10px;       /* Giảm đệm */
            }
        }
    </style>
</head>
<body>

<!-- =========================
     TOPBAR - THANH THÔNG BÁO TRÊN CÙNG
========================= -->
<div class="topbar">
    🚚 Miễn phí vận chuyển toàn quốc |   <!-- Thông báo vận chuyển -->
    ⚡ Hỗ trợ khách hàng 24/7 |          <!-- Thông báo hỗ trợ -->
    🔒 Bảo mật thông tin tuyệt đối        <!-- Thông báo bảo mật -->
</div>

<!-- =========================
     HEADER - PHẦN ĐẦU TRANG (LOGO + NAV)
========================= -->
<header class="header">
    <div class="logo">
        <a href="products.jsp" class="logo-link">
            🛒 Tech Shop                    <!-- Logo + link về trang sản phẩm -->
        </a>
    </div>
    
    <div class="header-right">
        <!-- Link trang chủ -->
        <a href="products.jsp">
            <i class="fa fa-house"></i>    <!-- Icon ngôi nhà -->
            Trang chủ
        </a>
        
        <!-- Link giỏ hàng -->
        <a href="cart.jsp">
            <i class="fa fa-cart-shopping"></i>  <!-- Icon giỏ hàng -->
            Giỏ hàng
        </a>
        
        <!-- Nếu ĐÃ ĐĂNG NHẬP: hiển thị tên người dùng + nút đăng xuất -->
        <% if (username != null && !username.trim().isEmpty()) { %>
            <a href="my-orders.jsp" style="background: #2563eb; color: white; padding: 8px 15px; border-radius: 8px;">
                <i class="fa fa-user"></i>      <!-- Icon người dùng -->
                <%= fullname.isEmpty() ? username : fullname %>  <!-- Hiển thị tên hoặc username -->
            </a>
            <a href="logout" style="color: #dc2626;">
                <i class="fa fa-sign-out-alt"></i>  <!-- Icon đăng xuất -->
                Đăng xuất
            </a>
        <!-- Nếu CHƯA ĐĂNG NHẬP: hiển thị link đăng nhập và đăng ký -->
        <% } else { %>
            <a href="login.jsp">
                <i class="fa fa-user"></i>      <!-- Icon người dùng -->
                Đăng nhập
            </a>
            <a href="register.jsp">
                <i class="fa fa-user-plus"></i> <!-- Icon thêm người dùng -->
                Đăng ký
            </a>
        <% } %>
    </div>
</header>

<!-- =========================
     MENU - THANH DANH MỤC SẢN PHẨM
========================= -->
<nav class="menu">
    <a href="category.jsp?category=router">📡 Router Wifi</a>          <!-- Danh mục Router -->
    <a href="category.jsp?category=switch">🔌 Switch</a>              <!-- Danh mục Switch -->
    <a href="category.jsp?category=access-point">📶 Access Point</a>  <!-- Danh mục Access Point -->
    <a href="category.jsp?category=modem">📠 Modem</a>                <!-- Danh mục Modem -->
    <a href="category.jsp?category=lan">🔗 Cáp mạng & Phụ kiện</a>    <!-- Danh mục Cáp mạng -->
    <a href="products.jsp">🎁 Khuyến mãi / Tất cả</a>                  <!-- Trang khuyến mãi -->
    <a href="contact.jsp" class="active">📞 Liên hệ</a>               <!-- Trang liên hệ (đang active) -->
</nav>

<!-- =========================
     CONTACT - KHU VỰC FORM LIÊN HỆ
========================= -->
<div class="contact-container">
    <div class="contact-box">
        
        <!-- Tiêu đề form liên hệ -->
        <h2>
            <i class="fa fa-headset"></i>   <!-- Icon headset (tai nghe) -->
            Liên hệ hỗ trợ
        </h2>
        
        <!-- =========================
             HIỂN THỊ THÔNG BÁO THÀNH CÔNG / LỖI
             (do Servlet gửi sang)
        ========================= -->
        <%
            // Lấy thông báo thành công và lỗi từ request attribute
            String success = (String) request.getAttribute("success");
            String error = (String) request.getAttribute("error");
            
            // Nếu có thông báo thành công -> hiển thị
            if (success != null && !success.trim().isEmpty()) {
        %>
            <div class="success">
                ✅ <%= success %>         <!-- Hiển thị nội dung thành công -->
            </div>
        <%
            }
            
            // Nếu có thông báo lỗi -> hiển thị
            if (error != null && !error.trim().isEmpty()) {
        %>
            <div class="error">
                ❌ <%= error %>           <!-- Hiển thị nội dung lỗi -->
            </div>
        <%
            }
        %>
        
        <!-- =========================
             HIỂN THỊ THÔNG TIN CỦA BẠN (NẾU ĐÃ ĐĂNG NHẬP)
        ========================= -->
        <% if (username != null && !username.trim().isEmpty()) { %>
            <div class="info-card">
                <h4><i class="fa fa-user-circle"></i> Thông tin của bạn</h4>
                <p><strong>Họ tên:</strong> <%= fullname %></p>   <!-- Hiển thị họ tên -->
                <p><strong>Email:</strong> <%= email %></p>       <!-- Hiển thị email -->
                <p><strong>SĐT:</strong> <%= phone %></p>         <!-- Hiển thị số điện thoại -->
                <% if (!address.isEmpty()) { %>
                    <p><strong>Địa chỉ:</strong> <%= address %></p> <!-- Hiển thị địa chỉ nếu có -->
                <% } %>
            </div>
        <% } %>
        
        <!-- =========================
             THÔNG BÁO KHI CHƯA ĐĂNG NHẬP
        ========================= -->
        <%
            if (username == null || username.trim().isEmpty()) {
        %>
            <div class="login-warning">
                🔐 <strong>Chưa đăng nhập!</strong> Vui lòng <a href="login.jsp?redirect=contact.jsp">đăng nhập</a> 
                để chúng tôi có thể hỗ trợ bạn tốt hơn.
            </div>
        <%
            }
        %>
        
        <!-- =========================
             FORM LIÊN HỆ
             action="contact" -> gửi đến ContactServlet
        ========================= -->
        
            
            <!-- CHỦ ĐỀ LIÊN HỆ: dropdown select -->
            <select name="subject" required style="width:100%; padding:14px; margin-bottom:18px; border:2px solid #e5e7eb; border-radius:12px;">
                <option value="">📌 Chọn chủ đề liên hệ</option>                    <!-- Mặc định -->
                <option value="order">🛒 Vấn đề về đơn hàng</option>                <!-- Chủ đề đơn hàng -->
                <option value="product">📦 Tư vấn sản phẩm</option>                <!-- Chủ đề sản phẩm -->
                <option value="delivery">🚚 Giao hàng & Vận chuyển</option>        <!-- Chủ đề giao hàng -->
                <option value="payment">💰 Thanh toán & Hóa đơn</option>           <!-- Chủ đề thanh toán -->
                <option value="warranty">🔧 Bảo hành & Đổi trả</option>            <!-- Chủ đề bảo hành -->
                <option value="other">💬 Khác</option>                             <!-- Chủ đề khác -->
            </select>
            
            <!-- NỘI DUNG LIÊN HỆ: textarea -->
            <textarea name="message"
                      placeholder="📝 Nhập nội dung liên hệ chi tiết..."
                      rows="6"
                      required></textarea>
            
            <!-- NÚT GỬI LIÊN HỆ -->
            <button type="submit">
                <i class="fa fa-paper-plane"></i>  <!-- Icon máy bay giấy -->
                Gửi liên hệ
            </button>
            
        </form>
        
        <!-- =========================
             THÔNG TIN LIÊN HỆ TRỰC TIẾP
        ========================= -->
        <div style="margin-top: 25px; padding-top: 20px; border-top: 1px solid #eee;">
            <h3 style="font-size: 16px; margin-bottom: 15px; color: #333;">
                📞 Liên hệ trực tiếp
            </h3>
            <div style="display: flex; flex-direction: column; gap: 10px;">
                <!-- Hotline -->
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fa fa-phone" style="color: #ff6600; width: 25px;"></i>
                    <span><strong>Hotline:</strong> 1900 XXXX (8:00 - 22:00)</span>
                </div>
                <!-- Email -->
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fa fa-envelope" style="color: #ff6600; width: 25px;"></i>
                    <span><strong>Email:</strong> support@techshop.vn</span>
                </div>
                <!-- Facebook -->
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fa fa-facebook" style="color: #1877f2; width: 25px;"></i>
                    <span><strong>Facebook:</strong> fb.com/techshop</span>
                </div>
                <!-- Địa chỉ -->
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fa fa-map-marker-alt" style="color: #ff6600; width: 25px;"></i>
                    <span><strong>Địa chỉ:</strong> 123 Đường Công Nghệ, Quận Cầu Giấy, Hà Nội</span>
                </div>
            </div>
        </div>
        
    </div>
</div>

<!-- ========== FOOTER MỚI ========== -->
<footer class="footer">
    <div class="footer-container">
        
        <!-- Cột 1: Thông tin công ty -->
        <div class="footer-col">
            <h3><i class="fas fa-building"></i> Tech Shop</h3>
            <p>MST: 0310685120</p>
            <p><i class="fas fa-map-marker-alt"></i>Tầng 11-Tháp A2, Tòa nhà Viettel, Số 123 Đường Công Nghệ, Quận Cầu Giấy, Hà Nội</p>
            <p><i class="fas fa-phone"></i> 0974.596.219</p>
            <p><i class="fas fa-envelope"></i> support@techshop.vn</p>
        </div>
        
        <!-- Cột 2: Tổng đài hỗ trợ -->
        <div class="footer-col">
            <h3><i class="fas fa-headset"></i> TỔNG ĐÀI HỖ TRỢ (8:00 - 21:00)</h3>
            <p><i class="fas fa-cart-shopping"></i> Mua hàng: <strong>0974.596.219</strong></p>
            <p><i class="fas fa-shield-alt"></i> Bảo hành: <strong>0974.596.219</strong></p>
            <p><i class="fas fa-comment-dots"></i> Khiếu nại: <strong>0974.596.219</strong></p>
            <p><i class="fas fa-envelope"></i> Email: <strong>support@techshop.vn</strong></p>
        </div>
        
        <!-- Cột 3: Danh mục sản phẩm -->
        <div class="footer-col">
            <h3><i class="fas fa-tags"></i> Danh Mục Sản Phẩm</h3>
            <ul>
                <li><a href="category.jsp?category=router">📡 Thiết bị mạng</a></li>
                <li><a href="category.jsp?category=camera">🎥 Camera</a></li>
                <li><a href="category.jsp?category=smart-home">🏠 Smart Home</a></li>
                <li><a href="category.jsp?category=accessories">🔌 Phụ Kiện</a></li>
                <li><a href="news.jsp">📰 Tin Tức</a></li>
            </ul>
        </div>
        
        <!-- Cột 4: Chính sách -->
        <div class="footer-col">
            <h3><i class="fas fa-file-alt"></i> Chính sách</h3>
            <ul>
                <li><a href="about.jsp">📄 Giới thiệu</a></li>
                <li><a href="policy-delivery.jsp">🚚 Chính sách giao nhận và thanh toán</a></li>
                <li><a href="policy-return.jsp">🔄 Chính sách đổi trả</a></li>
                <li><a href="policy-privacy.jsp">🔒 Chính sách bảo mật</a></li>
                <li><a href="terms.jsp">⚖️ Điều khoản dịch vụ</a></li>
                <li><a href="contact.jsp">📞 Liên hệ</a></li>
            </ul>
        </div>
        
    </div>
    
    <div class="footer-bottom">
        <p>© 2026 Tech Shop - Lê Văn Thiên - Nguyễn Tiến Hoàng</p>
    </div>
</footer>

<style>
    /* Footer mới */
    .footer {
        background: #1a1a2e;
        color: #eee;
        padding: 50px 5% 20px;
        margin-top: 50px;
    }
    
    .footer-container {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 30px;
        max-width: 1200px;
        margin: 0 auto;
    }
    
    .footer-col h3 {
        color: #ff6600;
        font-size: 16px;
        margin-bottom: 15px;
        font-weight: bold;
    }
    
    .footer-col p {
        font-size: 13px;
        line-height: 1.6;
        margin-bottom: 8px;
        color: #ccc;
    }
    
    .footer-col p i {
        width: 25px;
        color: #ff6600;
    }
    
    .footer-col ul {
        list-style: none;
        padding: 0;
    }
    
    .footer-col ul li {
        margin-bottom: 8px;
    }
    
    .footer-col ul li a {
        color: #ccc;
        text-decoration: none;
        font-size: 13px;
        transition: 0.3s;
    }
    
    .footer-col ul li a:hover {
        color: #ff6600;
        padding-left: 5px;
    }
    
    .footer-bottom {
        text-align: center;
        padding-top: 30px;
        margin-top: 30px;
        border-top: 1px solid #333;
        font-size: 12px;
        color: #888;
    }
    
    @media (max-width: 768px) {
        .footer-container {
            grid-template-columns: 1fr;
            text-align: center;
        }
        .footer-col p i {
            width: auto;
            margin-right: 5px;
        }
    }
</style>

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