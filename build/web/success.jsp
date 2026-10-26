<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt hàng thành công - Tech Shop</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .success-container {
            max-width: 500px;
            width: 100%;
            background: white;
            border-radius: 32px;
            padding: 50px 40px;
            text-align: center;
            box-shadow: 0 25px 50px -12px rgba(0,0,0,0.25);
            animation: fadeInUp 0.5s ease;
        }
        
        /* Icon thành công */
        .success-icon {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #22c55e, #16a34a);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 25px;
            animation: scaleIn 0.4s ease 0.2s both;
        }
        
        .success-icon i {
            font-size: 55px;
            color: white;
        }
        
        /* Tiêu đề */
        h1 {
            font-size: 32px;
            font-weight: 700;
            color: #111827;
            margin-bottom: 10px;
        }
        
        /* Đường kẻ */
        .divider {
            width: 80px;
            height: 4px;
            background: #22c55e;
            margin: 20px auto;
            border-radius: 2px;
        }
        
        /* Nội dung */
        .message {
            font-size: 16px;
            color: #6b7280;
            line-height: 1.6;
            margin-bottom: 30px;
        }
        
        .order-info {
            background: #f9fafb;
            border-radius: 20px;
            padding: 20px;
            margin-bottom: 30px;
            text-align: left;
        }
        
        .order-info p {
            margin: 8px 0;
            font-size: 14px;
            color: #374151;
        }
        
        .order-info i {
            width: 24px;
            color: #22c55e;
            margin-right: 8px;
        }
        
        /* Nút bấm */
        .btn-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 14px 28px;
            border-radius: 40px;
            font-weight: 600;
            font-size: 15px;
            text-decoration: none;
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .btn-primary {
            background: #ff6600;
            color: white;
            border: none;
        }
        
        .btn-primary:hover {
            background: #e65c00;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px -5px rgba(255,102,0,0.4);
        }
        
        .btn-outline {
            background: transparent;
            color: #ff6600;
            border: 2px solid #ff6600;
        }
        
        .btn-outline:hover {
            background: #ff6600;
            color: white;
            transform: translateY(-2px);
        }
        
        /* Thông báo thêm */
        .extra-note {
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #e5e7eb;
            font-size: 13px;
            color: #9ca3af;
        }
        
        .extra-note i {
            color: #ff6600;
            margin-right: 5px;
        }
        
        /* Animation */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes scaleIn {
            from {
                opacity: 0;
                transform: scale(0.5);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }
        
        /* Responsive */
        @media (max-width: 550px) {
            .success-container {
                padding: 35px 25px;
            }
            h1 {
                font-size: 26px;
            }
            .btn {
                padding: 12px 20px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>

<div class="success-container">
    
    <!-- Icon thành công -->
    <div class="success-icon">
        <i class="fas fa-check"></i>
    </div>
    
    <!-- Tiêu đề -->
    <h1>Đặt hàng thành công!</h1>
    <div class="divider"></div>
    
    <!-- Nội dung -->
    <div class="message">
        Cảm ơn bạn đã tin tưởng và mua sắm tại <strong>Tech Shop</strong>.<br>
        Đơn hàng của bạn đã được ghi nhận và sẽ được xử lý trong thời gian sớm nhất.
    </div>
    
    <!-- Thông tin đơn hàng (có thể lấy từ session) -->
    <div class="order-info">
        <p><i class="fas fa-check-circle"></i> Xác nhận đơn hàng qua email</p>
        <p><i class="fas fa-truck"></i> Giao hàng dự kiến: 2-3 ngày</p>
        <p><i class="fas fa-headset"></i> Hotline hỗ trợ: <strong>1900 XXXX</strong></p>
    </div>
    
    <!-- Nút hành động -->
    <div class="btn-group">
        <a href="products.jsp" class="btn btn-primary">
            <i class="fas fa-store"></i> Tiếp tục mua sắm
        </a>
        <a href="my-orders.jsp" class="btn btn-outline">
            <i class="fas fa-box"></i> Xem đơn hàng
        </a>
    </div>
    
    <!-- Thông báo thêm -->
    <div class="extra-note">
        <i class="fas fa-envelope"></i> Chúng tôi đã gửi email xác nhận đến địa chỉ của bạn
    </div>
    
</div>

</body>
</html>