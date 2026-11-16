package vn.iotstar.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class PasswordUtils {

    /**
     * Mã hóa mật khẩu bằng thuật toán băm SHA-256 (64 ký tự Hex)
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null) {
            return null;
        }
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encodedHash = digest.digest(plainPassword.trim().getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder(2 * encodedHash.length);
            for (byte b : encodedHash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Lỗi mã hóa mật khẩu SHA-256", e);
        }
    }

    /**
     * Kiểm tra mật khẩu người dùng nhập vào với mật khẩu đã mã hóa trong Database
     */
    public static boolean verifyPassword(String plainPassword, String storedPassword) {
        if (plainPassword == null || storedPassword == null) {
            return false;
        }
        String hashedInput = hashPassword(plainPassword);
        return hashedInput.equalsIgnoreCase(storedPassword.trim()) || plainPassword.trim().equals(storedPassword.trim());
    }
}
