<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Cập nhật danh mục - TechZone Store</title>
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
</style>
</head>
<body>
  <%@ include file="/common/web/topbar.jsp" %>

  <div class="container py-4">
    <div class="form-card">
      <div class="form-card-header">
        <h4 class="fw-bold mb-1"><i class="fa fa-pen-to-square me-2"></i>Cập nhật danh mục sản phẩm</h4>
        <p class="mb-0 text-white-50 small">Chỉnh sửa thông tin và hình ảnh hiển thị của danh mục #CAT0${cate.cateid}</p>
      </div>
      <div class="p-4 p-md-5">
        <form action="${pageContext.request.contextPath}/admin/category/update" method="post" enctype="multipart/form-data">
          <input type="hidden" name="categoryid" value="${cate.categoryid}">

          <div class="mb-4">
            <label class="form-label fw-bold">Tên danh mục sản phẩm</label>
            <input type="text" name="categoryname" value="${cate.categoryname}" class="form-control form-control-lg rounded-3" required>
          </div>

          <div class="mb-4">
            <label class="form-label fw-bold">Trạng thái kinh doanh</label>
            <select name="status" class="form-select rounded-3">
              <option value="1" ${cate.status == 1 ? 'selected' : ''}>Đang kinh doanh</option>
              <option value="0" ${cate.status == 0 ? 'selected' : ''}>Tạm ngưng hiển thị</option>
            </select>
          </div>

          <div class="mb-4 text-center p-3 bg-light rounded-4">
            <div class="small text-muted mb-2">Hình ảnh hiện tại</div>
            <img id="editPreview" src="${pageContext.request.contextPath}/image?fname=${not empty cate.images ? cate.images : 'abc.jpg'}" style="height: 120px; border-radius: 14px; object-fit: cover;">
          </div>

          <div class="mb-4">
            <label class="form-label fw-bold">Thay đổi hình ảnh mới</label>
            <input type="file" name="images1" class="form-control rounded-3" accept="image/*" onchange="previewEdit(this)">
          </div>

          <div class="d-flex justify-content-end gap-2 pt-2">
            <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-light border px-4 rounded-3 fw-semibold">Quay lại</a>
            <button type="submit" class="btn btn-primary px-4 rounded-3 fw-bold" style="background: linear-gradient(135deg, #4f46e5, #7c3aed); border: none;">
              <i class="fa fa-check me-1"></i> Lưu thay đổi
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <script>
    function previewEdit(input) {
      if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = e => document.getElementById('editPreview').src = e.target.result;
        reader.readAsDataURL(input.files[0]);
      }
    }
  </script>
</body>
</html>
