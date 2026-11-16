<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Quản lý danh mục - TechZone Store</title>
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
    transition: transform 0.25s ease;
  }
  .stat-card:hover {
    transform: translateY(-4px);
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
    letter-spacing: 0.5px;
    padding: 15px 18px;
    border-bottom: 1px solid #e2e8f0;
  }
  .table tbody td {
    padding: 16px 18px;
    vertical-align: middle;
  }
  .cat-img-preview {
    width: 76px;
    height: 56px;
    object-fit: cover;
    border-radius: 12px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
    transition: transform 0.25s ease;
  }
  .cat-img-preview:hover {
    transform: scale(1.1);
  }
  .status-pill {
    cursor: pointer;
    user-select: none;
    padding: 6px 14px;
    border-radius: 999px;
    font-weight: 700;
    font-size: 0.78rem;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    transition: all 0.2s ease;
  }
  .status-pill.active {
    background: #dcfce7;
    color: #15803d;
  }
  .status-pill.locked {
    background: #fee2e2;
    color: #b91c1c;
  }
  .btn-gradient-primary {
    background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
    color: #fff !important;
    border: none;
    border-radius: 12px;
    padding: 10px 20px;
    font-weight: 700;
    box-shadow: 0 8px 20px -4px rgba(79, 70, 229, 0.45);
    transition: all 0.22s ease;
    text-decoration: none;
  }
  .btn-gradient-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 12px 24px -4px rgba(79, 70, 229, 0.6);
  }
</style>
</head>
<body>
  <%@ include file="/common/web/topbar.jsp" %>

  <div class="container py-4">
    <!-- Tiêu đề trang -->
    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
      <div>
        <h3 class="fw-bold mb-1">Quản lý danh mục sản phẩm</h3>
        <p class="text-muted small mb-0">Cập nhật hình ảnh, tên gọi và trạng thái hiển thị của các ngành hàng trên cửa hàng</p>
      </div>
      <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/home" class="btn btn-light border rounded-3 fw-semibold px-3">
          <i class="fa fa-store me-1"></i> Xem cửa hàng
        </a>
        <a href="${pageContext.request.contextPath}/admin/category/add" class="btn-gradient-primary">
          <i class="fa fa-plus me-1"></i> Thêm danh mục mới
        </a>
      </div>
    </div>

    <!-- Thẻ thống kê -->
    <div class="row g-3 mb-4">
      <div class="col-md-4">
        <div class="stat-card">
          <div>
            <div class="text-muted small fw-semibold mb-1">TỔNG DANH MỤC</div>
            <div class="fs-2 fw-extrabold text-dark fw-bold">${totalCount != null ? totalCount : listcate.size()}</div>
          </div>
          <div class="stat-icon" style="background: linear-gradient(135deg, #4f46e5, #818cf8);">
            <i class="fa fa-layer-group"></i>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="stat-card">
          <div>
            <div class="text-muted small fw-semibold mb-1">ĐANG KINH DOANH</div>
            <div class="fs-2 fw-extrabold text-success fw-bold">${activeCount != null ? activeCount : listcate.size()}</div>
          </div>
          <div class="stat-icon" style="background: linear-gradient(135deg, #10b981, #34d399);">
            <i class="fa fa-check-double"></i>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="stat-card">
          <div>
            <div class="text-muted small fw-semibold mb-1">QUẢN TRỊ VIÊN</div>
            <div class="fs-5 fw-bold text-primary">${sessionScope.account != null ? sessionScope.account.fullName : 'Mai Anh Khoa'}</div>
            <div class="text-muted" style="font-size: 0.78rem;">${sessionScope.account != null ? sessionScope.account.email : '24110027@student.hcmute.edu.vn'}</div>
          </div>
          <div class="stat-icon" style="background: linear-gradient(135deg, #f43f5e, #fb923c);">
            <i class="fa fa-user-shield"></i>
          </div>
        </div>
      </div>
    </div>

    <c:if test="${not empty sessionScope.flashMsg}">
      <div class="alert alert-success border-0 shadow-sm rounded-4 d-flex align-items-center justify-content-between mb-4">
        <div><i class="fa fa-circle-check me-2"></i><strong>${sessionScope.flashMsg}</strong></div>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
      <c:remove var="flashMsg" scope="session" />
    </c:if>

    <!-- Thanh công cụ tìm kiếm & lọc -->
    <div class="table-shell">
      <div class="p-3 p-md-4 border-bottom bg-white d-flex justify-content-between align-items-center flex-wrap gap-3">
        <form action="${pageContext.request.contextPath}/admin/categories" method="get" class="d-flex gap-2 flex-grow-1" style="max-width: 520px;">
          <div class="input-group">
            <span class="input-group-text bg-light border-end-0"><i class="fa fa-search text-muted"></i></span>
            <input type="text" id="quickFilter" name="keyword" value="${keyword}" class="form-control bg-light border-start-0" placeholder="Nhập tên danh mục cần tìm..." oninput="filterRows()">
          </div>
          <button type="submit" class="btn btn-primary px-4 fw-semibold rounded-3">Tìm kiếm</button>
          <c:if test="${not empty keyword}">
            <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-outline-secondary rounded-3">Xóa lọc</a>
          </c:if>
        </form>
        <div class="text-muted small fw-semibold">
          Hiển thị <strong>${listcate.size()}</strong> danh mục sản phẩm
        </div>
      </div>

      <div class="table-responsive">
        <table class="table table-hover mb-0" id="categoryTable">
          <thead>
            <tr>
              <th style="width: 70px;">STT</th>
              <th style="width: 120px;">Hình ảnh</th>
              <th>Mã danh mục</th>
              <th>Tên danh mục sản phẩm</th>
              <th>Trạng thái</th>
              <th class="text-end" style="width: 190px;">Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${listcate}" var="cate" varStatus="STT">
              <tr class="cat-row">
                <td class="fw-bold text-muted">${STT.index + 1}</td>
                <td>
                  <c:choose>
                    <c:when test="${not empty cate.images}">
                      <img src="${pageContext.request.contextPath}/image?fname=${cate.images}" class="cat-img-preview" alt="${cate.categoryname}">
                    </c:when>
                    <c:otherwise>
                      <img src="${pageContext.request.contextPath}/image?fname=abc.jpg" class="cat-img-preview" alt="${cate.categoryname}">
                    </c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <span class="badge bg-light text-dark border px-3 py-2 rounded-pill fw-bold">#CAT0${cate.categoryid}</span>
                </td>
                <td>
                  <div class="fw-bold text-dark fs-6 cat-name">${cate.categoryname}</div>
                  <div class="text-muted small">Chính hãng • Bảo hành 24 tháng</div>
                </td>
                <td>
                  <c:choose>
                    <c:when test="${cate.status == 1}">
                      <a href="${pageContext.request.contextPath}/admin/category/toggle-status?id=${cate.categoryid}" class="status-pill active text-decoration-none">
                        <i class="fa fa-circle-check"></i> Đang kinh doanh
                      </a>
                    </c:when>
                    <c:otherwise>
                      <a href="${pageContext.request.contextPath}/admin/category/toggle-status?id=${cate.categoryid}" class="status-pill locked text-decoration-none">
                        <i class="fa fa-circle-pause"></i> Tạm ngưng
                      </a>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td class="text-end">
                  <a href="${pageContext.request.contextPath}/admin/category/edit?id=${cate.categoryid}" class="btn btn-sm btn-outline-primary rounded-3 px-3 me-1 fw-semibold">
                    <i class="fa fa-pen me-1"></i> Sửa
                  </a>
                  <a href="${pageContext.request.contextPath}/admin/category/delete?id=${cate.categoryid}" class="btn btn-sm btn-outline-danger rounded-3 px-3 fw-semibold" onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục ${cate.categoryname}?');">
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

  <script>
    function filterRows() {
      const q = (document.getElementById('quickFilter').value || '').toLowerCase();
      document.querySelectorAll('#categoryTable .cat-row').forEach(row => {
        const name = (row.querySelector('.cat-name').textContent || '').toLowerCase();
        row.style.display = name.includes(q) ? '' : 'none';
      });
    }
    function toggleBadge(el) {
      if (el.classList.contains('active')) {
        el.classList.remove('active');
        el.classList.add('locked');
        el.innerHTML = '<i class="fa fa-circle-pause"></i> Tạm ngưng';
      } else {
        el.classList.remove('locked');
        el.classList.add('active');
        el.innerHTML = '<i class="fa fa-circle-check"></i> Đang kinh doanh';
      }
    }
  </script>
</body>
</html>
