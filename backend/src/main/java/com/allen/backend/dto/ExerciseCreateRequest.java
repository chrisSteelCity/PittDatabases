package com.allen.backend.dto;

import com.allen.backend.entity.ExerciseType;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

import java.time.ZonedDateTime;

public class ExerciseCreateRequest {
    @NotNull
    private Long userId;

    @NotNull
    private ExerciseType type;

    @NotNull @Min(1)
    private Integer durationMinutes;

    private String location;

    @NotNull
    private ZonedDateTime occurredAt;

    // getters/setters...
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
}
