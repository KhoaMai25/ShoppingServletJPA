<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Hồ sơ cá nhân - TechZone Store</title>
<style>
  .profile-banner {
    background: linear-gradient(125deg, #1e1b4b 0%, #4338ca 50%, #db2777 100%);
    border-radius: 24px;
    padding: 32px 36px;
    color: #fff;
    box-shadow: 0 20px 45px -15px rgba(67, 56, 202, 0.45);
  }
  .profile-card {
    background: #ffffff;
    border-radius: 24px;
    border: 1px solid #e2e8f0;
    box-shadow: 0 15px 35px -10px rgba(15, 23, 42, 0.08);
    overflow: hidden;
  }
  .avatar-preview-ring {
    width: 128px;
    height: 128px;
    border-radius: 50%;
    padding: 4px;
    background: linear-gradient(135deg, #4f46e5, #f43f5e, #fb923c);
    display: inline-block;
    box-shadow: 0 12px 28px rgba(79, 70, 229, 0.28);
  }
  .avatar-preview-img {
    width: 100%;
    height: 100%;
    border-radius: 50%;
    object-fit: cover;
    border: 3px solid #ffffff;
    background: #f8fafc;
  }
  .sample-avatar-item {
    width: 52px;
    height: 52px;
    border-radius: 50%;
    object-fit: cover;
    cursor: pointer;
    border: 2px solid transparent;
    transition: all 0.2s ease;
  }
  .sample-avatar-item:hover, .sample-avatar-item.active {
    border-color: #4f46e5;
    transform: scale(1.1);
  }
  .otp-verify-box {
    background: linear-gradient(135deg, #eef2ff 0%, #fdf2f8 100%);
    border: 2px dashed #6366f1;
    border-radius: 20px;
    padding: 24px;
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
  <c:if test="${not empty sessionScope.profileToast}">
    <div id="profileToast" class="tz-floating-toast">
      <i class="fa fa-circle-check text-success fs-5"></i>
      <div>
        <div class="fw-bold small">Thông báo hệ thống</div>
        <div class="text-white-50" style="font-size: 0.8rem;">${sessionScope.profileToast}</div>
      </div>
    </div>
    <c:remove var="profileToast" scope="session" />
  </c:if>

  <div class="container py-4">
    <!-- Header Banner -->
    <div class="profile-banner mb-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
      <div>
        <span class="badge bg-warning text-dark rounded-pill px-3 py-1 fw-bold mb-2">
          <i class="fa fa-id-card-clip me-1"></i> QUẢN LÝ HỒ SƠ CÁ NHÂN
        </span>
        <h3 class="fw-extrabold mb-1">Hồ sơ của ${userProfile.fullName}</h3>
        <p class="mb-0 text-white-50 small">
          Cập nhật Họ và tên, Số điện thoại, Ảnh đại diện Cloudinary Multipart và xác thực OTP khi thay đổi Email mới
        </p>
      </div>
      <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/home" class="btn btn-light rounded-pill px-3 fw-semibold">
          <i class="fa fa-home me-1"></i> Trang chủ
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-light rounded-pill px-3 fw-semibold">
          <i class="fa fa-users-gear me-1"></i> Bảng tài khoản
        </a>
      </div>
    </div>

    <div class="row g-4">
      <!-- Cột trái: Thẻ thông tin hiện tại -->
      <div class="col-lg-4">
        <div class="profile-card p-4 text-center h-100">
          <div class="avatar-preview-ring mb-3">
            <c:choose>
              <c:when test="${not empty userProfile.avatar and userProfile.avatar.startsWith('http')}">
                <img id="currentAvatarDisplay" src="${userProfile.avatar}" class="avatar-preview-img" alt="${userProfile.fullName}">
              </c:when>
              <c:otherwise>
                <img id="currentAvatarDisplay" src="${pageContext.request.contextPath}/image?fname=${not empty userProfile.avatar ? userProfile.avatar : 'phone.jpg'}" class="avatar-preview-img" alt="${userProfile.fullName}">
              </c:otherwise>
            </c:choose>
          </div>
          <h5 class="fw-bold mb-1">${userProfile.fullName}</h5>
          <div class="text-primary fw-semibold small mb-3">@${userProfile.userName}</div>

          <div class="d-flex justify-content-center gap-2 mb-4">
            <span class="badge bg-success-subtle text-success rounded-pill px-3 py-2 fw-bold">
              <i class="fa fa-shield-check me-1"></i> Đã kích hoạt OTP
            </span>
            <span class="badge bg-primary-subtle text-primary rounded-pill px-3 py-2 fw-bold">
              Cloudinary Ready
            </span>
          </div>

          <div class="text-start border-top pt-3 small">
            <div class="d-flex justify-content-between py-2 border-bottom">
              <span class="text-muted"><i class="fa fa-envelope me-2 text-primary"></i>Email hiện tại</span>
              <span class="fw-bold text-dark">${userProfile.email}</span>
            </div>
            <div class="d-flex justify-content-between py-2 border-bottom">
              <span class="text-muted"><i class="fa fa-phone me-2 text-primary"></i>Số điện thoại</span>
              <span class="fw-bold text-dark">${userProfile.phone}</span>
            </div>
            <div class="d-flex justify-content-between py-2">
              <span class="text-muted"><i class="fa fa-calendar-check me-2 text-primary"></i>Ngày tham gia</span>
              <span class="fw-bold text-dark">${userProfile.createdDate}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Cột phải: Form cập nhật Hồ sơ + Xác thực OTP khi đổi Email mới -->
      <div class="col-lg-8">
        <!-- Khung xác nhận OTP khi người dùng nhập Email mới -->
        <c:if test="${not empty sessionScope.pendingNewEmail}">
          <div class="otp-verify-box mb-4 shadow-sm">
            <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-2">
              <h5 class="fw-bold text-primary mb-0">
                <i class="fa fa-envelope-circle-check me-2"></i>Xác nhận OTP để cập nhật Email mới
              </h5>
              <span class="badge bg-warning text-dark rounded-pill px-3 py-1 fw-bold">Chờ xác thực</span>
            </div>
            <p class="small text-muted mb-3">
              Hệ thống đã gửi mã xác thực OTP gồm 6 chữ số đến địa chỉ Email mới:
              <strong class="text-danger">${sessionScope.pendingNewEmail}</strong>.
              Vui lòng nhập mã OTP bên dưới để hoàn tất đổi Email.
            </p>

            <c:if test="${not empty otpError}">
              <div class="alert alert-danger py-2 small rounded-3"><i class="fa fa-circle-exclamation me-1"></i> ${otpError}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/profile/verify-email" method="post" class="row g-2 align-items-center needs-validation" novalidate>
              <div class="col-sm-6">
                <input type="text" name="otp" maxlength="6" pattern="^[0-9]{6}$"
                       class="form-control form-control-lg text-center fw-bold"
                       style="letter-spacing: 6px;" placeholder="Nhập 6 số OTP" required autofocus>
                <div class="invalid-feedback">Vui lòng nhập đúng 6 chữ số OTP.</div>
              </div>
              <div class="col-sm-6 d-flex gap-2">
                <button type="submit" class="btn btn-success btn-lg fw-bold flex-grow-1 rounded-3">
                  <i class="fa fa-check-double me-1"></i> Xác nhận đổi Email
                </button>
              </div>
            </form>

            <div class="d-flex gap-3 mt-3 pt-2 border-top">
              <form action="${pageContext.request.contextPath}/profile/verify-email" method="post">
                <input type="hidden" name="action" value="resend">
                <button type="submit" class="btn btn-link btn-sm p-0 text-decoration-none fw-bold">
                  <i class="fa fa-rotate-right me-1"></i> Gửi lại mã OTP
                </button>
              </form>
              <form action="${pageContext.request.contextPath}/profile/verify-email" method="post">
                <input type="hidden" name="action" value="cancel">
                <button type="submit" class="btn btn-link btn-sm p-0 text-danger text-decoration-none fw-semibold">
                  <i class="fa fa-xmark me-1"></i> Hủy đổi Email
                </button>
              </form>
            </div>
          </div>
        </c:if>

        <div class="profile-card p-4 p-md-5">
          <h5 class="fw-bold mb-1"><i class="fa fa-user-pen text-primary me-2"></i>Cập nhật thông tin tài khoản</h5>
          <p class="text-muted small mb-4">
            Nếu bạn thay đổi sang địa chỉ Email mới, hệ thống sẽ tự động gửi mã OTP đến Email mới để xác nhận trước khi lưu.
          </p>

          <c:if test="${not empty alert}">
            <div class="alert alert-danger py-2 small rounded-3"><i class="fa fa-circle-exclamation me-1"></i> ${alert}</div>
          </c:if>

          <form action="${pageContext.request.contextPath}/profile" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
            <div class="row g-3">
              <div class="col-md-6">
                <label class="form-label fw-bold small">Tên đăng nhập</label>
                <input type="text" class="form-control bg-light" value="${userProfile.userName}" readonly>
              </div>

              <div class="col-md-6">
                <label class="form-label fw-bold small">Họ và tên</label>
                <input type="text" name="fullname" value="${userProfile.fullName}"
                       class="form-control ${not empty errors.fullname ? 'is-invalid' : ''}"
                       minlength="2" required placeholder="Nhập họ và tên đầy đủ">
                <div class="invalid-feedback">
                  ${not empty errors.fullname ? errors.fullname : 'Họ và tên không được để trống và phải có ít nhất 2 ký tự.'}
                </div>
              </div>

              <div class="col-md-6">
                <label class="form-label fw-bold small">Số điện thoại</label>
                <input type="text" name="phone" value="${userProfile.phone}"
                       class="form-control ${not empty errors.phone ? 'is-invalid' : ''}"
                       pattern="^(0|\+84)[0-9]{9,10}$" required placeholder="0837707462">
                <div class="invalid-feedback">
                  ${not empty errors.phone ? errors.phone : 'Số điện thoại phải gồm 10-11 chữ số bắt đầu bằng 0 hoặc +84.'}
                </div>
              </div>

              <div class="col-md-6">
                <label class="form-label fw-bold small">Địa chỉ Email</label>
                <input type="email" name="email" value="${not empty sessionScope.pendingNewEmail ? sessionScope.pendingNewEmail : userProfile.email}"
                       class="form-control ${not empty errors.email ? 'is-invalid' : ''}"
                       required placeholder="Nhập email hiện tại hoặc email mới">
                <div class="invalid-feedback">
                  ${not empty errors.email ? errors.email : 'Vui lòng nhập đúng định dạng địa chỉ Email.'}
                </div>
              </div>

              <div class="col-12 pt-2">
                <label class="form-label fw-bold small">Tải ảnh đại diện mới lên Cloudinary qua Multipart</label>
                <input type="file" name="imageFile" class="form-control" accept="image/*" onchange="previewProfileImage(this)">
                <input type="hidden" name="avatarSample" id="avatarSampleInput" value="${userProfile.avatar}">
              </div>

              <div class="col-12">
                <label class="form-label fw-semibold small text-muted d-block">Hoặc chọn nhanh ảnh đại diện mẫu:</label>
                <div class="d-flex gap-2 flex-wrap align-items-center">
                  <img src="${pageContext.request.contextPath}/image?fname=phone.jpg" class="sample-avatar-item" onclick="selectAvatarSample('phone.jpg', this)">
                  <img src="${pageContext.request.contextPath}/image?fname=laptop.jpg" class="sample-avatar-item" onclick="selectAvatarSample('laptop.jpg', this)">
                  <img src="${pageContext.request.contextPath}/image?fname=watch.jpg" class="sample-avatar-item" onclick="selectAvatarSample('watch.jpg', this)">
                  <img src="${pageContext.request.contextPath}/image?fname=camera.jpg" class="sample-avatar-item" onclick="selectAvatarSample('camera.jpg', this)">
                  <img src="${pageContext.request.contextPath}/image?fname=audio.jpg" class="sample-avatar-item" onclick="selectAvatarSample('audio.jpg', this)">
                </div>
              </div>
            </div>

            <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
              <a href="${pageContext.request.contextPath}/home" class="btn btn-light border rounded-3 px-4 fw-semibold">Quay lại</a>
              <button type="submit" class="btn btn-primary rounded-3 px-4 fw-bold" style="background: linear-gradient(135deg, #4f46e5, #7c3aed); border: none;">
                <i class="fa fa-floppy-disk me-1"></i> Lưu cập nhật Hồ sơ
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>

  <script>
    const pToast = document.getElementById('profileToast');
    if (pToast) {
      setTimeout(() => {
        pToast.classList.add('hide-toast');
      }, 3800);
    }
    function selectAvatarSample(fname, el) {
      document.getElementById('avatarSampleInput').value = fname;
      document.getElementById('currentAvatarDisplay').src = '${pageContext.request.contextPath}/image?fname=' + fname;
      document.querySelectorAll('.sample-avatar-item').forEach(i => i.classList.remove('active'));
      el.classList.add('active');
    }
    function previewProfileImage(input) {
      if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = e => document.getElementById('currentAvatarDisplay').src = e.target.result;
        reader.readAsDataURL(input.files[0]);
      }
    }
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
