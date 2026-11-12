<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@page import="java.util.List, java.net.URLEncoder, java.nio.charset.StandardCharsets"%>
<%@page import="model.Customer1, model.Dish1, dao.DishDAO1, util.Format1, util.Pagination1"%>
<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();
    Customer1 cus = (Customer1) session.getAttribute("customer");
    if (cus == null) {
        response.sendRedirect(ctx + "/member/GDLogin1.jsp");
        return;
    }

    // Vao trang lan dau (chua nhap tu khoa) -> hien thi tat ca mon an
    String txtDishName = request.getParameter("txtDishName");
    if (txtDishName == null) {
        txtDishName = "";
    }
    DishDAO1 dishDAO = new DishDAO1();
    List<Dish1> dishList = dishDAO.searchDish(txtDishName);
    // Phan trang: 5 mon an / trang
    int totalPages = Pagination1.totalPages(dishList.size());
    int currentPage = Pagination1.currentPage(request.getParameter("page"), totalPages);
    List<Dish1> pageList = Pagination1.slice(dishList, currentPage);
    String keyParam = URLEncoder.encode(txtDishName, StandardCharsets.UTF_8);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Tìm kiếm món ăn - RestMan</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style1.css">
</head>
<body>
<div class="topbar">
    <div class="brand">Rest<span>Man</span></div>
    <div class="user">Khách hàng: <%= Format1.esc(cus.getFullName()) %>
        <a href="<%= ctx %>/member/GDLogin1.jsp?action=logout">Đăng xuất</a></div>
</div>
<div class="page">
    <div class="card">
        <h1 id="lblTitle">Tìm kiếm món ăn</h1>
        <form class="inline" method="get" action="GDSearchDish1.jsp">
            <label for="txtDishName">Tên món ăn:</label>
            <input type="text" id="txtDishName" name="txtDishName" value="<%= Format1.esc(txtDishName) %>" autofocus>
            <button type="submit" class="btn" name="btnSearch">Tìm kiếm</button>
        </form>

        <% if (dishList.isEmpty()) { %>
                <div class="msg err"><%= txtDishName.trim().isEmpty() ? "Chưa có món ăn nào." : "Không tìm thấy món ăn được nhập." %></div>
            <% } else { %>
                <table class="data" id="tblDishList">
                    <thead>
                    <tr><th class="center">ID</th><th>Tên món ăn</th><th class="num">Đơn giá</th><th class="center">Xem chi tiết</th></tr>
                    </thead>
                    <tbody>
                    <% for (Dish1 dish : pageList) { %>
                    <tr>
                        <td class="center"><%= dish.getId() %></td>
                        <td><%= Format1.esc(dish.getFoodName()) %></td>
                        <td class="num"><%= Format1.money(dish.getPrice()) %></td>
                        <td class="center"><a href="GDDishInformation1.jsp?id=<%= dish.getId() %>&txtDishName=<%= keyParam %>&page=<%= currentPage %>">Xem chi tiết</a></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <%= Pagination1.links("GDSearchDish1.jsp?txtDishName=" + keyParam, currentPage, totalPages, dishList.size()) %>
        <% } %>

        <div class="actions">
            <a class="btn secondary" id="btnReturn" href="GDMainCustomer1.jsp">Quay lại</a>
        </div>
    </div>
</div>
</body>
</html>
