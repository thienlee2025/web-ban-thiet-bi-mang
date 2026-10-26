<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.CartItem" %>
<%@ page import="java.sql.*" %>
<%@ page import="connect.DBConnection" %>

<%
    request.setCharacterEncoding("UTF-8");
    
    // Lấy thông báo lỗi
    String error = (String) request.getAttribute("error");
    
    // Lấy giỏ hàng
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    String username = (String) session.getAttribute("user");
    
    // ========== XỬ LÝ MUA NGAY ==========
    // Nếu không có giỏ hàng hoặc giỏ rỗng, chuyển về trang sản phẩm
    if (cart == null || cart.isEmpty()) {
        response.sendRedirect("products.jsp");
        return;
    }
    
    // Lấy thông tin user từ database
    String userFullname = "";
    String userEmail = "";
    String userPhone = "";
    String userAddress = "";
    
    if (username != null && !username.trim().isEmpty()) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT hoten, email, sodienthoai, diachi FROM users WHERE username = ? OR email = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, username);
            rs = ps.executeQuery();
            if (rs.next()) {
                userFullname = rs.getString("hoten") != null ? rs.getString("hoten") : "";
                userEmail = rs.getString("email") != null ? rs.getString("email") : "";
                userPhone = rs.getString("sodienthoai") != null ? rs.getString("sodienthoai") : "";
                userAddress = rs.getString("diachi") != null ? rs.getString("diachi") : "";
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
    
    // Tính tổng tiền
    double total = 0;
    boolean hasItems = false;
    if (cart != null && !cart.isEmpty()) {
        hasItems = true;
        for (CartItem item : cart) {
            total += item.getPrice() * item.getQuantity();
        }
    }
    
    // Kiểm tra đăng nhập
    if (username == null || username.trim().isEmpty()) {
        response.sendRedirect("login.jsp?redirect=checkout.jsp&message=login_required");
        return;
    }
    
    // Kiểm tra giỏ hàng trống
    if (!hasItems) {
        response.sendRedirect("products.jsp?message=cart_empty");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán - Tech Shop</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #eef2f7 100%);
            min-height: 100vh;
            padding: 40px 20px;
        }
        
        .checkout-wrapper {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .checkout-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .checkout-header h1 {
            font-size: 32px;
            color: #111827;
            font-weight: 700;
        }
        
        .checkout-header p {
            color: #6b7280;
            margin-top: 8px;
        }
        
        .checkout-grid {
            display: grid;
            grid-template-columns: 1fr 1.2fr;
            gap: 30px;
        }
        
        .checkout-form {
            background: white;
            border-radius: 24px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
        }
        
        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #111827;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #ff6600;
            display: inline-block;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 6px;
        }
        
        .form-group label i {
            color: #ff6600;
            margin-right: 6px;
        }
        
        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            font-size: 15px;
            font-family: inherit;
            transition: all 0.3s;
            background: white;
        }
        
        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: #ff6600;
            box-shadow: 0 0 0 3px rgba(255,102,0,0.1);
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }
        
        .edit-info-checkbox {
            margin-bottom: 20px;
            padding: 12px;
            background: #fef3c7;
            border-radius: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .edit-info-checkbox input {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }
        
        .edit-info-checkbox label {
            font-size: 14px;
            color: #92400e;
            cursor: pointer;
            margin: 0;
        }
        
        .submit-btn {
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
        
        .submit-btn:hover {
            background: #e65c00;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255,102,0,0.3);
        }
        
        .order-summary {
            background: white;
            border-radius: 24px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
            position: sticky;
            top: 20px;
            height: fit-content;
        }
        
        .order-summary h3 {
            font-size: 18px;
            font-weight: 600;
            color: #111827;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e5e7eb;
        }
        
        .order-items {
            max-height: 350px;
            overflow-y: auto;
            margin-bottom: 20px;
        }
        
        .order-item {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #f3f4f6;
        }
        
        .order-item-info {
            flex: 2;
        }
        
        .order-item-name {
            font-size: 14px;
            font-weight: 500;
            color: #111827;
        }
        
        .order-item-price {
            font-size: 13px;
            color: #6b7280;
        }
        
        .order-item-qty {
            font-size: 13px;
            color: #9ca3af;
        }
        
        .order-item-total {
            font-weight: 600;
            color: #e53935;
        }
        
        .order-total {
            padding-top: 15px;
            border-top: 2px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            font-size: 18px;
            font-weight: 700;
            color: #111827;
        }
        
        .order-total span:last-child {
            color: #ff6600;
            font-size: 22px;
        }
        
        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #ff6600;
            text-decoration: none;
            font-weight: 500;
            transition: 0.3s;
        }
        
        .back-link:hover {
            text-decoration: underline;
        }
        
        .error-message, .success-message {
            padding: 12px 16px;
            border-radius: 12px;
            margin-bottom: 20px;
            text-align: center;
            font-weight: 500;
        }
        .error-message { background: #fee2e2; color: #dc2626; border: 1px solid #fecaca; }
        .success-message { background: #dcfce7; color: #16a34a; border: 1px solid #bbf7d0; }
        
        /* Style cho input readonly (giống disabled nhưng vẫn gửi dữ liệu) */
        input:read-only, textarea:read-only, select:read-only {
            background: #f9fafb;
            color: #6b7280;
            cursor: default;
        }
        
        @media (max-width: 768px) {
            .checkout-grid { grid-template-columns: 1fr; }
            .checkout-header h1 { font-size: 24px; }
            .checkout-form, .order-summary { padding: 20px; }
        }
    </style>
</head>

<body>

<div class="checkout-wrapper">
    
    <div class="checkout-header">
        <h1><i class="fa fa-credit-card"></i> Thanh toán</h1>
        <p>Vui lòng kiểm tra thông tin trước khi đặt hàng</p>
    </div>
    
    <div class="checkout-grid">
        
        <!-- ========== CỘT TRÁI: FORM THÔNG TIN ========== -->
        <div class="checkout-form">
            
            <h2 class="section-title"><i class="fa fa-user-circle"></i> Thông tin giao hàng</h2>
            
            <% if (error != null && !error.trim().isEmpty()) { %>
                <div class="error-message"><i class="fa fa-exclamation-triangle"></i> <%= error %></div>
            <% } %>
            
            <div class="edit-info-checkbox">
                <input type="checkbox" id="editInfoCheckbox">
                <label for="editInfoCheckbox">
                    <i class="fa fa-pencil-alt"></i> Đặt hàng hộ? (Bật để sửa thông tin người nhận)
                </label>
            </div>
            
            <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm">
                
                <div class="form-group">
                    <label><i class="fa fa-user"></i> Họ và tên *</label>
                    <input type="text" name="fullname" id="fullname" 
                           value="<%= userFullname %>" 
                           placeholder="Nhập họ tên người nhận" required>
                </div>
                
                <div class="form-group">
                    <label><i class="fa fa-envelope"></i> Email *</label>
                    <input type="email" name="email" id="email"
                           value="<%= userEmail %>"
                           placeholder="example@gmail.com" required>
                </div>
                
                <div class="form-group">
                    <label><i class="fa fa-phone"></i> Số điện thoại *</label>
                    <input type="tel" name="phone" id="phone"
                           value="<%= userPhone %>"
                           placeholder="📞 0912 345 678"
                           pattern="[0-9]{10,11}"
                           title="Vui lòng nhập 10-11 chữ số" required>
                </div>
                
                <div class="form-group">
                    <label><i class="fa fa-map-marker-alt"></i> Địa chỉ *</label>
                    <input type="text" name="address" id="address"
                           value="<%= userAddress %>"
                           placeholder="Số nhà, đường, phường, quận, thành phố" required>
                </div>
                
                <div class="form-group">
                    <label><i class="fa fa-note-sticky"></i> Ghi chú (không bắt buộc)</label>
                    <textarea name="note" id="note" placeholder="Giao hàng giờ hành chính, để ở bảo vệ, ..."></textarea>
                </div>
                
                <div class="form-group">
                    <label><i class="fa fa-money-bill-wave"></i> Phương thức thanh toán</label>
                    <select name="payment_method">
                        <option value="cod">💰 Thanh toán khi nhận hàng (COD)</option>
                    </select>
                </div>
                
                <button type="submit" class="submit-btn">
                    <i class="fa fa-check-circle"></i> Xác nhận đặt hàng
                </button>
                
            </form>
            
            <a href="cart.jsp" class="back-link">
                <i class="fa fa-arrow-left"></i> Quay lại giỏ hàng
            </a>
            
        </div>
        
        <!-- ========== CỘT PHẢI: TÓM TẮT ĐƠN HÀNG ========== -->
        <div class="order-summary">
            
            <h3><i class="fa fa-shopping-bag"></i> Đơn hàng của bạn</h3>
            
            <div class="order-items">
                <% for (CartItem item : cart) { 
                    double subtotal = item.getPrice() * item.getQuantity();
                %>
                <div class="order-item">
                    <div class="order-item-info">
                        <div class="order-item-name"><%= item.getName() %></div>
                        <div class="order-item-price"><%= String.format("%,.0f", item.getPrice()) %>₫</div>
                    </div>
                    <div class="order-item-qty">x<%= item.getQuantity() %></div>
                    <div class="order-item-total"><%= String.format("%,.0f", subtotal) %>₫</div>
                </div>
                <% } %>
            </div>
            
            <div class="order-total">
                <span>Tổng cộng:</span>
                <span><%= String.format("%,.0f", total) %>₫</span>
            </div>
            
            <% if (total > 1000000) { %>
                <div style="margin-top: 15px; padding: 10px; background: #e8f5e9; border-radius: 10px; text-align: center; color: #2e7d32; font-size: 13px;">
                    <i class="fa fa-truck-fast"></i> Miễn phí vận chuyển!
                </div>
            <% } %>
            
            <div style="margin-top: 20px; padding: 12px; background: #fef3c7; border-radius: 10px; font-size: 12px; color: #92400e;">
                <i class="fa fa-shield-alt"></i> Đơn hàng sẽ được xác nhận trong vòng 24h
            </div>
            
        </div>
        
    </div>
    
</div>

<script>
    const editCheckbox = document.getElementById('editInfoCheckbox');
    const fullnameInput = document.getElementById('fullname');
    const emailInput = document.getElementById('email');
    const phoneInput = document.getElementById('phone');
    const addressInput = document.getElementById('address');
    
    const originalFullname = fullnameInput.value;
    const originalEmail = emailInput.value;
    const originalPhone = phoneInput.value;
    const originalAddress = addressInput.value;
    
    editCheckbox.addEventListener('change', function() {
        const isEditable = this.checked;
        
        if (isEditable) {
            // DÙNG readOnly = false (vẫn gửi dữ liệu lên server)
            fullnameInput.readOnly = false;
            emailInput.readOnly = false;
            phoneInput.readOnly = false;
            addressInput.readOnly = false;
            
            fullnameInput.style.background = 'white';
            emailInput.style.background = 'white';
            phoneInput.style.background = 'white';
            addressInput.style.background = 'white';
            
            fullnameInput.value = '';
            emailInput.value = '';
            phoneInput.value = '';
            addressInput.value = '';
            
            fullnameInput.placeholder = 'Nhập họ tên người nhận (đặt hộ)';
            emailInput.placeholder = 'Nhập email người nhận';
            phoneInput.placeholder = 'Nhập SĐT người nhận';
            addressInput.placeholder = 'Nhập địa chỉ người nhận';
        } else {
            // DÙNG readOnly = true (vẫn gửi dữ liệu lên server)
            fullnameInput.readOnly = true;
            emailInput.readOnly = true;
            phoneInput.readOnly = true;
            addressInput.readOnly = true;
            
            fullnameInput.style.background = '#f9fafb';
            emailInput.style.background = '#f9fafb';
            phoneInput.style.background = '#f9fafb';
            addressInput.style.background = '#f9fafb';
            
            fullnameInput.value = originalFullname;
            emailInput.value = originalEmail;
            phoneInput.value = originalPhone;
            addressInput.value = originalAddress;
            
            fullnameInput.placeholder = '';
            emailInput.placeholder = '';
            phoneInput.placeholder = '';
            addressInput.placeholder = '';
        }
    });
    
    // Mặc định: readOnly = true (đặt hàng cho chính mình, vẫn gửi dữ liệu)
    fullnameInput.readOnly = true;
    emailInput.readOnly = true;
    phoneInput.readOnly = true;
    addressInput.readOnly = true;
    
    fullnameInput.style.background = '#f9fafb';
    emailInput.style.background = '#f9fafb';
    phoneInput.style.background = '#f9fafb';
    addressInput.style.background = '#f9fafb';
    
    document.getElementById('checkoutForm').addEventListener('submit', function(e) {
        let fullname = fullnameInput.value.trim();
        let email = emailInput.value.trim();
        let phone = phoneInput.value.trim();
        let address = addressInput.value.trim();
        
        if (fullname === "") {
            alert("❌ Vui lòng nhập họ tên người nhận!");
            e.preventDefault();
            return false;
        }
        
        if (email === "") {
            alert("❌ Vui lòng nhập email!");
            e.preventDefault();
            return false;
        }
        
        if (!email.includes('@') || !email.includes('.')) {
            alert("❌ Email không hợp lệ!");
            e.preventDefault();
            return false;
        }
        
        if (phone === "") {
            alert("❌ Vui lòng nhập số điện thoại!");
            e.preventDefault();
            return false;
        }
        
        if (!/^[0-9]{10,11}$/.test(phone)) {
            alert("❌ Số điện thoại phải có 10-11 chữ số!");
            e.preventDefault();
            return false;
        }
        
        if (address === "") {
            alert("❌ Vui lòng nhập địa chỉ giao hàng!");
            e.preventDefault();
            return false;
        }
        
        return true;
    });
</script>

</body>
</html>