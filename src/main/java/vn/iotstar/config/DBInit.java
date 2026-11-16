package vn.iotstar.config;

import java.awt.Color;
import java.awt.Font;
import java.awt.GradientPaint;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.sql.Date;
import javax.imageio.ImageIO;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.User;
import vn.iotstar.util.Constant;

public class DBInit {
    public static void init() {
        ensureSampleImages();

        EntityManager enma = JpaConfig.getEntityManager();
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();

            // Tài khoản chính của Mai Anh Khoa (Username: AnhPha)
            long count = enma.createQuery("SELECT count(u) FROM User u WHERE u.userName = 'AnhPha'", Long.class).getSingleResult();
            if (count == 0) {
                User admin = new User(
                        "24110027@student.hcmute.edu.vn",
                        "AnhPha",
                        "Mai Anh Khoa",
                        "123456",
                        "avatar.png",
                        1,
                        "0837707462",
                        new Date(System.currentTimeMillis())
                );
                enma.persist(admin);
            } else {
                enma.createQuery("UPDATE User u SET u.email = '24110027@student.hcmute.edu.vn', u.fullName = 'Mai Anh Khoa', u.phone = '0837707462' WHERE u.userName = 'AnhPha'").executeUpdate();
            }

            // Khởi tạo các danh mục cửa hàng với ảnh sản phẩm thật
            seedCategoryIfMissing(enma, "Điện thoại & Smartphone", "phone.jpg", 1);
            seedCategoryIfMissing(enma, "Laptop & MacBook", "laptop.jpg", 1);
            seedCategoryIfMissing(enma, "Máy tính bảng iPad", "ipad.jpg", 1);
            seedCategoryIfMissing(enma, "Đồng hồ thông minh", "watch.jpg", 1);
            seedCategoryIfMissing(enma, "Tai nghe & Âm thanh", "audio.jpg", 1);
            seedCategoryIfMissing(enma, "Máy ảnh kỹ thuật số", "camera.jpg", 1);

            trans.commit();
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            e.printStackTrace();
        } finally {
            enma.close();
        }
    }

    private static void seedCategoryIfMissing(EntityManager enma, String name, String image, int status) {
        Long cnt = enma.createQuery("SELECT count(c) FROM Category c WHERE c.categoryname = :name", Long.class)
                .setParameter("name", name)
                .getSingleResult();
        if (cnt == null || cnt == 0) {
            Category c = new Category(0, name, image, status);
            enma.persist(c);
        }
    }

    public static void ensureSampleImages() {
        try {
            File dir = new File(Constant.DIR);
            if (!dir.exists()) {
                dir.mkdirs();
            }
            String[] sampleFiles = {"phone.jpg", "laptop.jpg", "ipad.jpg", "watch.jpg", "audio.jpg", "camera.jpg", "abc.jpg", "avatar.png"};
            for (String fileName : sampleFiles) {
                File dest = new File(dir, fileName);
                if (!dest.exists()) {
                    try (java.io.InputStream is = DBInit.class.getResourceAsStream("/sample-images/" + fileName)) {
                        if (is != null) {
                            java.nio.file.Files.copy(is, dest.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                        }
                    } catch (Exception ignored) {
                    }
                }
            }
            File fallback = new File(dir, "avatar.png");
            if (!fallback.exists()) {
                BufferedImage img = new BufferedImage(320, 200, BufferedImage.TYPE_INT_RGB);
                Graphics2D g = img.createGraphics();
                g.setPaint(new GradientPaint(0, 0, new Color(15, 23, 42), 320, 200, new Color(30, 58, 138)));
                g.fillRect(0, 0, 320, 200);
                g.setColor(Color.WHITE);
                g.setFont(new Font("SansSerif", Font.BOLD, 20));
                g.drawString("Product Image", 90, 105);
                g.dispose();
                ImageIO.write(img, "png", fallback);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
