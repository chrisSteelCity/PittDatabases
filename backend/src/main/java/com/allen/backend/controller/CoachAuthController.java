package com.allen.backend.controller;

import com.allen.backend.dto.*;
import com.allen.backend.service.CoachAuthService;
import com.allen.backend.service.ExerciseService;
import jakarta.validation.Valid;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class CoachAuthController {

    private final CoachAuthService service;
    private final ExerciseService exerciseService;

    public CoachAuthController(CoachAuthService service, ExerciseService exerciseService) {
        this.service = service;
        this.exerciseService = exerciseService;
    }

    // POST /api/coach/register
    @PostMapping("/coach/register")
    public ResponseEntity<?> register(@Valid @RequestBody CoachRegisterRequest req) {
        try { return ResponseEntity.status(HttpStatus.CREATED).body(service.register(req)); }
        catch (IllegalArgumentException e) { return ResponseEntity.status(HttpStatus.CONFLICT).body(e.getMessage()); }
    }

    // POST /api/coach/login
    @PostMapping("/coach/login")
    public ResponseEntity<?> login(@Valid @RequestBody CoachLoginRequest req) {
        try { return ResponseEntity.ok(service.login(req)); }
        catch (IllegalArgumentException e) { return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(e.getMessage()); }
    }

    // GET /api/coaches/{id}
    @GetMapping("/coaches/{id}")
    public ResponseEntity<?> getById(@PathVariable Long id) {
        try { return ResponseEntity.ok(service.getById(id)); }
        catch (IllegalArgumentException e) { return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage()); }
    }

    // GET /api/coaches/users - Get all users with their last report time
    @GetMapping("/coaches/users")
    public ResponseEntity<?> getAllUsersWithLastReport() {
        try { return ResponseEntity.ok(service.getAllUsersWithLastReport()); }
        catch (Exception e) { return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage()); }
    }

    // GET /api/coaches/user/{userId}/reports/last7days - Get last 7 days exercise report for a user
    @GetMapping("/coaches/user/{userId}/reports/last7days")
    public ResponseEntity<?> getLast7DaysReport(@PathVariable Long userId) {
        try { return ResponseEntity.ok(exerciseService.getLast7DaysReport(userId)); }
        catch (Exception e) { return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage()); }
    }
}
