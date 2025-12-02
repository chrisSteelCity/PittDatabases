package com.allen.backend.dto;

import java.util.List;

public class Last7DaysReportResponse {
    private List<String> dates;
    private List<Integer> durations;

    public Last7DaysReportResponse() {}

    public Last7DaysReportResponse(List<String> dates, List<Integer> durations) {
        this.dates = dates;
        this.durations = durations;
    }

    public List<String> getDates() {
        return dates;
    }

    public void setDates(List<String> dates) {
        this.dates = dates;
    }

    public List<Integer> getDurations() {
        return durations;
    }

    public void setDurations(List<Integer> durations) {
        this.durations = durations;
    }
}
