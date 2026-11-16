<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Đăng nhập - TechZone Store</title>
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
    max-width: 450px;
    width: 100%;
    margin: auto;
    background: #ffffff;
    border-radius: 24px;
    padding: 38px 36px;
    box-shadow: 0 25px 60px rgba(0, 0, 0, 0.35);
  }
  .btn-auth {
    background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
    color: #fff;
    border: none;
    border-radius: 12px;
    padding: 12px;
    font-weight: 700;
    box-shadow: 0 10px 22px -5px rgba(79, 70, 229, 0.5);
    transition: all 0.22s ease;
  }
  .btn-auth:hover {
    color: #fff;
    transform: translateY(-2px);
    box-shadow: 0 14px 28px -5px rgba(79, 70, 229, 0.65);
  }
</style>
</head>
<body>
  <%@ include file="/common/web/topbar.jsp" %>
  <div class="container py-5 my-auto">
    <div class="auth-card">
      <div class="text-center mb-4">
        <div class="d-inline-flex align-items-center justify-content-center rounded-4 mb-3" style="width: 56px; height: 56px; background: linear-gradient(135deg, #f43f5e, #fb923c); color: #fff; font-size: 1.5rem;">
          <i class="fa fa-bolt"></i>
        </div>
        <h4 class="fw-bold mb-1">Chào mừng trở lại</h4>
        <p class="text-muted small mb-0">Đăng nhập vào hệ thống mua sắm TechZone Store</p>
      </div>

      <c:if test="${alert != null}">
        <div class="alert alert-danger py-2 small rounded-3"><i class="fa fa-circle-exclamation me-1"></i> ${alert}</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/login" method="post">
        <div class="mb-3">
          <label class="form-label fw-semibold small">Tên đăng nhập</label>
          <div class="input-group">
            <span class="input-group-text bg-light"><i class="fa fa-user text-muted"></i></span>
            <input type="text" id="usernameInput" name="username" class="form-control" value="AnhPha" required>
          </div>
        </div>

        <div class="mb-3">
          <label class="form-label fw-semibold small">Mật khẩu</label>
          <div class="input-group">
            <span class="input-group-text bg-light"><i class="fa fa-lock text-muted"></i></span>
            <input type="password" id="passwordInput" name="password" class="form-control" value="123456" required>
          </div>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-4 small">
          <div class="form-check">
            <input type="checkbox" name="remember" class="form-check-input" id="rememberMe" checked>
            <label class="form-check-label text-muted" for="rememberMe">Duy trì đăng nhập</label>
          </div>
          <a href="${pageContext.request.contextPath}/register" class="text-decoration-none fw-semibold">Tạo tài khoản mới</a>
        </div>

        <button type="submit" class="btn-auth w-100">
          <i class="fa fa-right-to-bracket me-1"></i> Đăng nhập ngay
        </button>
      </form>
    </div>
  </div>
</body>
</html>
