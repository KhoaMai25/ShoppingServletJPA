package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
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

@SuppressWarnings("serial")
@WebServlet(urlPatterns = {"/verify-otp"})
public class VerifyCodeController extends HttpServlet {
    private IUserService userService = new UserServiceImpl();

    private void clearRememberCookie(HttpServletRequest req, HttpServletResponse resp) {
        Cookie cookie = new Cookie(Constant.COOKIE_REMEMBER, "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        resp.addCookie(cookie);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String username = (session != null) ? (String) session.getAttribute("pendingUsername") : null;
        if (username != null) {
            User u = userService.get(username);
            if (u != null) {
                req.setAttribute("pendingUser", u);
            }
        }
        req.getRequestDispatcher(Constant.Path.VERIFY_OTP).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(true);
        clearRememberCookie(req, resp);

        String action = req.getParameter("action");
        String username = req.getParameter("username");
        if (username == null || username.trim().isEmpty()) {
            username = (String) session.getAttribute("pendingUsername");
        }
        String email = req.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            email = (String) session.getAttribute("pendingEmail");
        }

        User user = null;
        if (username != null && !username.isBlank()) {
            user = userService.get(username.trim());
        }
        if (user == null && email != null && !email.isBlank()) {
            user = userService.findByEmail(email.trim());
        }

        // Bước 1: Xác nhận địa chỉ Email & Tạo mã OTP gửi đến Email
        if ("sendOtp".equals(action) || "resend".equals(action)) {
            if (user != null) {
                if (email != null && !email.isBlank()) {
                    user.setEmail(email.trim());
                }
                String newOtp = EmailUtils.getRandom();
                user.setCode(newOtp);
                userService.update(user);
                EmailUtils.sendOtpEmail(user.getEmail(), user.getFullName(), newOtp, "Kích hoạt tài khoản");

                session.setAttribute("pendingUsername", user.getUserName());
                session.setAttribute("pendingEmail", user.getEmail());
                session.setAttribute("otpSentToast", "Mã OTP đã được tạo và gửi tới " + user.getEmail());
                req.setAttribute("pendingUser", user);
            } else {
                req.setAttribute("alert", "Không tìm thấy tài khoản cần xác nhận!");
            }
            req.getRequestDispatcher(Constant.Path.VERIFY_OTP).forward(req, resp);
            return;
        }

        // Bước 2: Kiểm tra mã OTP người dùng nhập vào
        String otp = req.getParameter("otp");
        if (otp == null || otp.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập mã xác nhận OTP gồm 6 chữ số!");
            req.setAttribute("pendingUser", user);
            req.getRequestDispatcher(Constant.Path.VERIFY_OTP).forward(req, resp);
            return;
        }

        if (user != null && user.getCode() != null && user.getCode().trim().equals(otp.trim())) {
            user.setStatus(1);
            user.setCode(null);
            userService.update(user);

            session.removeAttribute("pendingUsername");
            session.removeAttribute("pendingEmail");
            session.setAttribute("username", user.getUserName());
            session.setAttribute("account", user);
            resp.sendRedirect(req.getContextPath() + "/home");
        } else {
            req.setAttribute("alert", "Mã xác thực OTP không chính xác. Vui lòng kiểm tra lại!");
            req.setAttribute("pendingUser", user);
            req.getRequestDispatcher(Constant.Path.VERIFY_OTP).forward(req, resp);
        }
    }
}
