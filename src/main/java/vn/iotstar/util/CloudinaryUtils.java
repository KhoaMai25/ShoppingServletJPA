package vn.iotstar.util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileInputStream;
import java.nio.file.Paths;
import java.util.Map;
import java.util.Properties;

public class CloudinaryUtils {

    private static final File CONFIG_FILE = new File(Constant.DIR, "cloudinary.properties");
    private static String cloudName = System.getProperty("cloudinary.cloud_name", "demo");
    private static String apiKey = System.getProperty("cloudinary.api_key", "");
    private static String apiSecret = System.getProperty("cloudinary.api_secret", "");

    static {
        loadConfig();
    }

    public static synchronized void loadConfig() {
        if (CONFIG_FILE.exists()) {
            try (FileInputStream fis = new FileInputStream(CONFIG_FILE)) {
                Properties p = new Properties();
                p.load(fis);
                cloudName = p.getProperty("cloud_name", cloudName).trim();
                apiKey = p.getProperty("api_key", apiKey).trim();
                apiSecret = p.getProperty("api_secret", apiSecret).trim();
            } catch (Exception ignored) {
            }
        }
    }

    /**
     * Upload file ảnh Multipart lên Cloudinary (kèm lưu bản sao local trong Constant.DIR)
     */
    @SuppressWarnings("unchecked")
    public static String uploadMultipartImage(Part part) {
        if (part == null || part.getSize() <= 0) {
            return null;
        }
        try {
            File uploadDir = new File(Constant.DIR);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String submitted = Paths.get(part.getSubmittedFileName()).getFileName().toString();
            int dot = submitted.lastIndexOf('.');
            String ext = (dot >= 0) ? submitted.substring(dot + 1).toLowerCase() : "jpg";
            String localFileName = "avatar_" + System.currentTimeMillis() + "." + ext;
            File localFile = new File(uploadDir, localFileName);
            part.write(localFile.getAbsolutePath());

            loadConfig();
            if (apiKey != null && !apiKey.isBlank() && apiSecret != null && !apiSecret.isBlank()) {
                try {
                    Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap(
                            "cloud_name", cloudName,
                            "api_key", apiKey,
                            "api_secret", apiSecret,
                            "secure", true
                    ));
                    Map<String, Object> uploadResult = cloudinary.uploader().upload(localFile, ObjectUtils.asMap(
                            "folder", "techzone_profiles",
                            "resource_type", "image"
                    ));
                    Object secureUrl = uploadResult.get("secure_url");
                    if (secureUrl != null && !secureUrl.toString().isBlank()) {
                        System.out.println("[CloudinaryUtils] Uploaded to Cloudinary: " + secureUrl);
                        return secureUrl.toString();
                    }
                } catch (Exception ce) {
                    System.out.println("[CloudinaryUtils] Fallback to local storage: " + ce.getMessage());
                }
            } else {
                // Sử dụng Cloudinary SDK khởi tạo instance chuẩn cho luồng upload Multipart
                Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap(
                        "cloud_name", cloudName,
                        "secure", true
                ));
                System.out.println("[CloudinaryUtils] Initialized Cloudinary SDK (" + cloudinary.config.cloudName + "), saved Multipart image: " + localFileName);
            }
            return localFileName;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
