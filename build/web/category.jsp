<%@ page import="java.sql.*" %>
<%@ page import="connect.DBConnection" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    request.setCharacterEncoding("UTF-8");
    String category = request.getParameter("category");
    if (category != null) {
        category = category.toLowerCase().trim();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= category == null ? "Tất cả sản phẩm" : category.toUpperCase() %> - Tech Shop</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, Helvetica, sans-serif;
        }
        
        body {
            background: #f5f5f5;
        }
        
        /* TOPBAR */
        .topbar {
            background: #111;
            color: white;
            text-align: center;
            padding: 8px;
            font-size: 14px;
        }
        
        /* HEADER */
        .header {
            background: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 40px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .logo-link {
            text-decoration: none;
            color: #ff6600;
            font-size: 28px;
            font-weight: bold;
        }
        
        .header-right {
            display: flex;
            align-items: center;
            gap: 20px;
            flex-wrap: wrap;
        }
        
        .header-right a {
            text-decoration: none;
            color: #333;
            font-weight: bold;
        }
        
        .cart-btn {
            background: #ff6600;
            color: white !important;
            padding: 10px 15px;
            border-radius: 8px;
        }
        
        /* MENU */
        .menu {
            background: #ff6600;
            padding: 12px;
            display: flex;
            justify-content: center;
            gap: 25px;
            flex-wrap: wrap;
        }
        
        .menu a {
            color: white;
            text-decoration: none;
            font-weight: bold;
            padding: 6px 12px;
            border-radius: 6px;
        }
        
        .menu a.active {
            background: #2563eb;
        }
        
        /* CATEGORY HEADER */
        .category-header {
            background: linear-gradient(135deg, #ff6a00, #ff9100);
            padding: 20px 5%;
            text-align: center;
            color: white;
        }
        
        .category-header h1 {
            font-size: 32px;
        }
        
        /* PRODUCT GRID - GIỐNG PRODUCTS.JSP */
        .container {
            width: 90%;
            margin: 40px auto;
        }
        
        .products {
    display: grid;
    grid-template-columns: repeat(3, 400px);
    justify-content: center;                                                                                                                                                                                                                                                                                                                        
    gap: 25px;
}
        
        .product-item {
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        
        .product-link {
            text-decoration: none;
            color: inherit;
            display: block;
        }
        
        .card {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            position: relative;
            transition: 0.3s;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 24px rgba(0,0,0,0.12);
        }
        
        .discount-badge {
            position: absolute;
            top: 12px;
            left: 12px;
            background: #ef4444;
            color: white;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            z-index: 2;
        }
        
        .product-img {
            width: 100%;
            height: 200px;
            object-fit: contain;
            background: #fafafa;
            padding: 20px;
            transition: 0.3s;
        }
        
        .card:hover .product-img {
            transform: scale(1.03);
        }
        
        .product-info {
            padding: 16px;
            display: flex;
            flex-direction: column;
            flex: 1;
        }
        
        .product-name {
            font-size: 15px;
            font-weight: 600;
            color: #111827;
            line-height: 1.4;
            height: 42px;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            margin-bottom: 8px;
        }
        
        .product-name a {
            text-decoration: none;
            color: #111827;
        }
        
        .product-name a:hover {
            color: #ff6600;
        }
        
        .price-wrapper {
            margin: 10px 0;
        }
        
        .current-price {
            font-size: 18px;
            font-weight: 700;
            color: #dc2626;
        }
        
        .old-price {
            font-size: 14px;
            color: #9ca3af;
            text-decoration: line-through;
            margin-left: 8px;
        }
        
        .star {
            color: #f59e0b;
            font-size: 13px;
            margin-bottom: 8px;
        }
        
        .status-instock {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            background: #dcfce7;
            color: #16a34a;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            width: fit-content;
            margin: 8px 0;
        }
        
        .status-outstock {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            background: #fee2e2;
            color: #dc2626;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            width: fit-content;
            margin: 8px 0;
        }
        
        .cart-form {
            margin-top: auto;
            padding: 0 16px 16px 16px;
        }
        
        .btn-add {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 40px;
            background: #ff6600;
            color: white;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-add:hover {
            background: #e65c00;
            transform: translateY(-2px);
        }
        
        .btn-add:disabled {
            background: #9ca3af;
            cursor: not-allowed;
            transform: none;
        }
        
        /* FOOTER */
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
        }
        
        .footer-col p, .footer-col ul li a {
            font-size: 13px;
            color: #ccc;
            text-decoration: none;
            line-height: 1.8;
        }
        
        .footer-col ul {
            list-style: none;
            padding: 0;
        }
        
        .footer-col ul li a:hover {
            color: #ff6600;
        }
        
        .footer-bottom {
            text-align: center;
            padding-top: 30px;
            margin-top: 30px;
            border-top: 1px solid #333;
            font-size: 12px;
        }
        
        .empty-product {
            text-align: center;
            padding: 60px;
            background: white;
            border-radius: 16px;
            grid-column: 1 / -1;
        }
        
        @media (max-width: 768px) {
            .header { flex-direction: column; }
            .products { grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 15px; }
            .product-img { height: 160px; }
            .product-name { font-size: 13px; height: 36px; }
            .footer-container { grid-template-columns: 1fr; text-align: center; }
        }
    </style>
</head>

<body>

<!-- TOPBAR -->
<div class="topbar">🚚 Miễn phí vận chuyển toàn quốc | ⚡ Hỗ trợ 24/7 | 🔒 Bảo hành chính hãng</div>

<!-- HEADER -->
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

<!-- MENU -->
<nav class="menu">
    <a href="category.jsp?category=router">📡 Router Wifi</a>
    <a href="category.jsp?category=switch">🔌 Switch</a>
    <a href="category.jsp?category=access-point">📶 Access Point</a>
    <a href="category.jsp?category=modem">📠 Modem</a>
    <a href="category.jsp?category=lan">🔗 Cáp mạng</a>
    <a href="products.jsp">🎁 Khuyến mãi</a>
    <a href="contact.jsp" class="active">📞 Liên hệ</a>
</nav>

<!-- CATEGORY HEADER -->
<div class="category-header">
    <h1><%= category == null ? "TẤT CẢ SẢN PHẨM" : category.toUpperCase() %></h1>
</div>

<!-- PRODUCTS -->
<div class="container">
    <div class="products">
        <%
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            
            try {
                conn = DBConnection.getConnection();
                String sql;
                if (category == null || category.isEmpty()) {
                    sql = "SELECT * FROM products ORDER BY id DESC";
                    ps = conn.prepareStatement(sql);
                } else {
                    sql = "SELECT * FROM products WHERE LOWER(category) LIKE ? ORDER BY id DESC";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, "%" + category + "%");
                }
                rs = ps.executeQuery();
                
                boolean hasProduct = false;
                while (rs.next()) {
                    hasProduct = true;
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    double price = rs.getDouble("price");
                    double discount = rs.getDouble("discount_percent");
                    double finalPrice = discount > 0 ? price - (price * discount / 100) : price;
                    String image = rs.getString("image");
                    String status = rs.getString("status");
                    if (status == null) status = "Còn hàng";
                    if (image == null || image.isEmpty()) image = "default.jpg";
        %>
        <div class="product-item">
            <a href="product-detail.jsp?id=<%= id %>" class="product-link">
                <div class="card">
                    <% if (discount > 0) { %>
                        <div class="discount-badge">-<%= (int)discount %>%</div>
                    <% } %>
                    <img src="images/<%= image %>" class="product-img" onerror="this.src='images/default.jpg'">
                    <div class="product-info">
                        <h3 class="product-name"><a href="product-detail.jsp?id=<%= id %>"><%= name %></a></h3>
                        <div class="price-wrapper">
                            <% if (discount > 0) { %>
                                <span class="old-price"><%= String.format("%,.0f", price) %>₫</span>
                                <span class="current-price"><%= String.format("%,.0f", finalPrice) %>₫</span>
                            <% } else { %>
                                <span class="current-price"><%= String.format("%,.0f", price) %>₫</span>
                            <% } %>
                        </div>
                        <div class="star">
                            <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i>
                            <span style="color:#666;">(4.5)</span>
                        </div>
                        <% if ("Còn hàng".equals(status)) { %>
                            <div class="status-instock"><i class="fas fa-check-circle"></i> Còn hàng</div>
                        <% } else { %>
                            <div class="status-outstock"><i class="fas fa-times-circle"></i> Hết hàng</div>
                        <% } %>
                    </div>
                </div>
            </a>
            <% if ("Còn hàng".equals(status)) { %>
                <form action="add-to-cart" method="post" class="cart-form">
                    <input type="hidden" name="id" value="<%= id %>">
                    <input type="hidden" name="quantity" value="1">
                    <button type="submit" class="btn-add"><i class="fas fa-cart-plus"></i> Thêm vào giỏ</button>
                </form>
            <% } else { %>
                <div class="cart-form">
                    <button type="button" class="btn-add" disabled><i class="fas fa-times-circle"></i> Tạm hết hàng</button>
                </div>
            <% } %>
        </div>
        <%
                }
                if (!hasProduct) {
        %>
        <div class="empty-product">
            <i class="fas fa-box-open" style="font-size: 48px; color: #ccc;"></i>
            <h2>Không có sản phẩm nào!</h2>
            <a href="products.jsp" style="display: inline-block; margin-top: 15px; padding: 10px 20px; background: #ff6600; color: white; border-radius: 8px; text-decoration: none;">← Quay lại trang chủ</a>
        </div>
        <%
                }
            } catch (Exception e) {
                out.println("<div class='empty-product'><h2>Lỗi: " + e.getMessage() + "</h2></div>");
                e.printStackTrace();
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (ps != null) ps.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        %>
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
                <li><a href="products.jsp">📰 Tin Tức</a></li>
            </ul>
        </div>
        
        <!-- Cột 4: Chính sách -->
        <div class="footer-col">
            <h3><i class="fas fa-file-alt"></i> Chính sách</h3>
            <ul>
                <li><a href="#">📄 Giới thiệu</a></li>
                <li><a href="#">🚚 Chính sách giao nhận và thanh toán</a></li>
                <li><a href="#">🔄 Chính sách đổi trả</a></li>
                <li><a href="#">🔒 Chính sách bảo mật</a></li>
                <li><a href="#">⚖️ Điều khoản dịch vụ</a></li>
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