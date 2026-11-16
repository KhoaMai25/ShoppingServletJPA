<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>File Upload Demo - TechZone Store</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
  <%@ include file="/common/web/topbar.jsp" %>
  <div class="container py-5">
    <div class="card shadow-sm border-0 rounded-4 mx-auto" style="max-width: 560px;">
      <div class="card-body p-4">
        <h4 class="fw-bold mb-3">Servlet Multipart Upload</h4>
        <form method="post" action="${pageContext.request.contextPath}/multiPartServlet" enctype="multipart/form-data">
          <div class="mb-3">
            <label class="form-label fw-semibold">Chọn tệp tin cần tải lên:</label>
            <input type="file" name="multiPartServlet" class="form-control" required/>
          </div>
          <button type="submit" class="btn btn-primary px-4 fw-bold">Upload</button>
        </form>
      </div>
    </div>
  </div>
</body>
</html>
