<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="connect.DBConnection" %>

<%
request.setCharacterEncoding("UTF-8");

String id = request.getParameter("id");

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

try{

    conn = DBConnection.getConnection();

    ps = conn.prepareStatement(
        "SELECT * FROM products WHERE id=?"
    );

    ps.setString(1, id);

    rs = ps.executeQuery();

    if(rs.next()){

        double price = rs.getDouble("price");
        double discount = rs.getDouble("discount_percent");

        double finalPrice = price - (price * discount / 100);

        String status = rs.getString("status");
        if(status == null || status.isEmpty()){
            status = "Còn hàng";
        }
        status = status.trim();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= rs.getString("name") %> - Tech Shop</title>
    <link rel="stylesheet" href="CSS/product-detail.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <style>
        /* Nút thêm vào giỏ */
        .btn-cart {
            width: 100%;
            padding: 14px;
            border-radius: 12px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            background: #ff6600;
            color: white;
            border: none;
        }
        .btn-cart:hover {
            background: #e65c00;
            transform: translateY(-2px);
        }
        .disabled-btn {
            background: #9ca3af !important;
            cursor: not-allowed !important;
            transform: none !important;
        }
    </style>
</head>

<body>

<!-- TOPBAR -->
<div class="topbar">
    🚚 Miễn phí vận chuyển toàn quốc |
    ⚡ Giao nhanh 2H |
    🔒 Chính hãng 100%
</div>

<!-- HEADER -->
<header class="header">
    <div class="logo">
        <a href="products.jsp" class="logo-link">🛒 Tech Shop</a>
    </div>
    <a href="products.jsp" class="back-home">
        <i class="fa fa-house"></i> Trang chủ
    </a>
</header>

<!-- DETAIL -->
<div class="detail-container">

    <!-- IMAGE -->
    <div class="detail-image">
        <img src="images/<%= rs.getString("image") %>"
             alt="<%= rs.getString("name") %>"
             onerror="this.src='images/default.jpg'">
    </div>

    <!-- INFO -->
    <div class="detail-info">
        <h1><%= rs.getString("name") %></h1>

        <!-- RATING -->
        <div class="rating">
            ⭐⭐⭐⭐⭐ <span>(120 đánh giá)</span>
        </div>

        <!-- PRICE -->
        <div class="price">
            <% if(discount > 0){ %>
                <del><%= String.format("%,.0f", price) %>₫</del>
                <span style="color:red; font-size:24px; font-weight:bold;">
                    <%= String.format("%,.0f", finalPrice) %>₫
                </span>
                <span style="color:green; margin-left:10px;">-<%= String.format("%.0f", discount) %>%</span>
            <% } else { %>
                <span style="color:red; font-size:24px; font-weight:bold;">
                    <%= String.format("%,.0f", price) %>₫
                </span>
            <% } %>
        </div>

        <!-- SAVE -->
        <% if(discount > 0){ %>
            <p style="color:#666; margin-top:8px;">
                Tiết kiệm: <%= String.format("%,.0f", price - finalPrice) %>₫
            </p>
        <% } %>

        <!-- STATUS -->
        <div class="status <%= "Còn hàng".equalsIgnoreCase(status) ? "conhang" : "hethang" %>">
            <%= "Còn hàng".equalsIgnoreCase(status) ? "✅ Còn hàng" : "❌ Hết hàng" %>
        </div>

        <!-- DESCRIPTION -->
        <div class="description">
            <h3>Mô tả sản phẩm</h3>
            <p>
                <%= rs.getString("description") == null
                ? "Sản phẩm chính hãng, hiệu năng cao, bảo hành 12 tháng."
                : rs.getString("description") %>
            </p>
        </div>

        <!-- NÚT THÊM VÀO GIỎ -->
        <form action="add-to-cart" method="post">
            <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
            <input type="hidden" name="name" value="<%= rs.getString("name") %>">
            <input type="hidden" name="price" value="<%= finalPrice %>">
            <input type="hidden" name="image" value="<%= rs.getString("image") %>">
            <input type="hidden" name="quantity" value="1">
            
            <button type="submit" class="btn-cart <%= !"Còn hàng".equalsIgnoreCase(status) ? "disabled-btn" : "" %>"
                    <%= !"Còn hàng".equalsIgnoreCase(status) ? "disabled" : "" %>>
                <i class="fa fa-cart-shopping"></i>
                <%= "Còn hàng".equalsIgnoreCase(status) ? "Thêm vào giỏ hàng" : "Tạm hết hàng" %>
            </button>
        </form>
        
    </div>
</div>

</body>
</html>

<%
    }
} catch(Exception e){
    out.println("<div style='padding:20px; color:red;'>Lỗi: " + e.getMessage() + "</div>");
    e.printStackTrace();
} finally {
    if(rs != null) rs.close();
    if(ps != null) ps.close();
    if(conn != null) conn.close();
}
%>