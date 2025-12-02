package com.allen.backend.service;

import com.allen.backend.dto.UserProfileResponse;
import com.allen.backend.entity.User;
import com.allen.backend.repo.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;

@Service
public class UserProfileService {

    private final UserRepository userRepository;

    public UserProfileService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Transactional(readOnly = true)
    public UserProfileResponse getUserProfile(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        UserProfileResponse response = new UserProfileResponse();
        response.setId(user.getId());
        response.setUsername(user.getUsername());
        response.setPoints(user.getPoints());
        response.setAddress(user.getAddress());
        response.setLastCheckinDate(user.getLastCheckinDate());
        return response;
    }

    @Transactional
    public UserProfileResponse updateAddress(Long userId, String address) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        user.setAddress(address);
        userRepository.save(user);

        return getUserProfile(userId);
    }

    @Transactional
    public UserProfileResponse checkin(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        LocalDate today = LocalDate.now();

        if (user.getLastCheckinDate() != null && user.getLastCheckinDate().equals(today)) {
            throw new IllegalArgumentException("Already checked in today");
        }

        user.setPoints(user.getPoints() + 20);
        user.setLastCheckinDate(today);
        userRepository.save(user);

        return getUserProfile(userId);
    }

    @Transactional
    public void addPoints(Long userId, Integer points) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        user.setPoints(user.getPoints() + points);
        userRepository.save(user);
    }
}
