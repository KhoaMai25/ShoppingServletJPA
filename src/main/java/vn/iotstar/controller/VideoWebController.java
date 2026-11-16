package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import vn.iotstar.entity.User;
import vn.iotstar.entity.Video;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.service.impl.VideoServiceImpl;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = {"/video", "/video/detail"})
public class VideoWebController extends HttpServlet {
    private IVideoService videoService = new VideoServiceImpl();
    private IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String url = req.getRequestURI();
        String videoId = req.getParameter("id");

        // Xem chi tiết & Play 1 video khi bấm vào tiêu đề video trên /home hoặc /video
        if (url.contains("/video/detail") || (videoId != null && !videoId.trim().isEmpty())) {
            Video video = videoService.findById(videoId != null ? videoId.trim() : "VID01");
            if (video == null) {
                List<Video> top = videoService.findTop10Newest();
                if (!top.isEmpty()) {
                    video = top.get(0);
                }
            }
            if (video != null) {
                video.setViews(video.getViews() + 1);
                videoService.update(video);
            }
            req.setAttribute("video", video);
            req.setAttribute("relatedVideos", videoService.findTop10Newest());
            req.getRequestDispatcher("/views/web/video-detail.jsp").forward(req, resp);
            return;
        }

        // Hiển thị tất cả videos của user và phân trang 6 sản phẩm (videos) / trang trên URL /video
        int pageSize = 6;
        int currentPage = 1;
        String pageParam = req.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Math.max(1, Integer.parseInt(pageParam));
            } catch (NumberFormatException ignored) {
            }
        }

        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("account") : null;
        if (currentUser == null) {
            currentUser = userService.get("AnhPha");
        }

        int userId = (currentUser != null) ? currentUser.getId() : 1;
        int totalVideos = videoService.countByUser(userId);
        int totalPages = (int) Math.ceil((double) totalVideos / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        List<Video> pagedVideos = videoService.findByUserPaging(userId, currentPage, pageSize);

        req.setAttribute("videoOwner", currentUser);
        req.setAttribute("videoList", pagedVideos);
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalVideos", totalVideos);
        req.setAttribute("pageSize", pageSize);
        req.getRequestDispatcher("/views/web/video-list.jsp").forward(req, resp);
    }
}
