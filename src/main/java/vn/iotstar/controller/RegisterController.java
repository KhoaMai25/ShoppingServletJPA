package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;
import vn.iotstar.entity.User;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.Constant;
import vn.iotstar.util.PasswordUtils;
import vn.iotstar.util.ValidationUtils;

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

        Map<String, String> errors = ValidationUtils.validateRegister(username, password, fullname, email, phone);
        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.setAttribute("oldUsername", username);
            req.setAttribute("oldFullname", fullname);
            req.setAttribute("oldEmail", email);
            req.setAttribute("oldPhone", phone);
            req.setAttribute("alert", "Vui lòng kiểm tra lại các trường thông tin chưa hợp lệ!");
            req.getRequestDispatcher(Constant.Path.REGISTER).forward(req, resp);
            return;
        }

        username = username.trim();
        email = email.trim();
        fullname = fullname.trim();
        phone = phone.trim();

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
            errors.put("email", "Email này đã tồn tại trên hệ thống.");
            req.setAttribute("errors", errors);
            req.setAttribute("oldUsername", username);
            req.setAttribute("oldFullname", fullname);
            req.setAttribute("oldEmail", email);
            req.setAttribute("oldPhone", phone);
            req.setAttribute("alert", "Email đã tồn tại trên hệ thống!");
            req.getRequestDispatcher(Constant.Path.REGISTER).forward(req, resp);
            return;
        }

        if (service.checkExistUsername(username)) {
            errors.put("username", "Tên đăng nhập này đã được sử dụng.");
            req.setAttribute("errors", errors);
            req.setAttribute("oldUsername", username);
            req.setAttribute("oldFullname", fullname);
            req.setAttribute("oldEmail", email);
            req.setAttribute("oldPhone", phone);
            req.setAttribute("alert", "Tên đăng nhập đã tồn tại!");
            req.getRequestDispatcher(Constant.Path.REGISTER).forward(req, resp);
            return;
        }

        boolean isSuccess = service.registerWithOtp(username, password, email, fullname, phone, null);
        if (isSuccess) {
            HttpSession session = req.getSession(true);
            session.removeAttribute("account");
            session.setAttribute("resetUsername", username);
            session.setAttribute("flashSuccess", "Đăng ký thành công! Vui lòng đăng nhập lại để xác nhận email và nhận mã OTP kích hoạt.");
            resp.sendRedirect(req.getContextPath() + "/login");
        } else {
            req.setAttribute("alert", "Có lỗi hệ thống xảy ra khi tạo tài khoản!");
            req.getRequestDispatcher(Constant.Path.REGISTER).forward(req, resp);
        }
    }
}
