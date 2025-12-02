package com.allen.backend.dto;

import com.allen.backend.entity.ExerciseType;

import java.time.ZonedDateTime;

public class ExerciseResponse {
    private Long id;
    private Long userId;
    private ExerciseType type;
    private Integer durationMinutes;
    private String location;
    private ZonedDateTime occurredAt;
    private String timezone;

    public ExerciseResponse() {}
    public ExerciseResponse(Long id, Long userId, ExerciseType type, Integer durationMinutes,
                            String location, ZonedDateTime occurredAt, String timezone) {
        this.id = id; this.userId = userId; this.type = type;
        this.durationMinutes = durationMinutes; this.location = location;
        this.occurredAt = occurredAt; this.timezone = timezone;
    }

    // getters/setters...
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public ExerciseType getType() { return type; }
    public void setType(ExerciseType type) { this.type = type; }
    public Integer getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(Integer durationMinutes) { this.durationMinutes = durationMinutes; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public ZonedDateTime getOccurredAt() { return occurredAt; }
    public void setOccurredAt(ZonedDateTime occurredAt) { this.occurredAt = occurredAt; }
    public String getTimezone() { return timezone; }
    public void setTimezone(String timezone) { this.timezone = timezone; }
}
