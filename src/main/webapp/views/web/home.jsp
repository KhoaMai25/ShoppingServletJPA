<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>TechZone Store - Hệ thống bán lẻ công nghệ chính hãng</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<style>
  :root {
    --tz-indigo: #4f46e5;
    --tz-violet: #7c3aed;
    --tz-rose: #f43f5e;
    --tz-amber: #f59e0b;
    --tz-emerald: #10b981;
  }
  body {
    background: radial-gradient(circle at 10% 0%, #eef2ff 0%, #f8fafc 45%, #fdf2f8 100%);
    min-height: 100vh;
  }
  /* Hero Banner */
  .hero-banner {
    background: linear-gradient(125deg, #1e1b4b 0%, #4338ca 48%, #7c3aed 82%, #db2777 100%);
    border-radius: 24px;
    padding: 36px 40px;
    color: #ffffff;
    box-shadow: 0 20px 45px -15px rgba(67, 56, 202, 0.45);
    position: relative;
    overflow: hidden;
  }
  .hero-banner::before {
    content: '';
    position: absolute;
    width: 340px;
    height: 340px;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(244, 63, 94, 0.35) 0%, transparent 70%);
    top: -110px;
    right: -60px;
    pointer-events: none;
  }
  .hero-tag {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: rgba(255, 255, 255, 0.16);
    border: 1px solid rgba(255, 255, 255, 0.28);
    padding: 6px 14px;
    border-radius: 999px;
    font-size: 0.8rem;
    font-weight: 700;
    letter-spacing: 0.4px;
    text-transform: uppercase;
    margin-bottom: 14px;
  }
  .profile-glass {
    background: rgba(255, 255, 255, 0.13);
    backdrop-filter: blur(16px);
    border: 1px solid rgba(255, 255, 255, 0.25);
    border-radius: 18px;
    padding: 20px 22px;
    transition: transform 0.25s ease;
  }
  .profile-glass:hover {
    transform: translateY(-3px);
  }
  .profile-row {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 5px 0;
    font-size: 0.92rem;
  }
  .profile-row i {
    width: 22px;
    color: #fde047;
    text-align: center;
  }
  .btn-cta-gold {
    background: linear-gradient(135deg, #f59e0b 0%, #f97316 100%);
    color: #fff !important;
    font-weight: 700;
    padding: 11px 22px;
    border-radius: 12px;
    border: none;
    box-shadow: 0 10px 20px -5px rgba(249, 115, 22, 0.5);
    transition: all 0.25s ease;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 8px;
  }
  .btn-cta-gold:hover {
    transform: translateY(-2px);
    box-shadow: 0 14px 26px -5px rgba(249, 115, 22, 0.65);
  }
  .btn-cta-light {
    background: rgba(255, 255, 255, 0.16);
    color: #fff !important;
    border: 1px solid rgba(255, 255, 255, 0.3);
    font-weight: 600;
    padding: 11px 20px;
    border-radius: 12px;
    transition: all 0.25s ease;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 8px;
  }
  .btn-cta-light:hover {
    background: rgba(255, 255, 255, 0.26);
    transform: translateY(-2px);
  }

  /* Category Cards */
  .cat-pill-card {
    background: #ffffff;
    border-radius: 18px;
    overflow: hidden;
    border: 2px solid transparent;
    box-shadow: 0 8px 24px rgba(15, 23, 42, 0.06);
    transition: all 0.28s cubic-bezier(0.16, 1, 0.3, 1);
    cursor: pointer;
    height: 100%;
  }
  .cat-pill-card:hover, .cat-pill-card.active {
    transform: translateY(-6px);
    border-color: var(--tz-indigo);
    box-shadow: 0 16px 32px rgba(79, 70, 229, 0.18);
  }
  .cat-thumb-wrap {
    height: 130px;
    overflow: hidden;
    position: relative;
    background: #f1f5f9;
  }
  .cat-thumb-wrap img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.45s ease;
  }
  .cat-pill-card:hover .cat-thumb-wrap img {
    transform: scale(1.09);
  }
  .cat-status-dot {
    position: absolute;
    top: 10px;
    right: 10px;
    background: rgba(16, 185, 129, 0.92);
    color: #fff;
    font-size: 0.7rem;
    font-weight: 700;
    padding: 3px 9px;
    border-radius: 999px;
    backdrop-filter: blur(4px);
  }

  /* Filter Pill Buttons */
  .filter-chip {
    border: 1px solid #e2e8f0;
    background: #ffffff;
    color: #334155;
    padding: 8px 18px;
    border-radius: 999px;
    font-weight: 600;
    font-size: 0.88rem;
    transition: all 0.22s ease;
    cursor: pointer;
  }
  .filter-chip:hover, .filter-chip.active {
    background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
    color: #ffffff;
    border-color: transparent;
    box-shadow: 0 6px 16px rgba(79, 70, 229, 0.3);
    transform: translateY(-1px);
  }

  /* Product Card */
  .product-card {
    background: #ffffff;
    border-radius: 20px;
    border: 1px solid #f1f5f9;
    overflow: hidden;
    box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.06);
    transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
    height: 100%;
    display: flex;
    flex-direction: column;
  }
  .product-card:hover {
    transform: translateY(-7px);
    box-shadow: 0 22px 40px -10px rgba(79, 70, 229, 0.2);
    border-color: #c7d2fe;
  }
  .product-img-box {
    height: 215px;
    position: relative;
    overflow: hidden;
    background: #f8fafc;
  }
  .product-img-box img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.5s ease;
  }
  .product-card:hover .product-img-box img {
    transform: scale(1.08);
  }
  .badge-discount {
    position: absolute;
    top: 12px;
    left: 12px;
    background: linear-gradient(135deg, #f43f5e 0%, #e11d48 100%);
    color: #fff;
    font-weight: 800;
    font-size: 0.76rem;
    padding: 4px 11px;
    border-radius: 999px;
    box-shadow: 0 4px 10px rgba(244, 63, 94, 0.35);
  }
  .btn-wishlist {
    position: absolute;
    top: 12px;
    right: 12px;
    width: 36px;
    height: 36px;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.9);
    border: none;
    color: #64748b;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s ease;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  }
  .btn-wishlist.liked, .btn-wishlist:hover {
    color: #f43f5e;
    transform: scale(1.12);
    background: #fff;
  }
  .product-price {
    font-size: 1.18rem;
    font-weight: 800;
    color: #e11d48;
  }
  .product-old-price {
    font-size: 0.84rem;
    color: #94a3b8;
    text-decoration: line-through;
  }
  .btn-buy-now {
    background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
    color: #fff;
    border: none;
    border-radius: 12px;
    padding: 9px 14px;
    font-weight: 700;
    font-size: 0.86rem;
    transition: all 0.22s ease;
  }
  .btn-buy-now:hover {
    background: linear-gradient(135deg, #4338ca 0%, #4f46e5 100%);
    color: #fff;
    transform: translateY(-1px);
    box-shadow: 0 6px 15px rgba(79, 70, 229, 0.35);
  }
  /* Floating Cart Bar */
  .floating-cart {
    position: fixed;
    bottom: 24px;
    right: 24px;
    z-index: 1050;
    background: linear-gradient(135deg, #1e1b4b 0%, #4f46e5 100%);
    color: #fff;
    border-radius: 999px;
    padding: 12px 22px;
    box-shadow: 0 15px 35px rgba(49, 46, 129, 0.45);
    display: flex;
    align-items: center;
    gap: 12px;
    cursor: pointer;
    border: 2px solid rgba(255, 255, 255, 0.2);
    transition: all 0.25s ease;
  }
  .floating-cart:hover {
    transform: translateY(-3px) scale(1.03);
  }
  .cart-count-badge {
    background: #f43f5e;
    color: #fff;
    font-weight: 800;
    font-size: 0.8rem;
    padding: 2px 9px;
    border-radius: 999px;
  }
  /* Toast Notification */
  .tz-toast {
    position: fixed;
    top: 82px;
    right: 24px;
    z-index: 1090;
    background: #0f172a;
    color: #fff;
    padding: 14px 20px;
    border-radius: 14px;
    box-shadow: 0 15px 30px rgba(15, 23, 42, 0.3);
    display: flex;
    align-items: center;
    gap: 12px;
    transform: translateX(130%);
    transition: transform 0.32s cubic-bezier(0.16, 1, 0.3, 1);
  }
  .tz-toast.show {
    transform: translateX(0);
  }
</style>
</head>
<body>
  <%@ include file="/common/web/topbar.jsp" %>

  <!-- Toast Thông báo mượt mà -->
  <div id="tzToast" class="tz-toast">
    <i class="fa fa-check-circle text-success fs-5"></i>
    <div>
      <div class="fw-bold small" id="tzToastTitle">Đã thêm vào giỏ hàng</div>
      <div class="text-white-50" style="font-size: 0.78rem;" id="tzToastDesc">Sản phẩm chính hãng bảo hành 24 tháng</div>
    </div>
  </div>

  <div class="container py-4">
    <!-- Hero Banner + Thông tin khách hàng -->
    <div class="hero-banner mb-5">
      <div class="row align-items-center g-4">
        <div class="col-lg-7">
          <div class="hero-tag">
            <i class="fa fa-fire text-warning"></i> Đại tiệc công nghệ chính hãng
          </div>
          <h1 class="fw-extrabold mb-2" style="font-size: 2.3rem; font-weight: 800;">
            Xin chào, ${sessionScope.account != null ? sessionScope.account.fullName : 'Quý khách'}!
          </h1>
          <p class="mb-4 text-white-50 fs-6" style="max-width: 560px;">
            Khám phá hệ sinh thái thiết bị công nghệ cao cấp từ Apple, Sony, Samsung với ưu đãi độc quyền dành riêng cho sinh viên HCMUTE.
          </p>
          <div class="d-flex flex-wrap gap-3">
            <a href="#featuredProducts" class="btn-cta-gold">
              <i class="fa fa-bag-shopping"></i> Mua sắm ngay
            </a>
            <a href="${pageContext.request.contextPath}/admin/categories" class="btn-cta-light">
              <i class="fa fa-sliders"></i> Quản lý danh mục
            </a>
          </div>
        </div>
        <div class="col-lg-5">
          <c:if test="${sessionScope.account != null}">
            <div class="profile-glass">
              <div class="d-flex align-items-center justify-content-between mb-3 pb-2 border-bottom border-light border-opacity-25">
                <div class="d-flex align-items-center gap-2">
                  <span class="badge bg-warning text-dark fw-bold px-3 py-1 rounded-pill">Thành viên VIP</span>
                </div>
                <span class="small text-white-50">Tài khoản đã xác thực</span>
              </div>
              <div class="profile-row">
                <i class="fa fa-user"></i>
                <span>Tài khoản: <strong>${sessionScope.account.userName}</strong></span>
              </div>
              <div class="profile-row">
                <i class="fa fa-id-card"></i>
                <span>Họ và tên: <strong>${sessionScope.account.fullName}</strong></span>
              </div>
              <div class="profile-row">
                <i class="fa fa-envelope"></i>
                <span>Email: <strong>${sessionScope.account.email}</strong></span>
              </div>
              <div class="profile-row">
                <i class="fa fa-phone"></i>
                <span>Số điện thoại: <strong>${sessionScope.account.phone}</strong></span>
              </div>
            </div>
          </c:if>
        </div>
      </div>
    </div>

    <!-- Danh mục sản phẩm từ Database -->
    <div class="d-flex justify-content-between align-items-end mb-3 flex-wrap gap-2">
      <div>
        <h4 class="fw-bold mb-1">Danh mục sản phẩm</h4>
        <p class="text-muted small mb-0">Chọn danh mục bên dưới để lọc nhanh các dòng sản phẩm yêu thích</p>
      </div>
      <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-sm btn-outline-primary rounded-pill px-3 fw-semibold">
        <i class="fa fa-pen-to-square me-1"></i> Chỉnh sửa danh mục
      </a>
    </div>

    <div class="row g-3 mb-5">
      <c:forEach items="${listcate}" var="c">
        <div class="col-6 col-md-4 col-lg-2">
          <div class="cat-pill-card" onclick="filterByCategory('${c.catename}', this)">
            <div class="cat-thumb-wrap">
              <c:choose>
                <c:when test="${not empty c.icon}">
                  <img src="${pageContext.request.contextPath}/image?fname=${c.icon}" alt="${c.catename}">
                </c:when>
                <c:otherwise>
                  <img src="${pageContext.request.contextPath}/image?fname=abc.jpg" alt="${c.catename}">
                </c:otherwise>
              </c:choose>
              <span class="cat-status-dot">Sẵn hàng</span>
            </div>
            <div class="p-3 text-center">
              <div class="fw-bold text-dark small text-truncate">${c.catename}</div>
              <div class="text-muted" style="font-size: 0.75rem;">Khám phá ngay <i class="fa fa-arrow-right ms-1"></i></div>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>

    <!-- Khu vực Sản phẩm nổi bật có Tương tác Lọc & Tìm kiếm trực tiếp -->
    <div id="featuredProducts" class="pt-2">
      <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
        <div>
          <h4 class="fw-bold mb-1">Sản phẩm công nghệ nổi bật</h4>
          <p class="text-muted small mb-0">Cam kết chính hãng 100%, miễn phí giao hàng nhanh toàn quốc</p>
        </div>
        <div class="d-flex align-items-center gap-2 flex-wrap">
          <div class="input-group" style="width: 270px;">
            <span class="input-group-text bg-white border-end-0 rounded-start-pill ps-3">
              <i class="fa fa-search text-muted"></i>
            </span>
            <input type="text" id="liveSearchInput" class="form-control border-start-0 rounded-end-pill" placeholder="Tìm iPhone, MacBook, Sony..." oninput="applyProductFilter()">
          </div>
          <button class="filter-chip active" onclick="filterByCategory('ALL', this)">Tất cả</button>
        </div>
      </div>

      <div class="row g-4" id="productGrid">
        <!-- Product 1 -->
        <div class="col-sm-6 col-lg-4 col-xl-3 product-item" data-category="Điện thoại & Smartphone" data-name="iPhone 16 Pro Max 256GB Titan Tự Nhiên">
          <div class="product-card">
            <div class="product-img-box">
              <img src="${pageContext.request.contextPath}/image?fname=phone.jpg" alt="iPhone 16 Pro Max">
              <span class="badge-discount">-12%</span>
              <button class="btn-wishlist" onclick="toggleWishlist(this)" title="Yêu thích"><i class="fa fa-heart"></i></button>
            </div>
            <div class="p-3 d-flex flex-column flex-grow-1 justify-content-between">
              <div>
                <div class="text-primary fw-bold" style="font-size: 0.75rem;">Điện thoại & Smartphone</div>
                <h6 class="fw-bold mt-1 mb-2">iPhone 16 Pro Max 256GB Titan Tự Nhiên</h6>
                <div class="text-warning small mb-2">
                  <i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i>
                  <span class="text-muted ms-1">4.9</span>
                </div>
              </div>
              <div>
                <div class="d-flex align-items-baseline gap-2 mb-3">
                  <span class="product-price">31.990.000₫</span>
                  <span class="product-old-price">34.990.000₫</span>
                </div>
                <div class="d-flex gap-2">
                  <button class="btn-buy-now flex-grow-1" onclick="addToCart('iPhone 16 Pro Max 256GB', '31.990.000₫')">
                    <i class="fa fa-cart-plus me-1"></i> Thêm vào giỏ
                  </button>
                  <button class="btn btn-light border rounded-3" onclick="quickView('iPhone 16 Pro Max 256GB Titan Tự Nhiên', '31.990.000₫', 'phone.jpg', 'Chip A18 Pro 3nm cực mạnh, màn hình Super Retina XDR 6.9 inch ProMotion 120Hz, Camera 48MP Zoom quang 5x.')">
                    <i class="fa fa-eye"></i>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Product 2 -->
        <div class="col-sm-6 col-lg-4 col-xl-3 product-item" data-category="Laptop & MacBook" data-name="MacBook Pro 14 M3 Pro 18GB 512GB Space Black">
          <div class="product-card">
            <div class="product-img-box">
              <img src="${pageContext.request.contextPath}/image?fname=laptop.jpg" alt="MacBook Pro 14 M3">
              <span class="badge-discount">-10%</span>
              <button class="btn-wishlist" onclick="toggleWishlist(this)" title="Yêu thích"><i class="fa fa-heart"></i></button>
            </div>
            <div class="p-3 d-flex flex-column flex-grow-1 justify-content-between">
              <div>
                <div class="text-primary fw-bold" style="font-size: 0.75rem;">Laptop & MacBook</div>
                <h6 class="fw-bold mt-1 mb-2">MacBook Pro 14 M3 Pro 18GB 512GB</h6>
                <div class="text-warning small mb-2">
                  <i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i>
                  <span class="text-muted ms-1">5.0</span>
                </div>
              </div>
              <div>
                <div class="d-flex align-items-baseline gap-2 mb-3">
                  <span class="product-price">46.490.000₫</span>
                  <span class="product-old-price">49.990.000₫</span>
                </div>
                <div class="d-flex gap-2">
                  <button class="btn-buy-now flex-grow-1" onclick="addToCart('MacBook Pro 14 M3 Pro', '46.490.000₫')">
                    <i class="fa fa-cart-plus me-1"></i> Thêm vào giỏ
                  </button>
                  <button class="btn btn-light border rounded-3" onclick="quickView('MacBook Pro 14 M3 Pro 18GB 512GB', '46.490.000₫', 'laptop.jpg', 'Hiệu năng đồ họa đỉnh cao với chip Apple M3 Pro, màn hình Liquid Retina XDR 120Hz, thời lượng pin lên đến 18 giờ.')">
                    <i class="fa fa-eye"></i>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Product 3 -->
        <div class="col-sm-6 col-lg-4 col-xl-3 product-item" data-category="Máy tính bảng iPad" data-name="iPad Pro M4 11 inch WiFi 256GB Ultra Retina OLED">
          <div class="product-card">
            <div class="product-img-box">
              <img src="${pageContext.request.contextPath}/image?fname=ipad.jpg" alt="iPad Pro M4">
              <span class="badge-discount">-8%</span>
              <button class="btn-wishlist" onclick="toggleWishlist(this)" title="Yêu thích"><i class="fa fa-heart"></i></button>
            </div>
            <div class="p-3 d-flex flex-column flex-grow-1 justify-content-between">
              <div>
                <div class="text-primary fw-bold" style="font-size: 0.75rem;">Máy tính bảng iPad</div>
                <h6 class="fw-bold mt-1 mb-2">iPad Pro M4 11 inch WiFi 256GB OLED</h6>
                <div class="text-warning small mb-2">
                  <i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i>
                  <span class="text-muted ms-1">4.9</span>
                </div>
              </div>
              <div>
                <div class="d-flex align-items-baseline gap-2 mb-3">
                  <span class="product-price">26.890.000₫</span>
                  <span class="product-old-price">28.990.000₫</span>
                </div>
                <div class="d-flex gap-2">
                  <button class="btn-buy-now flex-grow-1" onclick="addToCart('iPad Pro M4 11 inch', '26.890.000₫')">
                    <i class="fa fa-cart-plus me-1"></i> Thêm vào giỏ
                  </button>
                  <button class="btn btn-light border rounded-3" onclick="quickView('iPad Pro M4 11 inch WiFi 256GB', '26.890.000₫', 'ipad.jpg', 'Thiết kế siêu mỏng 5.3mm, màn hình Tandem OLED rực rỡ, vi xử lý Apple M4 xử lý AI và đồ họa chuyên nghiệp.')">
                    <i class="fa fa-eye"></i>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Product 4 -->
        <div class="col-sm-6 col-lg-4 col-xl-3 product-item" data-category="Đồng hồ thông minh" data-name="Apple Watch Ultra 2 GPS + Cellular 49mm Vỏ Titan">
          <div class="product-card">
            <div class="product-img-box">
              <img src="${pageContext.request.contextPath}/image?fname=watch.jpg" alt="Apple Watch Ultra 2">
              <span class="badge-discount">-15%</span>
              <button class="btn-wishlist" onclick="toggleWishlist(this)" title="Yêu thích"><i class="fa fa-heart"></i></button>
            </div>
            <div class="p-3 d-flex flex-column flex-grow-1 justify-content-between">
              <div>
                <div class="text-primary fw-bold" style="font-size: 0.75rem;">Đồng hồ thông minh</div>
                <h6 class="fw-bold mt-1 mb-2">Apple Watch Ultra 2 49mm Vỏ Titan</h6>
                <div class="text-warning small mb-2">
                  <i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i>
                  <span class="text-muted ms-1">4.8</span>
                </div>
              </div>
              <div>
                <div class="d-flex align-items-baseline gap-2 mb-3">
                  <span class="product-price">20.490.000₫</span>
                  <span class="product-old-price">23.990.000₫</span>
                </div>
                <div class="d-flex gap-2">
                  <button class="btn-buy-now flex-grow-1" onclick="addToCart('Apple Watch Ultra 2 49mm', '20.490.000₫')">
                    <i class="fa fa-cart-plus me-1"></i> Thêm vào giỏ
                  </button>
                  <button class="btn btn-light border rounded-3" onclick="quickView('Apple Watch Ultra 2 49mm Vỏ Titan', '20.490.000₫', 'watch.jpg', 'Khung viền Titanium chuẩn hàng không vũ trụ, màn hình 3000 nits, GPS băng tần kép chính xác tuyệt đối.')">
                    <i class="fa fa-eye"></i>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Product 5 -->
        <div class="col-sm-6 col-lg-4 col-xl-3 product-item" data-category="Tai nghe & Âm thanh" data-name="Tai nghe chống ồn Sony WH-1000XM5 Hi-Res Audio">
          <div class="product-card">
            <div class="product-img-box">
              <img src="${pageContext.request.contextPath}/image?fname=audio.jpg" alt="Sony WH-1000XM5">
              <span class="badge-discount">-18%</span>
              <button class="btn-wishlist" onclick="toggleWishlist(this)" title="Yêu thích"><i class="fa fa-heart"></i></button>
            </div>
            <div class="p-3 d-flex flex-column flex-grow-1 justify-content-between">
              <div>
                <div class="text-primary fw-bold" style="font-size: 0.75rem;">Tai nghe & Âm thanh</div>
                <h6 class="fw-bold mt-1 mb-2">Tai nghe chống ồn Sony WH-1000XM5</h6>
                <div class="text-warning small mb-2">
                  <i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i>
                  <span class="text-muted ms-1">4.9</span>
                </div>
              </div>
              <div>
                <div class="d-flex align-items-baseline gap-2 mb-3">
                  <span class="product-price">6.990.000₫</span>
                  <span class="product-old-price">8.490.000₫</span>
                </div>
                <div class="d-flex gap-2">
                  <button class="btn-buy-now flex-grow-1" onclick="addToCart('Tai nghe Sony WH-1000XM5', '6.990.000₫')">
                    <i class="fa fa-cart-plus me-1"></i> Thêm vào giỏ
                  </button>
                  <button class="btn btn-light border rounded-3" onclick="quickView('Tai nghe chống ồn Sony WH-1000XM5', '6.990.000₫', 'audio.jpg', 'Công nghệ chống ồn chủ động 8 micro hàng đầu thế giới, âm thanh chuẩn Hi-Res LDAC, thời lượng pin 30 giờ.')">
                    <i class="fa fa-eye"></i>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Product 6 -->
        <div class="col-sm-6 col-lg-4 col-xl-3 product-item" data-category="Máy ảnh kỹ thuật số" data-name="Máy ảnh Sony Alpha A7M4 Full-Frame Mirrorless">
          <div class="product-card">
            <div class="product-img-box">
              <img src="${pageContext.request.contextPath}/image?fname=camera.jpg" alt="Sony Alpha A7 IV">
              <span class="badge-discount">-9%</span>
              <button class="btn-wishlist" onclick="toggleWishlist(this)" title="Yêu thích"><i class="fa fa-heart"></i></button>
            </div>
            <div class="p-3 d-flex flex-column flex-grow-1 justify-content-between">
              <div>
                <div class="text-primary fw-bold" style="font-size: 0.75rem;">Máy ảnh kỹ thuật số</div>
                <h6 class="fw-bold mt-1 mb-2">Máy ảnh Sony Alpha A7 IV Full-Frame</h6>
                <div class="text-warning small mb-2">
                  <i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i>
                  <span class="text-muted ms-1">5.0</span>
                </div>
              </div>
              <div>
                <div class="d-flex align-items-baseline gap-2 mb-3">
                  <span class="product-price">53.990.000₫</span>
                  <span class="product-old-price">58.990.000₫</span>
                </div>
                <div class="d-flex gap-2">
                  <button class="btn-buy-now flex-grow-1" onclick="addToCart('Máy ảnh Sony Alpha A7 IV', '53.990.000₫')">
                    <i class="fa fa-cart-plus me-1"></i> Thêm vào giỏ
                  </button>
                  <button class="btn btn-light border rounded-3" onclick="quickView('Máy ảnh Sony Alpha A7 IV Full-Frame', '53.990.000₫', 'camera.jpg', 'Cảm biến Exmor R CMOS Full-Frame 33MP, quay video 4K 60p 10-bit 4:2:2, lấy nét tự động theo ánh mắt thời gian thực.')">
                    <i class="fa fa-eye"></i>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Product 7 -->
        <div class="col-sm-6 col-lg-4 col-xl-3 product-item" data-category="Điện thoại & Smartphone" data-name="Samsung Galaxy S24 Ultra 5G 12GB 256GB">
          <div class="product-card">
            <div class="product-img-box">
              <img src="${pageContext.request.contextPath}/image?fname=abc.jpg" alt="Galaxy S24 Ultra">
              <span class="badge-discount">-16%</span>
              <button class="btn-wishlist" onclick="toggleWishlist(this)" title="Yêu thích"><i class="fa fa-heart"></i></button>
            </div>
            <div class="p-3 d-flex flex-column flex-grow-1 justify-content-between">
              <div>
                <div class="text-primary fw-bold" style="font-size: 0.75rem;">Điện thoại & Smartphone</div>
                <h6 class="fw-bold mt-1 mb-2">Samsung Galaxy S24 Ultra 5G 256GB</h6>
                <div class="text-warning small mb-2">
                  <i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i>
                  <span class="text-muted ms-1">4.9</span>
                </div>
              </div>
              <div>
                <div class="d-flex align-items-baseline gap-2 mb-3">
                  <span class="product-price">27.990.000₫</span>
                  <span class="product-old-price">33.990.000₫</span>
                </div>
                <div class="d-flex gap-2">
                  <button class="btn-buy-now flex-grow-1" onclick="addToCart('Samsung Galaxy S24 Ultra 5G', '27.990.000₫')">
                    <i class="fa fa-cart-plus me-1"></i> Thêm vào giỏ
                  </button>
                  <button class="btn btn-light border rounded-3" onclick="quickView('Samsung Galaxy S24 Ultra 5G 256GB', '27.990.000₫', 'abc.jpg', 'Quyền năng Galaxy AI tích hợp bút S-Pen, khung viền Titanium bền bỉ cùng Camera mắt thần bóng đêm 200MP.')">
                    <i class="fa fa-eye"></i>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Product 8 -->
        <div class="col-sm-6 col-lg-4 col-xl-3 product-item" data-category="Laptop & MacBook" data-name="MacBook Air 15 inch M3 16GB 512GB Midnight">
          <div class="product-card">
            <div class="product-img-box">
              <img src="${pageContext.request.contextPath}/image?fname=laptop.jpg" alt="MacBook Air M3">
              <span class="badge-discount">-11%</span>
              <button class="btn-wishlist" onclick="toggleWishlist(this)" title="Yêu thích"><i class="fa fa-heart"></i></button>
            </div>
            <div class="p-3 d-flex flex-column flex-grow-1 justify-content-between">
              <div>
                <div class="text-primary fw-bold" style="font-size: 0.75rem;">Laptop & MacBook</div>
                <h6 class="fw-bold mt-1 mb-2">MacBook Air 15 M3 16GB 512GB Midnight</h6>
                <div class="text-warning small mb-2">
                  <i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i>
                  <span class="text-muted ms-1">4.9</span>
                </div>
              </div>
              <div>
                <div class="d-flex align-items-baseline gap-2 mb-3">
                  <span class="product-price">34.490.000₫</span>
                  <span class="product-old-price">38.990.000₫</span>
                </div>
                <div class="d-flex gap-2">
                  <button class="btn-buy-now flex-grow-1" onclick="addToCart('MacBook Air 15 M3 16GB', '34.490.000₫')">
                    <i class="fa fa-cart-plus me-1"></i> Thêm vào giỏ
                  </button>
                  <button class="btn btn-light border rounded-3" onclick="quickView('MacBook Air 15 M3 16GB 512GB', '34.490.000₫', 'laptop.jpg', 'Mỏng nhẹ ấn tượng cùng màn hình Liquid Retina 15.3 inch rộng rãi, RAM 16GB đa nhiệm mượt mà mọi tác vụ.')">
                    <i class="fa fa-eye"></i>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Nút Giỏ hàng nổi -->
  <div class="floating-cart" onclick="showCartSummary()">
    <i class="fa fa-bag-shopping fs-5"></i>
    <span class="fw-bold small">Giỏ hàng của bạn</span>
    <span class="cart-count-badge" id="cartCount">2</span>
  </div>

  <!-- Modal Xem nhanh sản phẩm -->
  <div class="modal fade" id="quickViewModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content border-0 shadow-lg" style="border-radius: 22px; overflow: hidden;">
        <div class="modal-header border-0 pb-0">
          <h5 class="modal-title fw-bold" id="qvTitle">Chi tiết sản phẩm</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <img id="qvImg" src="" alt="" class="w-100 rounded-4 mb-3" style="height: 240px; object-fit: cover;">
          <div class="d-flex justify-content-between align-items-center mb-2">
            <span class="fs-4 fw-extrabold text-danger fw-bold" id="qvPrice"></span>
            <span class="badge bg-success-subtle text-success rounded-pill px-3 py-2">Còn hàng tại cửa hàng</span>
          </div>
          <p class="text-muted small mb-0" id="qvDesc"></p>
        </div>
        <div class="modal-footer border-0 pt-0">
          <button type="button" class="btn btn-light rounded-3" data-bs-dismiss="modal">Đóng</button>
          <button type="button" class="btn-buy-now px-4" id="qvAddBtn">
            <i class="fa fa-cart-plus me-1"></i> Đặt mua ngay
          </button>
        </div>
      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    let currentCategory = 'ALL';
    let cartItems = 2;

    function showToast(title, desc) {
      const toast = document.getElementById('tzToast');
      document.getElementById('tzToastTitle').textContent = title;
      document.getElementById('tzToastDesc').textContent = desc;
      toast.classList.add('show');
      clearTimeout(window.tzToastTimer);
      window.tzToastTimer = setTimeout(() => toast.classList.remove('show'), 2600);
    }

    function addToCart(name, price) {
      cartItems++;
      document.getElementById('cartCount').textContent = cartItems;
      showToast('Đã thêm ' + name, 'Giá ưu đãi: ' + price + ' • Giao nhanh 2h');
    }

    function toggleWishlist(btn) {
      btn.classList.toggle('liked');
      if (btn.classList.contains('liked')) {
        showToast('Đã lưu vào danh sách yêu thích', 'Bạn có thể xem lại sản phẩm bất cứ lúc nào');
      }
    }

    function filterByCategory(categoryName, el) {
      currentCategory = categoryName;
      document.querySelectorAll('.cat-pill-card, .filter-chip').forEach(c => c.classList.remove('active'));
      if (el) el.classList.add('active');
      applyProductFilter();
      document.getElementById('featuredProducts').scrollIntoView({ behavior: 'smooth', block: 'start' });
    }

    function applyProductFilter() {
      const keyword = (document.getElementById('liveSearchInput').value || '').toLowerCase().trim();
      const items = document.querySelectorAll('.product-item');
      items.forEach(item => {
        const cat = item.getAttribute('data-category') || '';
        const name = (item.getAttribute('data-name') || '').toLowerCase();
        const matchCat = (currentCategory === 'ALL') || (cat === currentCategory);
        const matchKey = !keyword || name.includes(keyword) || cat.toLowerCase().includes(keyword);
        item.style.display = (matchCat && matchKey) ? '' : 'none';
      });
    }

    function quickView(title, price, imgFile, desc) {
      document.getElementById('qvTitle').textContent = title;
      document.getElementById('qvPrice').textContent = price;
      document.getElementById('qvImg').src = '${pageContext.request.contextPath}/image?fname=' + imgFile;
      document.getElementById('qvDesc').textContent = desc;
      const btn = document.getElementById('qvAddBtn');
      btn.onclick = function() {
        addToCart(title, price);
        bootstrap.Modal.getInstance(document.getElementById('quickViewModal')).hide();
      };
      new bootstrap.Modal(document.getElementById('quickViewModal')).show();
    }

    function showCartSummary() {
      showToast('Giỏ hàng hiện có ' + cartItems + ' sản phẩm', 'Miễn phí vận chuyển cho tài khoản sinh viên HCMUTE');
    }
  </script>
</body>
</html>
