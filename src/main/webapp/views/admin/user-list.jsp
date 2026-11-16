<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Danh sách Tài khoản & Mật khẩu mã hóa - TechZone Store</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<style>
  body {
    background: radial-gradient(circle at 0% 0%, #eef2ff 0%, #f8fafc 50%, #fdf2f8 100%);
    min-height: 100vh;
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
    font-size: 0.78rem;
    text-transform: uppercase;
    padding: 15px 16px;
  }
  .table tbody td {
    padding: 14px 16px;
    vertical-align: middle;
  }
  .hash-box {
    font-family: 'Consolas', 'Courier New', monospace;
    font-size: 0.76rem;
    background: #f1f5f9;
    color: #0f172a;
    padding: 6px 10px;
    border-radius: 8px;
    border: 1px solid #cbd5e1;
    max-width: 280px;
    word-break: break-all;
    display: inline-block;
  }
</style>
</head>
<body>
  <%@ include file="/common/web/topbar.jsp" %>

  <div class="container py-4">
    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
      <div>
        <h3 class="fw-bold mb-1">Quản lý Tài khoản & Mật khẩu bảo mật</h3>
        <p class="text-muted small mb-0">
          Kiểm tra trực tiếp toàn bộ tài khoản đã đăng ký, chuỗi băm mật khẩu SHA-256, mã OTP và trạng thái kích hoạt
        </p>
      </div>
      <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary rounded-3 fw-bold px-3">
          <i class="fa fa-user-plus me-1"></i> Đăng ký tài khoản mới
        </a>
      </div>
    </div>

    <div class="table-shell">
      <div class="table-responsive">
        <table class="table table-hover mb-0">
          <thead>
            <tr>
              <th>ID</th>
              <th>Tài khoản</th>
              <th>Họ và tên</th>
              <th>Email & SĐT</th>
              <th>Mật khẩu mã hóa SHA-256</th>
              <th>Mã OTP</th>
              <th>Trạng thái</th>
              <th>Ngày tạo</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${userList}" var="u">
              <tr>
                <td class="fw-bold text-muted">#${u.id}</td>
                <td>
                  <span class="fw-bold text-primary">${u.userName}</span>
                </td>
                <td class="fw-semibold">${u.fullName}</td>
                <td>
                  <div class="small fw-semibold"><i class="fa fa-envelope text-muted me-1"></i>${u.email}</div>
                  <div class="small text-muted"><i class="fa fa-phone text-muted me-1"></i>${u.phone}</div>
                </td>
                <td>
                  <span class="hash-box" title="${u.passWord}">${u.passWord}</span>
                </td>
                <td>
                  <c:choose>
                    <c:when test="${not empty u.code}">
                      <span class="badge bg-warning text-dark fs-6 fw-bold px-3 py-2 rounded-pill">${u.code}</span>
                    </c:when>
                    <c:otherwise>
                      <span class="text-muted small">Đã dùng / Trống</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <c:choose>
                    <c:when test="${u.status == 1}">
                      <span class="badge bg-success-subtle text-success rounded-pill px-3 py-2 fw-bold">
                        <i class="fa fa-circle-check me-1"></i> Đã kích hoạt
                      </span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge bg-danger-subtle text-danger rounded-pill px-3 py-2 fw-bold">
                        <i class="fa fa-clock me-1"></i> Chờ OTP
                      </span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td class="small text-muted">${u.createdDate}</td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</body>
</html>
