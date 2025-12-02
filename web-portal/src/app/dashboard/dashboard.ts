import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { DashboardService, UserSummary } from '../services/dashboard';

interface User {
  id: number; // User ID for navigation
  username: string;
  alert: boolean;
  lastReportTime: string;
  daysSinceReport: number; // Number of days since last report, -1 if no reports
}

@Component({
  selector: 'app-dashboard',
  imports: [CommonModule],
  templateUrl: './dashboard.html',
  styleUrl: './dashboard.scss',
})
export class Dashboard {
  // Expose Math for template
  Math = Math;

  // Pagination settings
  currentPage = 1;
  itemsPerPage = 10;
  totalItems = 0;
  totalPages = 0;

  // User data
  users: User[] = [];
  displayedUsers: User[] = [];

  constructor(
    private dashboardService: DashboardService,
    private router: Router
  ) {}

  ngOnInit() {
    this.loadUsers();
  }

  loadUsers() {
    this.dashboardService.getAllUsersWithLastReport().subscribe({
      next: (data: UserSummary[]) => {
        this.users = data.map(user => this.mapToUser(user));
        this.updatePagination();
      },
      error: (error) => {
        console.error('Failed to load users:', error);
      }
    });
  }

  mapToUser(summary: UserSummary): User {
    const lastReportTime = summary.lastReportTime
      ? new Date(summary.lastReportTime)
      : null;

    // Use daysSinceReport from backend
    const daysSinceReport = summary.daysSinceReport;

    return {
      id: summary.id,
      username: summary.username,
      alert: daysSinceReport > 2,
      lastReportTime: lastReportTime
        ? this.formatDateTime(lastReportTime)
        : 'No reports',
      daysSinceReport: daysSinceReport
    };
  }

  calculateDaysDifference(date1: Date, date2: Date): number {
    const diffTime = Math.abs(date2.getTime() - date1.getTime());
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    return diffDays;
  }

  formatDateTime(date: Date): string {
    return date.toLocaleString('en-US', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      hour12: false
    });
  }

  updatePagination() {
    this.totalItems = this.users.length;
    this.totalPages = Math.ceil(this.totalItems / this.itemsPerPage);
    this.updateDisplayedUsers();
  }

  updateDisplayedUsers() {
    const startIndex = (this.currentPage - 1) * this.itemsPerPage;
    const endIndex = startIndex + this.itemsPerPage;
    this.displayedUsers = this.users.slice(startIndex, endIndex);
  }

  goToPage(page: number) {
    if (page >= 1 && page <= this.totalPages) {
      this.currentPage = page;
      this.updateDisplayedUsers();
    }
  }

  previousPage() {
    this.goToPage(this.currentPage - 1);
  }

  nextPage() {
    this.goToPage(this.currentPage + 1);
  }

  viewUser(user: User) {
    // Navigate to user-list page with userId as route parameter
    this.router.navigate(['/user-list', user.id]);
  }

  get pageNumbers(): number[] {
    return Array.from({ length: this.totalPages }, (_, i) => i + 1);
  }
}
