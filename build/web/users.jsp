<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="connect.DBConnection" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    // Kiểm tra quyền admin
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Lấy thông báo
    String successMsg = (String) session.getAttribute("success");
    String errorMsg = (String) session.getAttribute("error");
    if (successMsg != null) session.removeAttribute("success");
    if (errorMsg != null) session.removeAttribute("error");

    // Tìm kiếm và lọc
    String search = request.getParameter("search");
    String roleFilter = request.getParameter("roleFilter");
    
    // Phân trang
    int pageSize = 10;
    int currentPage = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.isEmpty()) {
        currentPage = Integer.parseInt(pageParam);
    }
    int offset = (currentPage - 1) * pageSize;

    Connection conn = null;
    Statement st = null;
    ResultSet rs = null;
    ResultSet rsCount = null;
    
    int totalUsers = 0;
    int totalPages = 0;

    try {
        conn = DBConnection.getConnection();
        st = conn.createStatement();

        // Đếm tổng số người dùng
        String countSql = "SELECT COUNT(*) FROM users WHERE 1=1";
        if (search != null && !search.trim().isEmpty()) {
            countSql += " AND (hoten LIKE '%" + search + "%' OR email LIKE '%" + search + "%' OR username LIKE '%" + search + "%')";
        }
        if (roleFilter != null && !roleFilter.isEmpty()) {
            countSql += " AND role = '" + roleFilter + "'";
        }
        
        rsCount = st.executeQuery(countSql);
        if (rsCount.next()) {
            totalUsers = rsCount.getInt(1);
            totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        }
        rsCount.close();

        // Lấy danh sách người dùng
        String sql = "SELECT * FROM users WHERE 1=1";
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (hoten LIKE '%" + search + "%' OR email LIKE '%" + search + "%' OR username LIKE '%" + search + "%')";
        }
        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql += " AND role = '" + roleFilter + "'";
        }
        sql += " ORDER BY id DESC LIMIT " + pageSize + " OFFSET " + offset;
        
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
    <title>Quản lý người dùng - Admin</title>
    <link rel="stylesheet" href="CSS/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .content { padding: 30px; margin-left: 260px; }
        .back-btn { display: inline-block; margin-bottom: 20px; background: #2563eb; color: white; padding: 10px 18px; border-radius: 8px; text-decoration: none; font-weight: bold; transition: 0.3s; }
        .back-btn:hover { background: #1d4ed8; transform: translateX(-3px); }
        
        .filter-bar { background: white; padding: 15px 20px; border-radius: 12px; margin-bottom: 20px; display: flex; gap: 15px; align-items: flex-end; flex-wrap: wrap; }
        .filter-group { display: flex; flex-direction: column; gap: 5px; }
        .filter-group label { font-weight: bold; font-size: 13px; color: #333; }
        .filter-group input, .filter-group select { padding: 8px 12px; border-radius: 8px; border: 1px solid #ddd; width: 200px; }
        .filter-group button { padding: 8px 15px; background: #2563eb; color: white; border: none; border-radius: 8px; cursor: pointer; }
        .filter-group button:hover { background: #1d4ed8; }
        
        .success-message { background: #dcfce7; color: #16a34a; padding: 10px; border-radius: 8px; margin-bottom: 20px; text-align: center; }
        .error-message { background: #fee2e2; color: #dc2626; padding: 10px; border-radius: 8px; margin-bottom: 20px; text-align: center; }
        
        .table-box { background: white; border-radius: 12px; overflow-x: auto; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; min-width: 800px; }
        th { background: #2563eb; color: white; padding: 12px; text-align: center; }
        td { padding: 10px; text-align: center; border-bottom: 1px solid #eee; vertical-align: middle; }
        tr:hover { background: #f8fafc; }
        
        .role-badge { padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: bold; display: inline-block; }
        .role-admin { background: #2563eb; color: white; }
        .role-user { background: #16a34a; color: white; }
        
        .action-btn { padding: 5px 10px; border-radius: 6px; text-decoration: none; font-size: 12px; display: inline-block; margin: 2px; }
        .edit-btn { background: #f59e0b; color: white; }
        .delete-btn { background: #dc2626; color: white; }
        .action-btn:hover { opacity: 0.8; }
        
        .pagination { display: flex; justify-content: center; gap: 8px; margin-top: 25px; flex-wrap: wrap; }
        .pagination a { padding: 6px 12px; background: white; color: #2563eb; text-decoration: none; border-radius: 6px; border: 1px solid #ddd; }
        .pagination a:hover { background: #2563eb; color: white; }
        .pagination .active { background: #2563eb; color: white; }
        .pagination .disabled { color: #999; pointer-events: none; }
        
        .no-data { text-align: center; padding: 50px; color: #999; }
        
        @media (max-width: 768px) {
            .content { margin-left: 0; padding: 15px; }
            .filter-bar { flex-direction: column; align-items: stretch; }
            .filter-group input, .filter-group select { width: 100%; }
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
        <a href="order_items.jsp"><i class="fa fa-receipt"></i> Chi tiết đơn hàng</a>
        <a href="users.jsp" class="active"><i class="fa fa-users"></i> Quản lý người dùng</a>
        <a href="products.jsp"><i class="fa fa-store"></i> Trang bán hàng</a>
        <a href="logout"><i class="fa fa-right-from-bracket"></i> Đăng xuất</a>
    </div>

    <div class="content">
        <a href="dashboard.jsp" class="back-btn"><i class="fa fa-arrow-left"></i> Quay lại Dashboard</a>
        <h1><i class="fa fa-users"></i> Quản lý người dùng</h1>
        
        <% if (successMsg != null) { %>
            <div class="success-message"><i class="fa fa-check-circle"></i> <%= successMsg %></div>
        <% } %>
        <% if (errorMsg != null) { %>
            <div class="error-message"><i class="fa fa-exclamation-triangle"></i> <%= errorMsg %></div>
        <% } %>
        
        <form method="get" action="users.jsp" class="filter-bar">
            <div class="filter-group">
                <label><i class="fa fa-search"></i> Tìm kiếm</label>
                <input type="text" name="search" placeholder="Họ tên, email, username..." value="<%= search != null ? search : "" %>">
            </div>
            <div class="filter-group">
                <label><i class="fa fa-filter"></i> Vai trò</label>
                <select name="roleFilter">
                    <option value="">👥 Tất cả</option>
                    <option value="admin" <%= "admin".equals(roleFilter) ? "selected" : "" %>>👑 Admin</option>
                    <option value="user" <%= "user".equals(roleFilter) ? "selected" : "" %>>👤 User</option>
                </select>
            </div>
            <div class="filter-group">
                <label>&nbsp;</label>
                <button type="submit"><i class="fa fa-filter"></i> Lọc</button>
            </div>
            <div class="filter-group">
                <label>&nbsp;</label>
                <a href="users.jsp" style="padding: 8px 15px; background: #6b7280; color: white; border-radius: 8px; text-decoration: none;">🗑️ Xóa lọc</a>
            </div>
        </form>
        
        <div class="table-box">
            <table>
                <thead>
                    <tr>
                        <th>ID</th><th>Họ tên</th><th>Username</th><th>Email</th>
                        <th>SĐT</th><th>Địa chỉ</th><th>Vai trò</th><th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        boolean hasData = false;
                        if (rs != null) {
                            while (rs.next()) {
                                hasData = true;
                                int userId = rs.getInt("id");
                                String hoten = rs.getString("hoten");
                                String username = rs.getString("username");
                                String email = rs.getString("email");
                                String sodienthoai = rs.getString("sodienthoai");
                                String diachi = rs.getString("diachi");
                                String userRole = rs.getString("role");
                                if (userRole == null) userRole = "user";
                    %>
                    <tr>
                        <td><%= userId %></td>
                        <td><%= hoten != null ? hoten : "N/A" %></td>
                        <td><%= username != null ? username : "N/A" %></td>
                        <td><%= email != null ? email : "N/A" %></td>
                        <td><%= sodienthoai != null ? sodienthoai : "N/A" %></td>
                        <td><%= diachi != null ? diachi : "N/A" %></td>
                        <td>
                            <span class="role-badge <%= "admin".equals(userRole) ? "role-admin" : "role-user" %>">
                                <%= "admin".equals(userRole) ? "👑 Admin" : "👤 User" %>
                            </span>
                        </td>
                        <td>
                            <a href="edit-user.jsp?id=<%= userId %>" class="action-btn edit-btn"><i class="fa fa-pen"></i> Sửa</a>
                            <% if (userId != 1) { %>
                                <a href="delete-user?id=<%= userId %>" class="action-btn delete-btn" onclick="return confirm('Xóa người dùng <%= hoten %>?')"><i class="fa fa-trash"></i> Xóa</a>
                            <% } else { %>
                                <span style="color:#999; font-size:12px;">🔒 Không xóa</span>
                            <% } %>
                        </td>
                    </tr>
                    <%
                            }
                        }
                        if (!hasData) {
                    %>
                    <tr><td colspan="8" class="no-data"><i class="fa fa-users-slash"></i> Không có người dùng nào!</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        
        <% if (totalPages > 1) { %>
        <div class="pagination">
            <a href="?page=1&search=<%= search != null ? search : "" %>&roleFilter=<%= roleFilter != null ? roleFilter : "" %>" class="<%= currentPage == 1 ? "disabled" : "" %>">« Đầu</a>
            <a href="?page=<%= currentPage - 1 %>&search=<%= search != null ? search : "" %>&roleFilter=<%= roleFilter != null ? roleFilter : "" %>" class="<%= currentPage == 1 ? "disabled" : "" %>">‹ Trước</a>
            <% for (int i = Math.max(1, currentPage - 2); i <= Math.min(totalPages, currentPage + 2); i++) { %>
                <a href="?page=<%= i %>&search=<%= search != null ? search : "" %>&roleFilter=<%= roleFilter != null ? roleFilter : "" %>" class="<%= currentPage == i ? "active" : "" %>"><%= i %></a>
            <% } %>
            <a href="?page=<%= currentPage + 1 %>&search=<%= search != null ? search : "" %>&roleFilter=<%= roleFilter != null ? roleFilter : "" %>" class="<%= currentPage == totalPages ? "disabled" : "" %>">Tiếp ›</a>
            <a href="?page=<%= totalPages %>&search=<%= search != null ? search : "" %>&roleFilter=<%= roleFilter != null ? roleFilter : "" %>" class="<%= currentPage == totalPages ? "disabled" : "" %>">Cuối »</a>
        </div>
        <div style="text-align: center; margin-top: 10px; color: #666; font-size: 13px;">Hiển thị <%= offset + 1 %> - <%= Math.min(offset + pageSize, totalUsers) %> / <%= totalUsers %> người dùng</div>
        <% } %>
    </div>
</div>

<%
    try { if (rs != null) rs.close(); } catch (Exception e) {}
    try { if (st != null) st.close(); } catch (Exception e) {}
    try { if (conn != null) conn.close(); } catch (Exception e) {}
%>

</body>
</html>