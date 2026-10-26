<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="connect.DBConnection" %>

<%
    request.setCharacterEncoding("UTF-8");
    
    int id = Integer.parseInt(request.getParameter("id"));
    
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String name = "", image = "", description = "", category = "", status = "";
    double price = 0;
    int quantity = 0;
    
    try {
        conn = DBConnection.getConnection();
        ps = conn.prepareStatement("SELECT * FROM products WHERE id = ?");
        ps.setInt(1, id);
        rs = ps.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");
            price = rs.getDouble("price");
            image = rs.getString("image");
            description = rs.getString("description");
            category = rs.getString("category");
            quantity = rs.getInt("quantity");
            status = rs.getString("status");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa sản phẩm - Admin</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: Arial, sans-serif; }
        body { background: #f4f6f9; padding: 40px 20px; }
        
        .container { max-width: 550px; margin: 0 auto; }
        .back-btn { display: inline-block; margin-bottom: 20px; background: #111827; color: white; padding: 10px 20px; border-radius: 8px; text-decoration: none; font-weight: bold; }
        .back-btn:hover { background: #1f2937; }
        
        .form-card { background: white; border-radius: 16px; padding: 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .form-card h2 { text-align: center; color: #ff6600; margin-bottom: 25px; font-size: 26px; }
        
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; font-weight: bold; margin-bottom: 6px; color: #333; font-size: 14px; }
        .form-group input, .form-group textarea, .form-group select { width: 100%; padding: 10px 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; }
        .form-group input:focus, .form-group textarea:focus, .form-group select:focus { outline: none; border-color: #ff6600; }
        .form-group textarea { resize: vertical; min-height: 80px; }
        
        button { width: 100%; padding: 12px; background: #ff6600; color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: bold; cursor: pointer; margin-top: 10px; }
        button:hover { background: #e65c00; }
        
        .readonly-status { background: #f9fafb; color: #666; cursor: not-allowed; font-weight: bold; }
    </style>
</head>
<body>

<div class="container">
    <a href="qlspham.jsp" class="back-btn">← Quay lại danh sách</a>
    
    <div class="form-card">
        <h2>✏️ Sửa sản phẩm</h2>
        
        <form action="edit-product" method="post">
            <input type="hidden" name="id" value="<%= id %>">
            
            <div class="form-group">
                <label>📦 Tên sản phẩm *</label>
                <input type="text" name="name" value="<%= name %>" required>
            </div>
            
            <div class="form-group">
                <label>💰 Giá sản phẩm *</label>
                <input type="number" name="price" value="<%= price %>" required min="0" step="1000">
            </div>
            
            <div class="form-group">
                <label>🖼️ Tên file ảnh</label>
                <input type="text" name="image" value="<%= image != null ? image : "default.jpg" %>">
                <small style="color:#999; font-size:12px;">Ảnh phải có trong thư mục images/</small>
            </div>
            
            <div class="form-group">
                <label>📝 Mô tả sản phẩm</label>
                <textarea name="description"><%= description != null ? description : "" %></textarea>
            </div>
            
            <div class="form-group">
                <label>📁 Danh mục *</label>
                <select name="category" required>
                    <option value="">-- Chọn danh mục --</option>
                    <option value="router" <%= "router".equals(category) ? "selected" : "" %>>📡 Router</option>
                    <option value="switch" <%= "switch".equals(category) ? "selected" : "" %>>🔌 Switch</option>
                    <option value="access-point" <%= "access-point".equals(category) ? "selected" : "" %>>📶 Access Point</option>
                    <option value="modem" <%= "modem".equals(category) ? "selected" : "" %>>📠 Modem</option>
                    <option value="lan" <%= "lan".equals(category) ? "selected" : "" %>>🔗 Cáp mạng & Phụ kiện</option>
                </select>
            </div>
            
            <div class="form-group">
                <label>📊 Số lượng tồn kho *</label>
                <input type="number" name="quantity" id="quantity" value="<%= quantity %>" min="0" required>
                <small style="color:#999; font-size:12px;">Số lượng = 0 → Hết hàng | Số lượng > 0 → Còn hàng</small>
            </div>
            
            <div class="form-group">
                <label>🏷️ Trạng thái (tự động)</label>
                <input type="text" id="statusDisplay" value="<%= (quantity <= 0) ? "❌ Hết hàng" : "✅ Còn hàng" %>" readonly class="readonly-status">
                <input type="hidden" name="status" id="statusHidden" value="<%= (quantity <= 0) ? "Hết hàng" : "Còn hàng" %>">
            </div>
            
            <button type="submit">💾 Cập nhật sản phẩm</button>
        </form>
    </div>
</div>

<script>
    var quantity = document.getElementById('quantity');
    var statusDisplay = document.getElementById('statusDisplay');
    var statusHidden = document.getElementById('statusHidden');
    
    function updateStatus() {
        var val = parseInt(quantity.value) || 0;
        if (val <= 0) {
            statusDisplay.value = '❌ Hết hàng';
            statusHidden.value = 'Hết hàng';
        } else {
            statusDisplay.value = '✅ Còn hàng';
            statusHidden.value = 'Còn hàng';
        }
    }
    
    quantity.addEventListener('input', updateStatus);
    quantity.addEventListener('change', updateStatus);
</script>

</body>
</html>