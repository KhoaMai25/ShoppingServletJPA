package vn.iotstar.util;

import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;

public class ValidationUtils {

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^(0|\\+84)[0-9]{9,10}$");
    private static final Pattern OTP_PATTERN = Pattern.compile("^[0-9]{6}$");

    public static <T> Map<String, String> validateEntity(T entity) {
        Map<String, String> errors = new LinkedHashMap<>();
        try (ValidatorFactory factory = Validation.buildDefaultValidatorFactory()) {
            Validator validator = factory.getValidator();
            Set<ConstraintViolation<T>> violations = validator.validate(entity);
            for (ConstraintViolation<T> v : violations) {
                errors.put(v.getPropertyPath().toString(), v.getMessage());
            }
        } catch (Exception ignored) {
        }
        return errors;
    }

    public static Map<String, String> validateLogin(String username, String password) {
        Map<String, String> errors = new LinkedHashMap<>();
        if (username == null || username.trim().isEmpty()) {
            errors.put("username", "Tên đăng nhập hoặc Email không được để trống.");
        } else if (username.trim().length() < 3) {
            errors.put("username", "Tên đăng nhập phải có ít nhất 3 ký tự.");
        }
        if (password == null || password.trim().isEmpty()) {
            errors.put("password", "Mật khẩu không được để trống.");
        } else if (password.trim().length() < 6) {
            errors.put("password", "Mật khẩu phải có từ 6 ký tự trở lên.");
        }
        return errors;
    }

    public static Map<String, String> validateRegister(String username, String password, String fullname, String email, String phone) {
        Map<String, String> errors = new LinkedHashMap<>();
        if (username == null || username.trim().isEmpty()) {
            errors.put("username", "Vui lòng nhập tên đăng nhập.");
        } else if (username.trim().length() < 3 || username.trim().length() > 50) {
            errors.put("username", "Tên đăng nhập phải từ 3 đến 50 ký tự.");
        }

        if (password == null || password.trim().isEmpty()) {
            errors.put("password", "Vui lòng nhập mật khẩu.");
        } else if (password.trim().length() < 6) {
            errors.put("password", "Mật khẩu phải có tối thiểu 6 ký tự.");
        }

        if (fullname == null || fullname.trim().isEmpty()) {
            errors.put("fullname", "Vui lòng nhập họ và tên đầy đủ.");
        } else if (fullname.trim().length() < 2) {
            errors.put("fullname", "Họ và tên phải có ít nhất 2 ký tự.");
        }

        if (email == null || email.trim().isEmpty()) {
            errors.put("email", "Vui lòng nhập địa chỉ Email.");
        } else if (!EMAIL_PATTERN.matcher(email.trim()).matches()) {
            errors.put("email", "Địa chỉ Email không đúng định dạng (ví dụ: ten@gmail.com).");
        }

        if (phone == null || phone.trim().isEmpty()) {
            errors.put("phone", "Vui lòng nhập số điện thoại liên hệ.");
        } else if (!PHONE_PATTERN.matcher(phone.trim()).matches()) {
            errors.put("phone", "Số điện thoại phải gồm 10-11 chữ số bắt đầu bằng 0 hoặc +84.");
        }
        return errors;
    }

    public static Map<String, String> validateForgotPassword(String emailOrUser) {
        Map<String, String> errors = new LinkedHashMap<>();
        if (emailOrUser == null || emailOrUser.trim().isEmpty()) {
            errors.put("email", "Vui lòng nhập địa chỉ Email hoặc Tên đăng nhập đã đăng ký.");
        } else if (emailOrUser.trim().length() < 3) {
            errors.put("email", "Thông tin nhập vào phải có ít nhất 3 ký tự.");
        }
        return errors;
    }

    public static Map<String, String> validateResetPassword(String otp, String newPassword, String confirmPassword) {
        Map<String, String> errors = new LinkedHashMap<>();
        if (otp == null || otp.trim().isEmpty()) {
            errors.put("otp", "Vui lòng nhập mã xác thực OTP.");
        } else if (!OTP_PATTERN.matcher(otp.trim()).matches()) {
            errors.put("otp", "Mã OTP phải gồm đúng 6 chữ số.");
        }

        if (newPassword == null || newPassword.trim().isEmpty()) {
            errors.put("newPassword", "Vui lòng nhập mật khẩu mới.");
        } else if (newPassword.trim().length() < 6) {
            errors.put("newPassword", "Mật khẩu mới phải có từ 6 ký tự trở lên.");
        }

        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            errors.put("confirmPassword", "Vui lòng nhập lại mật khẩu xác nhận.");
        } else if (newPassword != null && !newPassword.equals(confirmPassword)) {
            errors.put("confirmPassword", "Mật khẩu xác nhận không khớp với mật khẩu mới.");
        }
        return errors;
    }

    public static Map<String, String> validateCategoryForm(String categoryname) {
        Map<String, String> errors = new LinkedHashMap<>();
        if (categoryname == null || categoryname.trim().isEmpty()) {
            errors.put("categoryname", "Tên danh mục sản phẩm không được để trống.");
        } else if (categoryname.trim().length() < 2 || categoryname.trim().length() > 255) {
            errors.put("categoryname", "Tên danh mục phải từ 2 đến 255 ký tự.");
        }
        return errors;
    }

    public static Map<String, String> validateVideoForm(String videoId, String title, String description, String viewsStr) {
        Map<String, String> errors = new LinkedHashMap<>();
        if (videoId == null || videoId.trim().isEmpty()) {
            errors.put("videoId", "Mã Video không được để trống.");
        } else if (videoId.trim().length() < 2 || videoId.trim().length() > 50) {
            errors.put("videoId", "Mã Video phải từ 2 đến 50 ký tự.");
        }

        if (title == null || title.trim().isEmpty()) {
            errors.put("title", "Tiêu đề Video không được để trống.");
        } else if (title.trim().length() < 5) {
            errors.put("title", "Tiêu đề Video phải có ít nhất 5 ký tự.");
        }

        if (description == null || description.trim().isEmpty()) {
            errors.put("description", "Mô tả Video không được để trống.");
        } else if (description.trim().length() < 10) {
            errors.put("description", "Mô tả Video phải có ít nhất 10 ký tự.");
        }

        if (viewsStr != null && !viewsStr.trim().isEmpty()) {
            try {
                int v = Integer.parseInt(viewsStr.trim());
                if (v < 0) {
                    errors.put("views", "Số lượt xem không được là số âm.");
                }
            } catch (NumberFormatException e) {
                errors.put("views", "Số lượt xem phải là số nguyên hợp lệ.");
            }
        }
        return errors;
    }

    public static Map<String, String> validateProfileForm(String fullname, String phone, String email) {
        Map<String, String> errors = new LinkedHashMap<>();
        if (fullname == null || fullname.trim().isEmpty()) {
            errors.put("fullname", "Họ và tên không được để trống.");
        } else if (fullname.trim().length() < 2) {
            errors.put("fullname", "Họ và tên phải có ít nhất 2 ký tự.");
        }

        if (phone == null || phone.trim().isEmpty()) {
            errors.put("phone", "Số điện thoại không được để trống.");
        } else if (!PHONE_PATTERN.matcher(phone.trim()).matches()) {
            errors.put("phone", "Số điện thoại không hợp lệ (gồm 10-11 chữ số, bắt đầu bằng 0 hoặc +84).");
        }

        if (email == null || email.trim().isEmpty()) {
            errors.put("email", "Địa chỉ Email không được để trống.");
        } else if (!EMAIL_PATTERN.matcher(email.trim()).matches()) {
            errors.put("email", "Địa chỉ Email không đúng định dạng.");
        }
        return errors;
    }
}
