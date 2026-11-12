<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@page import="java.util.List"%>
<%@page import="model.WarehouseStaff1, model.Ingredient1, model.IngredientReceipt1, model.IngredientReceiptDetail1, util.Format1"%>
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

    // Lay nguyen lieu da chon tu danh sach ket qua tim kiem
    String ingredientId = request.getParameter("ingredientId");
    Ingredient1 ingredient = null;
    List<Ingredient1> listIngredient = (List<Ingredient1>) session.getAttribute("listIngredient");
    if (listIngredient != null && ingredientId != null) {
        for (Ingredient1 ing : listIngredient) {
            if (String.valueOf(ing.getId()).equals(ingredientId)) {
                ingredient = ing;
                break;
            }
        }
    }
    if (ingredient == null) {
        response.sendRedirect("GDIngredientSearch1.jsp");
        return;
    }

    String txtPrice = request.getParameter("txtPrice");
    String txtAmount = request.getParameter("txtAmount");
    String error = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        double amount = Format1.parsePositive(txtAmount);
        double price = Format1.parsePositive(txtPrice);
        if (amount <= 0) {
            error = "Số lượng nguyên liệu không hợp lệ.";
        } else if (price <= 0) {
            error = "Đơn giá không hợp lệ.";
        } else {
            IngredientReceiptDetail1 detail = new IngredientReceiptDetail1(ingredient, amount, price);
            importReceipt.addDetail(detail);
            response.sendRedirect("GDIngredientSearch1.jsp");
            return;
        }
    }
    if (txtPrice == null && ingredient.getPrice() > 0) {
        txtPrice = String.valueOf((long) ingredient.getPrice());
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Nhập số lượng nguyên liệu - RestMan</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style1.css">
</head>
<body>
<div class="topbar">
    <div class="brand">Rest<span>Man</span></div>
    <div class="user">Nhân viên kho: <%= Format1.esc(warehouseStaff.getFullName()) %>
        <a href="<%= ctx %>/member/GDLogin1.jsp?action=logout">Đăng xuất</a></div>
</div>
<div class="page">
    <div class="card narrow">
        <h1>Nhập số lượng nguyên liệu</h1>
        <% if (error != null) { %><div class="msg err"><%= error %></div><% } %>
        <form method="post" action="GDIngredientAmount1.jsp?ingredientId=<%= ingredient.getId() %>">
            <table class="info" id="tblIngredient">
                <tr><th>Nguyên liệu</th><td><%= Format1.esc(ingredient.getIngredientName()) %></td></tr>
                <tr><th>Đơn vị tính</th><td><%= Format1.esc(ingredient.getUnit()) %></td></tr>
                <tr><th>Số lượng còn lại</th><td><%= Format1.number(ingredient.getQuantityInStock()) %></td></tr>
                <tr><th><label for="txtPrice">Đơn giá (đ)</label></th>
                    <td><input type="number" id="txtPrice" name="txtPrice" min="1" step="any" value="<%= Format1.esc(txtPrice) %>" required></td></tr>
                <tr><th><label for="txtAmount">Số lượng cần nhập</label></th>
                    <td><input type="number" id="txtAmount" name="txtAmount" min="0.001" step="any" value="<%= Format1.esc(txtAmount) %>" required autofocus></td></tr>
            </table>
            <div class="actions">
                <a class="btn secondary" id="btnReturn" href="GDIngredientSearch1.jsp">Quay lại</a>
                <button type="submit" class="btn" id="btnConfirm" name="btnConfirm">Xác nhận</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
