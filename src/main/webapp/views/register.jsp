<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Đăng ký thành viên - TechZone Store</title>
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
    max-width: 540px;
    width: 100%;
    margin: auto;
    background: #ffffff;
    border-radius: 24px;
    padding: 36px;
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
  <div class="container py-4 my-auto">
    <div class="auth-card">
      <div class="text-center mb-4">
        <h4 class="fw-bold mb-1">Đăng ký tài khoản thành viên</h4>
        <p class="text-muted small mb-0">Nhận ngay ưu đãi đặc quyền dành cho khách hàng mới tại TechZone Store</p>
      </div>

      <c:if test="${alert != null}">
        <div class="alert alert-danger py-2 small rounded-3"><i class="fa fa-circle-exclamation me-1"></i> ${alert}</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/register" method="post" class="needs-validation" novalidate>
        <div class="row g-3">
          <div class="col-md-6">
            <label class="form-label fw-semibold small">Tên đăng nhập</label>
            <input type="text" name="username" class="form-control ${not empty errors.username ? 'is-invalid' : ''}"
                   value="${oldUsername}" placeholder="AnhPha" minlength="3" maxlength="50" required>
            <div class="invalid-feedback">
              ${not empty errors.username ? errors.username : 'Tên đăng nhập phải từ 3 đến 50 ký tự.'}
            </div>
          </div>
          <div class="col-md-6">
            <label class="form-label fw-semibold small">Mật khẩu</label>
            <input type="password" name="password" class="form-control ${not empty errors.password ? 'is-invalid' : ''}"
                   placeholder="Tối thiểu 6 ký tự" minlength="6" required>
            <div class="invalid-feedback">
              ${not empty errors.password ? errors.password : 'Mật khẩu phải có tối thiểu 6 ký tự.'}
            </div>
          </div>
          <div class="col-12">
            <label class="form-label fw-semibold small">Họ và tên</label>
            <input type="text" name="fullname" class="form-control ${not empty errors.fullname ? 'is-invalid' : ''}"
                   value="${oldFullname}" placeholder="Mai Anh Khoa" minlength="2" required>
            <div class="invalid-feedback">
              ${not empty errors.fullname ? errors.fullname : 'Vui lòng nhập họ và tên hợp lệ.'}
            </div>
          </div>
          <div class="col-md-6">
            <label class="form-label fw-semibold small">Email liên hệ</label>
            <input type="email" name="email" class="form-control ${not empty errors.email ? 'is-invalid' : ''}"
                   value="${oldEmail}" placeholder="24110027@student.hcmute.edu.vn" required>
            <div class="invalid-feedback">
              ${not empty errors.email ? errors.email : 'Vui lòng nhập đúng định dạng địa chỉ Email.'}
            </div>
          </div>
          <div class="col-md-6">
            <label class="form-label fw-semibold small">Số điện thoại</label>
            <input type="text" name="phone" class="form-control ${not empty errors.phone ? 'is-invalid' : ''}"
                   value="${oldPhone}" placeholder="0837707462" pattern="^(0|\+84)[0-9]{9,10}$" required>
            <div class="invalid-feedback">
              ${not empty errors.phone ? errors.phone : 'Số điện thoại phải gồm 10-11 chữ số bắt đầu bằng 0.'}
            </div>
          </div>
        </div>
        <button type="submit" class="btn-auth w-100 mt-4">
          <i class="fa fa-user-check me-1"></i> Hoàn tất đăng ký
        </button>
      </form>
    </div>
  </div>
  <script>
    (() => {
      'use strict';
      const forms = document.querySelectorAll('.needs-validation');
      Array.from(forms).forEach(form => {
        form.addEventListener('submit', event => {
          if (!form.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
          }
          form.classList.add('was-validated');
        }, false);
      });
    })();
  </script>
</body>
</html>
