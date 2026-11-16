package vn.iotstar.dao;

import java.util.List;
import vn.iotstar.entity.Video;

public interface IVideoDao {
    void insert(Video video);
    void update(Video video);
    void delete(String videoId) throws Exception;
    Video findById(String videoId);
    List<Video> findAll();
    List<Video> findTop10Newest();
    List<Video> findAllPaging(int page, int pageSize);
    List<Video> findByUserPaging(int userId, int page, int pageSize);
    int countByUser(int userId);
    int count();
    List<Video> searchByTitle(String keyword);
}
