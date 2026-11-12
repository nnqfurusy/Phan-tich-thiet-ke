<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@page import="java.time.LocalDateTime, java.util.List"%>
<%@page import="model.WarehouseStaff1, model.IngredientReceipt1, model.IngredientReceiptDetail1"%>
<%@page import="dao.IngredientReceiptDAO1, dao.IngredientDAO1, util.Format1"%>
<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();
    WarehouseStaff1 warehouseStaff = (WarehouseStaff1) session.getAttribute("warehouseStaff");
    if (warehouseStaff == null) {
        response.sendRedirect(ctx + "/member/GDLogin1.jsp");
        return;
    }

    boolean saved = request.getParameter("saved") != null;
    String error = null;
    IngredientReceipt1 receipt;

    if (saved) {
        // Hien thi hoa don vua luu thanh cong
        receipt = (IngredientReceipt1) session.getAttribute("lastReceipt");
        if (receipt == null) {
            response.sendRedirect("GDMainWarehouseStaff1.jsp");
            return;
        }
    } else {
        receipt = (IngredientReceipt1) session.getAttribute("importReceipt");
        if (receipt == null || receipt.getSupplier() == null) {
            response.sendRedirect("GDSupplierSearch1.jsp");
            return;
        }
        if (receipt.getIngredientReceiptDetail().isEmpty()) {
            response.sendRedirect("GDIngredientSearch1.jsp?msg=empty");
            return;
        }

        // Nhan vien kho bam "In hoa don": luu hoa don, cap nhat ton kho
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            IngredientReceiptDAO1 ingredientReceiptDAO = new IngredientReceiptDAO1();
            if (ingredientReceiptDAO.saveImportReceipt(receipt)) {
                IngredientDAO1 ingredientDAO = new IngredientDAO1();
                for (IngredientReceiptDetail1 d : receipt.getIngredientReceiptDetail()) {
                    ingredientDAO.updateAmountInStock(d.getIngredient(), d.getQuantity(), d.getPurchasePrice());
                }
                session.setAttribute("lastReceipt", receipt);
                session.removeAttribute("importReceipt");
                session.removeAttribute("listSupplier");
                session.removeAttribute("listIngredient");
                session.removeAttribute("ingredientKeyword");
                session.removeAttribute("ingredientPage");
                response.sendRedirect("GDIngredientReceipt1.jsp?saved=1");
                return;
            }
            error = "Lưu hoá đơn thất bại. Vui lòng thử lại.";
        }
    }
    LocalDateTime receivedAt = receipt.getReceivedAt() != null ? receipt.getReceivedAt() : LocalDateTime.now();
    List<IngredientReceiptDetail1> details = receipt.getIngredientReceiptDetail();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hoá đơn nhập nguyên liệu - RestMan</title>
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
        <h1>Hoá đơn nhập nguyên liệu</h1>
        <% if (saved) { %>
            <div class="msg ok no-print">Lưu hoá đơn thành công. Đã cập nhật số lượng tồn kho.</div>
        <% } %>
        <% if (error != null) { %><div class="msg err"><%= error %></div><% } %>

        <table class="info">
            <% if (saved) { %><tr><th>Mã hoá đơn</th><td>HDN<%= String.format("%05d", receipt.getId()) %></td></tr><% } %>
            <tr><th>Nhà cung cấp</th><td><%= Format1.esc(receipt.getSupplier().getSupplierName()) %></td></tr>
            <tr><th>Ngày nhập</th><td><%= Format1.dateTime(receivedAt) %></td></tr>
            <tr><th>Nhân viên kho</th><td><%= Format1.esc(receipt.getWarehouseStaff().getFullName()) %></td></tr>
            <tr><th>Tổng tiền</th><td><b><%= Format1.money(receipt.getTotalValue()) %></b></td></tr>
            <tr><th>Trạng thái</th><td><%= saved ? "Đã thanh toán" : "Chưa lưu" %></td></tr>
        </table>

        <table class="data" id="tblImportIngredient">
            <thead>
            <tr><th class="center">STT</th><th>Nguyên liệu</th><th class="num">Đơn giá</th><th class="num">Số lượng nhập</th><th class="num">Tổng tiền</th></tr>
            </thead>
            <tbody>
            <% int i = 1; for (IngredientReceiptDetail1 d : details) { %>
            <tr>
                <td class="center"><%= i++ %></td>
                <td><%= Format1.esc(d.getIngredient().getIngredientName()) %></td>
                <td class="num"><%= Format1.money(d.getPurchasePrice()) %></td>
                <td class="num"><%= Format1.number(d.getQuantity()) + " " + Format1.esc(d.getIngredient().getUnit()) %></td>
                <td class="num"><%= Format1.money(d.getLineTotal()) %></td>
            </tr>
            <% } %>
            </tbody>
            <tfoot>
            <tr><td colspan="4" class="center">Tổng hoá đơn</td><td class="num"><%= Format1.money(receipt.getTotalValue()) %></td></tr>
            </tfoot>
        </table>

        <% if (saved) { %>
            <div class="actions">
                <a class="btn secondary" href="GDMainWarehouseStaff1.jsp">Về trang chủ</a>
                <button type="button" class="btn" onclick="window.print()">In lại hoá đơn</button>
            </div>
            <script>window.addEventListener('load', function () { window.print(); });</script>
        <% } else { %>
            <form method="post" action="GDIngredientReceipt1.jsp" class="actions">
                <a class="btn secondary" id="btnReturn" href="GDIngredientSearch1.jsp">Quay lại</a>
                <button type="submit" class="btn" id="btnPrintReceipt" name="btnPrintReceipt">In hoá đơn</button>
            </form>
        <% } %>
    </div>
</div>
</body>
</html>
