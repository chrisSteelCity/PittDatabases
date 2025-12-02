package com.allen.backend.dto;

import java.time.LocalDate;

public class UserProfileResponse {
    private Long id;
    private String username;
    private Integer points;
    private String address;
    private LocalDate lastCheckinDate;

    public UserProfileResponse() { }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public Integer getPoints() { return points; }
    public void setPoints(Integer points) { this.points = points; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public LocalDate getLastCheckinDate() { return lastCheckinDate; }
    public void setLastCheckinDate(LocalDate lastCheckinDate) { this.lastCheckinDate = lastCheckinDate; }
}
