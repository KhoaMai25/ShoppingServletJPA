package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import vn.iotstar.entity.User;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.Constant;
import vn.iotstar.util.EmailUtils;
import vn.iotstar.util.PasswordUtils;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = {"/forgot-password", "/reset-password"})
public class ForgotPasswordController extends HttpServlet {
    private IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String url = req.getRequestURI();
        if (url.contains("/reset-password")) {
            req.getRequestDispatcher(Constant.Path.RESET_PASSWORD).forward(req, resp);
        } else {
            req.getRequestDispatcher(Constant.Path.FORGOT_PASSWORD).forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String url = req.getRequestURI();
        HttpSession session = req.getSession(true);

        if (url.contains("/forgot-password")) {
            String emailOrUser = req.getParameter("email");
            if (emailOrUser == null || emailOrUser.trim().isEmpty()) {
                req.setAttribute("alert", "Vui lòng nhập địa chỉ Email hoặc Tên đăng nhập!");
                req.getRequestDispatcher(Constant.Path.FORGOT_PASSWORD).forward(req, resp);
                return;
            }

            User user = userService.findByEmail(emailOrUser.trim());
            if (user == null) {
                user = userService.get(emailOrUser.trim());
            }

            if (user == null) {
                req.setAttribute("alert", "Không tìm thấy tài khoản nào khớp với thông tin bạn nhập!");
                req.getRequestDispatcher(Constant.Path.FORGOT_PASSWORD).forward(req, resp);
                return;
            }

            String otpCode = EmailUtils.getRandom();
            user.setCode(otpCode);
            userService.update(user);
            EmailUtils.sendOtpEmail(user.getEmail(), user.getFullName(), otpCode, "Khôi phục mật khẩu");

            session.setAttribute("resetEmail", user.getEmail());
            session.setAttribute("resetUsername", user.getUserName());
            session.setAttribute("otpSentToast", "Mã OTP đã được tạo và gửi tới " + user.getEmail());
            resp.sendRedirect(req.getContextPath() + "/reset-password");
            return;
        }

        if (url.contains("/reset-password")) {
            String resetEmail = (String) session.getAttribute("resetEmail");
            String otp = req.getParameter("otp");
            String newPassword = req.getParameter("newPassword");
            String confirmPassword = req.getParameter("confirmPassword");

            if (otp == null || otp.trim().isEmpty() || newPassword == null || newPassword.trim().isEmpty()) {
                req.setAttribute("alert", "Vui lòng nhập đầy đủ mã OTP và mật khẩu mới!");
                req.getRequestDispatcher(Constant.Path.RESET_PASSWORD).forward(req, resp);
                return;
            }

            if (confirmPassword != null && !newPassword.equals(confirmPassword)) {
                req.setAttribute("alert", "Mật khẩu xác nhận không khớp!");
                req.getRequestDispatcher(Constant.Path.RESET_PASSWORD).forward(req, resp);
                return;
            }

            User user = null;
            if (resetEmail != null) {
                user = userService.findByEmail(resetEmail);
            }
            if (user == null) {
                String uname = req.getParameter("username");
                if (uname != null) {
                    user = userService.get(uname.trim());
                }
            }

            if (user != null && user.getCode() != null && user.getCode().trim().equals(otp.trim())) {
                user.setPassWord(PasswordUtils.hashPassword(newPassword.trim()));
                user.setCode(null);
                user.setStatus(1);
                userService.update(user);
                session.setAttribute("flashSuccess", "Đặt lại mật khẩu mới thành công! Mời bạn đăng nhập.");
                resp.sendRedirect(req.getContextPath() + "/login");
            } else {
                req.setAttribute("alert", "Mã xác nhận OTP không đúng hoặc đã hết hạn!");
                req.getRequestDispatcher(Constant.Path.RESET_PASSWORD).forward(req, resp);
            }
        }
    }
}
