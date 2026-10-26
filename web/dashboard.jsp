<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="connect.DBConnection" %>

<%
    // KIỂM TRA QUYỀN ADMIN
    String adminRole = (String) session.getAttribute("role");
    
    if (adminRole == null || !adminRole.equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // KẾT NỐI DATABASE
    Connection conn = null;
    Statement st = null;
    
    try {
        conn = DBConnection.getConnection();
        st = conn.createStatement();
        
        // THỐNG KÊ SẢN PHẨM
        ResultSet rs1 = st.executeQuery("SELECT COUNT(*) FROM products");
        rs1.next();
        int totalProducts = rs1.getInt(1);
        rs1.close();
        
        // THỐNG KÊ ĐƠN HÀNG
        ResultSet rs2 = st.executeQuery("SELECT COUNT(*) FROM orders");
        rs2.next();
        int totalOrders = rs2.getInt(1);
        rs2.close();
        
        // THỐNG KÊ NGƯỜI DÙNG
        ResultSet rs3 = st.executeQuery("SELECT COUNT(*) FROM users");
        rs3.next();
        int totalUsers = rs3.getInt(1);
        rs3.close();
        
        // THỐNG KÊ DOANH THU
        ResultSet rs4 = st.executeQuery("SELECT COALESCE(SUM(total), 0) FROM orders");
        rs4.next();
        double revenue = rs4.getDouble(1);
        rs4.close();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Tech Shop</title>
    <link rel="stylesheet" href="CSS/admin.css?v=2">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <style>
        .message-preview {
            max-width: 250px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .message-preview:hover {
            white-space: normal;
            overflow: visible;
            background: #f8fafc;
            position: absolute;
            z-index: 10;
            padding: 5px;
            border-radius: 5px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .status-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .status-completed {
            background: #28a745;
            color: white;
        }
        
        .no-data {
            text-align: center;
            padding: 30px;
            color: #999;
        }
        
        @media (max-width: 1200px) {
            .table-box {
                overflow-x: auto;
            }
            table {
                min-width: 800px;
            }
        }
    </style>
</head>
<body>

<div class="admin-container">

    <!-- SIDEBAR -->
    <div class="sidebar">
        <div class="logo">🛒 ADMIN PANEL</div>
        
        <a href="dashboard.jsp" class="active">
            <i class="fa fa-chart-line"></i> Dashboard
        </a>
        <a href="qlspham.jsp">
            <i class="fa fa-box"></i> Quản lý sản phẩm
        </a>
        <a href="orders.jsp">
            <i class="fa fa-cart-shopping"></i> Quản lý đơn hàng
        </a>
        <a href="order_items.jsp">
            <i class="fa fa-receipt"></i> Chi tiết đơn hàng
        </a>
        <a href="users.jsp">
            <i class="fa fa-users"></i> Quản lý người dùng
        </a>
        <a href="products.jsp">
            <i class="fa fa-store"></i> Trang bán hàng
        </a>
        <a href="logout">
            <i class="fa fa-right-from-bracket"></i> Đăng xuất
        </a>
    </div>

    <!-- CONTENT -->
    <div class="content">

        <!-- TOPBAR -->
        <div class="topbar">
            <h1><i class="fa fa-chart-line"></i> Dashboard</h1>
            <div class="admin-info">👋 Xin chào, Admin</div>
        </div>

        <!-- CARDS THỐNG KÊ -->
        <div class="cards">
            <div class="card">
                <div>
                    <h2><%= totalProducts %></h2>
                    <p>📦 Sản phẩm</p>
                </div>
                <i class="fa fa-box"></i>
            </div>
            <div class="card">
                <div>
                    <h2><%= totalOrders %></h2>
                    <p>🛒 Đơn hàng</p>
                </div>
                <i class="fa fa-cart-shopping"></i>
            </div>
            <div class="card">
                <div>
                    <h2><%= totalUsers %></h2>
                    <p>👥 Người dùng</p>
                </div>
                <i class="fa fa-users"></i>
            </div>
            <div class="card">
                <div>
                    <h2><%= String.format("%,.0f", revenue) %>₫</h2>
                    <p>💰 Doanh thu</p>
                </div>
                <i class="fa fa-money-bill-wave"></i>
            </div>
        </div>

        <!-- BẢNG ĐƠN HÀNG MỚI NHẤT -->
        <div class="table-box">
            <h2><i class="fa fa-clock"></i> Đơn hàng mới nhất</h2>
            
            <table>
                <thead>
                    <tr>
                        <th>ID</th><th>Khách hàng</th><th>SĐT</th>
                        <th>Địa chỉ</th><th>Tổng tiền</th>
                        <th>Ngày đặt</th><th>Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        ResultSet rs5 = st.executeQuery("SELECT * FROM orders ORDER BY id DESC LIMIT 5");
                        boolean hasOrders = false;
                        while (rs5.next()) {
                            hasOrders = true;
                            String status = rs5.getString("status");
                            if (status == null || status.isEmpty()) status = "pending";
                    %>
                    <tr>
                        <td>#<%= rs5.getInt("id") %></td>
                        <td><%= rs5.getString("fullname") != null ? rs5.getString("fullname") : "N/A" %></td>
                        <td><%= rs5.getString("phone") != null ? rs5.getString("phone") : "N/A" %></td>
                        <td><%= rs5.getString("address") != null ? rs5.getString("address") : "N/A" %></td>
                        <td class="price"><%= String.format("%,.0f", rs5.getDouble("total")) %>₫</td>
                        <td><%= rs5.getTimestamp("created_at") != null ? rs5.getTimestamp("created_at") : "N/A" %></td>
                        <td>
                            <span class="order-status <%= status.toLowerCase() %>">
                                <%= getStatusText(status) %>
                            </span>
                        </td>
                    </tr>
                    <%
                        }
                        rs5.close();
                        if (!hasOrders) {
                    %>
                    <tr><td colspan="7" class="no-data">📭 Chưa có đơn hàng nào</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        
        <!-- BẢNG LIÊN HỆ KHÁCH HÀNG -->
        <div class="table-box">
            <h2><i class="fa fa-envelope"></i> Liên hệ khách hàng mới nhất</h2>
            
            <table>
                <thead>
                    <tr>
                        <th>ID</th><th>Họ tên</th><th>Email</th>
                        <th>SĐT</th><th>Chủ đề</th><th>Nội dung</th><th>Ngày gửi</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            ResultSet rsContact = st.executeQuery("SELECT * FROM contacts ORDER BY id DESC LIMIT 5");
                            boolean hasContacts = false;
                            while (rsContact.next()) {
                                hasContacts = true;
                                String subject = rsContact.getString("subject");
                    %>
                    <tr>
                        <td>#<%= rsContact.getInt("id") %></td>
                        <td><%= rsContact.getString("fullname") != null ? rsContact.getString("fullname") : "N/A" %></td>
                        <td><%= rsContact.getString("email") != null ? rsContact.getString("email") : "N/A" %></td>
                        <td><%= rsContact.getString("phone") != null ? rsContact.getString("phone") : "N/A" %></td>
                        <td>
                            <% 
                                if (subject != null) {
                                    switch(subject) {
                                        case "order": out.print("🛒 Đơn hàng"); break;
                                        case "product": out.print("📦 Sản phẩm"); break;
                                        case "delivery": out.print("🚚 Giao hàng"); break;
                                        case "payment": out.print("💰 Thanh toán"); break;
                                        case "warranty": out.print("🔧 Bảo hành"); break;
                                        default: out.print("💬 " + subject);
                                    }
                                } else {
                                    out.print("💬 Khác");
                                }
                            %>
                        </td>
                        <td class="message-preview" title="<%= rsContact.getString("message") != null ? rsContact.getString("message").replace("\"", "&quot;") : "" %>">
                            <%= rsContact.getString("message") != null ? 
                                (rsContact.getString("message").length() > 50 ? 
                                rsContact.getString("message").substring(0, 50) + "..." : 
                                rsContact.getString("message")) : "N/A" %>
                        </td>
                        <td><%= rsContact.getTimestamp("created_at") != null ? rsContact.getTimestamp("created_at") : "N/A" %></td>
                    </tr>
                    <%
                            }
                            rsContact.close();
                            if (!hasContacts) {
                    %>
                    <tr><td colspan="7" class="no-data">📭 Chưa có liên hệ nào</td></tr>
                    <% }
                        } catch (SQLException e) {
                    %>
                    <tr><td colspan="7" class="no-data">📭 Chưa có liên hệ nào</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        
        <!-- THÔNG TIN NHANH -->
        <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; margin-top: 20px;">
            
            <div class="table-box" style="margin-bottom: 0;">
                <h2><i class="fa fa-clock"></i> Đơn hàng chờ xác nhận</h2>
                <%
                    ResultSet rsPending = st.executeQuery("SELECT COUNT(*) FROM orders WHERE status = 'pending' OR status IS NULL");
                    rsPending.next();
                    int pendingOrders = rsPending.getInt(1);
                    rsPending.close();
                %>
                <div style="text-align: center; padding: 20px;">
                    <span style="font-size: 48px; font-weight: bold; color: #ff9800;"><%= pendingOrders %></span>
                    <p style="color: #666;">đơn hàng cần xử lý</p>
                    <a href="orders.jsp?status=pending" style="display: inline-block; margin-top: 10px; padding: 8px 16px; background: #ff9800; color: white; text-decoration: none; border-radius: 8px;">Xử lý ngay →</a>
                </div>
            </div>
            
            <div class="table-box" style="margin-bottom: 0;">
                <h2><i class="fa fa-exclamation-triangle"></i> Sản phẩm hết hàng</h2>
                <%
                    ResultSet rsOutOfStock = st.executeQuery("SELECT COUNT(*) FROM products WHERE status = 'Hết hàng' OR status = 'out_of_stock'");
                    rsOutOfStock.next();
                    int outOfStock = rsOutOfStock.getInt(1);
                    rsOutOfStock.close();
                %>
                <div style="text-align: center; padding: 20px;">
                    <span style="font-size: 48px; font-weight: bold; color: #dc2626;"><%= outOfStock %></span>
                    <p style="color: #666;">sản phẩm hết hàng</p>
                    <a href="qlspham.jsp?filter=out_of_stock" style="display: inline-block; margin-top: 10px; padding: 8px 16px; background: #dc2626; color: white; text-decoration: none; border-radius: 8px;">Kiểm tra →</a>
                </div>
            </div>
            
        </div>

    </div>
</div>

</body>
</html>

<%
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<div style='padding:20px; background:#fee2e2; color:#dc2626; text-align:center;'>");
        out.println("<h3>❌ Lỗi kết nối Database!</h3>");
        out.println("<p>" + e.getMessage() + "</p>");
        out.println("</div>");
    } finally {
        try { if (st != null) st.close(); } catch (SQLException e) {}
        try { if (conn != null) conn.close(); } catch (SQLException e) {}
    }
%>

<%!
    private String getStatusText(String status) {
        if (status == null) return "Chờ xác nhận";
        switch(status.toLowerCase()) {
            case "pending": return "🟠 Chờ xác nhận";
            case "confirmed": return "🔵 Đã xác nhận";
            case "shipping": return "🟣 Đang giao hàng";
            case "completed": return "🟢 Hoàn thành";
            default: return "⚪ " + status;
        }
    }
%>