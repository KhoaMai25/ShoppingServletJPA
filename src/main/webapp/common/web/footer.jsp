<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="mt-auto pt-5 pb-4" style="background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 100%); color: rgba(255,255,255,0.82); border-top: 1px solid rgba(255,255,255,0.1);">
  <div class="container">
    <div class="row g-4 pb-4 border-bottom border-secondary border-opacity-25">
      <div class="col-lg-5">
        <div class="d-flex align-items-center gap-2 mb-3">
          <span class="d-inline-flex align-items-center justify-content-center rounded-3 text-white" style="width: 34px; height: 34px; background: linear-gradient(135deg, #f43f5e, #fb923c);">
            <i class="fa fa-bolt"></i>
          </span>
          <span class="fw-extrabold fs-5 text-white fw-bold">TechZone Store</span>
        </div>
        <p class="small text-white-50 mb-2" style="max-width: 380px;">
          Hệ thống bán lẻ thiết bị công nghệ chính hãng & kênh Video đánh giá chuyên sâu dành cho sinh viên Trường Đại học Sư phạm Kỹ thuật TP.HCM.
        </p>
        <div class="small text-white-50">
          <div><i class="fa fa-user-graduate text-warning me-2"></i>Mai Anh Khoa • MSSV: 24110027</div>
          <div><i class="fa fa-envelope text-warning me-2"></i>24110027@student.hcmute.edu.vn • <i class="fa fa-phone text-warning ms-1 me-1"></i>0837707462</div>
        </div>
      </div>
      <div class="col-6 col-lg-3">
        <h6 class="text-white fw-bold mb-3">Khám phá</h6>
        <ul class="list-unstyled small d-flex flex-column gap-2 mb-0">
          <li><a href="${pageContext.request.contextPath}/home" class="text-white-50 text-decoration-none">Trang chủ cửa hàng</a></li>
          <li><a href="${pageContext.request.contextPath}/video" class="text-white-50 text-decoration-none">Kênh Video công nghệ</a></li>
          <li><a href="${pageContext.request.contextPath}/profile" class="text-white-50 text-decoration-none">Hồ sơ cá nhân</a></li>
        </ul>
      </div>
      <div class="col-6 col-lg-4">
        <h6 class="text-white fw-bold mb-3">Quản trị hệ thống</h6>
        <ul class="list-unstyled small d-flex flex-column gap-2 mb-0">
          <li><a href="${pageContext.request.contextPath}/admin/categories" class="text-white-50 text-decoration-none">Quản lý Danh mục sản phẩm</a></li>
          <li><a href="${pageContext.request.contextPath}/admin/videos" class="text-white-50 text-decoration-none">Quản lý Video đánh giá</a></li>
          <li><a href="${pageContext.request.contextPath}/admin/users" class="text-white-50 text-decoration-none">Quản lý Tài khoản & Bảo mật</a></li>
        </ul>
      </div>
    </div>
    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 pt-3 small text-white-50">
      <span>© 2026 TechZone Store • Giao diện quản lý bằng SiteMesh Decorator 3 & Bootstrap 5</span>
      <span>HCMUTE • Lập trình Web</span>
    </div>
  </div>
</footer>
