import { Component } from '@angular/core';
import { IonicModule, ToastController } from '@ionic/angular';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Router } from '@angular/router';

@Component({
  standalone: true,
  selector: 'app-auth',
  templateUrl: './auth.page.html',
  styleUrl: './auth.page.scss',
  imports: [IonicModule, CommonModule, FormsModule],
})
export class AuthPage {
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
    private http: HttpClient,
    private toast: ToastController,
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
  async onLogin() {
    // Clear previous error
    this.errorMessage = '';

    // Validate input
    if (!this.username || !this.password) {
      this.errorMessage = 'Please enter username and password';
      return;
    }

    this.isLoading = true;

    this.http.post<{id: number, username: string}>('http://localhost:8080/api/auth/login',
      { username: this.username, password: this.password })
      .subscribe({
        next: async (res) => {
          this.isLoading = false;
          // Save username and user ID to localStorage
          localStorage.setItem('currentUsername', res.username);
          localStorage.setItem('currentUserId', res.id.toString());

          (await this.toast.create({
            message: 'Login successful!',
            duration: 1200,
            color: 'success',
          })).present();

          // Navigate to tabs after successful login
          this.router.navigateByUrl('/tabs/add');
        },
        error: async (error: HttpErrorResponse) => {
          this.isLoading = false;
          console.error('Login failed:', error);

          // Handle different error cases
          if (error.status === 401) {
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
            this.errorMessage = 'Cannot connect to server. Please try again later.';
          } else {
            this.errorMessage = 'Login failed. Please try again.';
          }

          (await this.toast.create({
            message: this.errorMessage,
            duration: 1800,
            color: 'danger',
          })).present();
        }
      });
  }

  // Register handler
  async onRegister() {
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

    this.http.post<{id: number, username: string}>('http://localhost:8080/api/auth/register',
      { username: this.username, password: this.password })
      .subscribe({
        next: async (res) => {
          this.isLoading = false;
          // Save username and user ID to localStorage
          localStorage.setItem('currentUsername', res.username);
          localStorage.setItem('currentUserId', res.id.toString());

          (await this.toast.create({
            message: 'Registration successful!',
            duration: 1200,
            color: 'success',
          })).present();

          // Navigate to tabs after successful registration
          this.router.navigateByUrl('/tabs/add');
        },
        error: async (error: HttpErrorResponse) => {
          this.isLoading = false;
          console.error('Registration failed:', error);

          // Handle different error cases
          if (error.status === 409) {
            if (typeof error.error === 'string') {
              this.errorMessage = error.error;
            } else {
              this.errorMessage = 'Username already exists. Please choose a different username.';
            }
          } else if (error.status === 400) {
            this.errorMessage = 'Invalid input. Please check your username and password.';
          } else if (error.status === 0) {
            this.errorMessage = 'Cannot connect to server. Please try again later.';
          } else {
            this.errorMessage = 'Registration failed. Please try again.';
          }

          (await this.toast.create({
            message: this.errorMessage,
            duration: 1800,
            color: 'danger',
          })).present();
        }
      });
  }
}
