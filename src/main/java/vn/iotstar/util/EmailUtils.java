package vn.iotstar.util;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.io.File;
import java.io.FileInputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.security.SecureRandom;
import java.time.Duration;
import java.util.Properties;

public class EmailUtils {

    private static final File CONFIG_FILE = new File(Constant.DIR, "smtp.properties");
    private static String smtpUser = "24110027@student.hcmute.edu.vn";
    private static String smtpPassword = "";

    static {
        loadSmtpConfig();
    }

    public static synchronized void loadSmtpConfig() {
        if (CONFIG_FILE.exists()) {
            try (FileInputStream fis = new FileInputStream(CONFIG_FILE)) {
                Properties p = new Properties();
                p.load(fis);
                smtpUser = p.getProperty("smtp.user", smtpUser).trim();
                smtpPassword = p.getProperty("smtp.password", "").replace(" ", "").trim();
            } catch (Exception ignored) {
            }
        }
    }

    /**
     * Sinh mã OTP ngẫu nhiên gồm 6 chữ số
     */
    public static String getRandom() {
        SecureRandom rnd = new SecureRandom();
        int number = rnd.nextInt(900000) + 100000;
        return String.format("%06d", number);
    }

    /**
     * Gửi mã xác nhận OTP qua Email (kết hợp Jakarta Mail SMTP & Cloud Relay)
     */
    public static boolean sendOtpEmail(String toEmail, String fullName, String otpCode, String actionTitle) {
        loadSmtpConfig();
        System.out.println("==================================================");
        System.out.println("[TECHZONE OTP] " + actionTitle);
        System.out.println("Người nhận : " + fullName + " <" + toEmail + ">");
        System.out.println("Mã OTP     : " + otpCode);
        System.out.println("==================================================");

        new Thread(() -> {
            boolean sentViaSmtp = false;
            if (smtpPassword != null && smtpPassword.length() >= 16) {
                try {
                    Properties pr = new Properties();
                    pr.setProperty("mail.smtp.host", "smtp.gmail.com");
                    pr.setProperty("mail.smtp.port", "587");
                    pr.setProperty("mail.smtp.auth", "true");
                    pr.setProperty("mail.smtp.starttls.enable", "true");
                    pr.setProperty("mail.smtp.ssl.protocols", "TLSv1.2");
                    pr.setProperty("mail.smtp.connectiontimeout", "5000");
                    pr.setProperty("mail.smtp.timeout", "5000");

                    final String currentFrom = smtpUser;
                    final String currentPass = smtpPassword;

                    Session session = Session.getInstance(pr, new Authenticator() {
                        @Override
                        protected PasswordAuthentication getPasswordAuthentication() {
                            return new PasswordAuthentication(currentFrom, currentPass);
                        }
                    });

                    Message mess = new MimeMessage(session);
                    mess.setHeader("Content-Type", "text/html; charset=UTF-8");
                    mess.setFrom(new InternetAddress(currentFrom, "TechZone Store"));
                    mess.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
                    mess.setSubject("[TechZone Store] " + actionTitle + " - Mã OTP: " + otpCode);

                    String htmlContent = "<div style='font-family:Arial,sans-serif;max-width:520px;margin:auto;padding:24px;border:1px solid #e2e8f0;border-radius:16px;'>"
                            + "<h2 style='color:#4f46e5;margin-top:0;'>TechZone Store</h2>"
                            + "<p>Xin chào <strong>" + fullName + "</strong>,</p>"
                            + "<p>Mã xác thực OTP cho yêu cầu <strong>" + actionTitle + "</strong> của bạn là:</p>"
                            + "<div style='font-size:28px;font-weight:bold;letter-spacing:6px;color:#e11d48;background:#f8fafc;padding:14px;text-align:center;border-radius:12px;'>"
                            + otpCode + "</div>"
                            + "<p style='color:#64748b;font-size:13px;margin-top:16px;'>Mã có hiệu lực trong vòng 10 phút. Vui lòng không chia sẻ mã này cho người khác.</p>"
                            + "</div>";
                    mess.setContent(htmlContent, "text/html; charset=UTF-8");
                    Transport.send(mess);
                    sentViaSmtp = true;
                } catch (Exception ignored) {
                }
            }

            if (!sentViaSmtp) {
                try {
                    HttpClient client = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(8)).build();
                    String json = String.format(
                            "{\"_subject\":\"[TechZone Store] %s - Ma OTP: %s\",\"Khach_hang\":\"%s\",\"Yeu_cau\":\"%s\",\"Ma_OTP\":\"%s\",\"Ghi_chu\":\"Vui long nhap ma OTP 6 chu so nay tren trang xac thuc TechZone Store.\"}",
                            actionTitle, otpCode, fullName, actionTitle, otpCode
                    );
                    HttpRequest request = HttpRequest.newBuilder()
                            .uri(URI.create("https://formsubmit.co/ajax/" + toEmail.trim()))
                            .header("Content-Type", "application/json")
                            .header("Accept", "application/json")
                            .header("Referer", "http://localhost:8080/ShoppingServletJPA/verify-otp")
                            .header("Origin", "http://localhost:8080")
                            .POST(HttpRequest.BodyPublishers.ofString(json))
                            .build();
                    HttpResponse<String> res = client.send(request, HttpResponse.BodyHandlers.ofString());
                    System.out.println("[EmailUtils Relay] Sent to " + toEmail + " -> " + res.body());
                } catch (Exception e) {
                    System.out.println("[EmailUtils Relay Error] " + e.getMessage());
                }
            }
        }).start();

        return true;
    }
}
