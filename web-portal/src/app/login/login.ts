import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../services/auth';
import { HttpErrorResponse } from '@angular/common/http';

@Component({
  selector: 'app-login',
  imports: [CommonModule, FormsModule],
  templateUrl: './login.html',
  styleUrl: './login.scss',
})
export class Login {
  // Toggle between login and register mode
  isLoginMode = true;

  // Form fields
  username = '';
  password = '';
  confirmPassword = '';

  // Error message
  errorMessage = '';

  // Loading state
  isLoading = false;

  constructor(
    private authService: AuthService,
    private router: Router
  ) {}

  // Toggle between login and register
  toggleMode() {
    this.isLoginMode = !this.isLoginMode;
    // Clear form and error when switching modes
    this.username = '';
    this.password = '';
    this.confirmPassword = '';
    this.errorMessage = '';
  }

  // Login handler
  onLogin() {
    // Clear previous error
    this.errorMessage = '';

    // Validate input
    if (!this.username || !this.password) {
      this.errorMessage = 'Please enter username and password';
      return;
    }

    this.isLoading = true;

    this.authService.login(this.username, this.password).subscribe({
      next: (response) => {
        console.log('Login successful:', response);
        this.isLoading = false;
        // Save username to localStorage
        localStorage.setItem('username', response.username);
        // Navigate to dashboard
        this.router.navigate(['/dashboard']);
      },
      error: (error: HttpErrorResponse) => {
        this.isLoading = false;
        console.error('Login failed:', error);

        // Handle different error cases
        if (error.status === 401) {
          // Unauthorized - wrong password or user not found
          if (typeof error.error === 'string') {
            const errorMsg = error.error.toLowerCase();
            if (errorMsg.includes('not found') || errorMsg.includes('does not exist')) {
              this.errorMessage = 'User not found. Please register first.';
            } else if (errorMsg.includes('password') || errorMsg.includes('incorrect')) {
              this.errorMessage = 'Incorrect password. Please try again.';
            } else {
              this.errorMessage = error.error;
            }
          } else {
            this.errorMessage = 'Invalid username or password';
          }
        } else if (error.status === 0) {
          // Network error
          this.errorMessage = 'Cannot connect to server. Please try again later.';
        } else {
          this.errorMessage = 'Login failed. Please try again.';
        }
      }
    });
  }

  // Register handler
  onRegister() {
    // Clear previous error
    this.errorMessage = '';

    // Validate input
    if (!this.username || !this.password || !this.confirmPassword) {
      this.errorMessage = 'Please fill in all fields';
      return;
    }

    // Check if passwords match
    if (this.password !== this.confirmPassword) {
      this.errorMessage = 'Passwords do not match';
      return;
    }

    // Validate username length (3-32 characters)
    if (this.username.length < 3 || this.username.length > 32) {
      this.errorMessage = 'Username must be between 3 and 32 characters';
      return;
    }

    // Validate password length (3-100 characters)
    if (this.password.length < 3 || this.password.length > 100) {
      this.errorMessage = 'Password must be between 3 and 100 characters';
      return;
    }

    this.isLoading = true;

    this.authService.register(this.username, this.password).subscribe({
      next: (response) => {
        console.log('Registration successful:', response);
        this.isLoading = false;
        // Save username to localStorage
        localStorage.setItem('username', response.username);
        // Navigate to dashboard after successful registration
        this.router.navigate(['/dashboard']);
      },
      error: (error: HttpErrorResponse) => {
        this.isLoading = false;
        console.error('Registration failed:', error);

        // Handle different error cases
        if (error.status === 409) {
          // Conflict - username already exists
          if (typeof error.error === 'string') {
            this.errorMessage = error.error;
          } else {
            this.errorMessage = 'Username already exists. Please choose a different username.';
          }
        } else if (error.status === 400) {
          // Bad request - validation error
          this.errorMessage = 'Invalid input. Please check your username and password.';
        } else if (error.status === 0) {
          // Network error
          this.errorMessage = 'Cannot connect to server. Please try again later.';
        } else {
          this.errorMessage = 'Registration failed. Please try again.';
        }
      }
    });
  }
}
