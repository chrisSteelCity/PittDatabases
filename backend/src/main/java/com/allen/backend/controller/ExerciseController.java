package com.allen.backend.controller;

import com.allen.backend.dto.ExerciseCreateRequest;
import com.allen.backend.dto.ExerciseResponse;
import com.allen.backend.dto.ExerciseSyncRequest;
import com.allen.backend.dto.ExerciseSyncResponse;
import com.allen.backend.service.ExerciseService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.ZonedDateTime;

@RestController
@RequestMapping("/api/exercises")
public class ExerciseController {

    private final ExerciseService service;
    public ExerciseController(ExerciseService service) { this.service = service; }

    // POST /api/exercises
    @PostMapping
    public ResponseEntity<?> create(@Valid @RequestBody ExerciseCreateRequest req) {
        try {
            ExerciseResponse resp = service.create(req);
            return ResponseEntity.status(HttpStatus.CREATED).body(resp);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // POST /api/exercises/sync - 批量同步记录
    @PostMapping("/sync")
    public ResponseEntity<?> syncBatch(@Valid @RequestBody ExerciseSyncRequest req) {
        try {
            ExerciseSyncResponse resp = service.syncBatch(req);
            return ResponseEntity.ok(resp);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Sync failed: " + e.getMessage());
        }
    }

    // GET /api/exercises/{id}
    @GetMapping("/{id}")
    public ResponseEntity<?> getById(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(service.getById(id));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

    // DELETE /api/exercises/{id}
    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        try {
            service.delete(id);
            return ResponseEntity.noContent().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

    // （可选）GET /api/exercises?userId=&from=&to=&page=&size=
    @GetMapping
    public ResponseEntity<Page<ExerciseResponse>> list(
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) ZonedDateTime from,
            @RequestParam(required = false) ZonedDateTime to,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        return ResponseEntity.ok(service.list(userId, from, to, page, size));
    }
}
