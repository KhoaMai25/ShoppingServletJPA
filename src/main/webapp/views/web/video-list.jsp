<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Kênh Video Công Nghệ - TechZone Store</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<style>
  body {
    background: radial-gradient(circle at 10% 0%, #eef2ff 0%, #f8fafc 45%, #fdf2f8 100%);
    min-height: 100vh;
  }
  .channel-header {
    background: linear-gradient(125deg, #1e1b4b 0%, #4338ca 55%, #db2777 100%);
    border-radius: 22px;
    padding: 32px 36px;
    color: #fff;
    box-shadow: 0 18px 40px -12px rgba(67, 56, 202, 0.45);
  }
  .video-card {
    background: #ffffff;
    border-radius: 20px;
    border: 1px solid #e2e8f0;
    overflow: hidden;
    box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.06);
    transition: all 0.28s ease;
    height: 100%;
    display: flex;
    flex-direction: column;
  }
  .video-card:hover {
    transform: translateY(-6px);
    box-shadow: 0 22px 40px -10px rgba(79, 70, 229, 0.2);
    border-color: #a5b4fc;
  }
  .video-thumb {
    height: 205px;
    position: relative;
    overflow: hidden;
    background: #0f172a;
    display: block;
  }
  .video-thumb img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.45s ease;
  }
  .video-card:hover .video-thumb img {
    transform: scale(1.08);
  }
  .play-overlay {
    position: absolute;
    inset: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(15, 23, 42, 0.28);
  }
  .play-btn-icon {
    width: 54px;
    height: 54px;
    border-radius: 50%;
    background: linear-gradient(135deg, #f43f5e 0%, #fb923c 100%);
    color: #fff;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.25rem;
    box-shadow: 0 8px 20px rgba(244, 63, 94, 0.55);
    transition: transform 0.25s ease;
  }
  .video-card:hover .play-btn-icon {
    transform: scale(1.14);
  }
  .video-title-link {
    color: #0f172a;
    text-decoration: none;
    font-weight: 700;
    font-size: 1.05rem;
    line-height: 1.4;
    display: block;
    transition: color 0.2s ease;
  }
  .video-title-link:hover {
    color: #4f46e5;
  }
  .page-link-custom {
    width: 42px;
    height: 42px;
    border-radius: 12px !important;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    margin: 0 4px;
    border: 1px solid #e2e8f0;
    color: #334155;
    text-decoration: none;
    background: #fff;
    transition: all 0.2s ease;
  }
  .page-link-custom:hover, .page-link-custom.active {
    background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
    color: #fff;
    border-color: transparent;
    box-shadow: 0 8px 18px rgba(79, 70, 229, 0.35);
  }
</style>
</head>
<body>
  <%@ include file="/common/web/topbar.jsp" %>

  <div class="container py-4">
    <!-- Banner Kênh Video của User -->
    <div class="channel-header mb-4">
      <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
        <div>
          <span class="badge bg-warning text-dark rounded-pill px-3 py-1 fw-bold mb-2">
            <i class="fa fa-video me-1"></i> KÊNH VIDEO CỦA THÀNH VIÊN
          </span>
          <h3 class="fw-extrabold mb-1">
            Danh sách Video của ${videoOwner != null ? videoOwner.fullName : 'Mai Anh Khoa'}
          </h3>
          <p class="mb-0 text-white-50 small">
            Tài khoản: <strong>${videoOwner != null ? videoOwner.userName : 'AnhPha'}</strong> •
            Email: <strong>${videoOwner != null ? videoOwner.email : '24110027@student.hcmute.edu.vn'}</strong> •
            Tổng số: <strong>${totalVideos} Videos</strong> • Hiển thị <strong>${pageSize} video/trang</strong>
          </p>
        </div>
        <div class="d-flex gap-2">
          <a href="${pageContext.request.contextPath}/home" class="btn btn-light rounded-pill px-3 fw-semibold">
            <i class="fa fa-home me-1"></i> Trang chủ
          </a>
          <a href="${pageContext.request.contextPath}/admin/video/add" class="btn btn-warning rounded-pill px-3 fw-bold text-dark">
            <i class="fa fa-plus-circle me-1"></i> Đăng tải Video mới
          </a>
        </div>
      </div>
    </div>

    <!-- Lưới 6 Videos / trang -->
    <div class="row g-4 mb-4">
      <c:forEach items="${videoList}" var="v">
        <div class="col-md-6 col-lg-4">
          <div class="video-card">
            <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" class="video-thumb">
              <img src="${pageContext.request.contextPath}/image?fname=${not empty v.poster ? v.poster : 'phone.jpg'}" alt="${v.title}">
              <div class="play-overlay">
                <div class="play-btn-icon"><i class="fa fa-play ms-1"></i></div>
              </div>
              <span class="position-absolute top-0 start-0 m-3 badge bg-primary rounded-pill px-3 py-1">
                ${v.category != null ? v.category.categoryname : 'Công nghệ'}
              </span>
              <span class="position-absolute bottom-0 end-0 m-3 badge bg-dark bg-opacity-75 rounded-pill px-3 py-1">
                <i class="fa fa-eye me-1"></i> ${v.views} lượt xem
              </span>
            </a>
            <div class="p-4 d-flex flex-column flex-grow-1 justify-content-between">
              <div>
                <h5 class="mb-2">
                  <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" class="video-title-link">
                    ${v.title}
                  </a>
                </h5>
                <p class="text-muted small mb-3">${v.description}</p>
              </div>
              <div class="d-flex justify-content-between align-items-center pt-3 border-top small">
                <span class="text-muted">
                  <i class="fa fa-user-check text-primary me-1"></i>
                  <strong>${v.user != null ? v.user.fullName : 'Mai Anh Khoa'}</strong>
                </span>
                <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" class="btn btn-sm btn-outline-danger rounded-pill px-3 fw-bold">
                  <i class="fa fa-circle-play me-1"></i> Xem & Phát
                </a>
              </div>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>

    <!-- Thanh phân trang 6 sản phẩm/trang -->
    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 bg-white p-3 px-4 rounded-4 shadow-sm border">
      <div class="text-muted small fw-semibold">
        Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong> • Hiển thị <strong>6 video/trang</strong> • Tổng <strong>${totalVideos}</strong> video
      </div>
      <div class="d-flex align-items-center">
        <c:if test="${currentPage > 1}">
          <a href="${pageContext.request.contextPath}/video?page=${currentPage - 1}" class="page-link-custom">
            <i class="fa fa-chevron-left"></i>
          </a>
        </c:if>
        <c:forEach begin="1" end="${totalPages}" var="p">
          <a href="${pageContext.request.contextPath}/video?page=${p}" class="page-link-custom ${p == currentPage ? 'active' : ''}">
            ${p}
          </a>
        </c:forEach>
        <c:if test="${currentPage < totalPages}">
          <a href="${pageContext.request.contextPath}/video?page=${currentPage + 1}" class="page-link-custom">
            <i class="fa fa-chevron-right"></i>
          </a>
        </c:if>
      </div>
    </div>
  </div>
</body>
</html>
