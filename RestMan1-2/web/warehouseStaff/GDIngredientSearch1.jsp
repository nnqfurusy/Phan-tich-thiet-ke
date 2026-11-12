<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@page import="java.util.List, java.net.URLEncoder, java.nio.charset.StandardCharsets"%>
<%@page import="model.WarehouseStaff1, model.Ingredient1, model.IngredientReceipt1, model.IngredientReceiptDetail1"%>
<%@page import="dao.IngredientDAO1, util.Format1, util.Pagination1"%>
<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();
    WarehouseStaff1 warehouseStaff = (WarehouseStaff1) session.getAttribute("warehouseStaff");
    if (warehouseStaff == null) {
        response.sendRedirect(ctx + "/member/GDLogin1.jsp");
        return;
    }
    IngredientReceipt1 importReceipt = (IngredientReceipt1) session.getAttribute("importReceipt");
    if (importReceipt == null || importReceipt.getSupplier() == null) {
        response.sendRedirect("GDSupplierSearch1.jsp");
        return;
    }

    // Xoa mot dong nguyen lieu da nhap khoi danh sach
    String remove = request.getParameter("remove");
    if (remove != null) {
        try {
            int index = Integer.parseInt(remove);
            if (index >= 0 && index < importReceipt.getIngredientReceiptDetail().size()) {
                importReceipt.getIngredientReceiptDetail().remove(index);
            }
        } catch (NumberFormatException e) {
            // bo qua
        }
        response.sendRedirect("GDIngredientSearch1.jsp");
        return;
    }

    // Tim kiem nguyen lieu: lay tu khoa vua nhap, hoac tu khoa/trang lan truoc khi quay lai trang nay.
    // Vao trang lan dau -> hien thi tat ca nguyen lieu.
    String txtIngredientName = request.getParameter("txtIngredientName");
    String pageParam = request.getParameter("page");
    if (txtIngredientName == null) {
        txtIngredientName = (String) session.getAttribute("ingredientKeyword");
        if (pageParam == null) {
            pageParam = (String) session.getAttribute("ingredientPage");
        }
    }
    if (txtIngredientName == null) {
        txtIngredientName = "";
    }
    IngredientDAO1 ingredientDAO = new IngredientDAO1();
    List<Ingredient1> listIngredient = ingredientDAO.searchIngredient(txtIngredientName);
    session.setAttribute("listIngredient", listIngredient);
    session.setAttribute("ingredientKeyword", txtIngredientName);

    int totalPages = Pagination1.totalPages(listIngredient.size());
    int currentPage = Pagination1.currentPage(pageParam, totalPages);
    session.setAttribute("ingredientPage", String.valueOf(currentPage));
    List<Ingredient1> pageList = Pagination1.slice(listIngredient, currentPage);
    String keyParam = URLEncoder.encode(txtIngredientName, StandardCharsets.UTF_8);
    List<IngredientReceiptDetail1> chosen = importReceipt.getIngredientReceiptDetail();
    String error = "empty".equals(request.getParameter("msg")) ? "Chưa có nguyên liệu nào trong danh sách nhập." : null;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Tìm kiếm nguyên liệu - RestMan</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style1.css">
</head>
<body>
<div class="topbar">
    <div class="brand">Rest<span>Man</span></div>
    <div class="user">Nhân viên kho: <%= Format1.esc(warehouseStaff.getFullName()) %>
        <a href="<%= ctx %>/member/GDLogin1.jsp?action=logout">Đăng xuất</a></div>
</div>
<div class="page">
    <div class="card">
        <h1>Tìm kiếm nguyên liệu</h1>
        <p class="subtitle"><b>Nhà cung cấp:</b> <%= Format1.esc(importReceipt.getSupplier().getSupplierName()) %></p>
        <% if (error != null) { %><div class="msg err"><%= error %></div><% } %>

        <div class="actions between" style="margin-top:0">
            <form class="inline" method="get" action="GDIngredientSearch1.jsp">
                <label for="txtIngredientName">Tên nguyên liệu</label>
                <input type="text" id="txtIngredientName" name="txtIngredientName" value="<%= Format1.esc(txtIngredientName) %>" autofocus>
                <button type="submit" class="btn" name="btnSearch">Tìm kiếm</button>
            </form>
            <a class="btn secondary" id="btnNew" href="GDNewIngredient1.jsp">Tạo mới</a>
        </div>

        <% if (listIngredient.isEmpty()) { %>
                <div class="msg err">Không tìm thấy nguyên liệu. Bấm "Tạo mới" để thêm nguyên liệu.</div>
            <% } else { %>
                <table class="data" id="tblIngredient">
                    <thead>
                    <tr><th class="center">STT</th><th>Nguyên liệu</th><th>Đơn vị tính</th><th class="num">Số lượng còn lại</th><th class="center"></th></tr>
                    </thead>
                    <tbody>
                    <% int i = Pagination1.firstIndex(currentPage); for (Ingredient1 ing : pageList) { %>
                    <tr>
                        <td class="center"><%= i++ %></td>
                        <td><%= Format1.esc(ing.getIngredientName()) %></td>
                        <td><%= Format1.esc(ing.getUnit()) %></td>
                        <td class="num"><%= Format1.number(ing.getQuantityInStock()) %></td>
                        <td class="center"><a href="GDIngredientAmount1.jsp?ingredientId=<%= ing.getId() %>">Chọn</a></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <%= Pagination1.links("GDIngredientSearch1.jsp?txtIngredientName=" + keyParam, currentPage, totalPages, listIngredient.size()) %>
        <% } %>

        <div class="actions">
            <a class="btn secondary" id="btnReturn" href="GDSupplierSearch1.jsp">Quay lại</a>
        </div>
    </div>

    <div class="card">
        <h2 style="margin-top:0; text-align:center">Nguyên liệu đã nhập</h2>
        <% if (chosen.isEmpty()) { %>
            <div class="empty">Chưa có nguyên liệu nào. Hãy tìm và chọn nguyên liệu ở trên.</div>
        <% } else { %>
            <table class="data" id="tblChosenIngredient">
                <thead>
                <tr><th class="center">STT</th><th>Nguyên liệu</th><th class="num">Đơn giá</th><th class="num">Số lượng nhập</th><th class="num">Tổng tiền</th><th class="center no-print"></th></tr>
                </thead>
                <tbody>
                <% for (int k = 0; k < chosen.size(); k++) { IngredientReceiptDetail1 d = chosen.get(k); %>
                <tr>
                    <td class="center"><%= k + 1 %></td>
                    <td><%= Format1.esc(d.getIngredient().getIngredientName()) %></td>
                    <td class="num"><%= Format1.money(d.getPurchasePrice()) %></td>
                    <td class="num"><%= Format1.number(d.getQuantity()) + " " + Format1.esc(d.getIngredient().getUnit()) %></td>
                    <td class="num"><%= Format1.money(d.getLineTotal()) %></td>
                    <td class="center"><a href="GDIngredientSearch1.jsp?remove=<%= k %>">Xoá</a></td>
                </tr>
                <% } %>
                </tbody>
                <tfoot>
                <tr><td colspan="4" class="center">Tổng hoá đơn</td><td class="num"><%= Format1.money(importReceipt.getTotalValue()) %></td><td></td></tr>
                </tfoot>
            </table>
        <% } %>
        <div class="actions">
            <% if (chosen.isEmpty()) { %>
                <button class="btn" id="btnConfirm" disabled>Xác nhận</button>
            <% } else { %>
                <a class="btn" id="btnConfirm" href="GDIngredientReceipt1.jsp">Xác nhận</a>
            <% } %>
        </div>
    </div>
</div>
</body>
</html>
