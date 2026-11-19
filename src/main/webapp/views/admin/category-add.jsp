<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Thêm danh mục sản phẩm - TechZone Store</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<style>
  body {
    background: radial-gradient(circle at 10% 10%, #eef2ff 0%, #f8fafc 50%, #fdf2f8 100%);
    min-height: 100vh;
  }
  .form-card {
    max-width: 680px;
    margin: 24px auto;
    background: #ffffff;
    border-radius: 24px;
    border: 1px solid #e2e8f0;
    box-shadow: 0 20px 45px -15px rgba(15, 23, 42, 0.1);
    overflow: hidden;
  }
  .form-card-header {
    background: linear-gradient(135deg, #1e1b4b 0%, #4338ca 60%, #7c3aed 100%);
    color: #fff;
    padding: 26px 32px;
  }
  .sample-thumb {
    width: 72px;
    height: 54px;
    object-fit: cover;
    border-radius: 10px;
    cursor: pointer;
    border: 2px solid transparent;
    transition: all 0.2s ease;
  }
  .sample-thumb:hover, .sample-thumb.active {
    border-color: #4f46e5;
    transform: translateY(-2px);
  }
</style>
</head>
<body>
  <%@ include file="/common/web/topbar.jsp" %>

  <div class="container py-4">
    <div class="form-card">
      <div class="form-card-header">
        <h4 class="fw-bold mb-1"><i class="fa fa-folder-plus me-2"></i>Thêm danh mục sản phẩm mới</h4>
        <p class="mb-0 text-white-50 small">Tạo danh mục ngành hàng mới để trưng bày trên hệ thống cửa hàng</p>
      </div>
      <div class="p-4 p-md-5">
        <c:if test="${not empty alert}">
          <div class="alert alert-danger py-2 small rounded-3"><i class="fa fa-circle-exclamation me-1"></i> ${alert}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/category/insert" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
          <div class="mb-4">
            <label class="form-label fw-bold">Tên danh mục sản phẩm</label>
            <input type="text" name="categoryname" value="${oldCategoryname}"
                   class="form-control form-control-lg rounded-3 ${not empty errors.categoryname ? 'is-invalid' : ''}"
                   placeholder="Ví dụ: Phụ kiện Gaming & Bàn phím cơ" minlength="2" maxlength="255" required>
            <div class="invalid-feedback">
              ${not empty errors.categoryname ? errors.categoryname : 'Tên danh mục không được để trống và phải từ 2 ký tự trở lên.'}
            </div>
          </div>

          <div class="mb-4">
            <label class="form-label fw-bold">Trạng thái kinh doanh</label>
            <select name="status" class="form-select rounded-3">
              <option value="1" selected>Đang kinh doanh</option>
              <option value="0">Tạm ngưng hiển thị</option>
            </select>
          </div>

          <div class="mb-4">
            <label class="form-label fw-bold">Tải ảnh đại diện từ máy tính</label>
            <input type="file" name="images1" class="form-control rounded-3" accept="image/*" onchange="previewUpload(this)">
            <input type="hidden" name="images" id="existingIconInput" value="phone.jpg">
          </div>

          <div class="mb-4">
            <label class="form-label fw-bold d-block">Hoặc chọn nhanh ảnh sản phẩm mẫu</label>
            <div class="d-flex gap-2 flex-wrap align-items-center">
              <img src="${pageContext.request.contextPath}/image?fname=phone.jpg" class="sample-thumb active" onclick="pickSample('phone.jpg', this)" title="Điện thoại">
              <img src="${pageContext.request.contextPath}/image?fname=laptop.jpg" class="sample-thumb" onclick="pickSample('laptop.jpg', this)" title="Laptop">
              <img src="${pageContext.request.contextPath}/image?fname=ipad.jpg" class="sample-thumb" onclick="pickSample('ipad.jpg', this)" title="Máy tính bảng">
              <img src="${pageContext.request.contextPath}/image?fname=watch.jpg" class="sample-thumb" onclick="pickSample('watch.jpg', this)" title="Đồng hồ">
              <img src="${pageContext.request.contextPath}/image?fname=audio.jpg" class="sample-thumb" onclick="pickSample('audio.jpg', this)" title="Âm thanh">
              <img src="${pageContext.request.contextPath}/image?fname=camera.jpg" class="sample-thumb" onclick="pickSample('camera.jpg', this)" title="Máy ảnh">
            </div>
          </div>

          <div class="mb-4 text-center p-3 bg-light rounded-4">
            <div class="small text-muted mb-2">Xem trước hình ảnh danh mục</div>
            <img id="livePreview" src="${pageContext.request.contextPath}/image?fname=phone.jpg" style="height: 120px; border-radius: 14px; object-fit: cover;">
          </div>

          <div class="d-flex justify-content-end gap-2 pt-2">
            <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-light border px-4 rounded-3 fw-semibold">Hủy bỏ</a>
            <button type="submit" class="btn btn-primary px-4 rounded-3 fw-bold" style="background: linear-gradient(135deg, #4f46e5, #7c3aed); border: none;">
              <i class="fa fa-check me-1"></i> Lưu danh mục
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <script>
    function pickSample(fname, el) {
      document.getElementById('existingIconInput').value = fname;
      document.getElementById('livePreview').src = '${pageContext.request.contextPath}/image?fname=' + fname;
      document.querySelectorAll('.sample-thumb').forEach(t => t.classList.remove('active'));
      el.classList.add('active');
    }
    function previewUpload(input) {
      if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = e => document.getElementById('livePreview').src = e.target.result;
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
