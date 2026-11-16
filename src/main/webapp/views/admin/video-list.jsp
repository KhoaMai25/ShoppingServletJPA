<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Quản lý Video - TechZone Store</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<style>
  body {
    background: radial-gradient(circle at 0% 0%, #eef2ff 0%, #f8fafc 50%, #fdf2f8 100%);
    min-height: 100vh;
  }
  .stat-card {
    background: #ffffff;
    border-radius: 20px;
    padding: 22px 24px;
    border: 1px solid #f1f5f9;
    box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.05);
    display: flex;
    align-items: center;
    justify-content: space-between;
  }
  .stat-icon {
    width: 54px;
    height: 54px;
    border-radius: 16px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.35rem;
    color: #fff;
  }
  .table-shell {
    background: #ffffff;
    border-radius: 22px;
    border: 1px solid #e2e8f0;
    box-shadow: 0 14px 35px -10px rgba(15, 23, 42, 0.07);
    overflow: hidden;
  }
  .table thead th {
    background: #f8fafc;
    color: #475569;
    font-weight: 700;
    font-size: 0.8rem;
    text-transform: uppercase;
    padding: 15px 18px;
  }
  .table tbody td {
    padding: 15px 18px;
    vertical-align: middle;
  }
  .vid-poster {
    width: 88px;
    height: 58px;
    object-fit: cover;
    border-radius: 12px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
  }
  .btn-gradient-primary {
    background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
    color: #fff !important;
    border: none;
    border-radius: 12px;
    padding: 10px 20px;
    font-weight: 700;
    text-decoration: none;
    box-shadow: 0 8px 20px -4px rgba(79, 70, 229, 0.45);
  }
</style>
</head>
<body>
  <%@ include file="/common/web/topbar.jsp" %>

  <div class="container py-4">
    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
      <div>
        <h3 class="fw-bold mb-1">Quản lý danh sách Video</h3>
        <p class="text-muted small mb-0">Thêm mới, chỉnh sửa, tải lên Poster Multipart và phân loại Video theo danh mục & người dùng</p>
      </div>
      <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/video" class="btn btn-light border rounded-3 fw-semibold px-3">
          <i class="fa fa-circle-play me-1 text-danger"></i> Xem trang /video
        </a>
        <a href="${pageContext.request.contextPath}/admin/video/add" class="btn-gradient-primary">
          <i class="fa fa-plus me-1"></i> Thêm Video mới
        </a>
      </div>
    </div>

    <div class="row g-3 mb-4">
      <div class="col-md-4">
        <div class="stat-card">
          <div>
            <div class="text-muted small fw-semibold mb-1">TỔNG SỐ VIDEO</div>
            <div class="fs-2 fw-bold text-dark">${totalVideos != null ? totalVideos : videoList.size()}</div>
          </div>
          <div class="stat-icon" style="background: linear-gradient(135deg, #4f46e5, #818cf8);">
            <i class="fa fa-film"></i>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="stat-card">
          <div>
            <div class="text-muted small fw-semibold mb-1">HIỂN THỊ TRANG CHỦ</div>
            <div class="fs-2 fw-bold text-success">Top 10</div>
          </div>
          <div class="stat-icon" style="background: linear-gradient(135deg, #10b981, #34d399);">
            <i class="fa fa-bolt"></i>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="stat-card">
          <div>
            <div class="text-muted small fw-semibold mb-1">CHỦ SỞ HỮU KÊNH</div>
            <div class="fs-5 fw-bold text-primary">${sessionScope.account != null ? sessionScope.account.fullName : 'Mai Anh Khoa'}</div>
            <div class="text-muted" style="font-size: 0.78rem;">${sessionScope.account != null ? sessionScope.account.email : '24110027@student.hcmute.edu.vn'}</div>
          </div>
          <div class="stat-icon" style="background: linear-gradient(135deg, #f43f5e, #fb923c);">
            <i class="fa fa-user-check"></i>
          </div>
        </div>
      </div>
    </div>

    <c:if test="${not empty sessionScope.flashVideoMsg}">
      <div class="alert alert-success border-0 shadow-sm rounded-4 d-flex align-items-center justify-content-between mb-4">
        <div><i class="fa fa-circle-check me-2"></i><strong>${sessionScope.flashVideoMsg}</strong></div>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
      <c:remove var="flashVideoMsg" scope="session" />
    </c:if>

    <div class="table-shell">
      <div class="p-3 p-md-4 border-bottom bg-white d-flex justify-content-between align-items-center flex-wrap gap-3">
        <form action="${pageContext.request.contextPath}/admin/videos" method="get" class="d-flex gap-2 flex-grow-1" style="max-width: 520px;">
          <div class="input-group">
            <span class="input-group-text bg-light border-end-0"><i class="fa fa-search text-muted"></i></span>
            <input type="text" name="keyword" value="${keyword}" class="form-control bg-light border-start-0" placeholder="Tìm kiếm theo tiêu đề hoặc mô tả video...">
          </div>
          <button type="submit" class="btn btn-primary px-4 fw-semibold rounded-3">Tìm</button>
          <c:if test="${not empty keyword}">
            <a href="${pageContext.request.contextPath}/admin/videos" class="btn btn-outline-secondary rounded-3">Xóa</a>
          </c:if>
        </form>
        <div class="text-muted small fw-semibold">
          Hiển thị <strong>${videoList.size()}</strong> video
        </div>
      </div>

      <div class="table-responsive">
        <table class="table table-hover mb-0">
          <thead>
            <tr>
              <th>Mã Video</th>
              <th>Poster</th>
              <th>Tiêu đề Video</th>
              <th>Danh mục</th>
              <th>Người đăng</th>
              <th>Lượt xem</th>
              <th>Trạng thái</th>
              <th class="text-end">Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${videoList}" var="v">
              <tr>
                <td><span class="badge bg-light text-dark border px-2 py-1 fw-bold">#${v.videoId}</span></td>
                <td>
                  <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}">
                    <img src="${pageContext.request.contextPath}/image?fname=${not empty v.poster ? v.poster : 'phone.jpg'}" class="vid-poster" alt="${v.title}">
                  </a>
                </td>
                <td style="max-width: 300px;">
                  <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" class="fw-bold text-dark text-decoration-none d-block">
                    ${v.title}
                  </a>
                  <div class="text-muted small text-truncate">${v.description}</div>
                </td>
                <td>
                  <span class="badge bg-primary-subtle text-primary rounded-pill px-3 py-1">
                    ${v.category != null ? v.category.categoryname : 'Công nghệ'}
                  </span>
                </td>
                <td class="small fw-semibold">${v.user != null ? v.user.fullName : 'Mai Anh Khoa'}</td>
                <td class="fw-bold text-danger"><i class="fa fa-eye me-1"></i>${v.views}</td>
                <td>
                  <c:choose>
                    <c:when test="${v.active == 1}">
                      <span class="badge bg-success-subtle text-success rounded-pill px-3 py-1">Hoạt động</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge bg-secondary-subtle text-secondary rounded-pill px-3 py-1">Đang ẩn</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td class="text-end">
                  <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" class="btn btn-sm btn-outline-success rounded-3 me-1" title="Phát video">
                    <i class="fa fa-play"></i>
                  </a>
                  <a href="${pageContext.request.contextPath}/admin/video/edit?id=${v.videoId}" class="btn btn-sm btn-outline-primary rounded-3 me-1" title="Sửa">
                    <i class="fa fa-pen"></i>
                  </a>
                  <a href="${pageContext.request.contextPath}/admin/video/delete?id=${v.videoId}" class="btn btn-sm btn-outline-danger rounded-3" onclick="return confirm('Xóa video ${v.title}?');" title="Xóa">
                    <i class="fa fa-trash"></i>
                  </a>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</body>
</html>
