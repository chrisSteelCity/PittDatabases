package com.allen.backend.repo;

import com.allen.backend.entity.Exercise;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.ZonedDateTime;
import java.util.List;

public interface ExerciseRepository extends JpaRepository<Exercise, Long> {

    Page<Exercise> findByUserIdAndOccurredAtBetween(
            Long userId, ZonedDateTime from, ZonedDateTime to, Pageable pageable);

    Page<Exercise> findByUserId(Long userId, Pageable pageable);

    // Find the latest exercise for a specific user
    @Query("SELECT e FROM Exercise e WHERE e.userId = ?1 ORDER BY e.occurredAt DESC")
    List<Exercise> findLatestByUserId(Long userId, Pageable pageable);
}
