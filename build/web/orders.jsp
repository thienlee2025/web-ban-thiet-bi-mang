<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="connect.DBConnection" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }

    String successMsg = (String) session.getAttribute("success");
    String errorMsg = (String) session.getAttribute("error");
    if (successMsg != null) session.removeAttribute("success");
    if (errorMsg != null) session.removeAttribute("error");

    String statusFilter = request.getParameter("status");

    Connection conn = null;
    Statement st = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        st = conn.createStatement();

        String sql = "SELECT * FROM orders";
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql += " WHERE status = '" + statusFilter + "'";
        }
        sql += " ORDER BY id DESC";
        
        rs = st.executeQuery(sql);
    } catch (Exception e) {
        out.println("<div style='color:red; padding:20px;'>Lỗi: " + e.getMessage() + "</div>");
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng</title>
    <link rel="stylesheet" href="CSS/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        .admin-container { display: flex; }
        .sidebar { width: 260px; background: #0f172a; min-height: 100vh; padding: 20px; position: fixed; }
        .sidebar .logo { color: white; font-size: 24px; font-weight: bold; text-align: center; margin-bottom: 40px; }
        .sidebar a { display: flex; align-items: center; gap: 12px; color: #cbd5e1; text-decoration: none; padding: 12px 15px; border-radius: 10px; margin-bottom: 8px; transition: 0.3s; }
        .sidebar a:hover, .sidebar .active { background: #2563eb; color: white; }
        
        .content { margin-left: 260px; padding: 30px; width: calc(100% - 260px); }
        
        .top-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; flex-wrap: wrap; gap: 15px; }
        .top-bar h1 { font-size: 28px; color: #0f172a; }
        .back-btn { background: #2563eb; color: white; padding: 8px 16px; border-radius: 8px; text-decoration: none; font-weight: bold; }
        .back-btn:hover { background: #1d4ed8; }
        
        .filter-bar { background: white; padding: 15px 20px; border-radius: 12px; margin-bottom: 20px; display: flex; gap: 15px; align-items: flex-end; flex-wrap: wrap; }
        .filter-group { display: flex; flex-direction: column; gap: 5px; }
        .filter-group label { font-weight: bold; font-size: 13px; color: #333; }
        .filter-group select { padding: 8px 12px; border-radius: 8px; border: 1px solid #ddd; }
        .filter-group button { padding: 8px 15px; background: #2563eb; color: white; border: none; border-radius: 8px; cursor: pointer; }
        .reset-btn { padding: 8px 15px; background: #6b7280; color: white; border-radius: 8px; text-decoration: none; font-size: 14px; }
        
        .success-msg { background: #dcfce7; color: #16a34a; padding: 12px; border-radius: 10px; margin-bottom: 20px; text-align: center; }
        .error-msg { background: #fee2e2; color: #dc2626; padding: 12px; border-radius: 10px; margin-bottom: 20px; text-align: center; }
        
        .table-wrapper { background: white; border-radius: 12px; overflow-x: auto; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; min-width: 1100px; }
        th { background: #2563eb; color: white; padding: 14px 10px; text-align: center; font-size: 14px; }
        td { padding: 12px 10px; text-align: center; border-bottom: 1px solid #eee; vertical-align: middle; }
        tr:hover { background: #f8fafc; }
        
        .status-badge { padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: bold; display: inline-block; }
        .status-pending { background: #ff9800; color: white; }
        .status-confirmed { background: #2196f3; color: white; }
        .status-shipping { background: #9c27b0; color: white; }
        .status-completed { background: #28a745; color: white; }
        .status-cancelled { background: #dc2626; color: white; }
        
        .action-group { display: flex; gap: 6px; justify-content: center; flex-wrap: wrap; }
        .action-btn { padding: 5px 10px; border-radius: 5px; text-decoration: none; color: white; font-size: 11px; display: inline-block; transition: 0.2s; }
        .action-btn:hover { opacity: 0.8; transform: translateY(-1px); }
        .btn-confirm { background: #2196f3; }
        .btn-ship { background: #9c27b0; }
        .btn-done { background: #28a745; }
        .btn-cancel { background: #dc2626; }
        .action-disabled { background: #ccc; cursor: not-allowed; pointer-events: none; }
        
        .no-data { text-align: center; padding: 50px; color: #999; }
        
        @media (max-width: 768px) {
            .sidebar { width: 80px; }
            .sidebar a span { display: none; }
            .content { margin-left: 80px; width: calc(100% - 80px); }
            .filter-bar { flex-direction: column; align-items: stretch; }
            .top-bar { flex-direction: column; align-items: flex-start; }
        }
    </style>
</head>
<body>

<div class="admin-container">
    <div class="sidebar">
        <div class="logo">🛒 ADMIN</div>
        <a href="dashboard.jsp"><i class="fa fa-chart-line"></i> <span>Dashboard</span></a>
        <a href="qlspham.jsp"><i class="fa fa-box"></i> <span>Sản phẩm</span></a>
        <a href="orders.jsp" class="active"><i class="fa fa-cart-shopping"></i> <span>Đơn hàng</span></a>
        <a href="order_items.jsp"><i class="fa fa-receipt"></i> <span>Chi tiết ĐH</span></a>
        <a href="users.jsp"><i class="fa fa-users"></i> <span>Người dùng</span></a>
        <a href="products.jsp"><i class="fa fa-store"></i> <span>Bán hàng</span></a>
        <a href="logout"><i class="fa fa-sign-out-alt"></i> <span>Đăng xuất</span></a>
    </div>

    <div class="content">
        <div class="top-bar">
            <h1><i class="fa fa-cart-shopping"></i> Quản lý đơn hàng</h1>
            <a href="dashboard.jsp" class="back-btn"><i class="fa fa-arrow-left"></i> Quay lại</a>
        </div>
        
        <% if (successMsg != null) { %>
            <div class="success-msg"><i class="fa fa-check-circle"></i> <%= successMsg %></div>
        <% } %>
        <% if (errorMsg != null) { %>
            <div class="error-msg"><i class="fa fa-exclamation-triangle"></i> <%= errorMsg %></div>
        <% } %>
        
        <div class="filter-bar">
            <form method="get" action="orders.jsp" style="display: flex; gap: 15px; align-items: flex-end; flex-wrap: wrap;">
                <div class="filter-group">
                    <label><i class="fa fa-filter"></i> Lọc theo trạng thái</label>
                    <select name="status">
                        <option value="">📋 Tất cả</option>
                        <option value="pending" <%= "pending".equals(statusFilter) ? "selected" : "" %>>🟠 Chờ xác nhận</option>
                        <option value="confirmed" <%= "confirmed".equals(statusFilter) ? "selected" : "" %>>🔵 Đã xác nhận</option>
                        <option value="shipping" <%= "shipping".equals(statusFilter) ? "selected" : "" %>>🟣 Đang giao</option>
                        <option value="completed" <%= "completed".equals(statusFilter) ? "selected" : "" %>>🟢 Hoàn thành</option>
                        <option value="cancelled" <%= "cancelled".equals(statusFilter) ? "selected" : "" %>>❌ Đã hủy</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label>&nbsp;</label>
                    <button type="submit"><i class="fa fa-filter"></i> Lọc</button>
                </div>
            </form>
            <a href="orders.jsp" class="reset-btn"><i class="fa fa-undo"></i> Xóa lọc</a>
        </div>
        
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>ID</th><th>Khách hàng</th><th>Email</th><th>SĐT</th>
                        <th>Địa chỉ</th><th>Tổng tiền</th><th>Ngày đặt</th><th>Trạng thái</th><th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        boolean hasData = false;
                        if (rs != null) {
                            while (rs.next()) {
                                hasData = true;
                                int id = rs.getInt("id");
                                String status = rs.getString("status");
                                if (status == null || status.isEmpty()) status = "pending";
                                String fullname = rs.getString("fullname");
                                String email = rs.getString("email");
                                String phone = rs.getString("phone");
                                String address = rs.getString("address");
                                double total = rs.getDouble("total");
                                String createdAt = rs.getString("created_at");
                    %>
                    <tr>
                        <td>#<%= id %></td>
                        <td><%= fullname != null ? fullname : "N/A" %></td>
                        <td><%= email != null ? email : "N/A" %></td>
                        <td><%= phone != null ? phone : "N/A" %></td>
                        <td><%= address != null ? address : "N/A" %></td>
                        <td class="price"><%= String.format("%,.0f", total) %>₫</td>
                        <td><%= createdAt != null ? createdAt : "N/A" %></td>
                        <td><span class="status-badge status-<%= status %>"><%= getStatusText(status) %></span></td>
                        <td class="action-group">
                            <% if ("pending".equals(status)) { %>
                                <a href="update-order-status?id=<%= id %>&status=confirmed" class="action-btn btn-confirm" onclick="return confirm('Xác nhận đơn hàng #<%= id %>?')">✅ Xác nhận</a>
                                <a href="update-order-status?id=<%= id %>&status=cancelled" class="action-btn btn-cancel" onclick="return confirm('Hủy đơn hàng #<%= id %>?')">❌ Hủy</a>
                            <% } else if ("confirmed".equals(status)) { %>
                                <a href="update-order-status?id=<%= id %>&status=shipping" class="action-btn btn-ship" onclick="return confirm('Chuyển sang đang giao?')">🚚 Đang giao</a>
                                <a href="update-order-status?id=<%= id %>&status=cancelled" class="action-btn btn-cancel" onclick="return confirm('Hủy đơn hàng #<%= id %>?')">❌ Hủy</a>
                            <% } else if ("shipping".equals(status)) { %>
                                <a href="update-order-status?id=<%= id %>&status=completed" class="action-btn btn-done" onclick="return confirm('Hoàn thành đơn hàng #<%= id %>?')">✅ Hoàn thành</a>
                            <% } else if ("completed".equals(status)) { %>
                                <span class="action-btn action-disabled">✅ Đã hoàn thành</span>
                            <% } else if ("cancelled".equals(status)) { %>
                                <span class="action-btn action-disabled">❌ Đã hủy</span>
                            <% } %>
                        </td>
                    </tr>
                    <%
                            }
                        }
                        if (!hasData) {
                    %>
                    <tr><td colspan="9" class="no-data">📭 Không có đơn hàng nào!</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%
    try { if (rs != null) rs.close(); } catch (Exception e) {}
    try { if (st != null) st.close(); } catch (Exception e) {}
    try { if (conn != null) conn.close(); } catch (Exception e) {}
%>

<%!
    private String getStatusText(String status) {
        if (status == null) return "Chờ xác nhận";
        switch(status) {
            case "pending": return "🟠 Chờ xác nhận";
            case "confirmed": return "🔵 Đã xác nhận";
            case "shipping": return "🟣 Đang giao";
            case "completed": return "🟢 Hoàn thành";
            case "cancelled": return "❌ Đã hủy";
            default: return status;
        }
    }
%>

</body>
</html>