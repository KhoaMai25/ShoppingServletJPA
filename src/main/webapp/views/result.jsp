<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Upload Result - TechZone Store</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
  <%@ include file="/common/web/topbar.jsp" %>
  <div class="container py-5">
    <div class="card shadow-sm border-0 rounded-4 mx-auto text-center p-4" style="max-width: 520px;">
      <h4 class="fw-bold text-success mb-3">${message}</h4>
      <div>
        <a href="${pageContext.request.contextPath}/multiPartServlet" class="btn btn-outline-primary me-2">Tải thêm tệp khác</a>
        <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Về trang chủ</a>
      </div>
    </div>
  </div>
</body>
</html>
