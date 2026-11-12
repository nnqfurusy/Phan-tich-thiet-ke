<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@page import="model.Member1, model.Customer1, model.WarehouseStaff1, dao.MemberDAO1, util.Format1"%>
<%
    request.setCharacterEncoding("UTF-8");
    String ctx = request.getContextPath();
    String error = null;

    // Dang xuat
    if ("logout".equals(request.getParameter("action"))) {
        session.invalidate();
        response.sendRedirect(ctx + "/member/GDLogin1.jsp");
        return;
    }

    String username = request.getParameter("txtUsername");
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String password = request.getParameter("txtPassword");
        if (username == null || username.trim().isEmpty() || password == null || password.isEmpty()) {
            error = "Vui lòng nhập tên đăng nhập và mật khẩu.";
        } else {
            Member1 member = new Member1();
            member.setUsername(username.trim());
            member.setPassword(password);
            MemberDAO1 memberDAO = new MemberDAO1();
            if (memberDAO.checkLogin(member)) {
                session.setAttribute("member", member);
                if ("customer".equals(member.getRole())) {
                    Customer1 customer = memberDAO.getCustomer(member);
                    session.setAttribute("customer", customer);
                    response.sendRedirect(ctx + "/customer/GDMainCustomer1.jsp");
                    return;
                } else if ("warehouseStaff".equals(member.getRole())) {
                    WarehouseStaff1 warehouseStaff = memberDAO.getWarehouseStaff(member);
                    session.setAttribute("warehouseStaff", warehouseStaff);
                    response.sendRedirect(ctx + "/warehouseStaff/GDMainWarehouseStaff1.jsp");
                    return;
                } else {
                    session.invalidate();
                    error = "Chức năng của vai trò này chưa được xây dựng trong phiên bản hiện tại.";
                }
            } else {
                error = "Sai tên đăng nhập hoặc mật khẩu.";
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng nhập - RestMan</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style1.css">
</head>
<body>
<div class="topbar"><div class="brand">Rest<span>Man</span></div></div>
<div class="page">
    <div class="card narrow">
        <h1>Đăng nhập</h1>
        <p class="subtitle">Hệ thống quản lý nhà hàng</p>
        <% if (error != null) { %><div class="msg err"><%= error %></div><% } %>
        <form method="post" action="<%= ctx %>/member/GDLogin1.jsp">
            <div class="field">
                <label for="txtUsername">Tên đăng nhập</label>
                <input type="text" id="txtUsername" name="txtUsername" value="<%= Format1.esc(username) %>" autofocus>
            </div>
            <div class="field">
                <label for="txtPassword">Mật khẩu</label>
                <input type="password" id="txtPassword" name="txtPassword">
            </div>
            <div class="actions center">
                <button type="submit" class="btn big" name="btnLogin">Đăng nhập</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
