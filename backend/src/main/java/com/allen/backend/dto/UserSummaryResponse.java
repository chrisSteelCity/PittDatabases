package com.allen.backend.dto;

import java.time.ZonedDateTime;

public class UserSummaryResponse {
    private Long id;
    private String username;
    private ZonedDateTime lastReportTime;
    private Long daysSinceReport; // Number of days since last report, -1 if no reports

    public UserSummaryResponse() {}

    public UserSummaryResponse(Long id, String username, ZonedDateTime lastReportTime, Long daysSinceReport) {
        this.id = id;
        this.username = username;
        this.lastReportTime = lastReportTime;
        this.daysSinceReport = daysSinceReport;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public ZonedDateTime getLastReportTime() { return lastReportTime; }
    public void setLastReportTime(ZonedDateTime lastReportTime) { this.lastReportTime = lastReportTime; }

    public Long getDaysSinceReport() { return daysSinceReport; }
    public void setDaysSinceReport(Long daysSinceReport) { this.daysSinceReport = daysSinceReport; }
}
