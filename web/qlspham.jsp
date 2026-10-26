<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="connect.DBConnection" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    // ========== PHÂN TRANG ==========
    int pageSize = 10;                              // Số sản phẩm mỗi trang
    int currentPage = 1;                            // Trang hiện tại
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.isEmpty()) {
        currentPage = Integer.parseInt(pageParam);
    }
    int offset = (currentPage - 1) * pageSize;      // Vị trí bắt đầu

    // ========== TÌM KIẾM & LỌC ==========
    String searchKeyword = request.getParameter("search");
    String categoryFilter = request.getParameter("category");
    String statusFilter = request.getParameter("status");

    // ========== HIỂN THỊ THÔNG BÁO THÀNH CÔNG ==========
    String successMsg = (String) session.getAttribute("success");
    if (successMsg != null) {
        session.removeAttribute("success");         // Xóa sau khi đọc
    }

    Connection conn = null;
    Statement st = null;
    ResultSet rs = null;
    ResultSet rsCount = null;
    
    int totalProducts = 0;
    int totalPages = 0;

    try {
        conn = DBConnection.getConnection();
        st = conn.createStatement();

        // ========== ĐẾM TỔNG SỐ SẢN PHẨM ==========
        String countSql = "SELECT COUNT(*) FROM products WHERE 1=1";
        
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            countSql += " AND (name LIKE '%" + searchKeyword + "%' OR description LIKE '%" + searchKeyword + "%')";
        }
        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            countSql += " AND category = '" + categoryFilter + "'";
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            countSql += " AND status = '" + statusFilter + "'";
        }
        
        rsCount = st.executeQuery(countSql);
        if (rsCount.next()) {
            totalProducts = rsCount.getInt(1);
            totalPages = (int) Math.ceil((double) totalProducts / pageSize);
        }
        rsCount.close();

        // ========== TRUY VẤN DANH SÁCH SẢN PHẨM ==========
        String sql = "SELECT * FROM products WHERE 1=1";
        
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql += " AND (name LIKE '%" + searchKeyword + "%' OR description LIKE '%" + searchKeyword + "%')";
        }
        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            sql += " AND category = '" + categoryFilter + "'";
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql += " AND status = '" + statusFilter + "'";
        }
        
        sql += " ORDER BY id DESC LIMIT " + pageSize + " OFFSET " + offset;
        
        rs = st.executeQuery(sql);

    } catch (Exception e) {
        out.println("<div class='error-message'>❌ Lỗi: " + e.getMessage() + "</div>");
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý sản phẩm - Admin</title>

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        /* RESET */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, Helvetica, sans-serif;
        }

        /* BODY - NỀN GRADIENT ĐỘNG */
        body {
            background: linear-gradient(-45deg, #fff7f0, #ffe0b2, #fff3e0, #ffffff);
            background-size: 400% 400%;
            animation: bgMove 12s ease infinite;
            padding: 30px;
        }

        /* KHUNG CHÍNH */
        .content {
            width: 95%;
            margin: auto;
        }

        /* THANH TIÊU ĐỀ + NÚT */
        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .top-bar h1 {
            font-size: 42px;
            color: #111827;
        }

        /* NÚT BẤM */
        .btn {
            display: inline-block;
            padding: 12px 20px;
            border-radius: 10px;
            text-decoration: none;
            color: white;
            font-weight: bold;
            transition: 0.3s;
        }
        
        .btn-group {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .back-btn { background: #2563eb; }
        .back-btn:hover { background: #1d4ed8; transform: translateY(-2px); }
        .add-btn { background: #16a34a; }
        .add-btn:hover { background: #15803d; transform: translateY(-2px); }

        /* THÔNG BÁO THÀNH CÔNG (THÊM MỚI) */
        .success-message {
            background: #dcfce7;
            color: #16a34a;
            padding: 14px 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            text-align: center;
            border: 1px solid #bbf7d0;
            font-weight: bold;
            animation: slideDown 0.4s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* TÌM KIẾM & LỌC */
        .filter-bar {
            background: white;
            padding: 20px;
            border-radius: 16px;
            margin-bottom: 20px;
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            align-items: flex-end;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .filter-group {
            flex: 1;
            min-width: 150px;
        }

        .filter-group label {
            display: block;
            font-size: 13px;
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
        }

        .filter-group input,
        .filter-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }

        .filter-group button {
            width: 100%;
            padding: 10px;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
        }

        .filter-group button:hover {
            background: #1d4ed8;
        }

        .reset-btn {
            background: #6b7280 !important;
        }
        .reset-btn:hover {
            background: #4b5563 !important;
        }

        /* BẢNG */
        .table-box {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1200px;
        }

        /* HEADER BẢNG */
        table th {
            background: linear-gradient(90deg, #2563eb, #3b82f6);
            color: white;
            padding: 20px;
            text-align: center;
            font-size: 17px;
        }

        /* DÒNG BẢNG */
        table td {
            padding: 18px;
            text-align: center;
            border-bottom: 1px solid #eee;
            vertical-align: middle;
        }

        table tr { transition: 0.3s; }
        table tr:hover { background: #fff7ed; }

        /* ẢNH SẢN PHẨM */
        .product-img {
            width: 70px;
            height: 70px;
            object-fit: contain;
            border-radius: 10px;
            background: white;
            border: 1px solid #eee;
            padding: 5px;
        }

        /* TÊN SẢN PHẨM */
        .product-name {
            font-size: 16px;
            font-weight: bold;
            color: #111827;
        }

        /* GIÁ */
        .price {
            color: #dc2626;
            font-size: 18px;
            font-weight: bold;
        }

        /* MÔ TẢ (cắt ngắn) */
        .description {
            color: #4b5563;
            font-size: 13px;
            max-width: 300px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* DANH MỤC */
        .category {
            background: #fff3e0;
            color: #ff6600;
            padding: 6px 12px;
            border-radius: 30px;
            font-weight: bold;
            font-size: 13px;
            display: inline-block;
        }

        /* TRẠNG THÁI */
        .status {
            padding: 6px 12px;
            border-radius: 30px;
            color: white;
            font-size: 13px;
            font-weight: bold;
            display: inline-block;
        }
        .conhang { background: #16a34a; }
        .hethang { background: #dc2626; }

        /* NÚT HÀNH ĐỘNG */
        .action {
            display: flex;
            justify-content: center;
            gap: 8px;
            flex-wrap: wrap;
        }

        .action-btn {
            padding: 8px 14px;
            border-radius: 8px;
            text-decoration: none;
            color: white;
            font-size: 13px;
            font-weight: bold;
            transition: 0.3s;
        }
        .edit-btn { background: #f59e0b; }
        .edit-btn:hover { background: #d97706; transform: translateY(-2px); }
        .delete-btn { background: #ef4444; }
        .delete-btn:hover { background: #dc2626; transform: translateY(-2px); }

        /* PHÂN TRANG */
        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 30px;
            flex-wrap: wrap;
        }
        .pagination a, .pagination span {
            display: inline-block;
            padding: 10px 16px;
            background: white;
            color: #2563eb;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
            transition: 0.3s;
            border: 1px solid #ddd;
        }
        .pagination a:hover {
            background: #2563eb;
            color: white;
        }
        .pagination .active {
            background: #2563eb;
            color: white;
            border-color: #2563eb;
        }
        .pagination .disabled {
            color: #999;
            cursor: not-allowed;
            pointer-events: none;
        }

        /* THÔNG BÁO KHÔNG CÓ DỮ LIỆU */
        .no-data {
            text-align: center;
            padding: 60px;
            color: #999;
        }

        /* ANIMATION NỀN */
        @keyframes bgMove {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        /* RESPONSIVE */
        @media (max-width: 768px) {
            .top-bar {
                flex-direction: column;
                align-items: flex-start;
            }
            .top-bar h1 { font-size: 30px; }
            .filter-bar { flex-direction: column; }
            .filter-group button { width: auto; }
        }
    </style>
</head>

<body>

<div class="content">

    <!-- TOP BAR -->
    <div class="top-bar">
        <h1>🛒 Quản lý sản phẩm</h1>
        <div class="btn-group">
            <a href="dashboard.jsp" class="btn back-btn">
                <i class="fa fa-arrow-left"></i> Dashboard
            </a>
            <a href="add-product.jsp" class="btn add-btn">
                <i class="fa fa-plus"></i> Thêm sản phẩm
            </a>
        </div>
    </div>

    <!-- ========== HIỂN THỊ THÔNG BÁO THÀNH CÔNG ========== -->
    <% if (successMsg != null && !successMsg.isEmpty()) { %>
    <div class="success-message">
        <i class="fa fa-check-circle"></i> <%= successMsg %>
    </div>
    <% } %>

    <!-- ========== FILTER BAR ========== -->
    <form method="get" action="qlspham.jsp" class="filter-bar">
        <div class="filter-group">
            <label><i class="fa fa-search"></i> Tìm kiếm</label>
            <input type="text" name="search" placeholder="Tên hoặc mô tả..." 
                   value="<%= searchKeyword != null ? searchKeyword : "" %>">
        </div>
        <div class="filter-group">
            <label><i class="fa fa-tag"></i> Danh mục</label>
            <select name="category">
                <option value="">Tất cả</option>
                <option value="router" <%= "router".equals(categoryFilter) ? "selected" : "" %>>Router</option>
                <option value="switch" <%= "switch".equals(categoryFilter) ? "selected" : "" %>>Switch</option>
                <option value="modem" <%= "modem".equals(categoryFilter) ? "selected" : "" %>>Modem</option>
                <option value="access-point" <%= "access-point".equals(categoryFilter) ? "selected" : "" %>>Access Point</option>
            </select>
        </div>
        <div class="filter-group">
            <label><i class="fa fa-check-circle"></i> Trạng thái</label>
            <select name="status">
                <option value="">Tất cả</option>
                <option value="Còn hàng" <%= "Còn hàng".equals(statusFilter) ? "selected" : "" %>>Còn hàng</option>
                <option value="Hết hàng" <%= "Hết hàng".equals(statusFilter) ? "selected" : "" %>>Hết hàng</option>
            </select>
        </div>
        <div class="filter-group">
            <label>&nbsp;</label>
            <button type="submit"><i class="fa fa-filter"></i> Lọc</button>
        </div>
        <div class="filter-group">
            <label>&nbsp;</label>
            <a href="qlspham.jsp" class="reset-btn" style="display: block; text-align: center; padding: 10px; background: #6b7280; color: white; border-radius: 8px; text-decoration: none;">
                <i class="fa fa-undo"></i> Xóa lọc
            </a>
        </div>
    </form>

    <!-- BẢNG SẢN PHẨM -->
    <div class="table-box">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Ảnh</th>
                    <th>Tên sản phẩm</th>
                    <th>Giá</th>
                    <th>Mô tả</th>
                    <th>Danh mục</th>
                    <th>Trạng thái</th>
                    <th>Số lượng</th>           <!-- THÊM: cột số lượng -->
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <%
                    boolean hasData = false;
                    if (rs != null) {
                        while (rs.next()) {
                            hasData = true;
                            String status = rs.getString("status");
                            if (status == null || status.isEmpty()) status = "Hết hàng";
                            int quantity = rs.getInt("quantity");  // THÊM: lấy số lượng
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td>
                        <img src="images/<%= rs.getString("image") != null ? rs.getString("image") : "default.jpg" %>"
                             class="product-img"
                             onerror="this.src='images/default.jpg'">
                    </td>
                    <td class="product-name"><%= rs.getString("name") %></td>
                    <td class="price"><%= String.format("%,.0f", rs.getDouble("price")) %> ₫</td>
                    <td class="description" title="<%= rs.getString("description") != null ? rs.getString("description") : "" %>">
                        <%= rs.getString("description") != null ? 
                            (rs.getString("description").length() > 50 ? 
                             rs.getString("description").substring(0, 50) + "..." : 
                             rs.getString("description")) : "N/A" %>
                    </td>
                    <td><span class="category"><%= rs.getString("category") != null ? rs.getString("category") : "Chưa phân loại" %></span></td>
                    <td>
                        <span class="status <%= "Còn hàng".equals(status) ? "conhang" : "hethang" %>">
                            <%= status %>
                        </span>
                    </td>
                    <td>
                        <% if (quantity <= 0) { %>
                            <span style="color: #dc2626; font-weight: bold;">🔴 <%= quantity %></span>
                        <% } else if (quantity <= 5) { %>
                            <span style="color: #f59e0b; font-weight: bold;">🟡 <%= quantity %></span>
                        <% } else { %>
                            <span style="color: #16a34a; font-weight: bold;">🟢 <%= quantity %></span>
                        <% } %>
                    </td>
                    <td>
                        <div class="action">
                            <a href="edit-product.jsp?id=<%= rs.getInt("id") %>" class="action-btn edit-btn">
                                <i class="fa fa-pen"></i> Sửa
                            </a>
                            <a href="delete-product?id=<%= rs.getInt("id") %>" 
                               class="action-btn delete-btn"
                               onclick="return confirm('⚠️ Bạn có chắc muốn xóa sản phẩm \"<%= rs.getString("name") %>\" này?')">
                                <i class="fa fa-trash"></i> Xóa
                            </a>
                        </div>
                    </td>
                </tr>
                <%
                        }
                    }
                    if (!hasData) {
                %>
                <tr>
                    <td colspan="9" class="no-data">
                        <i class="fa fa-box-open" style="font-size: 48px; color: #ccc;"></i>
                        <p>📭 Không tìm thấy sản phẩm nào!</p>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

    <!-- ========== PHÂN TRANG ========== -->
    <% if (totalPages > 1) { %>
    <div class="pagination">
        <a href="?page=1&search=<%= searchKeyword != null ? searchKeyword : "" %>&category=<%= categoryFilter != null ? categoryFilter : "" %>&status=<%= statusFilter != null ? statusFilter : "" %>"
           class="<%= currentPage == 1 ? "disabled" : "" %>">
            <i class="fa fa-angle-double-left"></i> Đầu
        </a>
        <a href="?page=<%= currentPage - 1 %><%= searchKeyword != null ? "&search=" + searchKeyword : "" %><%= categoryFilter != null ? "&category=" + categoryFilter : "" %><%= statusFilter != null ? "&status=" + statusFilter : "" %>"
           class="<%= currentPage == 1 ? "disabled" : "" %>">
            <i class="fa fa-chevron-left"></i> Trước
        </a>
        
        <%
            int startPage = Math.max(1, currentPage - 2);
            int endPage = Math.min(totalPages, currentPage + 2);
            for (int i = startPage; i <= endPage; i++) {
        %>
            <a href="?page=<%= i %><%= searchKeyword != null ? "&search=" + searchKeyword : "" %><%= categoryFilter != null ? "&category=" + categoryFilter : "" %><%= statusFilter != null ? "&status=" + statusFilter : "" %>"
               class="<%= currentPage == i ? "active" : "" %>">
                <%= i %>
            </a>
        <%
            }
        %>
        
        <a href="?page=<%= currentPage + 1 %><%= searchKeyword != null ? "&search=" + searchKeyword : "" %><%= categoryFilter != null ? "&category=" + categoryFilter : "" %><%= statusFilter != null ? "&status=" + statusFilter : "" %>"
           class="<%= currentPage == totalPages ? "disabled" : "" %>">
            Tiếp <i class="fa fa-chevron-right"></i>
        </a>
        <a href="?page=<%= totalPages %><%= searchKeyword != null ? "&search=" + searchKeyword : "" %><%= categoryFilter != null ? "&category=" + categoryFilter : "" %><%= statusFilter != null ? "&status=" + statusFilter : "" %>"
           class="<%= currentPage == totalPages ? "disabled" : "" %>">
            Cuối <i class="fa fa-angle-double-right"></i>
        </a>
    </div>
    <div style="text-align: center; margin-top: 15px; color: #666;">
        Hiển thị <%= offset + 1 %> - <%= Math.min(offset + pageSize, totalProducts) %> / <%= totalProducts %> sản phẩm
    </div>
    <% } %>

</div>

</body>
</html>

<%
    // Đóng tài nguyên
    try { if (rs != null) rs.close(); } catch (Exception e) {}
    try { if (st != null) st.close(); } catch (Exception e) {}
    try { if (conn != null) conn.close(); } catch (Exception e) {}
%>