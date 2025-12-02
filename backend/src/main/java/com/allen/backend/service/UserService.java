package com.allen.backend.service;

import com.allen.backend.dto.UserProfileResponse;
import com.allen.backend.entity.User;
import com.allen.backend.repo.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Transactional(readOnly = true)
    public List<UserProfileResponse> getAllUsers() {
        List<User> users = userRepository.findAll();
        return users.stream()
                .map(this::toUserProfileResponse)
                .collect(Collectors.toList());
    }

    @Transactional
    public UserProfileResponse updateUser(Long userId, Map<String, Object> updates) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (updates.containsKey("username")) {
            user.setUsername((String) updates.get("username"));
        }

        if (updates.containsKey("points")) {
            user.setPoints(((Number) updates.get("points")).intValue());
        }

        if (updates.containsKey("address")) {
            user.setAddress((String) updates.get("address"));
        }

        userRepository.save(user);
        return toUserProfileResponse(user);
    }

    @Transactional
    public void deleteUser(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        userRepository.delete(user);
    }

    private UserProfileResponse toUserProfileResponse(User user) {
        UserProfileResponse response = new UserProfileResponse();
        response.setId(user.getId());
        response.setUsername(user.getUsername());
        response.setPoints(user.getPoints());
        response.setAddress(user.getAddress());
        response.setLastCheckinDate(user.getLastCheckinDate());
        return response;
    }
}
