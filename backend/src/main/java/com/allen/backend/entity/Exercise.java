package com.allen.backend.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

import java.time.ZonedDateTime;

@Entity
@Table(name = "exercises", indexes = {
        @Index(name = "idx_exercises_user_time", columnList = "user_id, occurred_at")
})
public class Exercise {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // 外键直接存 userId（简单起步；未来可改 @ManyToOne User）
    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 24)
    private ExerciseType type;

    @Min(1)
    @Column(name = "duration_minutes", nullable = false)
    private Integer durationMinutes;

    @Column(length = 128)
    private String location;

    @NotNull
    @Column(name = "occurred_at", nullable = false)
    private ZonedDateTime occurredAt;

    // 时区信息（IANA时区ID，如 "America/New_York"）
    @Column(name = "timezone", length = 64)
    private String timezone;

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
