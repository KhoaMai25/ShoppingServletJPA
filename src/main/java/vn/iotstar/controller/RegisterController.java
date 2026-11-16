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
import vn.iotstar.util.PasswordUtils;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = "/register")
public class RegisterController extends HttpServlet {
    private IUserService service = new UserServiceImpl();

    private void clearRememberCookie(HttpServletRequest req, HttpServletResponse resp) {
        Cookie cookie = new Cookie(Constant.COOKIE_REMEMBER, "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        resp.addCookie(cookie);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.removeAttribute("account");
            session.removeAttribute("username");
        }
        clearRememberCookie(req, resp);
        req.getRequestDispatcher(Constant.Path.REGISTER).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setCharacterEncoding("UTF-8");
        req.setCharacterEncoding("UTF-8");

        clearRememberCookie(req, resp);

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String email = req.getParameter("email");
        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");

        String alertMsg = "";

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty() || email == null || email.trim().isEmpty()) {
            alertMsg = "Vui lòng nhập đầy đủ thông tin bắt buộc!";
            req.setAttribute("alert", alertMsg);
            req.getRequestDispatcher(Constant.Path.REGISTER).forward(req, resp);
            return;
        }

        username = username.trim();
        email = email.trim();

        // Nếu tài khoản thử nghiệm (khác AnhPha) đăng ký lại, cập nhật trạng thái chờ xác nhận email & OTP
        User existingByEmail = service.findByEmail(email);
        User existingByUser = service.get(username);
        if ((existingByEmail != null && !"AnhPha".equalsIgnoreCase(existingByEmail.getUserName()))
                || (existingByUser != null && !"AnhPha".equalsIgnoreCase(existingByUser.getUserName()))) {
            User target = existingByEmail != null ? existingByEmail : existingByUser;
            target.setUserName(username);
            target.setEmail(email);
            target.setFullName(fullname);
            target.setPhone(phone);
            target.setPassWord(PasswordUtils.hashPassword(password));
            target.setCode(null);
            target.setStatus(0);
            service.update(target);

            HttpSession session = req.getSession(true);
            session.removeAttribute("account");
            session.setAttribute("resetUsername", username);
            session.setAttribute("flashSuccess", "Đăng ký thành công! Vui lòng đăng nhập lại để xác nhận email và nhận mã OTP kích hoạt.");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if (service.checkExistEmail(email)) {
            alertMsg = "Email đã tồn tại trên hệ thống!";
            req.setAttribute("alert", alertMsg);
            req.getRequestDispatcher(Constant.Path.REGISTER).forward(req, resp);
            return;
        }

        if (service.checkExistUsername(username)) {
            alertMsg = "Tên đăng nhập đã tồn tại!";
            req.setAttribute("alert", alertMsg);
            req.getRequestDispatcher(Constant.Path.REGISTER).forward(req, resp);
            return;
        }

        // Lưu tài khoản ở trạng thái chưa kích hoạt (status = 0), yêu cầu đăng nhập lại để xác nhận email & tạo OTP
        boolean isSuccess = service.registerWithOtp(username, password, email, fullname, phone, null);
        if (isSuccess) {
            HttpSession session = req.getSession(true);
            session.removeAttribute("account");
            session.setAttribute("resetUsername", username);
            session.setAttribute("flashSuccess", "Đăng ký thành công! Vui lòng đăng nhập lại để xác nhận email và nhận mã OTP kích hoạt.");
            resp.sendRedirect(req.getContextPath() + "/login");
        } else {
            alertMsg = "Có lỗi hệ thống xảy ra khi tạo tài khoản!";
            req.setAttribute("alert", alertMsg);
            req.getRequestDispatcher(Constant.Path.REGISTER).forward(req, resp);
        }
    }
}
