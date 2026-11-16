package vn.iotstar.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.util.List;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.User;
import vn.iotstar.entity.Video;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.impl.CategoryServiceImpl;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.service.impl.VideoServiceImpl;
import vn.iotstar.util.Constant;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 25,
        maxRequestSize = 1024 * 1024 * 50
)
@WebServlet(urlPatterns = {
        "/admin/videos",
        "/admin/video/add",
        "/admin/video/insert",
        "/admin/video/edit",
        "/admin/video/update",
        "/admin/video/delete"
})
public class VideoController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private IVideoService videoService = new VideoServiceImpl();
    private ICategoryService cateService = new CategoryServiceImpl();
    private IUserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String url = req.getRequestURI();

        if (url.contains("/admin/videos")) {
            String keyword = req.getParameter("keyword");
            List<Video> list;
            if (keyword != null && !keyword.trim().isEmpty()) {
                list = videoService.searchByTitle(keyword.trim());
                req.setAttribute("keyword", keyword.trim());
            } else {
                list = videoService.findAll();
            }
            req.setAttribute("videoList", list);
            req.setAttribute("totalVideos", videoService.count());
            req.getRequestDispatcher("/views/admin/video-list.jsp").forward(req, resp);
        } else if (url.contains("/admin/video/add")) {
            req.setAttribute("listcate", cateService.findAll());
            req.getRequestDispatcher("/views/admin/video-add.jsp").forward(req, resp);
        } else if (url.contains("/admin/video/edit")) {
            String id = req.getParameter("id");
            Video video = videoService.findById(id);
            req.setAttribute("video", video);
            req.setAttribute("listcate", cateService.findAll());
            req.getRequestDispatcher("/views/admin/video-edit.jsp").forward(req, resp);
        } else if (url.contains("/admin/video/delete")) {
            String id = req.getParameter("id");
            try {
                videoService.delete(id);
                req.getSession().setAttribute("flashVideoMsg", "Đã xóa video #" + id + " thành công!");
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/admin/videos");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String url = req.getRequestURI();

        File uploadDir = new File(Constant.DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("account") : null;
        if (currentUser == null) {
            currentUser = userService.get("AnhPha");
        }

        if (url.contains("/admin/video/insert")) {
            String videoId = req.getParameter("videoId");
            if (videoId == null || videoId.trim().isEmpty()) {
                videoId = "VID" + (System.currentTimeMillis() % 100000);
            }
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String viewsStr = req.getParameter("views");
            int views = (viewsStr != null && !viewsStr.isEmpty()) ? Integer.parseInt(viewsStr) : 120;
            String activeStr = req.getParameter("active");
            int active = (activeStr != null && !activeStr.isEmpty()) ? Integer.parseInt(activeStr) : 1;
            String categoryIdStr = req.getParameter("categoryid");
            Category category = (categoryIdStr != null && !categoryIdStr.isEmpty())
                    ? cateService.findById(Integer.parseInt(categoryIdStr))
                    : null;

            String poster = req.getParameter("posterSample");
            if (poster == null || poster.isBlank()) {
                poster = "phone.jpg";
            }

            try {
                Part posterPart = req.getPart("posterFile");
                if (posterPart != null && posterPart.getSize() > 0) {
                    String submitted = Paths.get(posterPart.getSubmittedFileName()).getFileName().toString();
                    int dot = submitted.lastIndexOf('.');
                    String ext = dot >= 0 ? submitted.substring(dot + 1) : "jpg";
                    String savedName = "poster_" + System.currentTimeMillis() + "." + ext;
                    posterPart.write(Constant.DIR + File.separator + savedName);
                    poster = savedName;
                }
            } catch (Exception ignored) {
            }

            String videoUrl = req.getParameter("videoUrl");
            if (videoUrl == null || videoUrl.isBlank()) {
                videoUrl = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4";
            }

            try {
                Part videoPart = req.getPart("videoFile");
                if (videoPart != null && videoPart.getSize() > 0) {
                    String submitted = Paths.get(videoPart.getSubmittedFileName()).getFileName().toString();
                    int dot = submitted.lastIndexOf('.');
                    String ext = dot >= 0 ? submitted.substring(dot + 1) : "mp4";
                    String savedVid = "video_" + System.currentTimeMillis() + "." + ext;
                    videoPart.write(Constant.DIR + File.separator + savedVid);
                    videoUrl = req.getContextPath() + "/image?fname=" + savedVid;
                }
            } catch (Exception ignored) {
            }

            Video video = new Video(
                    videoId.trim(),
                    title,
                    poster,
                    views,
                    description,
                    active,
                    category,
                    currentUser,
                    videoUrl.trim(),
                    new Timestamp(System.currentTimeMillis())
            );
            videoService.insert(video);
            req.getSession().setAttribute("flashVideoMsg", "Đã thêm mới video \"" + title + "\" thành công!");
            resp.sendRedirect(req.getContextPath() + "/admin/videos");
            return;
        }

        if (url.contains("/admin/video/update")) {
            String videoId = req.getParameter("videoId");
            Video video = videoService.findById(videoId);
            if (video == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/videos");
                return;
            }

            video.setTitle(req.getParameter("title"));
            video.setDescription(req.getParameter("description"));
            String viewsStr = req.getParameter("views");
            if (viewsStr != null && !viewsStr.isEmpty()) {
                video.setViews(Integer.parseInt(viewsStr));
            }
            String activeStr = req.getParameter("active");
            if (activeStr != null && !activeStr.isEmpty()) {
                video.setActive(Integer.parseInt(activeStr));
            }
            String categoryIdStr = req.getParameter("categoryid");
            if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                video.setCategory(cateService.findById(Integer.parseInt(categoryIdStr)));
            }
            if (video.getUser() == null && currentUser != null) {
                video.setUser(currentUser);
            }

            String posterSample = req.getParameter("posterSample");
            if (posterSample != null && !posterSample.isBlank()) {
                video.setPoster(posterSample.trim());
            }

            try {
                Part posterPart = req.getPart("posterFile");
                if (posterPart != null && posterPart.getSize() > 0) {
                    String submitted = Paths.get(posterPart.getSubmittedFileName()).getFileName().toString();
                    int dot = submitted.lastIndexOf('.');
                    String ext = dot >= 0 ? submitted.substring(dot + 1) : "jpg";
                    String savedName = "poster_" + System.currentTimeMillis() + "." + ext;
                    posterPart.write(Constant.DIR + File.separator + savedName);
                    video.setPoster(savedName);
                }
            } catch (Exception ignored) {
            }

            String videoUrl = req.getParameter("videoUrl");
            if (videoUrl != null && !videoUrl.isBlank()) {
                video.setVideoUrl(videoUrl.trim());
            }

            try {
                Part videoPart = req.getPart("videoFile");
                if (videoPart != null && videoPart.getSize() > 0) {
                    String submitted = Paths.get(videoPart.getSubmittedFileName()).getFileName().toString();
                    int dot = submitted.lastIndexOf('.');
                    String ext = dot >= 0 ? submitted.substring(dot + 1) : "mp4";
                    String savedVid = "video_" + System.currentTimeMillis() + "." + ext;
                    videoPart.write(Constant.DIR + File.separator + savedVid);
                    video.setVideoUrl(req.getContextPath() + "/image?fname=" + savedVid);
                }
            } catch (Exception ignored) {
            }

            videoService.update(video);
            req.getSession().setAttribute("flashVideoMsg", "Đã cập nhật video \"" + video.getTitle() + "\" thành công!");
            resp.sendRedirect(req.getContextPath() + "/admin/videos");
        }
    }
}
