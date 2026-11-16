package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import org.apache.commons.io.IOUtils;
import vn.iotstar.config.DBInit;
import vn.iotstar.util.Constant;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = "/image") // ?fname=abc.png
public class DownloadImageController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fileName = req.getParameter("fname");
        if (fileName == null || fileName.trim().isEmpty()) {
            fileName = "avatar.png";
        }
        File file = new File(Constant.DIR + File.separator + fileName);
        if (!file.exists() || !file.isFile()) {
            DBInit.ensureSampleImages();
            file = new File(Constant.DIR + File.separator + fileName);
            if (!file.exists() || !file.isFile()) {
                file = new File(Constant.DIR + File.separator + "avatar.png");
            }
        }
        String lower = file.getName().toLowerCase();
        if (lower.endsWith(".png")) {
            resp.setContentType("image/png");
        } else {
            resp.setContentType("image/jpeg");
        }
        if (file.exists() && file.isFile()) {
            try (FileInputStream fis = new FileInputStream(file)) {
                IOUtils.copy(fis, resp.getOutputStream());
            }
        }
    }
}
