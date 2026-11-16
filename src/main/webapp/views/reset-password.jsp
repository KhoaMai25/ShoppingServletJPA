<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Đặt lại mật khẩu bằng OTP - TechZone Store</title>
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
    max-width: 480px;
    width: 100%;
    margin: auto;
    background: #ffffff;
    border-radius: 24px;
    padding: 36px;
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
  }
  .tz-floating-toast {
    position: fixed;
    top: 84px;
    right: 24px;
    z-index: 1090;
    background: #0f172a;
    color: #ffffff;
    padding: 14px 20px;
    border-radius: 14px;
    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.35);
    display: flex;
    align-items: center;
    gap: 12px;
    border-left: 4px solid #10b981;
    transition: opacity 0.45s ease, transform 0.45s ease;
  }
  .tz-floating-toast.hide-toast {
    opacity: 0;
    transform: translateX(120%);
    pointer-events: none;
  }
</style>
</head>
<body>
  <%@ include file="/common/web/topbar.jsp" %>

  <!-- Thông báo Toast tự động biến mất sau vài giây -->
  <c:if test="${not empty sessionScope.otpSentToast}">
    <div id="resetToast" class="tz-floating-toast">
      <i class="fa fa-circle-check text-success fs-5"></i>
      <div>
        <div class="fw-bold small">Đã gửi mã xác nhận OTP</div>
        <div class="text-white-50" style="font-size: 0.8rem;">${sessionScope.otpSentToast}</div>
      </div>
    </div>
    <c:remove var="otpSentToast" scope="session" />
  </c:if>

  <div class="container py-4 my-auto">
    <div class="auth-card">
      <div class="text-center mb-4">
        <h4 class="fw-bold mb-1">Xác nhận OTP & Đặt mật khẩu mới</h4>
        <p class="text-muted small mb-0">
          Vui lòng kiểm tra hộp thư <strong>${not empty sessionScope.resetEmail ? sessionScope.resetEmail : 'email của bạn'}</strong> để lấy mã OTP
        </p>
      </div>

      <c:if test="${not empty alert}">
        <div class="alert alert-danger py-2 small rounded-3"><i class="fa fa-circle-exclamation me-1"></i> ${alert}</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/reset-password" method="post">
        <div class="mb-3">
          <label class="form-label fw-semibold small">Mã xác nhận OTP 6 chữ số</label>
          <input type="text" id="resetOtpInput" name="otp" maxlength="6" class="form-control text-center fw-bold fs-5" placeholder="Nhập 6 số OTP từ Email" required autofocus>
        </div>

        <div class="mb-3">
          <label class="form-label fw-semibold small">Mật khẩu mới</label>
          <input type="password" name="newPassword" class="form-control" placeholder="Nhập mật khẩu mới" required>
        </div>

        <div class="mb-4">
          <label class="form-label fw-semibold small">Xác nhận mật khẩu mới</label>
          <input type="password" name="confirmPassword" class="form-control" placeholder="Nhập lại mật khẩu mới" required>
        </div>

        <button type="submit" class="btn-auth w-100">
          <i class="fa fa-shield-halved me-1"></i> Cập nhật mật khẩu mới
        </button>
      </form>
    </div>
  </div>

  <script>
    const resetToast = document.getElementById('resetToast');
    if (resetToast) {
      setTimeout(() => {
        resetToast.classList.add('hide-toast');
      }, 3500);
    }
  </script>
</body>
</html>

