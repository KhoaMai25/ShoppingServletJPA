package vn.iotstar.dao.impl;

import java.util.List;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import vn.iotstar.config.JpaConfig;
import vn.iotstar.dao.IVideoDao;
import vn.iotstar.entity.Video;

public class VideoDao implements IVideoDao {

    @Override
    public void insert(Video video) {
        EntityManager enma = JpaConfig.getEntityManager();
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            enma.persist(video);
            trans.commit();
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            enma.close();
        }
    }

    @Override
    public void update(Video video) {
        EntityManager enma = JpaConfig.getEntityManager();
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            enma.merge(video);
            trans.commit();
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            enma.close();
        }
    }

    @Override
    public void delete(String videoId) throws Exception {
        EntityManager enma = JpaConfig.getEntityManager();
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            Video video = enma.find(Video.class, videoId);
            if (video != null) {
                enma.remove(video);
            } else {
                throw new Exception("Không tìm thấy Video với mã: " + videoId);
            }
            trans.commit();
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            enma.close();
        }
    }

    @Override
    public Video findById(String videoId) {
        EntityManager enma = JpaConfig.getEntityManager();
        try {
            return enma.find(Video.class, videoId);
        } finally {
            enma.close();
        }
    }

    @Override
    public List<Video> findAll() {
        EntityManager enma = JpaConfig.getEntityManager();
        try {
            TypedQuery<Video> query = enma.createNamedQuery("Video.findAll", Video.class);
            return query.getResultList();
        } finally {
            enma.close();
        }
    }

    @Override
    public List<Video> findTop10Newest() {
        EntityManager enma = JpaConfig.getEntityManager();
        try {
            String jpql = "SELECT v FROM Video v WHERE v.active = 1 ORDER BY v.createdDate DESC, v.videoId DESC";
            TypedQuery<Video> query = enma.createQuery(jpql, Video.class);
            query.setMaxResults(10);
            return query.getResultList();
        } finally {
            enma.close();
        }
    }

    @Override
    public List<Video> findAllPaging(int page, int pageSize) {
        EntityManager enma = JpaConfig.getEntityManager();
        try {
            String jpql = "SELECT v FROM Video v ORDER BY v.createdDate DESC, v.videoId DESC";
            TypedQuery<Video> query = enma.createQuery(jpql, Video.class);
            int first = Math.max(0, (page - 1) * pageSize);
            query.setFirstResult(first);
            query.setMaxResults(pageSize);
            return query.getResultList();
        } finally {
            enma.close();
        }
    }

    @Override
    public List<Video> findByUserPaging(int userId, int page, int pageSize) {
        EntityManager enma = JpaConfig.getEntityManager();
        try {
            String jpql = "SELECT v FROM Video v WHERE v.user.id = :uid ORDER BY v.createdDate DESC, v.videoId DESC";
            TypedQuery<Video> query = enma.createQuery(jpql, Video.class);
            query.setParameter("uid", userId);
            int first = Math.max(0, (page - 1) * pageSize);
            query.setFirstResult(first);
            query.setMaxResults(pageSize);
            List<Video> list = query.getResultList();
            if (list.isEmpty()) {
                return findAllPaging(page, pageSize);
            }
            return list;
        } finally {
            enma.close();
        }
    }

    @Override
    public int countByUser(int userId) {
        EntityManager enma = JpaConfig.getEntityManager();
        try {
            TypedQuery<Long> query = enma.createQuery("SELECT count(v) FROM Video v WHERE v.user.id = :uid", Long.class);
            query.setParameter("uid", userId);
            Long cnt = query.getSingleResult();
            if (cnt == null || cnt == 0) {
                return count();
            }
            return cnt.intValue();
        } finally {
            enma.close();
        }
    }

    @Override
    public int count() {
        EntityManager enma = JpaConfig.getEntityManager();
        try {
            TypedQuery<Long> query = enma.createQuery("SELECT count(v) FROM Video v", Long.class);
            Long cnt = query.getSingleResult();
            return cnt != null ? cnt.intValue() : 0;
        } finally {
            enma.close();
        }
    }

    @Override
    public List<Video> searchByTitle(String keyword) {
        EntityManager enma = JpaConfig.getEntityManager();
        try {
            String jpql = "SELECT v FROM Video v WHERE LOWER(v.title) LIKE LOWER(:kw) OR LOWER(v.description) LIKE LOWER(:kw) ORDER BY v.createdDate DESC";
            TypedQuery<Video> query = enma.createQuery(jpql, Video.class);
            query.setParameter("kw", "%" + (keyword != null ? keyword.trim() : "") + "%");
            return query.getResultList();
        } finally {
            enma.close();
        }
    }
}
