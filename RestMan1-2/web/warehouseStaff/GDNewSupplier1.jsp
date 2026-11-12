<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@page import="java.net.URLEncoder, java.nio.charset.StandardCharsets"%>
<%@page import="model.WarehouseStaff1, model.Supplier1, dao.SupplierDAO1, util.Format1"%>
<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();
    WarehouseStaff1 warehouseStaff = (WarehouseStaff1) session.getAttribute("warehouseStaff");
    if (warehouseStaff == null) {
        response.sendRedirect(ctx + "/member/GDLogin1.jsp");
        return;
    }

    String supplierName = request.getParameter("txtSupplierName");
    String address = request.getParameter("txtAddress");
    String phoneNumber = request.getParameter("txtPhoneNumber");
    String email = request.getParameter("txtEmail");
    String error = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        if (supplierName == null || supplierName.trim().isEmpty()
                || address == null || address.trim().isEmpty()
                || phoneNumber == null || phoneNumber.trim().isEmpty()) {
            error = "Vui lòng nhập đầy đủ tên, địa chỉ và số điện thoại.";
        } else if (!phoneNumber.trim().matches("[0-9+ .-]{8,15}")) {
            error = "Số điện thoại không hợp lệ.";
        } else {
            Supplier1 supplier = new Supplier1();
            supplier.setSupplierName(supplierName.trim());
            supplier.setAddress(address.trim());
            supplier.setPhoneNumber(phoneNumber.trim());
            supplier.setEmail(email == null || email.trim().isEmpty() ? null : email.trim());
            SupplierDAO1 supplierDAO = new SupplierDAO1();
            if (supplierDAO.addNewSupplier(supplier)) {
                response.sendRedirect("GDSupplierSearch1.jsp?msg=added&txtSupplierName="
                        + URLEncoder.encode(supplier.getSupplierName(), StandardCharsets.UTF_8));
                return;
            }
            error = "Không lưu được nhà cung cấp. Vui lòng thử lại.";
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Thêm nhà cung cấp - RestMan</title>
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
        <h1>Thêm nhà cung cấp mới</h1>
        <% if (error != null) { %><div class="msg err"><%= error %></div><% } %>
        <form method="post" action="GDNewSupplier1.jsp">
            <div class="field">
                <label for="txtSupplierName">Tên nhà cung cấp *</label>
                <input type="text" id="txtSupplierName" name="txtSupplierName" value="<%= Format1.esc(supplierName) %>" required>
            </div>
            <div class="field">
                <label for="txtAddress">Địa chỉ *</label>
                <input type="text" id="txtAddress" name="txtAddress" value="<%= Format1.esc(address) %>" required>
            </div>
            <div class="field">
                <label for="txtPhoneNumber">Số điện thoại *</label>
                <input type="text" id="txtPhoneNumber" name="txtPhoneNumber" value="<%= Format1.esc(phoneNumber) %>" required>
            </div>
            <div class="field">
                <label for="txtEmail">Email</label>
                <input type="text" id="txtEmail" name="txtEmail" value="<%= Format1.esc(email) %>">
            </div>
            <div class="actions">
                <a class="btn secondary" href="GDSupplierSearch1.jsp">Quay lại</a>
                <button type="submit" class="btn" name="btnSave">Lưu</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
