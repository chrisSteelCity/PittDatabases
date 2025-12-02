package com.allen.backend.service;

import com.allen.backend.dto.*;
import com.allen.backend.entity.Exercise;
import com.allen.backend.entity.HealthCoach;
import com.allen.backend.entity.User;
import com.allen.backend.repo.ExerciseRepository;
import com.allen.backend.repo.HealthCoachRepository;
import com.allen.backend.repo.UserRepository;
import org.springframework.data.domain.PageRequest;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.ZonedDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class CoachAuthService {

    private final HealthCoachRepository repo;
    private final UserRepository userRepo;
    private final ExerciseRepository exerciseRepo;
    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    public CoachAuthService(HealthCoachRepository repo, UserRepository userRepo, ExerciseRepository exerciseRepo) {
        this.repo = repo;
        this.userRepo = userRepo;
        this.exerciseRepo = exerciseRepo;
    }

    @Transactional
    public CoachResponse register(CoachRegisterRequest req) {
        if (repo.existsByUsername(req.getUsername()))
            throw new IllegalArgumentException("Username already exists");
        HealthCoach saved = repo.save(new HealthCoach(
                req.getUsername(),
                encoder.encode(req.getPassword())
        ));
        return new CoachResponse(saved.getId(), saved.getUsername());
    }

    @Transactional(readOnly = true)
    public CoachResponse login(CoachLoginRequest req) {
        HealthCoach coach = repo.findByUsername(req.getUsername())
                .orElseThrow(() -> new IllegalArgumentException("Coach not found"));
        if (!encoder.matches(req.getPassword(), coach.getPasswordHash()))
            throw new IllegalArgumentException("Invalid password");
        return new CoachResponse(coach.getId(), coach.getUsername());
    }

    @Transactional(readOnly = true)
    public CoachResponse getById(Long id) {
        HealthCoach coach = repo.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Coach not found"));
        return new CoachResponse(coach.getId(), coach.getUsername());
    }

    @Transactional(readOnly = true)
    public List<UserSummaryResponse> getAllUsersWithLastReport() {
        List<User> users = userRepo.findAll();
        ZonedDateTime now = ZonedDateTime.now();

        return users.stream()
                .map(user -> {
                    // Get the latest exercise for this user
                    List<Exercise> exercises = exerciseRepo
                            .findLatestByUserId(user.getId(), PageRequest.of(0, 1));
                    Exercise latestExercise = exercises.isEmpty() ? null : exercises.get(0);

                    // Calculate days since last report
                    Long daysSinceReport;
                    if (latestExercise != null) {
                        daysSinceReport = ChronoUnit.DAYS.between(
                                latestExercise.getOccurredAt().toLocalDate(),
                                now.toLocalDate()
                        );
                    } else {
                        daysSinceReport = -1L; // No reports
                    }

                    return new UserSummaryResponse(
                            user.getId(),
                            user.getUsername(),
                            latestExercise != null ? latestExercise.getOccurredAt() : null,
                            daysSinceReport
                    );
                })
                // Sort by lastReportTime ascending (earliest/oldest date first)
                // Users with no reports (null lastReportTime) will be at the end
                .sorted(Comparator.comparing(
                        UserSummaryResponse::getLastReportTime,
                        Comparator.nullsLast(Comparator.naturalOrder())
                ))
                .collect(Collectors.toList());
    }
}
