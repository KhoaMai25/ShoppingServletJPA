package vn.iotstar.entity;

import java.io.Serializable;
import java.sql.Timestamp;
import jakarta.persistence.*;

@Entity
@Table(name = "videos")
@NamedQuery(name = "Video.findAll", query = "SELECT v FROM Video v ORDER BY v.createdDate DESC, v.videoId DESC")
public class Video implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "VideoId", length = 100)
    private String videoId;

    @Column(name = "Active")
    private int active = 1;

    @Column(name = "Description", columnDefinition = "nvarchar(1000) null")
    private String description;

    @Column(name = "Poster", columnDefinition = "nvarchar(500) null")
    private String poster;

    @Column(name = "Title", columnDefinition = "nvarchar(500) null")
    private String title;

    @Column(name = "Views")
    private int views;

    @Column(name = "VideoUrl", columnDefinition = "nvarchar(500) null")
    private String videoUrl;

    @Column(name = "CreatedDate")
    private Timestamp createdDate;

    // Quan hệ n-1 với bảng Category
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "CategoryId")
    private Category category;

    // Quan hệ n-1 với bảng Users (1 User có nhiều Videos)
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "userid")
    private User user;

    public Video() {
    }

    public Video(String videoId, String title, String poster, int views, String description, int active, Category category, User user, String videoUrl, Timestamp createdDate) {
        this.videoId = videoId;
        this.title = title;
        this.poster = poster;
        this.views = views;
        this.description = description;
        this.active = active;
        this.category = category;
        this.user = user;
        this.videoUrl = videoUrl;
        this.createdDate = createdDate;
    }

    public String getVideoId() {
        return videoId;
    }

    public void setVideoId(String videoId) {
        this.videoId = videoId;
    }

    public int getActive() {
        return active;
    }

    public void setActive(int active) {
        this.active = active;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPoster() {
        return poster;
    }

    public void setPoster(String poster) {
        this.poster = poster;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getViews() {
        return views;
    }

    public void setViews(int views) {
        this.views = views;
    }

    public String getVideoUrl() {
        return videoUrl;
    }

    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
