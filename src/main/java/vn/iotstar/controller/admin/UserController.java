package vn.iotstar.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import vn.iotstar.entity.User;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.impl.UserServiceImpl;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = {"/admin/users"})
public class UserController extends HttpServlet {
    private IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        List<User> users = userService.findAll();
        req.setAttribute("userList", users);
        req.getRequestDispatcher("/views/admin/user-list.jsp").forward(req, resp);
    }
}
