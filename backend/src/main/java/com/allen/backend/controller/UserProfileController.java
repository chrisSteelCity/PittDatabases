package com.allen.backend.controller;

import com.allen.backend.dto.UpdateAddressRequest;
import com.allen.backend.dto.UserProfileResponse;
import com.allen.backend.service.UserProfileService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/user/profile")
public class UserProfileController {

    private final UserProfileService userProfileService;

    public UserProfileController(UserProfileService userProfileService) {
        this.userProfileService = userProfileService;
    }

    @GetMapping("/{userId}")
    public ResponseEntity<?> getUserProfile(@PathVariable Long userId) {
        try {
            return ResponseEntity.ok(userProfileService.getUserProfile(userId));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/{userId}/address")
    public ResponseEntity<?> updateAddress(@PathVariable Long userId, @Valid @RequestBody UpdateAddressRequest request) {
        try {
            return ResponseEntity.ok(userProfileService.updateAddress(userId, request.getAddress()));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/{userId}/checkin")
    public ResponseEntity<?> checkin(@PathVariable Long userId) {
        try {
            return ResponseEntity.ok(userProfileService.checkin(userId));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
