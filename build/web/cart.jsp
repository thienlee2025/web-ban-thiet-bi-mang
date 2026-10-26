<%@ page import="java.util.*, model.CartItem" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="connect.DBConnection" %>

<%
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    String user = (String) session.getAttribute("user");
    double total = 0;
    
    String orderStatus = null;
    if (user != null && !user.trim().isEmpty()) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet orderRs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement("SELECT status FROM orders WHERE username = ? ORDER BY id DESC LIMIT 1");
            ps.setString(1, user);
            orderRs = ps.executeQuery();
            if (orderRs.next()) orderStatus = orderRs.getString("status");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (orderRs != null) try { orderRs.close(); } catch (SQLException e) {}
            if (ps != null) try { ps.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - Tech Shop</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, Helvetica, sans-serif;
        }
        body { background: #f5f5f5; padding: 30px; }
        .cart-container { width: 92%; margin: 0 auto; background: white; border-radius: 15px; padding: 25px; box-shadow: 0 2px 12px rgba(0,0,0,0.08); }
        h2 { text-align: center; color: #ff6600; margin-bottom: 25px; font-size: 32px; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #ff6600; color: white; padding: 15px; }
        td { padding: 15px; text-align: center; border-bottom: 1px solid #eee; }
        .cart-img { width: 70px; height: 70px; object-fit: contain; border-radius: 8px; background: white; padding: 5px; }
        .product-name { font-weight: bold; color: #333; }
        .price { color: #e53935; font-weight: bold; font-size: 16px; }
        .qty-box { display: flex; align-items: center; justify-content: center; gap: 8px; }
        .qty-input { width: 55px; height: 35px; text-align: center; border: 1px solid #ddd; border-radius: 6px; font-size: 15px; }
        .qty-btn { width: 32px; height: 32px; border: none; border-radius: 6px; background: #ff6600; color: white; font-size: 18px; font-weight: bold; cursor: pointer; transition: 0.2s; }
        .qty-btn:hover { background: #e65c00; transform: scale(1.05); }
        .update-btn { background: #ff6600; color: white; border: none; padding: 8px 15px; border-radius: 6px; cursor: pointer; margin-left: 10px; }
        .delete-btn { width: 35px; height: 35px; border-radius: 50%; background: #ef4444; color: white; border: none; cursor: pointer; }
        .delete-btn:hover { background: #dc2626; transform: scale(1.1); }
        .cart-total { text-align: right; margin-top: 20px; font-size: 22px; font-weight: bold; }
        .cart-total span { color: #ff6600; font-size: 26px; }
        .cart-actions { display: flex; justify-content: space-between; margin-top: 25px; gap: 15px; }
        .shop-btn, .checkout-btn { padding: 12px 25px; border: none; border-radius: 8px; font-weight: bold; cursor: pointer; transition: 0.3s; }
        .shop-btn { background: #333; color: white; }
        .shop-btn:hover { background: #111; }
        .checkout-btn { background: #ff6600; color: white; }
        .checkout-btn:hover { background: #e65c00; transform: translateY(-2px); }
        .empty-cart { text-align: center; padding: 60px; color: #666; }
        .order-status { padding: 12px; border-radius: 10px; margin-bottom: 20px; text-align: center; font-weight: bold; }
        .pending { background: #ff9800; color: white; }
        .confirmed { background: #2196f3; color: white; }
        .shipping { background: #9c27b0; color: white; }
        .completed { background: #28a745; color: white; }
        @media (max-width: 768px) { td, th { padding: 8px; font-size: 12px; } .cart-img { width: 50px; height: 50px; } .cart-actions { flex-direction: column; } .shop-btn, .checkout-btn { width: 100%; } }
    </style>
</head>
<body>

<div class="cart-container">
    <h2><i class="fa fa-shopping-cart"></i> Giỏ hàng của bạn</h2>
    
    <% if (orderStatus != null) { %>
        <div class="order-status <%= orderStatus %>">
            <%= "pending".equals(orderStatus) ? "🟠 Chờ xác nhận" : "confirmed".equals(orderStatus) ? "🔵 Đã xác nhận" : "shipping".equals(orderStatus) ? "🟣 Đang giao" : "🟢 Hoàn thành" %>
        </div>
    <% } %>
    
    <% if (cart == null || cart.isEmpty()) { %>
        <div class="empty-cart">
            <i class="fa fa-box-open" style="font-size: 48px; color: #ccc;"></i>
            <h3>Giỏ hàng đang trống!</h3>
            <a href="products.jsp"><button class="shop-btn"><i class="fa fa-store"></i> Tiếp tục mua hàng</button></a>
        </div>
    <% } else { %>
        
        <table>
            <thead><tr><th>Ảnh</th><th>Sản phẩm</th><th>Giá</th><th>Số lượng</th><th>Tạm tính</th><th>Xóa</th></tr></thead>
            <tbody id="cartBody">
                <% for (CartItem item : cart) { 
                    double subtotal = item.getPrice() * item.getQuantity();
                    total += subtotal;
                %>
                <tr id="row-<%= item.getId() %>">
                    <td><img src="images/<%= item.getImage() != null ? item.getImage() : "default.jpg" %>" class="cart-img" onerror="this.src='images/default.jpg'"></td>
                    <td class="product-name"><%= item.getName() %></td>
                    <td class="price"><%= String.format("%,.0f", item.getPrice()) %>₫</td>
                    <td>
                        <div class="qty-box">
                            <button class="qty-btn minus" data-id="<%= item.getId() %>" data-price="<%= item.getPrice() %>">−</button>
                            <input type="number" id="qty-<%= item.getId() %>" class="qty-input" value="<%= item.getQuantity() %>" min="1" max="99" data-id="<%= item.getId() %>">
                            <button class="qty-btn plus" data-id="<%= item.getId() %>" data-price="<%= item.getPrice() %>">+</button>
                        </div>
                    </td>
                    <td class="price" id="subtotal-<%= item.getId() %>"><%= String.format("%,.0f", subtotal) %>₫</td>
                    <td><a href="remove-cart?id=<%= item.getId() %>" onclick="return confirm('Xóa sản phẩm này?')"><button class="delete-btn"><i class="fa fa-trash"></i></button></a></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        
        <div class="cart-total">Tổng thanh toán: <span id="totalAmount"><%= String.format("%,.0f", total) %>₫</span></div>
        
        <div class="cart-actions">
            <a href="products.jsp"><button class="shop-btn"><i class="fa fa-arrow-left"></i> Tiếp tục mua hàng</button></a>
            <% if (user == null) { %>
                <a href="login.jsp?redirect=cart.jsp"><button class="checkout-btn"><i class="fa fa-lock"></i> Đăng nhập để thanh toán</button></a>
            <% } else { %>
                <a href="checkout.jsp"><button class="checkout-btn"><i class="fa fa-credit-card"></i> Thanh toán</button></a>
            <% } %>
        </div>
        
        <% if (total > 1000000) { %>
            <div style="margin-top: 20px; padding: 12px; background: #e8f5e9; border-radius: 10px; text-align: center; color: #2e7d32;">🎉 Miễn phí vận chuyển!</div>
        <% } %>
        
    <% } %>
</div>

<script>
function updateTotal() {
    let total = 0;
    document.querySelectorAll('[id^="subtotal-"]').forEach(el => {
        let val = el.innerText.replace(/[₫,]/g, '').replace(/\./g, '');
        total += parseFloat(val) || 0;
    });
    document.getElementById('totalAmount').innerText = total.toLocaleString('vi-VN') + '₫';
}

function updateSubtotal(id, price, quantity) {
    let subtotal = price * quantity;
    document.getElementById('subtotal-' + id).innerText = subtotal.toLocaleString('vi-VN') + '₫';
    updateTotal();
}

function sendUpdate(id, quantity) {
    fetch('update-cart', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'id=' + id + '&quantity=' + quantity
    }).catch(err => console.error('Lỗi:', err));
}

// Gắn sự kiện cho nút +/-
document.querySelectorAll('.plus').forEach(btn => {
    btn.addEventListener('click', function() {
        let id = this.getAttribute('data-id');
        let price = parseFloat(this.getAttribute('data-price'));
        let input = document.getElementById('qty-' + id);
        let newVal = parseInt(input.value) + 1;
        if (newVal <= 99) {
            input.value = newVal;
            updateSubtotal(id, price, newVal);
            sendUpdate(id, newVal);
        } else {
            alert('Số lượng tối đa là 99');
        }
    });
});

document.querySelectorAll('.minus').forEach(btn => {
    btn.addEventListener('click', function() {
        let id = this.getAttribute('data-id');
        let price = parseFloat(this.getAttribute('data-price'));
        let input = document.getElementById('qty-' + id);
        let newVal = parseInt(input.value) - 1;
        if (newVal >= 1) {
            input.value = newVal;
            updateSubtotal(id, price, newVal);
            sendUpdate(id, newVal);
        }
    });
});

// Nhập trực tiếp
document.querySelectorAll('.qty-input').forEach(input => {
    input.addEventListener('change', function() {
        let id = this.getAttribute('data-id');
        let price = parseFloat(document.querySelector(`.plus[data-id='${id}']`).getAttribute('data-price'));
        let newVal = parseInt(this.value);
        if (isNaN(newVal) || newVal < 1) newVal = 1;
        if (newVal > 99) { newVal = 99; alert('Tối đa 99'); }
        this.value = newVal;
        updateSubtotal(id, price, newVal);
        sendUpdate(id, newVal);
    });
});
</script>

</body>
</html>