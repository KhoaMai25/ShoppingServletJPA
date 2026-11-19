<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><sitemesh:write property="title">Quản trị hệ thống - TechZone Store</sitemesh:write></title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
  <sitemesh:write property="head"/>
</head>
<body class="d-flex flex-column min-vh-100">
  <%@ include file="/common/admin/header.jsp" %>
  <main class="flex-grow-1 d-flex flex-column">
    <sitemesh:write property="body"/>
  </main>
  <%@ include file="/common/admin/footer.jsp" %>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
