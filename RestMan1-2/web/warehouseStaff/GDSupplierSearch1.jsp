<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@page import="java.util.List, java.net.URLEncoder, java.nio.charset.StandardCharsets"%>
<%@page import="model.WarehouseStaff1, model.Supplier1, model.IngredientReceipt1, dao.SupplierDAO1, util.Format1, util.Pagination1"%>
<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();
    WarehouseStaff1 warehouseStaff = (WarehouseStaff1) session.getAttribute("warehouseStaff");
    if (warehouseStaff == null) {
        response.sendRedirect(ctx + "/member/GDLogin1.jsp");
        return;
    }

    // Bat dau mot lan nhap moi tu trang chu -> xoa hoa don dang lap do
    if (request.getParameter("start") != null) {
        session.removeAttribute("importReceipt");
        session.removeAttribute("listSupplier");
        session.removeAttribute("listIngredient");
        session.removeAttribute("ingredientKeyword");
        session.removeAttribute("ingredientPage");
    }

    // Nhan vien kho chon mot nha cung cap trong danh sach ket qua
    String chooseSupplier = request.getParameter("chooseSupplier");
    if (chooseSupplier != null) {
        List<Supplier1> listSupplier = (List<Supplier1>) session.getAttribute("listSupplier");
        if (listSupplier != null) {
            for (Supplier1 s : listSupplier) {
                if (String.valueOf(s.getId()).equals(chooseSupplier)) {
                    // Tao hoa don nhap moi cho nha cung cap vua chon
                    IngredientReceipt1 importReceipt = new IngredientReceipt1(s, warehouseStaff);
                    session.setAttribute("importReceipt", importReceipt);
                    response.sendRedirect("GDIngredientSearch1.jsp");
                    return;
                }
            }
        }
    }

    // Tim kiem nha cung cap theo ten; vao trang lan dau -> hien thi tat ca nha cung cap
    String txtSupplierName = request.getParameter("txtSupplierName");
    if (txtSupplierName == null) {
        txtSupplierName = "";
    }
    SupplierDAO1 supplierDAO = new SupplierDAO1();
    List<Supplier1> listSupplier = supplierDAO.searchSupplier(txtSupplierName);
    session.setAttribute("listSupplier", listSupplier);
    // Phan trang: 5 nha cung cap / trang
    int totalPages = Pagination1.totalPages(listSupplier.size());
    int currentPage = Pagination1.currentPage(request.getParameter("page"), totalPages);
    List<Supplier1> pageList = Pagination1.slice(listSupplier, currentPage);
    String keyParam = URLEncoder.encode(txtSupplierName, StandardCharsets.UTF_8);
    boolean added = "added".equals(request.getParameter("msg"));
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Tìm kiếm nhà cung cấp - RestMan</title>
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
        <h1>Tìm kiếm nhà cung cấp</h1>
        <% if (added) { %><div class="msg ok">Đã thêm nhà cung cấp mới. Hãy chọn nhà cung cấp trong danh sách.</div><% } %>
        <div class="actions between" style="margin-top:0">
            <form class="inline" method="get" action="GDSupplierSearch1.jsp">
                <label for="txtSupplierName">Tên nhà cung cấp</label>
                <input type="text" id="txtSupplierName" name="txtSupplierName" value="<%= Format1.esc(txtSupplierName) %>" autofocus>
                <button type="submit" class="btn" name="btnSearch">Tìm kiếm</button>
            </form>
            <a class="btn secondary" id="btnNew" href="GDNewSupplier1.jsp">Tạo mới</a>
        </div>

        <% if (listSupplier.isEmpty()) { %>
                <div class="msg err">Không tìm thấy nhà cung cấp. Bấm "Tạo mới" để thêm nhà cung cấp.</div>
            <% } else { %>
                <table class="data" id="tblSupplier">
                    <thead>
                    <tr><th class="center">STT</th><th>Nhà cung cấp</th><th>Số điện thoại</th><th>Địa chỉ</th><th class="center"></th></tr>
                    </thead>
                    <tbody>
                    <% int i = Pagination1.firstIndex(currentPage); for (Supplier1 s : pageList) { %>
                    <tr>
                        <td class="center"><%= i++ %></td>
                        <td><%= Format1.esc(s.getSupplierName()) %></td>
                        <td><%= Format1.esc(s.getPhoneNumber()) %></td>
                        <td><%= Format1.esc(s.getAddress()) %></td>
                        <td class="center"><a href="GDSupplierSearch1.jsp?chooseSupplier=<%= s.getId() %>">Chọn</a></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
                <%= Pagination1.links("GDSupplierSearch1.jsp?txtSupplierName=" + keyParam, currentPage, totalPages, listSupplier.size()) %>
        <% } %>

        <div class="actions">
            <a class="btn secondary" id="btnReturn" href="GDMainWarehouseStaff1.jsp">Quay lại</a>
        </div>
    </div>
</div>
</body>
</html>
