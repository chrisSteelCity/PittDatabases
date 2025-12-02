package com.allen.backend.dto;

import com.allen.backend.entity.ExerciseType;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public class ExerciseSyncRecord {
    @NotNull
    private ExerciseType type;

    @NotNull
    @Min(1)
    private Integer duration;

    @NotNull
    private String when;

    @NotNull
    private String location;

    // 时区信息（IANA时区ID，如 "America/New_York"）
    private String timezone;

    // getters/setters
    public ExerciseType getType() { return type; }
    public void setType(ExerciseType type) { this.type = type; }
    public Integer getDuration() { return duration; }
    public void setDuration(Integer duration) { this.duration = duration; }
    public String getWhen() { return when; }
    public void setWhen(String when) { this.when = when; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public String getTimezone() { return timezone; }
    public void setTimezone(String timezone) { this.timezone = timezone; }
}
