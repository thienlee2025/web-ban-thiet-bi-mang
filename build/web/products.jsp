<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="connect.DBConnection" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    String user = (String) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    String category = request.getParameter("category");
    if (category != null) category = category.toLowerCase();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tech Shop - Thiết bị mạng chính hãng</title>
    <link rel="stylesheet" href="CSS/bocuc.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <style>
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        .search-box {
            flex: 1;
            min-width: 250px;
            position: relative;
        }
        .header-right {
            display: flex;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }
        .my-orders-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #2563eb;
            color: white;
            padding: 10px 18px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: bold;
            transition: 0.3s;
        }
        .my-orders-btn:hover {
            background: #1d4ed8;
            transform: translateY(-2px);
        }
        .welcome {
            color: #333;
            font-weight: bold;
        }
        .search-result {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            max-height: 400px;
            overflow-y: auto;
            z-index: 1000;
            display: none;
        }
        .search-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 12px;
            text-decoration: none;
            border-bottom: 1px solid #eee;
            transition: 0.3s;
        }
        .search-item:hover {
            background: #f8fafc;
        }
        .search-item img {
            width: 50px;
            height: 50px;
            object-fit: contain;
        }
        .promo-box {
            position: relative;
        }
        .promo-text {
            position: absolute;
            bottom: 20px;
            left: 20px;
            background: rgba(0,0,0,0.7);
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 14px;
        }
        @media (max-width: 768px) {
            .header { flex-direction: column; }
            .header-right { justify-content: center; }
            .search-box { width: 100%; }
        }
    </style>
</head>

<body>

<!-- TOPBAR -->
<div class="topbar">
    🚚 Miễn phí vận chuyển toàn quốc cho đơn từ 500K |
    ⚡ Giao nhanh 2H nội thành |
    🔒 Bảo hành chính hãng
</div>

<!-- HEADER -->
<header class="header">
    <div class="logo">
        <a href="products.jsp" class="logo-link">🛒 Tech Shop</a>
    </div>

    <div class="search-box">
        <input type="text" id="searchInput" placeholder="🔍 Tìm router, switch, modem...">
        <button><i class="fa fa-search"></i></button>
        
        <div class="search-result" id="searchResult">
            <%
                Connection searchConn = null;
                Statement searchSt = null;
                ResultSet searchRs = null;
                try {
                    searchConn = DBConnection.getConnection();
                    searchSt = searchConn.createStatement();
                    searchRs = searchSt.executeQuery("SELECT id, name, price, image FROM products LIMIT 20");
                    while (searchRs.next()) {
            %>
            <a href="product-detail.jsp?id=<%= searchRs.getInt("id") %>" class="search-item">
                <img src="images/<%= searchRs.getString("image") != null ? searchRs.getString("image") : "default.jpg" %>" 
                     onerror="this.src='images/default.jpg'">
                <div>
                    <h4><%= searchRs.getString("name") %></h4>
                    <p><%= String.format("%,.0f", searchRs.getDouble("price")) %>₫</p>
                </div>
            </a>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try { if (searchRs != null) searchRs.close(); } catch (Exception e) {}
                    try { if (searchSt != null) searchSt.close(); } catch (Exception e) {}
                    try { if (searchConn != null) searchConn.close(); } catch (Exception e) {}
                }
            %>
        </div>
    </div>

    <a href="my-orders.jsp" class="my-orders-btn">
        <i class="fa fa-box"></i>
        <span>Đơn hàng</span>
    </a>

    <div class="header-right">
        <% if (role != null && role.equals("admin")) { %>
            <a href="dashboard.jsp" class="admin-btn">
                <i class="fa fa-chart-line"></i> Dashboard
            </a>
        <% } %>

        <% if (user == null) { %>
            <a href="login.jsp"><i class="fa fa-user"></i> Đăng nhập</a>
            <a href="register.jsp"><i class="fa fa-user-plus"></i> Đăng ký</a>
        <% } else { %>
            <span class="welcome">👋 Xin chào <%= user %></span>
            <a href="logout"><i class="fa fa-right-from-bracket"></i> Đăng xuất</a>
        <% } %>

        <a href="cart.jsp" class="cart-btn">
            <i class="fa fa-cart-shopping"></i> Giỏ hàng
        </a>
    </div>
</header>

<!-- MENU -->
<nav class="menu">
    <a href="category.jsp?category=router">📡 Router Wifi</a>
    <a href="category.jsp?category=switch">🔌 Switch</a>
    <a href="category.jsp?category=access-point">📶 Access Point</a>
    <a href="category.jsp?category=modem">📠 Modem</a>
    <a href="category.jsp?category=lan">🔗 Cáp mạng & Phụ kiện</a>
    <a href="products.jsp">🎁 Khuyến mãi / Tất cả</a>
    <a href="contact.jsp">📞 Liên hệ</a>
</nav>

<!-- BANNER SLIDER -->
<section class="banner">
    <div class="banner-slider">
        <div class="slide active">
            <img src="images/banner1.jpg" alt="Banner 1" onerror="this.src='images/default-banner.jpg'">
            <div class="banner-content">
                <h1>🔥 SIÊU SALE THÁNG 5 🔥</h1>
                <p>Router • Switch • Modem giảm đến 50%</p>
                <button onclick="location.href='products.jsp'">MUA NGAY</button>
            </div>
        </div>
        <div class="slide">
            <img src="images/banner2.jpg" alt="Banner 2" onerror="this.src='images/default-banner.jpg'">
            <div class="banner-content">
                <h1>⚡ WIFI 6 TỐC ĐỘ CAO ⚡</h1>
                <p>Router gaming cấu hình cực mạnh</p>
                <button onclick="location.href='category.jsp?category=router'">XEM NGAY</button>
            </div>
        </div>
    </div>
    <div class="promo-box">
        <img src="images/banner3.jpg" alt="Promo" onerror="this.src='images/default-banner.jpg'">
        <div class="promo-text">🎁 Tặng voucher 500K</div>
    </div>
</section>

<!-- POLICY -->
<section class="policy">
    <div class="policy-box"><i class="fa fa-truck-fast"></i><h4>Giao nhanh</h4><p>Toàn quốc 24/7</p></div>
    <div class="policy-box"><i class="fa fa-shield"></i><h4>Bảo hành</h4><p>Chính hãng 12 tháng</p></div>
    <div class="policy-box"><i class="fa fa-rotate"></i><h4>Đổi trả</h4><p>Trong 7 ngày</p></div>
    <div class="policy-box"><i class="fa fa-headset"></i><h4>Hỗ trợ</h4><p>24/7 miễn phí</p></div>
</section>

<!-- PRODUCT SECTIONS -->
<%
    Connection conn = null;
    Statement st = null;
    ResultSet rsSale = null;
    ResultSet rsHot = null;
    ResultSet rsAll = null;
    
    try {
        conn = DBConnection.getConnection();
        st = conn.createStatement();
%>

<div class="container">

    <!-- 1. SẢN PHẨM KHUYẾN MÃI -->
    <div class="section-title">
        <h2>🔥 Sản phẩm khuyến mãi</h2>
    </div>
    <div class="products">
        <%
            rsSale = st.executeQuery("SELECT * FROM products WHERE discount_percent > 0 ORDER BY discount_percent DESC LIMIT 8");
            while (rsSale.next()) {
                int id = rsSale.getInt("id");
                String name = rsSale.getString("name");
                double price = rsSale.getDouble("price");
                double discount = rsSale.getDouble("discount_percent");
                double finalPrice = discount > 0 ? price - (price * discount / 100) : price;
                String image = rsSale.getString("image");
                String status = rsSale.getString("status");
                if (status == null) status = "Còn hàng";
                if (image == null || image.isEmpty()) image = "default.jpg";
        %>
        <div class="product-item">
            <a href="product-detail.jsp?id=<%= id %>" class="product-link">
                <div class="card">
                    <div class="discount-badge">-<%= (int)discount %>%</div>
                    <img src="images/<%= image %>" class="product-img" onerror="this.src='images/default.jpg'">
                    <div class="product-info">
                        <h3 class="product-name"><%= name %></h3>
                        <div class="price-wrapper">
                            <span class="old-price"><%= String.format("%,.0f", price) %>₫</span>
                            <span class="current-price"><%= String.format("%,.0f", finalPrice) %>₫</span>
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
                    <button type="button" class="btn-add" disabled style="background:#9ca3af; cursor:not-allowed;">
                        <i class="fas fa-times-circle"></i> Tạm hết hàng
                    </button>
                </div>
            <% } %>
        </div>
        <% } %>
    </div>

    <!-- 2. SẢN PHẨM NỔI BẬT -->
    <div class="section-title">
        <h2>⭐ Sản phẩm nổi bật</h2>
    </div>
    <div class="products">
        <%
            rsHot = st.executeQuery("SELECT * FROM products ORDER BY id DESC LIMIT 8");
            while (rsHot.next()) {
                int id = rsHot.getInt("id");
                String name = rsHot.getString("name");
                double price = rsHot.getDouble("price");
                double discount = rsHot.getDouble("discount_percent");
                double finalPrice = discount > 0 ? price - (price * discount / 100) : price;
                String image = rsHot.getString("image");
                String status = rsHot.getString("status");
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
                        <h3 class="product-name"><%= name %></h3>
                        <div class="price-wrapper">
                            <% if (discount > 0) { %>
                                <span class="old-price"><%= String.format("%,.0f", price) %>₫</span>
                                <span class="current-price"><%= String.format("%,.0f", finalPrice) %>₫</span>
                            <% } else { %>
                                <span class="current-price"><%= String.format("%,.0f", price) %>₫</span>
                            <% } %>
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
                    <button type="button" class="btn-add" disabled style="background:#9ca3af; cursor:not-allowed;">
                        <i class="fas fa-times-circle"></i> Tạm hết hàng
                    </button>
                </div>
            <% } %>
        </div>
        <% } %>
    </div>

    <!-- 3. TẤT CẢ SẢN PHẨM -->
    <div class="section-title">
        <h2>📦 Tất cả sản phẩm</h2>
    </div>
    <div class="products">
        <%
            rsAll = st.executeQuery("SELECT * FROM products ORDER BY id DESC");
            while (rsAll.next()) {
                int id = rsAll.getInt("id");
                String name = rsAll.getString("name");
                double price = rsAll.getDouble("price");
                double discount = rsAll.getDouble("discount_percent");
                double finalPrice = discount > 0 ? price - (price * discount / 100) : price;
                String image = rsAll.getString("image");
                String status = rsAll.getString("status");
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
                        <h3 class="product-name"><%= name %></h3>
                        <div class="price-wrapper">
                            <% if (discount > 0) { %>
                                <span class="old-price"><%= String.format("%,.0f", price) %>₫</span>
                                <span class="current-price"><%= String.format("%,.0f", finalPrice) %>₫</span>
                            <% } else { %>
                                <span class="current-price"><%= String.format("%,.0f", price) %>₫</span>
                            <% } %>
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
                    <button type="button" class="btn-add" disabled style="background:#9ca3af; cursor:not-allowed;">
                        <i class="fas fa-times-circle"></i> Tạm hết hàng
                    </button>
                </div>
            <% } %>
        </div>
        <% } %>
    </div>

</div>

<%
    } catch (Exception e) {
        out.println("<div style='padding:20px; background:#fee2e2; color:#dc2626; text-align:center;'>❌ Lỗi tải sản phẩm: " + e.getMessage() + "</div>");
        e.printStackTrace();
    } finally {
        try { if (rsSale != null) rsSale.close(); } catch (Exception e) {}
        try { if (rsHot != null) rsHot.close(); } catch (Exception e) {}
        try { if (rsAll != null) rsAll.close(); } catch (Exception e) {}
        try { if (st != null) st.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
<!-- ========== TIN TỨC MỚI NHẤT ========== -->
<div class="news-section">
    <div class="section-title">
        <h2><i class="fas fa-newspaper"></i> Bài Viết Mới Nhất</h2>
        <a href="news.jsp" class="view-all">Xem tất cả →</a>
    </div>
    <div class="news-grid">
        <%
            Connection newsConn = null;
            Statement newsSt = null;
            ResultSet newsRs = null;
            try {
                newsConn = DBConnection.getConnection();
                newsSt = newsConn.createStatement();
                newsRs = newsSt.executeQuery("SELECT id, title, summary, created_at FROM news ORDER BY created_at DESC LIMIT 4");
                while (newsRs.next()) {
        %>
        <div class="news-card">
            <h3 class="news-title"><a href="news-detail.jsp?id=<%= newsRs.getInt("id") %>"><%= newsRs.getString("title") %></a></h3>
            <p class="news-summary"><%= newsRs.getString("summary") %></p>
            <div class="news-meta">
                <span><i class="far fa-calendar"></i> <%= newsRs.getTimestamp("created_at") %></span>
                <a href="news-detail.jsp?id=<%= newsRs.getInt("id") %>" class="read-more">Xem thêm →</a>
            </div>
        </div>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try { if (newsRs != null) newsRs.close(); } catch (Exception e) {}
                try { if (newsSt != null) newsSt.close(); } catch (Exception e) {}
                try { if (newsConn != null) newsConn.close(); } catch (Exception e) {}
            }
        %>
    </div>
</div>

<style>
    /* ========== TIN TỨC TRÊN TRANG CHỦ ========== */
    .news-section {
        width: 90%;
        margin: 50px auto 0;
    }
    
    .section-title {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 25px;
    }
    
    .section-title h2 {
        font-size: 24px;
        font-weight: bold;
        color: #111827;
        position: relative;
        padding-left: 15px;
        border-left: 4px solid #ff6600;
    }
    
    .view-all {
        color: #ff6600;
        text-decoration: none;
        font-weight: bold;
    }
    
    .view-all:hover {
        text-decoration: underline;
    }
    
    .news-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: 25px;
    }
    
    .news-card {
        background: white;
        border-radius: 12px;
        padding: 20px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        transition: 0.3s;
    }
    
    .news-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 20px rgba(0,0,0,0.1);
    }
    
    .news-title {
        font-size: 18px;
        font-weight: bold;
        margin-bottom: 10px;
        line-height: 1.4;
    }
    
    .news-title a {
        text-decoration: none;
        color: #111827;
    }
    
    .news-title a:hover {
        color: #ff6600;
    }
    
    .news-summary {
        color: #6b7280;
        font-size: 14px;
        line-height: 1.5;
        margin-bottom: 12px;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
    
    .news-meta {
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 12px;
        color: #9ca3af;
    }
    
    .read-more {
        color: #ff6600;
        text-decoration: none;
        font-weight: bold;
    }
    
    .read-more:hover {
        text-decoration: underline;
    }
    
    @media (max-width: 768px) {
        .news-grid {
            grid-template-columns: 1fr;
        }
        .section-title {
            flex-direction: column;
            gap: 10px;
            align-items: flex-start;
        }
    }
</style>

<!-- ========== FOOTER MỚI ========== -->
<footer class="footer">
    <div class="footer-container">
        
        <!-- Cột 1: Thông tin công ty -->
        <div class="footer-col">
            <h3><i class="fas fa-building"></i> Tech Shop</h3>
            <p> Lê Văn Thiên - 24/05/2005 </P><!-- comment -->
            <p>Nguyễn Tiến Hoàng - 11/04/2005 </p>
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

<!-- SCRIPTS -->
<script>
    const searchInput = document.getElementById("searchInput");
    const searchResult = document.getElementById("searchResult");
    const searchItems = document.querySelectorAll(".search-item");

    if (searchInput && searchResult) {
        searchInput.addEventListener("keyup", function() {
            let keyword = this.value.toLowerCase().trim();
            let found = false;
            
            searchItems.forEach(item => {
                let text = item.innerText.toLowerCase();
                if (keyword !== "" && text.includes(keyword)) {
                    item.style.display = "flex";
                    found = true;
                } else {
                    item.style.display = "none";
                }
            });
            
            searchResult.style.display = found ? "block" : "none";
        });

        document.addEventListener("click", function(e) {
            if (!searchInput.contains(e.target) && !searchResult.contains(e.target)) {
                searchResult.style.display = "none";
            }
        });
    }

    const slides = document.querySelectorAll(".slide");
    let current = 0;
    if (slides.length > 0) {
        setInterval(() => {
            slides[current].classList.remove("active");
            current = (current + 1) % slides.length;
            slides[current].classList.add("active");
        }, 4000);
    }
</script>

</body>
</html>