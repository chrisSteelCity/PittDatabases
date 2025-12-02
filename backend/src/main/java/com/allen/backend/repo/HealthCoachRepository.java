package com.allen.backend.repo;

import com.allen.backend.entity.HealthCoach;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface HealthCoachRepository extends JpaRepository<HealthCoach, Long> {
    boolean existsByUsername(String username);
    Optional<HealthCoach> findByUsername(String username);
}
