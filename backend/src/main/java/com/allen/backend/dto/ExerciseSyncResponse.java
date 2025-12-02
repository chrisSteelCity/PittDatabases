package com.allen.backend.dto;

public class ExerciseSyncResponse {
    private String date;
    private int totalRecords;
    private int successCount;
    private String message;

    public ExerciseSyncResponse(String date, int totalRecords, int successCount, String message) {
        this.date = date;
        this.totalRecords = totalRecords;
        this.successCount = successCount;
        this.message = message;
    }

    // getters/setters
    public String getDate() { return date; }
    public void setDate(String date) { this.date = date; }
    public int getTotalRecords() { return totalRecords; }
    public void setTotalRecords(int totalRecords) { this.totalRecords = totalRecords; }
    public int getSuccessCount() { return successCount; }
    public void setSuccessCount(int successCount) { this.successCount = successCount; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
}
