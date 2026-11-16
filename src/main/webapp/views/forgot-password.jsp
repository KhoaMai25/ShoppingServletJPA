<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Quên mật khẩu - TechZone Store</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<style>
  @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap');
  body {
    font-family: 'Plus Jakarta Sans', sans-serif;
    background: linear-gradient(135deg, #1e1b4b 0%, #312e81 45%, #4f46e5 100%);
    min-height: 100vh;
    display: flex;
    flex-direction: column;
  }
  .auth-card {
    max-width: 460px;
    width: 100%;
    margin: auto;
    background: #ffffff;
    border-radius: 24px;
    padding: 38px 36px;
    box-shadow: 0 25px 60px rgba(0, 0, 0, 0.35);
  }
  .btn-auth {
    background: linear-gradient(135deg, #f43f5e 0%, #f97316 100%);
    color: #fff;
    border: none;
    border-radius: 12px;
    padding: 12px;
    font-weight: 700;
    box-shadow: 0 10px 22px -5px rgba(244, 63, 94, 0.45);
    transition: all 0.22s ease;
  }
  .btn-auth:hover {
    color: #fff;
    transform: translateY(-2px);
  }
</style>
</head>
<body>
  <%@ include file="/common/web/topbar.jsp" %>
  <div class="container py-5 my-auto">
    <div class="auth-card">
      <div class="text-center mb-4">
        <div class="d-inline-flex align-items-center justify-content-center rounded-4 mb-3" style="width: 56px; height: 56px; background: linear-gradient(135deg, #f43f5e, #fb923c); color: #fff; font-size: 1.5rem;">
          <i class="fa fa-unlock-keyhole"></i>
        </div>
        <h4 class="fw-bold mb-1">Khôi phục mật khẩu</h4>
        <p class="text-muted small mb-0">Nhập địa chỉ Email đã đăng ký để nhận mã xác nhận OTP</p>
      </div>

      <c:if test="${not empty alert}">
        <div class="alert alert-danger py-2 small rounded-3"><i class="fa fa-circle-exclamation me-1"></i> ${alert}</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/forgot-password" method="post">
        <div class="mb-4">
          <label class="form-label fw-semibold small">Email hoặc Tên đăng nhập</label>
          <div class="input-group">
            <span class="input-group-text bg-light"><i class="fa fa-envelope text-muted"></i></span>
            <input type="text" name="email" class="form-control" value="24110027@student.hcmute.edu.vn" placeholder="24110027@student.hcmute.edu.vn" required>
          </div>
        </div>

        <button type="submit" class="btn-auth w-100 mb-3">
          <i class="fa fa-paper-plane me-1"></i> Gửi mã xác nhận OTP qua Email
        </button>

        <div class="text-center small">
          <a href="${pageContext.request.contextPath}/login" class="text-decoration-none fw-semibold text-muted">
            <i class="fa fa-arrow-left me-1"></i> Quay lại trang Đăng nhập
          </a>
        </div>
      </form>
    </div>
  </div>
</body>
</html>
