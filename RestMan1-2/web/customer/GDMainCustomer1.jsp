<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@page import="model.Customer1, util.Format1"%>
<%
    String ctx = request.getContextPath();
    Customer1 cus = (Customer1) session.getAttribute("customer");
    if (cus == null) {
        response.sendRedirect(ctx + "/member/GDLogin1.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Trang chủ khách hàng - RestMan</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style1.css">
</head>
<body>
<div class="topbar">
    <div class="brand">Rest<span>Man</span></div>
    <div class="user">Khách hàng: <%= Format1.esc(cus.getFullName()) %>
        <a href="<%= ctx %>/member/GDLogin1.jsp?action=logout">Đăng xuất</a></div>
</div>
<div class="page">
    <div class="card narrow">
        <h1>Trang chủ</h1>
        <div class="menu">
            <a class="btn big" id="btnSearchDish" href="GDSearchDish1.jsp">Tìm kiếm món ăn</a>
        </div>
    </div>
</div>
</body>
</html>
