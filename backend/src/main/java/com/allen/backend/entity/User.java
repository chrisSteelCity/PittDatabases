package com.allen.backend.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Entity
@Table(name = "users", uniqueConstraints = {
        @UniqueConstraint(name = "uk_users_username", columnNames = "username")
})
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Size(min = 3, max = 32)
    @Column(nullable = false, length = 32)
    private String username;

    @NotBlank
    @Size(min = 3, max = 100)
    @Column(nullable = false, length = 100)
    private String passwordHash; // 存BCrypt后的hash

    // UUID字段 - 系统自动生成，不参与业务逻辑
    @Column(nullable = false, unique = true, length = 36)
    private String uuid;

    // 积分系统相关字段
    @Column(nullable = false, columnDefinition = "INT DEFAULT 0")
    private Integer points = 0;

    // 用户地址
    @Column(length = 255)
    private String address;

    // 最后签到时间
    @Column(name = "last_checkin_date")
    private java.time.LocalDate lastCheckinDate;

    public User() { }

    public User(String username, String passwordHash) {
        this.username = username;
        this.passwordHash = passwordHash;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getUuid() { return uuid; }
    public void setUuid(String uuid) { this.uuid = uuid; }

    public Integer getPoints() { return points; }
    public void setPoints(Integer points) { this.points = points; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public java.time.LocalDate getLastCheckinDate() { return lastCheckinDate; }
    public void setLastCheckinDate(java.time.LocalDate lastCheckinDate) { this.lastCheckinDate = lastCheckinDate; }
}
