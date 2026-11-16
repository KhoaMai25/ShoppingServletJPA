package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.RandomAccessFile;
import org.apache.commons.io.IOUtils;
import vn.iotstar.config.DBInit;
import vn.iotstar.util.Constant;

@SuppressWarnings("serial")
@WebServlet(urlPatterns = "/image") // ?fname=abc.png hoặc ?fname=tech_review.mp4
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
                if (fileName.toLowerCase().endsWith(".mp4")) {
                    file = new File(Constant.DIR + File.separator + "tech_review.mp4");
                } else {
                    file = new File(Constant.DIR + File.separator + "avatar.png");
                }
            }
        }
        if (!file.exists() || !file.isFile()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String lower = file.getName().toLowerCase();
        if (lower.endsWith(".mp4") || lower.endsWith(".webm")) {
            streamVideoFile(file, req, resp);
            return;
        }

        if (lower.endsWith(".png")) {
            resp.setContentType("image/png");
        } else {
            resp.setContentType("image/jpeg");
        }
        resp.setContentLengthLong(file.length());
        try (FileInputStream fis = new FileInputStream(file)) {
            IOUtils.copy(fis, resp.getOutputStream());
        }
    }

    private void streamVideoFile(File file, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        long fileLength = file.length();
        String range = req.getHeader("Range");

        resp.setContentType("video/mp4");
        resp.setHeader("Accept-Ranges", "bytes");

        long start = 0;
        long end = fileLength - 1;

        if (range != null && range.startsWith("bytes=")) {
            String[] parts = range.substring(6).split("-");
            try {
                if (!parts[0].isEmpty()) {
                    start = Long.parseLong(parts[0]);
                }
                if (parts.length > 1 && !parts[1].isEmpty()) {
                    end = Long.parseLong(parts[1]);
                }
            } catch (NumberFormatException ignored) {
            }
            if (end >= fileLength) {
                end = fileLength - 1;
            }
            long contentLength = end - start + 1;
            resp.setStatus(HttpServletResponse.SC_PARTIAL_CONTENT);
            resp.setHeader("Content-Range", "bytes " + start + "-" + end + "/" + fileLength);
            resp.setContentLengthLong(contentLength);
        } else {
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.setContentLengthLong(fileLength);
        }

        try (RandomAccessFile raf = new RandomAccessFile(file, "r");
             OutputStream out = resp.getOutputStream()) {
            raf.seek(start);
            byte[] buffer = new byte[8192];
            long remaining = end - start + 1;
            while (remaining > 0) {
                int read = raf.read(buffer, 0, (int) Math.min(buffer.length, remaining));
                if (read == -1) {
                    break;
                }
                out.write(buffer, 0, read);
                remaining -= read;
            }
        }
    }
}
