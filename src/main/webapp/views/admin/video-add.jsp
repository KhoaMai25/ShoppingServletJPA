<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Thêm Video mới - TechZone Store</title>
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
  .sample-thumb {
    width: 74px;
    height: 52px;
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
        <h4 class="fw-bold mb-1"><i class="fa fa-video me-2"></i>Đăng tải Video công nghệ mới</h4>
        <p class="mb-0 text-white-50 small">Hỗ trợ tải file Poster & Video MP4 qua Multipart Servlet</p>
      </div>
      <div class="p-4 p-md-5">
        <form action="${pageContext.request.contextPath}/admin/video/insert" method="post" enctype="multipart/form-data">
          <div class="row g-3">
            <div class="col-md-4">
              <label class="form-label fw-bold">Mã Video</label>
              <input type="text" name="videoId" class="form-control" value="VID13" required>
            </div>
            <div class="col-md-8">
              <label class="form-label fw-bold">Tiêu đề Video</label>
              <input type="text" name="title" class="form-control" placeholder="Ví dụ: Đánh giá chi tiết MacBook Pro M4 Max" required>
            </div>

            <div class="col-md-6">
              <label class="form-label fw-bold">Danh mục sản phẩm</label>
              <select name="categoryid" class="form-select">
                <c:forEach items="${listcate}" var="c">
                  <option value="${c.categoryid}">${c.categoryname}</option>
                </c:forEach>
              </select>
            </div>

            <div class="col-md-3">
              <label class="form-label fw-bold">Lượt xem ban đầu</label>
              <input type="number" name="views" class="form-control" value="250">
            </div>

            <div class="col-md-3">
              <label class="form-label fw-bold">Trạng thái</label>
              <select name="active" class="form-select">
                <option value="1" selected>Hoạt động</option>
                <option value="0">Tạm ẩn</option>
              </select>
            </div>

            <div class="col-12">
              <label class="form-label fw-bold">Tải lên ảnh Poster đại diện</label>
              <input type="file" name="posterFile" class="form-control" accept="image/*" onchange="previewPoster(this)">
              <input type="hidden" name="posterSample" id="posterSampleInput" value="phone.jpg">
            </div>

            <div class="col-12">
              <label class="form-label fw-bold d-block">Hoặc chọn nhanh Poster sản phẩm có sẵn</label>
              <div class="d-flex gap-2 flex-wrap">
                <img src="${pageContext.request.contextPath}/image?fname=phone.jpg" class="sample-thumb active" onclick="pickPoster('phone.jpg', this)">
                <img src="${pageContext.request.contextPath}/image?fname=laptop.jpg" class="sample-thumb" onclick="pickPoster('laptop.jpg', this)">
                <img src="${pageContext.request.contextPath}/image?fname=ipad.jpg" class="sample-thumb" onclick="pickPoster('ipad.jpg', this)">
                <img src="${pageContext.request.contextPath}/image?fname=watch.jpg" class="sample-thumb" onclick="pickPoster('watch.jpg', this)">
                <img src="${pageContext.request.contextPath}/image?fname=audio.jpg" class="sample-thumb" onclick="pickPoster('audio.jpg', this)">
                <img src="${pageContext.request.contextPath}/image?fname=camera.jpg" class="sample-thumb" onclick="pickPoster('camera.jpg', this)">
              </div>
            </div>

            <div class="col-md-6">
              <label class="form-label fw-bold">Đường dẫn phát Video MP4</label>
              <input type="text" name="videoUrl" class="form-control" value="https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4">
            </div>

            <div class="col-md-6">
              <label class="form-label fw-bold">Hoặc tải file Video MP4 từ máy</label>
              <input type="file" name="videoFile" class="form-control" accept="video/*">
            </div>

            <div class="col-12">
              <label class="form-label fw-bold">Mô tả chi tiết nội dung Video</label>
              <textarea name="description" rows="3" class="form-control" placeholder="Nhập mô tả đánh giá chi tiết sản phẩm...">Video đánh giá thực tế thiết kế, hiệu năng và thời lượng pin chính hãng tại TechZone Store.</textarea>
            </div>
          </div>

          <div class="d-flex justify-content-end gap-2 pt-4">
            <a href="${pageContext.request.contextPath}/admin/videos" class="btn btn-light border px-4 rounded-3 fw-semibold">Hủy bỏ</a>
            <button type="submit" class="btn btn-primary px-4 rounded-3 fw-bold" style="background: linear-gradient(135deg, #4f46e5, #7c3aed); border: none;">
              <i class="fa fa-check me-1"></i> Lưu Video
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <script>
    function pickPoster(fname, el) {
      document.getElementById('posterSampleInput').value = fname;
      document.querySelectorAll('.sample-thumb').forEach(t => t.classList.remove('active'));
      el.classList.add('active');
    }
    function previewPoster(input) {}
  </script>
</body>
</html>
