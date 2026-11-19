package vn.iotstar.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import vn.iotstar.entity.Category;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.impl.CategoryServiceImpl;
import vn.iotstar.util.Constant;
import vn.iotstar.util.ValidationUtils;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 5 * 5
)
@WebServlet(urlPatterns = {
        "/admin/categories",
        "/admin/category/add",
        "/admin/category/insert",
        "/admin/category/edit",
        "/admin/category/update",
        "/admin/category/delete",
        "/admin/category/toggle-status"
})
public class CategoryController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    public ICategoryService cateService = new CategoryServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String url = req.getRequestURI();

        if (url.contains("/admin/categories")) {
            String keyword = req.getParameter("keyword");
            String statusFilter = req.getParameter("statusFilter");

            List<Category> allCategories = cateService.findAll();
            int totalCount = cateService.count();
            int activeCount = 0;
            int lockedCount = 0;
            for (Category c : allCategories) {
                if (c.getStatus() == 1) {
                    activeCount++;
                } else {
                    lockedCount++;
                }
            }

            List<Category> list;
            if (keyword != null && !keyword.trim().isEmpty()) {
                list = cateService.searchByName(keyword.trim());
                req.setAttribute("keyword", keyword.trim());
            } else {
                list = allCategories;
            }

            if (statusFilter != null && ("1".equals(statusFilter) || "0".equals(statusFilter))) {
                int st = Integer.parseInt(statusFilter);
                List<Category> filtered = new ArrayList<>();
                for (Category c : list) {
                    if (c.getStatus() == st) {
                        filtered.add(c);
                    }
                }
                list = filtered;
                req.setAttribute("statusFilter", statusFilter);
            }

            req.setAttribute("listcate", list);
            req.setAttribute("totalCount", totalCount);
            req.setAttribute("activeCount", activeCount);
            req.setAttribute("lockedCount", lockedCount);
            req.getRequestDispatcher("/views/admin/category-list.jsp").forward(req, resp);
        } else if (url.contains("/admin/category/add")) {
            req.getRequestDispatcher("/views/admin/category-add.jsp").forward(req, resp);
        } else if (url.contains("/admin/category/edit")) {
            int id = Integer.parseInt(req.getParameter("id"));
            Category category = cateService.findById(id);
            req.setAttribute("cate", category);
            req.getRequestDispatcher("/views/admin/category-edit.jsp").forward(req, resp);
        } else if (url.contains("/admin/category/toggle-status")) {
            int id = Integer.parseInt(req.getParameter("id"));
            Category category = cateService.findById(id);
            if (category != null) {
                category.setStatus(category.getStatus() == 1 ? 0 : 1);
                cateService.update(category);
                req.getSession().setAttribute("flashMsg", "Đã đổi trạng thái danh mục \"" + category.getCategoryname() + "\" thành công!");
            }
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        } else if (url.contains("/admin/category/delete")) {
            int id = Integer.parseInt(req.getParameter("id"));
            try {
                Category old = cateService.findById(id);
                cateService.delete(id);
                req.getSession().setAttribute("flashMsg", "Đã xóa danh mục " + (old != null ? "\"" + old.getCategoryname() + "\"" : "#" + id) + " thành công!");
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String url = req.getRequestURI();

        if (url.contains("/admin/category/insert")) {
            String categoryname = req.getParameter("categoryname");
            String statusParam = req.getParameter("status");
            int status = (statusParam != null && !statusParam.isEmpty()) ? Integer.parseInt(statusParam) : 1;
            String images = req.getParameter("images");

            Map<String, String> errors = ValidationUtils.validateCategoryForm(categoryname);
            if (!errors.isEmpty()) {
                req.setAttribute("errors", errors);
                req.setAttribute("oldCategoryname", categoryname);
                req.setAttribute("alert", errors.get("categoryname"));
                req.getRequestDispatcher("/views/admin/category-add.jsp").forward(req, resp);
                return;
            }

            Category category = new Category();
            category.setCategoryname(categoryname.trim());
            category.setStatus(status);

            String fname = "";
            String uploadPath = Constant.DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            try {
                Part part = req.getPart("images1");
                if (part != null && part.getSize() > 0) {
                    String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    int index = filename.lastIndexOf(".");
                    String ext = index >= 0 ? filename.substring(index + 1) : "png";
                    fname = System.currentTimeMillis() + "." + ext;
                    part.write(uploadPath + File.separator + fname);
                    category.setImages(fname);
                } else if (images != null && !images.trim().isEmpty()) {
                    category.setImages(images.trim());
                } else {
                    category.setImages("avatar.png");
                }
            } catch (FileNotFoundException fne) {
                fne.printStackTrace();
                category.setImages("avatar.png");
            } catch (Exception e) {
                category.setImages(images != null && !images.trim().isEmpty() ? images.trim() : "avatar.png");
            }

            cateService.insert(category);
            req.getSession().setAttribute("flashMsg", "Đã thêm mới danh mục \"" + category.getCategoryname() + "\" thành công!");
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        }

        if (url.contains("/admin/category/update")) {
            int categoryid = Integer.parseInt(req.getParameter("categoryid"));
            String categoryname = req.getParameter("categoryname");
            String statusParam = req.getParameter("status");
            int status = (statusParam != null && !statusParam.isEmpty()) ? Integer.parseInt(statusParam) : 1;
            String images = req.getParameter("images");

            Category category = cateService.findById(categoryid);
            if (category == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/categories");
                return;
            }

            Map<String, String> errors = ValidationUtils.validateCategoryForm(categoryname);
            if (!errors.isEmpty()) {
                req.setAttribute("errors", errors);
                req.setAttribute("cate", category);
                req.setAttribute("alert", errors.get("categoryname"));
                req.getRequestDispatcher("/views/admin/category-edit.jsp").forward(req, resp);
                return;
            }

            String fileold = category.getImages();
            category.setCategoryname(categoryname.trim());
            category.setStatus(status);

            String fname = "";
            String uploadPath = Constant.DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            try {
                Part part = req.getPart("images1");
                if (part != null && part.getSize() > 0) {
                    if (fileold != null && !fileold.startsWith("http") && !fileold.equals("avatar.png")) {
                        try {
                            deleteFile(uploadPath + File.separator + fileold);
                        } catch (Exception ignored) {
                        }
                    }
                    String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    int index = filename.lastIndexOf(".");
                    String ext = index >= 0 ? filename.substring(index + 1) : "png";
                    fname = System.currentTimeMillis() + "." + ext;
                    part.write(uploadPath + File.separator + fname);
                    category.setImages(fname);
                } else if (images != null && !images.trim().isEmpty()) {
                    category.setImages(images.trim());
                } else {
                    category.setImages(fileold);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            cateService.update(category);
            req.getSession().setAttribute("flashMsg", "Đã cập nhật danh mục \"" + category.getCategoryname() + "\" thành công!");
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        }
    }

    public static void deleteFile(String filePath) throws IOException {
        Path path = Paths.get(filePath);
        Files.deleteIfExists(path);
    }
}
