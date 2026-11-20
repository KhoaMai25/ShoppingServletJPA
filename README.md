# ShoppingServletJPA - Lập Trình Web (WEBPR330479)

**Sinh viên thực hiện:** Mai Anh Khoa  
**MSSV:** 24110027  
**Email:** 24110027@student.hcmute.edu.vn  
**Số điện thoại:** 0837707462  
**Lớp:** Lập trình Web - Nhóm 10 (HCMUTE)  
**Giảng viên hướng dẫn:** ThS. Nguyễn Hữu Trung  

---

## 1. Giới thiệu đề tài & Công nghệ áp dụng
Dự án xây dựng hệ thống thương mại điện tử & kênh Video đánh giá công nghệ **TechZone Store** sử dụng **Jakarta Persistence API (JPA 3.0) & Hibernate 6.6.1**:
- **Jakarta Servlet 6.0, JSP 3.1, JSTL 3.0 & Jakarta Mail 2.1**
- **Hibernate Core 6.6.1.Final** (ORM JPA Provider) & **Hibernate Validator 8.0.1**
- **Các chức năng hoàn chỉnh theo yêu cầu bài tập:**
  1. **Kích hoạt tài khoản bằng OTP qua Email khi đăng ký (`/register` -> `/verify-otp`)**: Sinh mã OTP 6 chữ số ngẫu nhiên, gửi qua Email và xác thực kích hoạt tài khoản (`status = 1`).
  2. **Đăng nhập với mật khẩu mã hóa SHA-256 (`/login`) & Đăng xuất (`/logout`)**: Toàn bộ mật khẩu được băm bằng thuật toán `SHA-256` (`PasswordUtils`), hỗ trợ Session và Cookie (`Remember Me` chuẩn URL-encoded).
  3. **Quên mật khẩu gửi mã xác nhận OTP qua Email (`/forgot-password` -> `/reset-password`)**: Xác thực OTP qua email và đặt lại mật khẩu mới được mã hóa `SHA-256`.
  4. **Quản lý bảng `Videos` với mối liên hệ `1-n` với bảng `users` và `categories`**:
     - **4.1. CRUD cho bảng `Videos`**: Xem danh sách, tìm kiếm (`/admin/videos`), thêm mới (`/admin/video/add`), cập nhật (`/admin/video/edit`), xóa (`/admin/video/delete`).
     - **4.2. Hiển thị 10 video mới nhất lên trang chủ (`/home`)**.
     - **4.3. Hiển thị tất cả videos của user và phân trang 6 sản phẩm/trang trên URL `/video`**.
     - **4.4. Hiển thị chi tiết và phát (play) 01 video (`/video/detail?id=...`)** khi bấm chuột vào tiêu đề của video trên `/home` và `/video` (hỗ trợ streaming `HTTP 206 Partial Content`).
     - **4.5. Upload file bằng Multipart (`@MultipartConfig`)**: Tải ảnh đại diện danh mục, Poster video, tệp MP4 và servlet mẫu `/multiPartServlet`.
  5. **Cấu hình SiteMesh Decorator 3 với Template Bootstrap 5 (`sitemesh3.xml`, `web.jsp`, `admin.jsp`)**:
     - Quản lý bố cục giao diện đồng nhất với `ConfigurableSiteMeshFilter` (`header.jsp`, `topbar.jsp`, `footer.jsp`).
  6. **Validation toàn diện cho tất cả các FORM (`login`, `register`, `forgetpassword`, `insert`, `edit`, `profile`)**:
     - Kiểm tra hợp lệ dữ liệu cả phía Server (`ValidationUtils` & Jakarta Bean Validation) và phía Client (`Bootstrap 5 Form Validation`).
  7. **Quản lý Hồ sơ cá nhân User (`/profile`, `/profile/verify-email`) với SiteMesh Decorator 3**:
     - Cập nhật `fullname`, `phone`, tải ảnh đại diện (`images`) lên **Cloudinary bằng Multipart** (`CloudinaryUtils`).
     - Khi đổi sang **Email mới**, hệ thống tự động gửi mã **OTP 6 chữ số đến Email mới** để xác nhận thành công trước khi cập nhật.

---

## 2. Cấu trúc thư mục dự án
```text
ShoppingServletJPA/
├── src/main/java/vn/iotstar/
│   ├── config/
│   │   ├── JpaConfig.java
│   │   ├── Test.java
│   │   ├── DBInit.java
│   │   └── AppContextListener.java
│   ├── entity/
│   │   ├── Category.java
│   │   ├── Video.java
│   │   └── User.java
│   ├── dao/
│   │   ├── ICategoryDao.java
│   │   ├── IUserDao.java
│   │   ├── IVideoDao.java
│   │   └── impl/
│   │       ├── CategoryDao.java
│   │       ├── UserDao.java
│   │       └── VideoDao.java
│   ├── service/
│   │   ├── ICategoryService.java
│   │   ├── IUserService.java
│   │   ├── IVideoService.java
│   │   └── impl/
│   │       ├── CategoryServiceImpl.java
│   │       ├── UserServiceImpl.java
│   │       └── VideoServiceImpl.java
│   ├── controller/
│   │   ├── LoginController.java
│   │   ├── RegisterController.java
│   │   ├── VerifyCodeController.java
│   │   ├── ForgotPasswordController.java
│   │   ├── WaitingController.java
│   │   ├── LogoutController.java
│   │   ├── HomeController.java
│   │   ├── VideoWebController.java
│   │   ├── DownloadImageController.java
│   │   └── admin/
│   │       ├── CategoryController.java
│   │       ├── VideoController.java
│   │       └── UserController.java
│   ├── util/
│   │   ├── Constant.java
│   │   ├── EmailUtils.java
│   │   └── PasswordUtils.java
│   └── utils/
│       ├── Constants.java
│       └── MultipartServlet.java
├── src/main/resources/
│   ├── META-INF/
│   │   └── persistence.xml
│   └── sample-images/
├── src/main/webapp/
│   ├── WEB-INF/
│   │   └── web.xml
│   ├── common/web/
│   │   └── topbar.jsp
│   ├── views/
│   │   ├── login.jsp
│   │   ├── register.jsp
│   │   ├── verify-otp.jsp
│   │   ├── forgot-password.jsp
│   │   ├── reset-password.jsp
│   │   ├── upload.jsp
│   │   ├── result.jsp
│   │   ├── web/
│   │   │   ├── home.jsp
│   │   │   ├── video-list.jsp
│   │   │   └── video-detail.jsp
│   │   └── admin/
│   │       ├── category-list.jsp
│   │       ├── category-add.jsp
│   │       ├── category-edit.jsp
│   │       ├── video-list.jsp
│   │       ├── video-add.jsp
│   │       ├── video-edit.jsp
│   │       └── user-list.jsp
│   └── index.jsp
├── pom.xml
└── README.md
```

---

## 3. Thông tin tài khoản quản trị mặc định
| Họ và tên | Username | Password | Email | Số điện thoại |
| :--- | :--- | :--- | :--- | :--- |
| **Mai Anh Khoa** | `AnhPha` | `123456` | `24110027@student.hcmute.edu.vn` | `0837707462` |
