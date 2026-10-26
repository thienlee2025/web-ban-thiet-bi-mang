<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm sản phẩm - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Arial, sans-serif; }
        body { background: #f4f6f9; padding: 40px 20px; }
        
        .container { max-width: 600px; margin: 0 auto; }
        .back-btn { display: inline-block; margin-bottom: 20px; background: #111827; color: white; padding: 10px 20px; border-radius: 8px; text-decoration: none; font-weight: bold; transition: 0.3s; }
        .back-btn:hover { background: #1f2937; transform: translateX(-3px); }
        
        .form-card { background: white; border-radius: 20px; padding: 35px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        .form-card h2 { text-align: center; color: #ff6600; margin-bottom: 25px; font-size: 28px; }
        
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-weight: bold; margin-bottom: 8px; color: #333; }
        .form-group label i { color: #ff6600; margin-right: 8px; }
        .form-group input, .form-group textarea, .form-group select { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 10px; font-size: 14px; transition: 0.3s; }
        .form-group input:focus, .form-group textarea:focus, .form-group select:focus { outline: none; border-color: #ff6600; box-shadow: 0 0 0 3px rgba(255,102,0,0.1); }
        .form-group textarea { resize: vertical; min-height: 100px; }
        
        button { width: 100%; padding: 14px; background: #ff6600; color: white; border: none; border-radius: 40px; font-size: 16px; font-weight: bold; cursor: pointer; transition: 0.3s; margin-top: 10px; }
        button:hover { background: #e65c00; transform: translateY(-2px); }
        
        .error-message { background: #fee2e2; color: #dc2626; padding: 12px; border-radius: 10px; margin-bottom: 20px; text-align: center; }
        
        @media (max-width: 600px) { .form-card { padding: 25px; } }
    </style>
</head>
<body>

<div class="container">
    <a href="qlspham.jsp" class="back-btn"><i class="fa fa-arrow-left"></i> Quay lại danh sách</a>
    
    <div class="form-card">
        <h2><i class="fa fa-plus-circle"></i> Thêm sản phẩm mới</h2>
        
        <%
            String error = (String) request.getAttribute("error");
            if (error != null && !error.trim().isEmpty()) {
        %>
            <div class="error-message"><i class="fa fa-exclamation-circle"></i> <%= error %></div>
        <%
            }
        %>
        
        <form action="add-product" method="post">
            <div class="form-group">
                <label><i class="fa fa-tag"></i> Tên sản phẩm *</label>
                <input type="text" name="name" placeholder="Nhập tên sản phẩm" required>
            </div>
            
            <div class="form-group">
                <label><i class="fa fa-dollar-sign"></i> Giá sản phẩm *</label>
                <input type="number" name="price" placeholder="Nhập giá" required min="0" step="1000">
            </div>
            
            <div class="form-group">
                <label><i class="fa fa-image"></i> Tên file ảnh</label>
                <input type="text" name="image" placeholder="vd: router.jpg" value="default.jpg">
                <small style="color: #666;">Ảnh phải có trong thư mục images/</small>
            </div>
            
            <div class="form-group">
                <label><i class="fa fa-align-left"></i> Mô tả sản phẩm</label>
                <textarea name="description" placeholder="Nhập mô tả chi tiết..."></textarea>
            </div>
            
            <div class="form-group">
                <label><i class="fa fa-list"></i> Danh mục *</label>
                <select name="category" required>
                    <option value="">-- Chọn danh mục --</option>
                    <option value="router">📡 Router</option>
                    <option value="switch">🔌 Switch</option>
                    <option value="access-point">📶 Access Point</option>
                    <option value="modem">📠 Modem</option>
                    <option value="lan">🔗 Cáp mạng & Phụ kiện</option>
                </select>
            </div>
            
            <div class="form-group">
                <label><i class="fa fa-boxes"></i> Số lượng tồn kho *</label>
                <input type="number" name="quantity" id="quantity" value="0" min="0" required>
                <small style="color: #666;"><i class="fa fa-info-circle"></i> Nếu số lượng = 0, sản phẩm sẽ tự động là "Hết hàng"</small>
            </div>
            
            <!-- Trạng thái (chỉ hiển thị, không cho sửa) -->
            <div class="form-group">
                <label><i class="fa fa-check-circle"></i> Trạng thái (tự động)</label>
                <input type="text" id="statusDisplay" value="❌ Hết hàng" readonly style="background:#f9fafb; cursor:not-allowed; font-weight:bold;">
                <input type="hidden" name="status" id="statusHidden" value="Hết hàng">
            </div>
            
            <button type="submit"><i class="fa fa-save"></i> Thêm sản phẩm</button>
        </form>
    </div>
</div>

<script>
    var quantityInput = document.getElementById('quantity');
    var statusDisplay = document.getElementById('statusDisplay');
    var statusHidden = document.getElementById('statusHidden');
    
    function updateStatus() {
        var quantity = parseInt(quantityInput.value) || 0;
        if (quantity <= 0) {
            statusDisplay.value = '❌ Hết hàng';
            statusDisplay.style.color = '#dc2626';
            statusHidden.value = 'Hết hàng';
        } else {
            statusDisplay.value = '✅ Còn hàng';
            statusDisplay.style.color = '#16a34a';
            statusHidden.value = 'Còn hàng';
        }
    }
    
    quantityInput.addEventListener('input', updateStatus);
    quantityInput.addEventListener('change', updateStatus);
    updateStatus();
</script>

</body>
</html>