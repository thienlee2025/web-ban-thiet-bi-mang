<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="connect.DBConnection" %>

<%
    // Kiểm tra quyền admin
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    Statement st = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        st = conn.createStatement();
        
        // Lấy chi tiết đơn hàng kèm thông tin khách hàng
        rs = st.executeQuery(
            "SELECT oi.*, o.fullname, o.email, o.phone, o.address, o.created_at, o.status " +
            "FROM order_items oi " +
            "JOIN orders o ON oi.order_id = o.id " +
            "ORDER BY oi.id DESC"
        );
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng - Admin</title>
    <link rel="stylesheet" href="CSS/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .content { padding: 30px; margin-left: 260px; }
        .back-btn { display: inline-block; margin-bottom: 20px; background: #2563eb; color: white; padding: 10px 18px; border-radius: 8px; text-decoration: none; font-weight: bold; transition: 0.3s; }
        .back-btn:hover { background: #1d4ed8; transform: translateX(-3px); }
        
        .table-box { background: white; border-radius: 12px; overflow-x: auto; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; min-width: 1000px; }
        th { background: #2563eb; color: white; padding: 14px; text-align: center; font-size: 14px; }
        td { padding: 12px; text-align: center; border-bottom: 1px solid #eee; vertical-align: middle; }
        tr:hover { background: #f8fafc; }
        
        .price { color: #dc2626; font-weight: bold; }
        .order-status { padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: bold; display: inline-block; }
        .pending { background: #ff9800; color: white; }
        .confirmed { background: #2196f3; color: white; }
        .shipping { background: #9c27b0; color: white; }
        .completed { background: #28a745; color: white; }
        
        .no-data { text-align: center; padding: 60px; color: #999; }
        
        @media (max-width: 768px) {
            .content { margin-left: 0; padding: 15px; }
        }
    </style>
</head>
<body>

<div class="admin-container">
    <div class="sidebar">
        <div class="logo">🛒 ADMIN PANEL</div>
        <a href="dashboard.jsp"><i class="fa fa-chart-line"></i> Dashboard</a>
        <a href="qlspham.jsp"><i class="fa fa-box"></i> Quản lý sản phẩm</a>
        <a href="orders.jsp"><i class="fa fa-cart-shopping"></i> Quản lý đơn hàng</a>
        <a href="order_items.jsp" class="active"><i class="fa fa-receipt"></i> Chi tiết đơn hàng</a>
        <a href="users.jsp"><i class="fa fa-users"></i> Quản lý người dùng</a>
        <a href="products.jsp"><i class="fa fa-store"></i> Trang bán hàng</a>
        <a href="logout"><i class="fa fa-right-from-bracket"></i> Đăng xuất</a>
    </div>

    <div class="content">
        <a href="dashboard.jsp" class="back-btn"><i class="fa fa-arrow-left"></i> Quay lại Dashboard</a>
        <h1><i class="fa fa-receipt"></i> Chi tiết đơn hàng</h1>
        
        <div class="table-box">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Mã ĐH</th>
                        <th>Khách hàng</th>
                        <th>Email</th>
                        <th>SĐT</th>
                        <th>Địa chỉ</th>
                        <th>Tên sản phẩm</th>
                        <th>Giá</th>
                        <th>Số lượng</th>
                        <th>Tổng</th>
                        <th>Ngày đặt</th>
                        <th>Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        boolean hasData = false;
                        while (rs != null && rs.next()) {
                            hasData = true;
                            int itemId = rs.getInt("id");
                            int orderId = rs.getInt("order_id");
                            String fullname = rs.getString("fullname");
                            String email = rs.getString("email");
                            String phone = rs.getString("phone");
                            String address = rs.getString("address");
                            String productName = rs.getString("product_name");
                            double price = rs.getDouble("price");
                            int quantity = rs.getInt("quantity");
                            double total = price * quantity;
                            String createdAt = rs.getString("created_at");
                            String status = rs.getString("status");
                            if (status == null) status = "pending";
                    %>
                    <tr>
                        <td><%= itemId %></td>
                        <td><%= orderId %></td>
                        <td><%= fullname != null ? fullname : "N/A" %></td>
                        <td><%= email != null ? email : "N/A" %></td>
                        <td><%= phone != null ? phone : "N/A" %></td>
                        <td style="max-width:200px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;" title="<%= address != null ? address : "" %>">
                            <%= address != null ? address : "N/A" %>
                        </td>
                        <td><%= productName != null ? productName : "N/A" %></td>
                        <td class="price"><%= String.format("%,.0f", price) %>₫</td>
                        <td><%= quantity %></td>
                        <td class="price"><%= String.format("%,.0f", total) %>₫</td>
                        <td><%= createdAt != null ? createdAt : "N/A" %></td>
                        <td>
                            <span class="order-status <%= status %>">
                                <%= getStatusText(status) %>
                            </span>
                        </td>
                    </tr>
                    <%
                        }
                        if (!hasData) {
                    %>
                    <tr><td colspan="12" class="no-data"><i class="fa fa-box-open"></i> Không có dữ liệu!</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%
    } catch (Exception e) {
        out.println("<div style='padding:20px; text-align:center; color:red;'>❌ Lỗi: " + e.getMessage() + "</div>");
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (st != null) st.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>

<%!
    private String getStatusText(String status) {
        if (status == null) return "Chờ xác nhận";
        switch(status) {
            case "pending": return "🟠 Chờ xác nhận";
            case "confirmed": return "🔵 Đã xác nhận";
            case "shipping": return "🟣 Đang giao hàng";
            case "completed": return "🟢 Hoàn thành";
            default: return "⚪ " + status;
        }
    }
%>

</body>
</html>