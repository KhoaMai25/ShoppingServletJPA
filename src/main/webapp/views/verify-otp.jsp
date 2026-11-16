<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Xác nhận Email & Kích hoạt OTP - TechZone Store</title>
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
  .otp-card {
    max-width: 470px;
    width: 100%;
    margin: auto;
    background: #ffffff;
    border-radius: 24px;
    padding: 38px 36px;
    box-shadow: 0 25px 60px rgba(0, 0, 0, 0.35);
  }
  .otp-input {
    letter-spacing: 8px;
    font-size: 1.5rem;
    font-weight: 800;
    text-align: center;
    border-radius: 14px;
    padding: 12px;
  }
  .btn-send-otp {
    background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
    color: #fff;
    border: none;
    border-radius: 12px;
    padding: 11px 18px;
    font-weight: 700;
    transition: all 0.22s ease;
  }
  .btn-send-otp:hover {
    color: #fff;
    transform: translateY(-1px);
  }
  .btn-verify {
    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
    color: #fff;
    border: none;
    border-radius: 12px;
    padding: 12px;
    font-weight: 700;
    box-shadow: 0 10px 22px -5px rgba(16, 185, 129, 0.45);
    transition: all 0.22s ease;
  }
  .btn-verify:hover {
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

  <!-- Thông báo Toast hiện vài giây rồi tự động mất đi -->
  <c:if test="${not empty sessionScope.otpSentToast}">
    <div id="otpToast" class="tz-floating-toast">
      <i class="fa fa-circle-check text-success fs-5"></i>
      <div>
        <div class="fw-bold small">Đã gửi mã xác nhận OTP</div>
        <div class="text-white-50" style="font-size: 0.8rem;">${sessionScope.otpSentToast}</div>
      </div>
    </div>
    <c:remove var="otpSentToast" scope="session" />
  </c:if>

  <div class="container py-5 my-auto">
    <div class="otp-card">
      <div class="text-center mb-4">
        <div class="d-inline-flex align-items-center justify-content-center rounded-4 mb-3" style="width: 56px; height: 56px; background: linear-gradient(135deg, #10b981, #34d399); color: #fff; font-size: 1.5rem;">
          <i class="fa fa-envelope-circle-check"></i>
        </div>
        <h4 class="fw-bold mb-1">Xác nhận Email & Kích hoạt OTP</h4>
        <p class="text-muted small mb-0">
          Xác nhận địa chỉ email của tài khoản <strong>${not empty sessionScope.pendingUsername ? sessionScope.pendingUsername : ''}</strong> để tạo và nhận mã OTP
        </p>
      </div>

      <c:if test="${not empty alert}">
        <div class="alert alert-danger py-2 small rounded-3"><i class="fa fa-circle-exclamation me-1"></i> ${alert}</div>
      </c:if>

      <!-- Bước 1: Xác nhận Email và bấm Tạo & Gửi mã OTP -->
      <form action="${pageContext.request.contextPath}/verify-otp" method="post" class="mb-4 pb-3 border-bottom">
        <input type="hidden" name="action" value="sendOtp">
        <input type="hidden" name="username" value="${sessionScope.pendingUsername}">
        <label class="form-label fw-semibold small">Bước 1: Xác nhận Email nhận mã OTP</label>
        <div class="input-group">
          <span class="input-group-text bg-light"><i class="fa fa-envelope text-muted"></i></span>
          <input type="email" name="email" class="form-control" value="${not empty sessionScope.pendingEmail ? sessionScope.pendingEmail : ''}" placeholder="Nhập email của bạn" required>
          <button type="submit" class="btn-send-otp">
            <i class="fa fa-paper-plane me-1"></i> Tạo & Gửi OTP
          </button>
        </div>
      </form>

      <!-- Bước 2: Nhập mã OTP 6 chữ số để kích hoạt -->
      <form action="${pageContext.request.contextPath}/verify-otp" method="post">
        <input type="hidden" name="username" value="${sessionScope.pendingUsername}">
        <div class="mb-4">
          <label class="form-label fw-semibold small d-block text-center">Bước 2: Nhập mã OTP 6 chữ số</label>
          <input type="text" id="otpField" name="otp" maxlength="6" class="form-control otp-input" placeholder="••••••" required>
        </div>
        <button type="submit" class="btn-verify w-100">
          <i class="fa fa-check-double me-1"></i> Kích hoạt tài khoản ngay
        </button>
      </form>
    </div>
  </div>

  <script>
    const toastEl = document.getElementById('otpToast');
    if (toastEl) {
      setTimeout(() => {
        toastEl.classList.add('hide-toast');
      }, 3500);
    }
  </script>
</body>
</html>
