<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Cập nhật Video - TechZone Store</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<style>
  body {
    background: radial-gradient(circle at 10% 10%, #eef2ff 0%, #f8fafc 50%, #fdf2f8 100%);
    min-height: 100vh;
  }
  .form-card {
    max-width: 740px;
    margin: 24px auto;
    background: #ffffff;
    border-radius: 24px;
    border: 1px solid #e2e8f0;
    box-shadow: 0 20px 45px -15px rgba(15, 23, 42, 0.1);
    overflow: hidden;
  }
  .form-card-header {
    background: linear-gradient(135deg, #1e1b4b 0%, #4338ca 60%, #db2777 100%);
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
        <h4 class="fw-bold mb-1"><i class="fa fa-pen-to-square me-2"></i>Cập nhật thông tin Video #${video.videoId}</h4>
        <p class="mb-0 text-white-50 small">Chỉnh sửa tiêu đề, danh mục, trạng thái và tệp đa phương tiện</p>
      </div>
      <div class="p-4 p-md-5">
        <form action="${pageContext.request.contextPath}/admin/video/update" method="post" enctype="multipart/form-data">
          <input type="hidden" name="videoId" value="${video.videoId}">
          <div class="row g-3">
            <div class="col-12">
              <label class="form-label fw-bold">Tiêu đề Video</label>
              <input type="text" name="title" value="${video.title}" class="form-control" required>
            </div>

            <div class="col-md-6">
              <label class="form-label fw-bold">Danh mục sản phẩm</label>
              <select name="categoryid" class="form-select">
                <c:forEach items="${listcate}" var="c">
                  <option value="${c.categoryid}" ${video.category != null && video.category.categoryid == c.categoryid ? 'selected' : ''}>
                    ${c.categoryname}
                  </option>
                </c:forEach>
              </select>
            </div>

            <div class="col-md-3">
              <label class="form-label fw-bold">Lượt xem</label>
              <input type="number" name="views" value="${video.views}" class="form-control">
            </div>

            <div class="col-md-3">
              <label class="form-label fw-bold">Trạng thái</label>
              <select name="active" class="form-select">
                <option value="1" ${video.active == 1 ? 'selected' : ''}>Hoạt động</option>
                <option value="0" ${video.active == 0 ? 'selected' : ''}>Tạm ẩn</option>
              </select>
            </div>

            <div class="col-md-6">
              <label class="form-label fw-bold">Tải lên ảnh Poster mới</label>
              <input type="file" name="posterFile" class="form-control" accept="image/*">
            </div>

            <div class="col-md-6">
              <label class="form-label fw-bold">Đường dẫn phát Video MP4</label>
              <input type="text" name="videoUrl" value="${video.videoUrl}" class="form-control">
            </div>

            <div class="col-12">
              <label class="form-label fw-bold">Mô tả chi tiết</label>
              <textarea name="description" rows="3" class="form-control">${video.description}</textarea>
            </div>
          </div>

          <div class="d-flex justify-content-end gap-2 pt-4">
            <a href="${pageContext.request.contextPath}/admin/videos" class="btn btn-light border px-4 rounded-3 fw-semibold">Quay lại</a>
            <button type="submit" class="btn btn-primary px-4 rounded-3 fw-bold" style="background: linear-gradient(135deg, #4f46e5, #7c3aed); border: none;">
              <i class="fa fa-check me-1"></i> Lưu thay đổi
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</body>
</html>
