<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Điều khoản dịch vụ - Tech Shop</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Arial, sans-serif; }
        body { background: #f5f7fa; }
        .topbar { background: #111; color: white; text-align: center; padding: 8px; font-size: 14px; }
        .header { background: white; display: flex; justify-content: space-between; align-items: center; padding: 15px 40px; flex-wrap: wrap; gap: 15px; }
        .logo-link { text-decoration: none; color: #ff6600; font-size: 28px; font-weight: bold; }
        .header-right { display: flex; align-items: center; gap: 20px; flex-wrap: wrap; }
        .header-right a { text-decoration: none; color: #333; font-weight: bold; }
        .cart-btn { background: #ff6600; color: white !important; padding: 10px 15px; border-radius: 8px; }
        .menu { background: #ff6600; padding: 12px; display: flex; justify-content: center; gap: 25px; flex-wrap: wrap; }
        .menu a { color: white; text-decoration: none; font-weight: bold; padding: 6px 12px; border-radius: 6px; }
        .page-title { background: linear-gradient(135deg, #2563eb, #1d4ed8); padding: 40px 5%; text-align: center; color: white; }
        .page-title h1 { font-size: 32px; margin-bottom: 10px; }
        .content-container { max-width: 1000px; margin: 40px auto; background: white; border-radius: 16px; padding: 35px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .content-container h2 { color: #ff6600; margin: 20px 0 10px; }
        .content-container p { line-height: 1.8; color: #374151; margin-bottom: 15px; }
        .content-container ul { margin-left: 25px; margin-bottom: 15px; }
        .content-container li { line-height: 1.8; color: #374151; }
        .footer { background: #1a1a2e; color: #eee; padding: 50px 5% 20px; margin-top: 50px; }
        .footer-container { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 30px; max-width: 1200px; margin: 0 auto; }
        .footer-col h3 { color: #ff6600; font-size: 16px; margin-bottom: 15px; }
        .footer-col p, .footer-col ul li a { font-size: 13px; color: #ccc; text-decoration: none; line-height: 1.8; }
        .footer-col ul { list-style: none; padding: 0; }
        .footer-col ul li a:hover { color: #ff6600; }
        .footer-bottom { text-align: center; padding-top: 30px; margin-top: 30px; border-top: 1px solid #333; font-size: 12px; }
        @media (max-width: 768px) { .header { flex-direction: column; } .menu { gap: 10px; } .content-container { margin: 20px; padding: 20px; } }
    </style>
</head>
<body>

<div class="topbar">🚚 Miễn phí vận chuyển toàn quốc | ⚡ Hỗ trợ 24/7 | 🔒 Bảo hành chính hãng</div>

<header class="header">
    <a href="products.jsp" class="logo-link">🛒 Tech Shop</a>
    <div class="header-right">
        <a href="products.jsp"><i class="fa fa-house"></i> Trang chủ</a>
        <a href="cart.jsp"><i class="fa fa-cart-shopping"></i> Giỏ hàng</a>
        <a href="login.jsp"><i class="fa fa-user"></i> Đăng nhập</a>
        <a href="register.jsp"><i class="fa fa-user-plus"></i> Đăng ký</a>
        <a href="cart.jsp" class="cart-btn"><i class="fa fa-cart-shopping"></i> Giỏ hàng</a>
    </div>
</header>

<nav class="menu">
    <a href="category.jsp?category=router">📡 Router</a>
    <a href="category.jsp?category=switch">🔌 Switch</a>
    <a href="category.jsp?category=access-point">📶 Access Point</a>
    <a href="category.jsp?category=modem">📠 Modem</a>
    <a href="category.jsp?category=lan">🔗 Cáp mạng</a>
    <a href="products.jsp">🎁 Khuyến mãi</a>
    <a href="contact.jsp">📞 Liên hệ</a>
    <a href="news.jsp">📰 Tin tức</a>
</nav>

<div class="page-title">
    <h1><i class="fas fa-file-contract"></i> Điều khoản dịch vụ</h1>
    <p>Quy định và điều khoản khi sử dụng dịch vụ của Tech Shop</p>
</div>

<div class="content-container">
    <h2>📌 Chấp nhận điều khoản</h2>
    <p>Bằng việc sử dụng website Tech Shop, bạn đồng ý tuân thủ các điều khoản và điều kiện được nêu dưới đây.</p>
    
    <h2>🛒 Đặt hàng</h2>
    <p>Khi đặt hàng trên website, bạn xác nhận rằng bạn có đủ năng lực pháp lý và thông tin cung cấp là chính xác. Tech Shop có quyền từ chối hoặc hủy đơn hàng nếu phát hiện thông tin không hợp lệ.</p>
    
    <h2>💰 Giá cả và thanh toán</h2>
    <p>Giá sản phẩm được niêm yết trên website đã bao gồm VAT. Tech Shop có quyền thay đổi giá mà không cần báo trước. Thanh toán được thực hiện theo phương thức đã chọn khi đặt hàng.</p>
    
    <h2>🚚 Giao hàng</h2>
    <p>Tech Shop sẽ giao hàng đến địa chỉ mà khách hàng cung cấp. Thời gian giao hàng có thể thay đổi tùy theo khu vực và tình hình thực tế.</p>
    
    <h2>📝 Bảo mật thông tin</h2>
    <p>Tech Shop cam kết bảo mật thông tin cá nhân của khách hàng theo chính sách bảo mật riêng.</p>
    
    <h2>⚖️ Trách nhiệm</h2>
    <p>Tech Shop không chịu trách nhiệm về thiệt hại phát sinh do sử dụng sản phẩm không đúng cách hoặc do yếu tố bất khả kháng.</p>
    
    <h2>🔄 Thay đổi điều khoản</h2>
    <p>Tech Shop có quyền thay đổi các điều khoản này bất kỳ lúc nào. Mọi thay đổi sẽ được cập nhật trên website.</p>
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