package com.allen.backend.service;

import com.allen.backend.dto.LoginRequest;
import com.allen.backend.dto.RegisterRequest;
import com.allen.backend.dto.UserResponse;
import com.allen.backend.entity.User;
import com.allen.backend.repo.UserRepository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
public class AuthService {

    private final UserRepository userRepo;
    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    public AuthService(UserRepository userRepo) {
        this.userRepo = userRepo;
    }

    @Transactional
    public UserResponse register(RegisterRequest req) {
        if (userRepo.existsByUsername(req.getUsername())) {
            throw new IllegalArgumentException("Username already exists");
        }
        String hash = encoder.encode(req.getPassword());
        User user = new User(req.getUsername(), hash);
        // 生成并设置 UUID
        user.setUuid(UUID.randomUUID().toString());
        User saved = userRepo.save(user);
        return new UserResponse(saved.getId(), saved.getUsername());
    }

    @Transactional(readOnly = true)
    public UserResponse login(LoginRequest req) {
        User user = userRepo.findByUsername(req.getUsername())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        if (!encoder.matches(req.getPassword(), user.getPasswordHash())) {
            throw new IllegalArgumentException("Invalid password");
        }
        return new UserResponse(user.getId(), user.getUsername());
    }

    @Transactional(readOnly = true)
    public UserResponse getById(Long id) {
        User user = userRepo.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        return new UserResponse(user.getId(), user.getUsername());
    }
}
