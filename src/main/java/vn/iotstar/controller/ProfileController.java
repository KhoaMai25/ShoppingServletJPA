package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.util.Map;
import vn.iotstar.entity.User;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.CloudinaryUtils;
import vn.iotstar.util.EmailUtils;
import vn.iotstar.util.ValidationUtils;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 25
)
@WebServlet(urlPatterns = {"/profile", "/profile/verify-email"})
public class ProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private IUserService userService = new UserServiceImpl();

    private User resolveCurrentUser(HttpServletRequest req) {
        HttpSession session = req.getSession(true);
        User current = (User) session.getAttribute("account");
        if (current != null) {
            User fresh = userService.get(current.getUserName());
            if (fresh != null) {
                session.setAttribute("account", fresh);
                return fresh;
            }
            return current;
        }
        User defaultUser = userService.get("AnhPha");
        if (defaultUser != null) {
            session.setAttribute("account", defaultUser);
            session.setAttribute("username", defaultUser.getUserName());
        }
        return defaultUser;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        User user = resolveCurrentUser(req);
        req.setAttribute("userProfile", user);
        req.getRequestDispatcher("/views/web/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String url = req.getRequestURI();
        HttpSession session = req.getSession(true);
        User user = resolveCurrentUser(req);

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Xác thực OTP khi đổi sang địa chỉ Email mới
        if (url.contains("/profile/verify-email")) {
            String action = req.getParameter("action");
            String pendingNewEmail = (String) session.getAttribute("pendingNewEmail");

            if ("cancel".equals(action)) {
                session.removeAttribute("pendingNewEmail");
                user.setCode(null);
                userService.update(user);
                session.setAttribute("account", user);
                resp.sendRedirect(req.getContextPath() + "/profile");
                return;
            }

            if ("resend".equals(action)) {
                if (pendingNewEmail != null && !pendingNewEmail.isBlank()) {
                    String newOtp = EmailUtils.getRandom();
                    user.setCode(newOtp);
                    userService.update(user);
                    EmailUtils.sendOtpEmail(pendingNewEmail, user.getFullName(), newOtp, "Xác nhận cập nhật Email mới");
                    session.setAttribute("profileToast", "Đã gửi lại mã OTP tới email mới: " + pendingNewEmail);
                }
                resp.sendRedirect(req.getContextPath() + "/profile");
                return;
            }

            String otp = req.getParameter("otp");
            if (otp == null || !otp.trim().matches("^[0-9]{6}$")) {
                req.setAttribute("otpError", "Mã OTP phải gồm đúng 6 chữ số.");
                req.setAttribute("userProfile", user);
                req.getRequestDispatcher("/views/web/profile.jsp").forward(req, resp);
                return;
            }

            if (pendingNewEmail != null && user.getCode() != null && user.getCode().trim().equals(otp.trim())) {
                user.setEmail(pendingNewEmail.trim());
                user.setCode(null);
                userService.update(user);
                session.removeAttribute("pendingNewEmail");
                session.setAttribute("account", user);
                session.setAttribute("profileToast", "Xác nhận OTP thành công! Email mới đã được cập nhật thành " + user.getEmail());
                resp.sendRedirect(req.getContextPath() + "/profile");
            } else {
                req.setAttribute("otpError", "Mã xác nhận OTP không chính xác. Vui lòng kiểm tra lại hộp thư email mới!");
                req.setAttribute("userProfile", user);
                req.getRequestDispatcher("/views/web/profile.jsp").forward(req, resp);
            }
            return;
        }

        // Cập nhật Hồ sơ User: fullname, phone, email, images (Multipart Cloudinary)
        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");
        String newEmail = req.getParameter("email");
        String avatarSample = req.getParameter("avatarSample");

        Map<String, String> errors = ValidationUtils.validateProfileForm(fullname, phone, newEmail);
        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.setAttribute("userProfile", user);
            req.setAttribute("alert", "Vui lòng kiểm tra lại thông tin hồ sơ chưa hợp lệ!");
            req.getRequestDispatcher("/views/web/profile.jsp").forward(req, resp);
            return;
        }

        user.setFullName(fullname.trim());
        user.setPhone(phone.trim());

        // Upload ảnh đại diện qua Multipart lên Cloudinary
        try {
            Part imagePart = req.getPart("imageFile");
            if (imagePart != null && imagePart.getSize() > 0) {
                String uploadedUrlOrFile = CloudinaryUtils.uploadMultipartImage(imagePart);
                if (uploadedUrlOrFile != null) {
                    user.setAvatar(uploadedUrlOrFile);
                }
            } else if (avatarSample != null && !avatarSample.isBlank()) {
                user.setAvatar(avatarSample.trim());
            }
        } catch (Exception ignored) {
        }

        String currentEmail = user.getEmail() != null ? user.getEmail().trim() : "";
        String requestedEmail = newEmail.trim();

        // Nếu người dùng thay đổi sang một địa chỉ Email mới -> Gửi OTP đến Email mới để xác nhận
        if (!requestedEmail.equalsIgnoreCase(currentEmail)) {
            User existingWithEmail = userService.findByEmail(requestedEmail);
            if (existingWithEmail != null && existingWithEmail.getId() != user.getId()) {
                errors.put("email", "Địa chỉ Email mới này đã thuộc về một tài khoản khác.");
                req.setAttribute("errors", errors);
                req.setAttribute("userProfile", user);
                req.setAttribute("alert", "Email mới đã được sử dụng bởi tài khoản khác!");
                req.getRequestDispatcher("/views/web/profile.jsp").forward(req, resp);
                return;
            }

            String otpCode = EmailUtils.getRandom();
            user.setCode(otpCode);
            userService.update(user);
            session.setAttribute("account", user);

            EmailUtils.sendOtpEmail(requestedEmail, user.getFullName(), otpCode, "Xác nhận cập nhật địa chỉ Email mới");
            session.setAttribute("pendingNewEmail", requestedEmail);
            session.setAttribute("profileToast", "Đã cập nhật Họ tên, SĐT & Ảnh. Mã OTP xác nhận đã được gửi tới email mới: " + requestedEmail);
            resp.sendRedirect(req.getContextPath() + "/profile");
            return;
        }

        userService.update(user);
        session.setAttribute("account", user);
        session.setAttribute("profileToast", "Cập nhật thông tin hồ sơ cá nhân thành công!");
        resp.sendRedirect(req.getContextPath() + "/profile");
    }
}
