<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@page import="model.WarehouseStaff1, util.Format1"%>
<%
    String ctx = request.getContextPath();
    WarehouseStaff1 warehouseStaff = (WarehouseStaff1) session.getAttribute("warehouseStaff");
    if (warehouseStaff == null) {
        response.sendRedirect(ctx + "/member/GDLogin1.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Trang chủ nhân viên kho - RestMan</title>
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
        <h1>Trang chủ Nhân viên kho</h1>
        <div class="menu">
            <a class="btn big" id="btnIngredientImport" href="GDSupplierSearch1.jsp?start=1">Nhập nguyên liệu</a>
            <a class="btn secondary" href="<%= ctx %>/member/GDLogin1.jsp?action=logout">Đăng xuất</a>
        </div>
    </div>
</div>
</body>
</html>
