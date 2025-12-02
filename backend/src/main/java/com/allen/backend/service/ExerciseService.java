package com.allen.backend.service;

import com.allen.backend.dto.ExerciseCreateRequest;
import com.allen.backend.dto.ExerciseResponse;
import com.allen.backend.dto.ExerciseSyncRequest;
import com.allen.backend.dto.ExerciseSyncRecord;
import com.allen.backend.dto.ExerciseSyncResponse;
import com.allen.backend.dto.Last7DaysReportResponse;
import com.allen.backend.entity.Exercise;
import com.allen.backend.repo.ExerciseRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.OffsetDateTime;
import java.time.ZonedDateTime;
import java.time.ZoneId;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Service
public class ExerciseService {

    private final ExerciseRepository repo;
    private final UserProfileService userProfileService;

    public ExerciseService(ExerciseRepository repo, UserProfileService userProfileService) {
        this.repo = repo;
        this.userProfileService = userProfileService;
    }

    @Transactional
    public ExerciseResponse create(ExerciseCreateRequest req) {
        Exercise ex = new Exercise();
        ex.setUserId(req.getUserId());
        ex.setType(req.getType());
        ex.setDurationMinutes(req.getDurationMinutes());
        ex.setLocation(req.getLocation());
        ex.setOccurredAt(req.getOccurredAt());
        Exercise saved = repo.save(ex);

        // 添加运动奖励积分50
        userProfileService.addPoints(req.getUserId(), 50);

        return toResp(saved);
    }

    @Transactional(readOnly = true)
    public ExerciseResponse getById(Long id) {
        Exercise ex = repo.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Exercise not found"));
        return toResp(ex);
    }

    @Transactional
    public void delete(Long id) {
        if (!repo.existsById(id)) throw new IllegalArgumentException("Exercise not found");
        repo.deleteById(id);
    }

    // 可选：列表/筛选
    @Transactional(readOnly = true)
    public Page<ExerciseResponse> list(Long userId, ZonedDateTime from, ZonedDateTime to,
                                       int page, int size) {
        PageRequest pr = PageRequest.of(page, size);
        if (userId != null && from != null && to != null) {
            return repo.findByUserIdAndOccurredAtBetween(userId, from, to, pr).map(this::toResp);
        } else if (userId != null) {
            return repo.findByUserId(userId, pr).map(this::toResp);
        } else {
            return repo.findAll(pr).map(this::toResp);
        }
    }

    @Transactional
    public ExerciseSyncResponse syncBatch(ExerciseSyncRequest req) {
        List<ExerciseSyncRecord> records = req.getRecords();
        int successCount = 0;
        List<String> errors = new ArrayList<>();

        for (int i = 0; i < records.size(); i++) {
            ExerciseSyncRecord record = records.get(i);
            try {
                // 转换 ISO 字符串为 ZonedDateTime
                ZonedDateTime occurredAt;
                if (record.getTimezone() != null && !record.getTimezone().isEmpty()) {
                    // 如果前端提供了时区信息，使用指定时区解析
                    ZoneId zoneId = ZoneId.of(record.getTimezone());
                    occurredAt = OffsetDateTime.parse(record.getWhen()).atZoneSameInstant(zoneId);
                } else {
                    // 如果没有时区信息，使用UTC解析后转为系统默认时区
                    occurredAt = OffsetDateTime.parse(record.getWhen()).atZoneSameInstant(ZoneId.systemDefault());
                }

                // 创建 Exercise 实体
                Exercise ex = new Exercise();
                ex.setUserId(req.getUserId());
                ex.setType(record.getType());
                ex.setDurationMinutes(record.getDuration());
                ex.setLocation(record.getLocation());
                ex.setOccurredAt(occurredAt);
                // 保存时区信息
                ex.setTimezone(record.getTimezone());

                repo.save(ex);

                // 批量同步时也添加积分奖励
                userProfileService.addPoints(req.getUserId(), 50);

                successCount++;
            } catch (Exception e) {
                errors.add("Record " + i + ": " + e.getMessage());
            }
        }

        String message = successCount == records.size()
                ? "All records synced successfully"
                : "Synced " + successCount + "/" + records.size() + " records. Errors: " + String.join(", ", errors);

        return new ExerciseSyncResponse(req.getDate(), records.size(), successCount, message);
    }

    @Transactional(readOnly = true)
    public Last7DaysReportResponse getLast7DaysReport(Long userId) {
        // Get current date in UTC
        ZonedDateTime now = ZonedDateTime.now(ZoneId.of("UTC"));
        LocalDate today = now.toLocalDate();

        // Calculate date range for last 7 days (from yesterday going back 7 days)
        LocalDate yesterday = today.minusDays(1);
        LocalDate startDate = yesterday.minusDays(6); // 7 days total: yesterday and 6 days before
        ZonedDateTime startDateTime = startDate.atStartOfDay(ZoneId.of("UTC"));
        ZonedDateTime endDateTime = today.atStartOfDay(ZoneId.of("UTC")); // End of yesterday (start of today)

        // Get all exercises for the user in the last 7 days
        List<Exercise> exercises = repo.findByUserIdAndOccurredAtBetween(
                userId, startDateTime, endDateTime, PageRequest.of(0, 1000)
        ).getContent();

        // Group exercises by date and sum durations
        // Use each exercise's own timezone for grouping (if available), otherwise use UTC
        Map<LocalDate, Integer> durationByDate = new HashMap<>();
        for (Exercise exercise : exercises) {
            ZoneId exerciseZone;
            if (exercise.getTimezone() != null && !exercise.getTimezone().isEmpty()) {
                try {
                    exerciseZone = ZoneId.of(exercise.getTimezone());
                } catch (Exception e) {
                    // If timezone is invalid, fall back to UTC
                    exerciseZone = ZoneId.of("UTC");
                }
            } else {
                // If no timezone info, use UTC
                exerciseZone = ZoneId.of("UTC");
            }

            // Convert to local date in the exercise's timezone
            LocalDate exerciseDate = exercise.getOccurredAt().withZoneSameInstant(exerciseZone).toLocalDate();
            durationByDate.merge(exerciseDate, exercise.getDurationMinutes(), Integer::sum);
        }

        // Build response with all 7 days (fill missing days with 0)
        // Start from yesterday and go back 7 days
        List<String> dates = new ArrayList<>();
        List<Integer> durations = new ArrayList<>();
        DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE;

        for (int i = 6; i >= 0; i--) {
            LocalDate date = yesterday.minusDays(i);
            dates.add(date.format(formatter));
            durations.add(durationByDate.getOrDefault(date, 0));
        }

        return new Last7DaysReportResponse(dates, durations);
    }

    private ExerciseResponse toResp(Exercise e) {
        return new ExerciseResponse(
                e.getId(), e.getUserId(), e.getType(), e.getDurationMinutes(),
                e.getLocation(), e.getOccurredAt(), e.getTimezone()
        );
    }
}
