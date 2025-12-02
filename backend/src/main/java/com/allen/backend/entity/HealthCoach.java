package com.allen.backend.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Entity
@Table(name = "health_coaches", uniqueConstraints = {
        @UniqueConstraint(name = "uk_health_coaches_username", columnNames = "username")
})
public class HealthCoach {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id; // health coach id

    @NotBlank
    @Size(min = 3, max = 32)
    @Column(nullable = false, length = 32)
    private String username;

    @NotBlank
    @Size(min = 3, max = 100)
    @Column(name = "password_hash", nullable = false, length = 100)
    private String passwordHash;

    public HealthCoach() {}
    public HealthCoach(String username, String passwordHash) {
        this.username = username; this.passwordHash = passwordHash;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
}
