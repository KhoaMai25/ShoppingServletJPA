<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap');
  :root {
    --primary: #4f46e5;
    --primary-hover: #4338ca;
    --accent: #f43f5e;
    --accent-orange: #f97316;
    --surface: #ffffff;
    --bg-main: #f8fafc;
    --text-main: #0f172a;
    --text-muted: #64748b;
  }
  body {
    font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
    background-color: var(--bg-main);
    color: var(--text-main);
  }
  .tz-navbar {
    background: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #4338ca 100%);
    padding: 13px 0;
    box-shadow: 0 10px 30px -10px rgba(49, 46, 129, 0.45);
    position: sticky;
    top: 0;
    z-index: 1030;
    backdrop-filter: blur(12px);
  }
  .tz-brand {
    font-weight: 800;
    font-size: 1.32rem;
    color: #ffffff !important;
    text-decoration: none;
    letter-spacing: -0.4px;
    display: inline-flex;
    align-items: center;
    gap: 10px;
    transition: transform 0.2s ease;
  }
  .tz-brand:hover {
    transform: translateY(-1px);
  }
  .tz-brand-icon {
    width: 38px;
    height: 38px;
    border-radius: 11px;
    background: linear-gradient(135deg, #f43f5e 0%, #fb923c 100%);
    display: inline-flex;
    align-items: center;
    justify-content: center;
    color: #fff;
    font-size: 1.1rem;
    box-shadow: 0 4px 12px rgba(244, 63, 94, 0.4);
  }
  .tz-nav-link {
    color: rgba(255, 255, 255, 0.88) !important;
    text-decoration: none;
    font-weight: 600;
    font-size: 0.9rem;
    padding: 8px 14px;
    border-radius: 10px;
    transition: all 0.22s cubic-bezier(0.16, 1, 0.3, 1);
    display: inline-flex;
    align-items: center;
    gap: 7px;
  }
  .tz-nav-link:hover, .tz-nav-link.active {
    color: #ffffff !important;
    background: rgba(255, 255, 255, 0.15);
    transform: translateY(-1px);
  }
  .tz-user-pill {
    background: rgba(255, 255, 255, 0.12);
    border: 1px solid rgba(255, 255, 255, 0.2);
    color: #ffffff;
    padding: 6px 14px;
    border-radius: 999px;
    font-size: 0.88rem;
    font-weight: 600;
    display: inline-flex;
    align-items: center;
    gap: 8px;
  }
  .tz-user-avatar {
    width: 26px;
    height: 26px;
    border-radius: 50%;
    background: linear-gradient(135deg, #38bdf8, #818cf8);
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-weight: 800;
    font-size: 0.78rem;
    color: #fff;
  }
  .tz-btn-logout {
    background: linear-gradient(135deg, #f43f5e 0%, #e11d48 100%);
    color: #ffffff !important;
    border: none;
    padding: 7px 15px;
    border-radius: 999px;
    font-size: 0.86rem;
    font-weight: 700;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    box-shadow: 0 4px 12px rgba(244, 63, 94, 0.35);
    transition: all 0.22s ease;
  }
  .tz-btn-logout:hover {
    transform: translateY(-1px);
    box-shadow: 0 6px 16px rgba(244, 63, 94, 0.5);
  }
</style>
<div class="tz-navbar">
  <div class="container d-flex justify-content-between align-items-center flex-wrap gap-2">
    <div class="d-flex align-items-center gap-2">
      <a href="${pageContext.request.contextPath}/home" class="tz-brand">
        <span class="tz-brand-icon"><i class="fa fa-bolt"></i></span>
        <span>TechZone Store</span>
      </a>
      <div class="d-none d-lg-flex align-items-center gap-1 ms-2">
        <a href="${pageContext.request.contextPath}/home" class="tz-nav-link">
          <i class="fa fa-home"></i> Trang chủ
        </a>
        <a href="${pageContext.request.contextPath}/video" class="tz-nav-link">
          <i class="fa fa-circle-play"></i> Kênh Video
        </a>
        <a href="${pageContext.request.contextPath}/admin/categories" class="tz-nav-link">
          <i class="fa fa-th-large"></i> Quản lý danh mục
        </a>
        <a href="${pageContext.request.contextPath}/admin/videos" class="tz-nav-link">
          <i class="fa fa-film"></i> Quản lý video
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="tz-nav-link">
          <i class="fa fa-users-gear"></i> Tài khoản & Mật khẩu
        </a>
      </div>
    </div>
    <div>
      <c:choose>
        <c:when test="${sessionScope.account == null}">
          <div class="d-flex align-items-center gap-2">
            <a href="${pageContext.request.contextPath}/login" class="tz-nav-link">
              <i class="fa fa-sign-in"></i> Đăng nhập
            </a>
            <a href="${pageContext.request.contextPath}/register" class="tz-btn-logout" style="background: linear-gradient(135deg, #f97316 0%, #ea580c 100%);">
              <i class="fa fa-user-plus"></i> Đăng ký
            </a>
          </div>
        </c:when>
        <c:otherwise>
          <div class="d-flex align-items-center gap-2 flex-wrap">
            <span class="tz-user-pill">
              <span class="tz-user-avatar">K</span>
              <span>${sessionScope.account.fullName}</span>
            </span>
            <a href="${pageContext.request.contextPath}/logout" class="tz-btn-logout">
              <i class="fa fa-power-off"></i> Đăng xuất
            </a>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</div>
