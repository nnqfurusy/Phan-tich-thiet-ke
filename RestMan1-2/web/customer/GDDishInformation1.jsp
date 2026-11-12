<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@page import="java.net.URLEncoder, java.nio.charset.StandardCharsets"%>
<%@page import="model.Customer1, model.Dish1, dao.DishDAO1, util.Format1"%>
<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();
    Customer1 cus = (Customer1) session.getAttribute("customer");
    if (cus == null) {
        response.sendRedirect(ctx + "/member/GDLogin1.jsp");
        return;
    }

    Dish1 dish = null;
    try {
        int id = Integer.parseInt(request.getParameter("id"));
        DishDAO1 dishDAO = new DishDAO1();
        dish = dishDAO.getDish(id);
    } catch (NumberFormatException e) {
        dish = null;
    }
    String txtDishName = request.getParameter("txtDishName");
    String pageParam = request.getParameter("page");
    String backUrl = "GDSearchDish1.jsp?txtDishName="
            + URLEncoder.encode(txtDishName == null ? "" : txtDishName, StandardCharsets.UTF_8)
            + (pageParam == null ? "" : "&page=" + URLEncoder.encode(pageParam, StandardCharsets.UTF_8));
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Thông tin chi tiết món ăn - RestMan</title>
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
        <h1 id="lblTitle">Thông tin chi tiết món ăn</h1>
        <% if (dish == null) { %>
            <div class="msg err">Món ăn chưa có thông tin.</div>
        <% } else { %>
            <table class="info" id="tblDishInfo">
                <tr><th>ID</th><td><%= dish.getId() %></td></tr>
                <tr><th>Tên món ăn</th><td><%= Format1.esc(dish.getFoodName()) %></td></tr>
                <tr><th>Loại</th><td><%= Format1.esc(dish.getFoodCategory()) %></td></tr>
                <tr><th>Khẩu phần</th><td><%= Format1.esc(dish.getUnit()) %></td></tr>
                <tr><th>Đơn giá</th><td><%= Format1.money(dish.getPrice()) %></td></tr>
                <tr><th>Mô tả</th><td><%= dish.getDescription() == null || dish.getDescription().isEmpty()
                        ? "<i>Chưa có mô tả</i>" : Format1.esc(dish.getDescription()) %></td></tr>
            </table>
        <% } %>
        <div class="actions">
            <a class="btn secondary" id="btnReturn" href="<%= backUrl %>">Quay lại</a>
        </div>
    </div>
</div>
</body>
</html>
