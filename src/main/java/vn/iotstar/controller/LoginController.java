package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import vn.iotstar.entity.User;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.util.Constant;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = "/login")
public class LoginController extends HttpServlet {
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
        if (session != null && session.getAttribute("account") != null) {
            resp.sendRedirect(req.getContextPath() + "/waiting");
            return;
        }

        if (session != null && (session.getAttribute("flashSuccess") != null || session.getAttribute("resetUsername") != null)) {
            clearRememberCookie(req, resp);
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (Constant.COOKIE_REMEMBER.equals(cookie.getName()) && cookie.getValue() != null && !cookie.getValue().isEmpty()) {
                    String decodedUser = URLDecoder.decode(cookie.getValue(), StandardCharsets.UTF_8);
                    User user = service.get(decodedUser);
                    if (user != null && user.getStatus() == 1) {
                        session = req.getSession(true);
                        session.setAttribute("username", user.getUserName());
                        session.setAttribute("account", user);
                        resp.sendRedirect(req.getContextPath() + "/waiting");
                        return;
                    }
                }
            }
        }
        req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");
        resp.setCharacterEncoding("UTF-8");
        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        boolean isRememberMe = "on".equals(req.getParameter("remember"));

        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            req.setAttribute("alert", "Tài khoản hoặc mật khẩu không được để trống!");
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        User user = service.login(username.trim(), password.trim());
        if (user != null) {
            if (user.getStatus() != 1) {
                HttpSession session = req.getSession(true);
                session.removeAttribute("account");
                session.setAttribute("pendingUsername", user.getUserName());
                session.setAttribute("pendingEmail", user.getEmail());
                resp.sendRedirect(req.getContextPath() + "/verify-otp");
                return;
            }

            HttpSession session = req.getSession(true);
            session.removeAttribute("resetUsername");
            session.setAttribute("username", user.getUserName());
            session.setAttribute("account", user);
            if (isRememberMe) {
                saveRememberMe(resp, user.getUserName());
            } else {
                clearRememberCookie(req, resp);
            }
            resp.sendRedirect(req.getContextPath() + "/waiting");
        } else {
            req.setAttribute("alert", "Tài khoản hoặc mật khẩu không đúng!");
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
        }
    }

    private void saveRememberMe(HttpServletResponse response, String username) {
        String safeCookieVal = URLEncoder.encode(username, StandardCharsets.UTF_8);
        Cookie cookie = new Cookie(Constant.COOKIE_REMEMBER, safeCookieVal);
        cookie.setMaxAge(30 * 60);
        cookie.setPath("/");
        response.addCookie(cookie);
    }
}
