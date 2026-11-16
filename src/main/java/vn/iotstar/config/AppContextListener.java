package vn.iotstar.config;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppContextListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println(">>> AppContextListener: Khởi tạo CSDL JPA và dữ liệu mẫu...");
        DBInit.init();
        System.out.println(">>> AppContextListener: Khởi tạo CSDL JPA hoàn tất!");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}
