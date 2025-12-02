import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';

@Component({
  selector: 'app-main-layout',
  imports: [CommonModule, RouterModule],
  templateUrl: './main-layout.html',
  styleUrl: './main-layout.scss',
})
export class MainLayout implements OnInit {
  currentUsername: string = 'Guest';

  constructor(private router: Router) {}

  ngOnInit() {
    // Get current username from localStorage
    const storedUsername = localStorage.getItem('username');
    if (storedUsername) {
      this.currentUsername = storedUsername;
      console.log('Logged in as:', storedUsername);
    } else {
      console.warn('No username found in localStorage. Please login again.');
      this.currentUsername = 'Guest';
    }
  }

  logout() {
    if (confirm('Are you sure you want to logout?')) {
      // Clear localStorage
      localStorage.removeItem('username');
      // Navigate to login page
      this.router.navigate(['/login']);
    }
  }
}
