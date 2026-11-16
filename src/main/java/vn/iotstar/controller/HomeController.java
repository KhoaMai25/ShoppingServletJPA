package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.Video;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.impl.CategoryServiceImpl;
import vn.iotstar.service.impl.VideoServiceImpl;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = {"/home"})
public class HomeController extends HttpServlet {
    private ICategoryService cateService = new CategoryServiceImpl();
    private IVideoService videoService = new VideoServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Category> categories = cateService.findAll();
        List<Video> top10Videos = videoService.findTop10Newest();
        req.setAttribute("listcate", categories);
        req.setAttribute("totalCate", cateService.count());
        req.setAttribute("top10Videos", top10Videos);
        req.getRequestDispatcher("/views/web/home.jsp").forward(req, resp);
    }
}
