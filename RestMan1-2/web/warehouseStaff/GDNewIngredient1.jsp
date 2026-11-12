<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@page import="java.net.URLEncoder, java.nio.charset.StandardCharsets"%>
<%@page import="model.WarehouseStaff1, model.Ingredient1, model.IngredientReceipt1, dao.IngredientDAO1, util.Format1"%>
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

    String ingredientName = request.getParameter("txtIngredientName");
    String unit = request.getParameter("txtUnit");
    String description = request.getParameter("txtDescription");
    String error = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        if (ingredientName == null || ingredientName.trim().isEmpty() || unit == null || unit.trim().isEmpty()) {
            error = "Vui lòng nhập tên nguyên liệu và đơn vị tính.";
        } else {
            Ingredient1 ingredient = new Ingredient1();
            ingredient.setIngredientName(ingredientName.trim());
            ingredient.setUnit(unit.trim());
            ingredient.setPrice(0);
            ingredient.setDescription(description == null || description.trim().isEmpty() ? null : description.trim());
            IngredientDAO1 ingredientDAO = new IngredientDAO1();
            if (ingredientDAO.addNewIngredient(ingredient)) {
                response.sendRedirect("GDIngredientSearch1.jsp?txtIngredientName="
                        + URLEncoder.encode(ingredient.getIngredientName(), StandardCharsets.UTF_8));
                return;
            }
            error = "Không lưu được nguyên liệu. Vui lòng thử lại.";
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Thêm nguyên liệu - RestMan</title>
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
        <h1>Thêm nguyên liệu mới</h1>
        <% if (error != null) { %><div class="msg err"><%= error %></div><% } %>
        <form method="post" action="GDNewIngredient1.jsp">
            <div class="field">
                <label for="txtIngredientName">Tên nguyên liệu *</label>
                <input type="text" id="txtIngredientName" name="txtIngredientName" value="<%= Format1.esc(ingredientName) %>" required>
            </div>
            <div class="field">
                <label for="txtUnit">Đơn vị tính *</label>
                <input type="text" id="txtUnit" name="txtUnit" value="<%= Format1.esc(unit) %>" placeholder="kg, bó, chai, gói..." required>
            </div>
            <div class="field">
                <label for="txtDescription">Mô tả</label>
                <textarea id="txtDescription" name="txtDescription" rows="3"><%= Format1.esc(description) %></textarea>
            </div>
            <div class="actions">
                <a class="btn secondary" href="GDIngredientSearch1.jsp">Quay lại</a>
                <button type="submit" class="btn" name="btnSave">Lưu</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
