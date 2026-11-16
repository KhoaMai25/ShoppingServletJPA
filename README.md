# ShoppingServletJPA - Bài tập 02 (12/11/2026) | Lập Trình Web (WEBPR330479)

**Sinh viên thực hiện:** Mai Anh Khoa  
**MSSV:** 24110027  
**Lớp:** Lập trình Web - Nhóm 10 (HCMUTE)  
**Giảng viên hướng dẫn:** ThS. Nguyễn Hữu Trung  

---

## 1. Giới thiệu đề tài & Công nghệ áp dụng
Bài tập 02 nâng cấp toàn bộ nội dung Bài tập 01 từ JDBC thuần sang **JPA 3.0 (Jakarta Persistence API) & Hibernate 6.6.1**:
- **Jakarta Servlet 6.0 & Jakarta Server Pages (JSP) 3.1 & JSTL 3.0**
- **Hibernate Core 6.6.1.Final** (ORM JPA Provider) & **Hibernate Validator 8.0.1**
- **Kiến trúc 3 tầng (3-Tier) & MVC 2**:
  - **Entity Layer:** `Category`, `Video`, `User` với các annotation JPA `@Entity`, `@Table`, `@Id`, `@GeneratedValue`, `@OneToMany`, `@ManyToOne`, `@NamedQuery`.
  - **DAO Layer:** `ICategoryDao`, `CategoryDao`, `IUserDao`, `UserDao` sử dụng `EntityManager`, `EntityTransaction`, `TypedQuery`, `JPQL`.
  - **Service Layer:** `ICategoryService`, `CategoryServiceImpl`, `IUserService`, `UserServiceImpl`.
  - **Controller Layer:** `LoginController`, `RegisterController`, `WaitingController`, `LogoutController`, `HomeController`, `DownloadImageController` và `CategoryController`.
  - **View Layer:** JSP kết hợp CSS Bootstrap 3.4 & FontAwesome.
- **Tính năng hoàn chỉnh:**
  1. **Login với Session & Cookie (Remember Me)**, bảo mật mật khẩu.
  2. **Register tài khoản** có kiểm tra trùng lặp email, username, phone.
  3. **WaitingController** phân quyền chuyển trang tự động theo vai trò (Admin -> `/admin/categories`, User -> `/home`).
  4. **CRUD Category bằng JPA**: Xem danh sách (`/admin/categories`), Thêm (`/admin/category/add`), Sửa (`/admin/category/edit`), Xóa (`/admin/category/delete`), Upload ảnh đại diện.
  5. **Cấu hình & Test JPA**: Chạy thành công class `Test.java` tự động sinh bảng DDL (`categories`, `videos`, `users`) và ghi dữ liệu mẫu.

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
│   │   └── impl/
│   │       ├── CategoryDao.java
│   │       └── UserDao.java
│   ├── service/
│   │   ├── ICategoryService.java
│   │   ├── IUserService.java
│   │   └── impl/
│   │       ├── CategoryServiceImpl.java
│   │       └── UserServiceImpl.java
│   ├── controller/
│   │   ├── LoginController.java
│   │   ├── RegisterController.java
│   │   ├── WaitingController.java
│   │   ├── LogoutController.java
│   │   ├── HomeController.java
│   │   ├── DownloadImageController.java
│   │   └── admin/
│   │       └── CategoryController.java
│   └── util/
│       └── Constant.java
├── src/main/resources/
│   └── META-INF/
│       └── persistence.xml
├── src/main/webapp/
│   ├── WEB-INF/
│   │   └── web.xml
│   ├── common/
│   │   └── web/
│   │       └── topbar.jsp
│   ├── views/
│   │   ├── login.jsp
│   │   ├── register.jsp
│   │   ├── web/
│   │   │   └── home.jsp
│   │   └── admin/
│   │       ├── category-list.jsp
│   │       ├── category-add.jsp
│   │       └── category-edit.jsp
│   └── index.jsp
├── pom.xml
└── README.md
```

---

## 3. Thông tin tài khoản quản trị
| Họ và tên | Username | Password | Email | Số điện thoại |
| :--- | :--- | :--- | :--- | :--- |
| **Mai Anh Khoa** | `AnhPha` | `123456` | `24110027@student.hcmute.edu.vn` | `0837707462` |
