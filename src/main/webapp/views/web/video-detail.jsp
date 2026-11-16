<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${video != null ? video.title : 'Chi tiết Video'} - TechZone Store</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<style>
  body {
    background: radial-gradient(circle at 10% 0%, #eef2ff 0%, #f8fafc 45%, #fdf2f8 100%);
    min-height: 100vh;
  }
  .player-shell {
    background: #0f172a;
    border-radius: 22px;
    overflow: hidden;
    box-shadow: 0 22px 45px -12px rgba(15, 23, 42, 0.45);
  }
  .video-meta-card {
    background: #ffffff;
    border-radius: 22px;
    padding: 26px 28px;
    border: 1px solid #e2e8f0;
    box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.05);
  }
  .related-item {
    display: flex;
    gap: 12px;
    padding: 10px;
    border-radius: 14px;
    background: #ffffff;
    border: 1px solid #f1f5f9;
    text-decoration: none;
    color: #0f172a;
    transition: all 0.22s ease;
  }
  .related-item:hover {
    transform: translateX(4px);
    border-color: #c7d2fe;
    box-shadow: 0 8px 20px rgba(79, 70, 229, 0.12);
  }
  .related-thumb {
    width: 115px;
    height: 74px;
    border-radius: 10px;
    object-fit: cover;
    flex-shrink: 0;
  }
</style>
</head>
<body>
  <%@ include file="/common/web/topbar.jsp" %>

  <div class="container py-4">
    <div class="mb-3 d-flex justify-content-between align-items-center flex-wrap gap-2">
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb mb-0 small fw-semibold">
          <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home" class="text-decoration-none">Trang chủ</a></li>
          <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/video" class="text-decoration-none">Kênh Video</a></li>
          <li class="breadcrumb-item active" aria-current="page">${video.title}</li>
        </ol>
      </nav>
      <a href="${pageContext.request.contextPath}/video" class="btn btn-sm btn-outline-primary rounded-pill px-3 fw-semibold">
        <i class="fa fa-arrow-left me-1"></i> Quay lại danh sách Video
      </a>
    </div>

    <div class="row g-4">
      <!-- Trình phát Video (Play 01 Video) -->
      <div class="col-lg-8">
        <div class="player-shell mb-3">
          <c:choose>
            <c:when test="${not empty video.videoUrl and video.videoUrl.startsWith('http')}">
              <c:set var="resolvedVideoSrc" value="${video.videoUrl}" />
            </c:when>
            <c:otherwise>
              <c:set var="resolvedVideoSrc" value="${pageContext.request.contextPath}/image?fname=${not empty video.videoUrl ? video.videoUrl : 'tech_review.mp4'}" />
            </c:otherwise>
          </c:choose>
          <video id="mainVideoPlayer" class="w-100" style="max-height: 460px; background: #000;" controls autoplay muted playsinline
                 poster="${pageContext.request.contextPath}/image?fname=${not empty video.poster ? video.poster : 'phone.jpg'}">
            <source src="${resolvedVideoSrc}" type="video/mp4">
            Trình duyệt của bạn không hỗ trợ phát video HTML5.
          </video>
        </div>

        <div class="video-meta-card">
          <div class="d-flex flex-wrap gap-2 mb-2">
            <span class="badge bg-primary-subtle text-primary rounded-pill px-3 py-1 fw-bold">
              <i class="fa fa-folder-open me-1"></i> ${video.category != null ? video.category.categoryname : 'Công nghệ'}
            </span>
            <span class="badge bg-danger-subtle text-danger rounded-pill px-3 py-1 fw-bold">
              <i class="fa fa-eye me-1"></i> ${video.views} lượt xem
            </span>
            <span class="badge bg-success-subtle text-success rounded-pill px-3 py-1 fw-bold">
              Mã Video: #${video.videoId}
            </span>
          </div>

          <h3 class="fw-extrabold mb-3">${video.title}</h3>

          <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 py-3 border-top border-bottom mb-3">
            <div class="d-flex align-items-center gap-3">
              <div class="rounded-circle d-flex align-items-center justify-content-center fw-bold text-white"
                   style="width: 44px; height: 44px; background: linear-gradient(135deg, #4f46e5, #db2777);">
                K
              </div>
              <div>
                <div class="fw-bold">${video.user != null ? video.user.fullName : 'Mai Anh Khoa'}</div>
                <div class="text-muted small">
                  @${video.user != null ? video.user.userName : 'AnhPha'} • ${video.user != null ? video.user.email : '24110027@student.hcmute.edu.vn'}
                </div>
              </div>
            </div>
            <div class="d-flex gap-2">
              <a href="${pageContext.request.contextPath}/admin/video/edit?id=${video.videoId}" class="btn btn-outline-primary rounded-pill px-3 fw-semibold btn-sm">
                <i class="fa fa-pen me-1"></i> Chỉnh sửa Video
              </a>
            </div>
          </div>

          <h6 class="fw-bold mb-2">Mô tả chi tiết</h6>
          <p class="text-muted mb-0" style="line-height: 1.7;">${video.description}</p>
        </div>
      </div>

      <!-- Cột phải: Danh sách Video đề xuất -->
      <div class="col-lg-4">
        <div class="bg-white p-3 p-md-4 rounded-4 border shadow-sm">
          <h5 class="fw-bold mb-3"><i class="fa fa-fire text-danger me-2"></i>Video tiếp theo</h5>
          <div class="d-flex flex-column gap-2">
            <c:forEach items="${relatedVideos}" var="rv">
              <c:if test="${rv.videoId != video.videoId}">
                <a href="${pageContext.request.contextPath}/video/detail?id=${rv.videoId}" class="related-item">
                  <img src="${pageContext.request.contextPath}/image?fname=${not empty rv.poster ? rv.poster : 'phone.jpg'}" class="related-thumb" alt="${rv.title}">
                  <div class="flex-grow-1">
                    <div class="fw-bold small line-clamp-2 mb-1">${rv.title}</div>
                    <div class="text-muted" style="font-size: 0.75rem;">
                      <i class="fa fa-eye me-1"></i> ${rv.views} lượt xem
                    </div>
                  </div>
                </a>
              </c:if>
            </c:forEach>
          </div>
        </div>
      </div>
    </div>
  </div>
</body>
</html>
