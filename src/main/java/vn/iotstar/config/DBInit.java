package vn.iotstar.config;

import java.awt.Color;
import java.awt.Font;
import java.awt.GradientPaint;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.sql.Date;
import java.sql.Timestamp;
import javax.imageio.ImageIO;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.User;
import vn.iotstar.entity.Video;
import vn.iotstar.util.Constant;
import vn.iotstar.util.PasswordUtils;

public class DBInit {
    public static void init() {
        ensureSampleImages();

        EntityManager enma = JpaConfig.getEntityManager();
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();

            String hashedDefault = PasswordUtils.hashPassword("123456");

            // Tài khoản chính của Mai Anh Khoa (Username: AnhPha, mật khẩu mã hóa SHA-256)
            User admin;
            var users = enma.createQuery("SELECT u FROM User u WHERE u.userName = 'AnhPha'", User.class).getResultList();
            if (users.isEmpty()) {
                admin = new User(
                        "24110027@student.hcmute.edu.vn",
                        "AnhPha",
                        "Mai Anh Khoa",
                        hashedDefault,
                        "avatar.png",
                        1,
                        "0837707462",
                        new Date(System.currentTimeMillis()),
                        1,
                        null
                );
                enma.persist(admin);
                enma.flush();
            } else {
                admin = users.get(0);
                admin.setEmail("24110027@student.hcmute.edu.vn");
                admin.setFullName("Mai Anh Khoa");
                admin.setPhone("0837707462");
                admin.setStatus(1);
                if (admin.getPassWord() == null || admin.getPassWord().length() < 32) {
                    admin.setPassWord(hashedDefault);
                }
                enma.merge(admin);
            }

            // Khởi tạo các danh mục cửa hàng với ảnh sản phẩm thật
            Category catPhone = seedCategoryIfMissing(enma, "Điện thoại & Smartphone", "phone.jpg", 1);
            Category catLaptop = seedCategoryIfMissing(enma, "Laptop & MacBook", "laptop.jpg", 1);
            Category catIpad = seedCategoryIfMissing(enma, "Máy tính bảng iPad", "ipad.jpg", 1);
            Category catWatch = seedCategoryIfMissing(enma, "Đồng hồ thông minh", "watch.jpg", 1);
            Category catAudio = seedCategoryIfMissing(enma, "Tai nghe & Âm thanh", "audio.jpg", 1);
            Category catCamera = seedCategoryIfMissing(enma, "Máy ảnh kỹ thuật số", "camera.jpg", 1);

            // Khởi tạo 12 Videos công nghệ gắn với User AnhPha (1-n) phát trực tiếp từ máy chủ (/image?fname=tech_review.mp4)
            long now = System.currentTimeMillis();
            seedVideo(enma, "VID01", "Trải nghiệm bàn phím Magic Keyboard trên iPad Pro", "ipad.jpg", 1420,
                    "Đánh giá chi tiết bàn phím Magic Keyboard nhôm nguyên khối mới dành cho iPad Pro M4 với dãy phím chức năng và Trackpad phản hồi xúc giác.",
                    catIpad, admin, "tech_review.mp4", now - 1200000L);

            seedVideo(enma, "VID02", "Hướng dẫn cân chỉnh màu màn hình MacBook cho Designer", "laptop.jpg", 1890,
                    "Thiết lập chuẩn màu Display P3 và sRGB trên màn hình Liquid Retina XDR giúp thiết kế đồ họa và dựng phim chính xác tuyệt đối.",
                    catLaptop, admin, "tech_review.mp4", now - 1100000L);

            seedVideo(enma, "VID03", "Top 5 phụ kiện sạc nhanh MagSafe đáng mua nhất năm nay", "phone.jpg", 2310,
                    "Tổng hợp các đế sạc MagSafe 3 trong 1 và pin dự phòng từ tính mỏng nhẹ tương thích hoàn hảo cho iPhone 16 Series.",
                    catPhone, admin, "tech_review.mp4", now - 1000000L);

            seedVideo(enma, "VID04", "Bí quyết tối ưu thời lượng pin trên iOS 18 hiệu quả", "abc.jpg", 3150,
                    "Hướng dẫn chi tiết các cài đặt làm mới ứng dụng nền và tối ưu màn hình Always-On Display giúp kéo dài thêm 3 giờ sử dụng mỗi ngày.",
                    catPhone, admin, "tech_review.mp4", now - 900000L);

            seedVideo(enma, "VID05", "Mở hộp MacBook Air 15 M3 16GB màu Midnight tuyệt đẹp", "laptop.jpg", 4280,
                    "Trên tay phiên bản MacBook Air 15 inch chip M3 với RAM 16GB tiêu chuẩn, thiết kế siêu mỏng nhẹ cùng lớp phủ chống bám vân tay mới.",
                    catLaptop, admin, "tech_review.mp4", now - 800000L);

            seedVideo(enma, "VID06", "So sánh Camera Galaxy S24 Ultra và iPhone 16 Pro Max", "abc.jpg", 5640,
                    "Bài kiểm tra thực tế khả năng chụp đêm, quay video chống rung 4K 60fps và khả năng zoom quang học 5x giữa hai flagship hàng đầu.",
                    catPhone, admin, "tech_review.mp4", now - 700000L);

            seedVideo(enma, "VID07", "Quay phim chuyên nghiệp 4K 10-bit trên Sony Alpha A7 IV", "camera.jpg", 3890,
                    "Đánh giá cảm biến Full-Frame 33MP kết hợp lấy nét ánh mắt thời gian thực Real-time Eye AF và cấu hình màu S-Cinetone điện ảnh.",
                    catCamera, admin, "tech_review.mp4", now - 600000L);

            seedVideo(enma, "VID08", "Đánh giá Apple Watch Ultra 2 khung viền Titanium bền bỉ", "watch.jpg", 4720,
                    "Thử nghiệm độ sáng màn hình 3000 nits dưới nắng gắt, GPS băng tần kép chuẩn xác và thời lượng pin thực tế lên tới 72 giờ.",
                    catWatch, admin, "tech_review.mp4", now - 500000L);

            seedVideo(enma, "VID09", "Thử nghiệm chống ồn chủ động trên tai nghe Sony WH-1000XM5", "audio.jpg", 6120,
                    "Hệ thống 8 micro chống ồn thông minh kết hợp màng loa sợi carbon 30mm mang lại chất âm Hi-Res Audio LDAC trong trẻo.",
                    catAudio, admin, "tech_review.mp4", now - 400000L);

            seedVideo(enma, "VID10", "Trên tay iPad Pro M4 màn hình Tandem OLED siêu mỏng 5.1mm", "ipad.jpg", 7340,
                    "Thiết bị mỏng nhất lịch sử Apple với sức mạnh đột phá từ vi xử lý M4 và màn hình Ultra Retina XDR độ tương phản tuyệt đối.",
                    catIpad, admin, "tech_review.mp4", now - 300000L);

            seedVideo(enma, "VID11", "Đánh giá hiệu năng MacBook Pro 14 M3 Pro sau 3 tháng sử dụng", "laptop.jpg", 8950,
                    "Trải nghiệm thực tế dựng phim 4K, lập trình Java Enterprise và chạy máy ảo mượt mà với thời lượng pin trọn vẹn cả ngày làm việc.",
                    catLaptop, admin, "tech_review.mp4", now - 200000L);

            seedVideo(enma, "VID12", "Đánh giá chi tiết iPhone 16 Pro Max 256GB Titan Tự Nhiên", "phone.jpg", 12450,
                    "Khám phá nút điều khiển Camera Control hoàn toàn mới, viền màn hình siêu mỏng 6.9 inch, chip A18 Pro 3nm và quay video 4K 120fps Dolby Vision.",
                    catPhone, admin, "tech_review.mp4", now - 100000L);

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

    private static Category seedCategoryIfMissing(EntityManager enma, String name, String image, int status) {
        var list = enma.createQuery("SELECT c FROM Category c WHERE c.categoryname = :name", Category.class)
                .setParameter("name", name)
                .getResultList();
        if (list.isEmpty()) {
            Category c = new Category(0, name, image, status);
            enma.persist(c);
            enma.flush();
            return c;
        }
        return list.get(0);
    }

    private static void seedVideo(EntityManager enma, String videoId, String title, String poster, int views,
                                  String description, Category category, User user, String videoUrl, long timestampMillis) {
        Video existing = enma.find(Video.class, videoId);
        if (existing == null) {
            Video v = new Video(videoId, title, poster, views, description, 1, category, user, videoUrl, new Timestamp(timestampMillis));
            enma.persist(v);
        } else {
            existing.setUser(user);
            existing.setCategory(category);
            existing.setPoster(poster);
            existing.setVideoUrl(videoUrl);
            if (existing.getCreatedDate() == null) {
                existing.setCreatedDate(new Timestamp(timestampMillis));
            }
            enma.merge(existing);
        }
    }

    public static void ensureSampleImages() {
        try {
            File dir = new File(Constant.DIR);
            if (!dir.exists()) {
                dir.mkdirs();
            }
            String[] sampleFiles = {"phone.jpg", "laptop.jpg", "ipad.jpg", "watch.jpg", "audio.jpg", "camera.jpg", "abc.jpg", "avatar.png", "tech_review.mp4"};
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
