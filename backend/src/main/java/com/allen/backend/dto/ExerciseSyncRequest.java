package com.allen.backend.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;

import java.util.List;

public class ExerciseSyncRequest {
    @NotNull
    private String date;

    @NotNull
    private Long userId;

    @NotNull
    @NotEmpty
    @Valid
    private List<ExerciseSyncRecord> records;

    // getters/setters
    public String getDate() { return date; }
    public void setDate(String date) { this.date = date; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public List<ExerciseSyncRecord> getRecords() { return records; }
    public void setRecords(List<ExerciseSyncRecord> records) { this.records = records; }
}
