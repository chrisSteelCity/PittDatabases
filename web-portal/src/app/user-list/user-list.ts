import { Component, OnInit, ViewChild, ElementRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { Chart, registerables } from 'chart.js';

Chart.register(...registerables);

interface Exercise {
  id: number;
  type: string;
  occurredAt: string;
  durationMinutes: number;
  location: string;
  timezone: string | null;
}

interface Last7DaysReport {
  dates: string[];
  durations: number[];
}

interface Order {
  id: number;
  userId: number;
  totalPoints: number;
  shippingAddress: string;
  status: string;
  createdAt: string;
  items: OrderItem[];
}

interface OrderItem {
  id: number;
  shopItemId: number;
  shopItemName: string;
  quantity: number;
  pointsPerItem: number;
}

@Component({
  selector: 'app-user-list',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './user-list.html',
  styleUrl: './user-list.scss',
})
export class UserList implements OnInit {
  @ViewChild('exerciseChart', { static: false }) exerciseChartRef!: ElementRef;

  userId!: number;
  username: string = '';

  // Exercise records table
  exercises: Exercise[] = [];
  displayedExercises: Exercise[] = [];
  currentPage = 1;
  itemsPerPage = 10;
  totalItems = 0;
  totalPages = 0;
  Math = Math;

  // Chart data
  chartLabels: string[] = [];
  chartData: number[] = [];
  chart: Chart | null = null;

  // Order records
  orders: Order[] = [];
  displayedOrders: Order[] = [];
  ordersPage = 1;
  ordersPerPage = 5;
  totalOrders = 0;
  totalOrdersPages = 0;

  private apiUrl = 'http://localhost:8080/api';

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private http: HttpClient
  ) {}

  ngOnInit() {
    // Get userId from route params
    this.route.params.subscribe(params => {
      this.userId = +params['userId'];
      this.loadData();
    });
  }

  ngAfterViewInit() {
    // Chart will be rendered after data is loaded
  }

  loadData() {
    // Load all exercise records
    this.loadExercises();
    // Load last 7 days report
    this.loadLast7DaysReport();
    // Load order records
    this.loadOrders();
  }

  loadExercises() {
    // Get all exercises for this user (no date filter, sorted by time desc)
    this.http.get<any>(`${this.apiUrl}/exercises`, {
      params: {
        userId: this.userId.toString(),
        page: '0',
        size: '1000' // Get all records
      }
    }).subscribe({
      next: (response) => {
        this.exercises = response.content || [];
        // Sort by occurredAt descending (latest first)
        this.exercises.sort((a, b) =>
          new Date(b.occurredAt).getTime() - new Date(a.occurredAt).getTime()
        );
        this.updatePagination();
      },
      error: (error) => {
        console.error('Failed to load exercises:', error);
      }
    });
  }

  loadLast7DaysReport() {
    this.http.get<Last7DaysReport>(`${this.apiUrl}/coaches/user/${this.userId}/reports/last7days`)
      .subscribe({
        next: (report) => {
          this.chartLabels = report.dates.map(date => {
            // Parse ISO date string directly to avoid timezone issues
            // Backend returns "2025-11-12" format
            const parts = date.split('-');
            const month = parseInt(parts[1], 10);
            const day = parseInt(parts[2], 10);
            return `${month}/${day}`;
          });
          this.chartData = report.durations;

          // Render chart after a short delay to ensure the view is ready
          setTimeout(() => this.renderChart(), 100);
        },
        error: (error) => {
          console.error('Failed to load last 7 days report:', error);
        }
      });
  }

  formatDateTime(dateString: string): string {
    const date = new Date(dateString);
    return date.toLocaleString('en-US', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      hour12: false
    });
  }

  formatDateTimeInTimezone(dateString: string, timezone: string | null): string {
    if (!dateString) return 'N/A';

    try {
      const date = new Date(dateString);

      // If timezone is provided, format in that timezone
      if (timezone) {
        return date.toLocaleString('en-US', {
          year: 'numeric',
          month: '2-digit',
          day: '2-digit',
          hour: '2-digit',
          minute: '2-digit',
          hour12: false,
          timeZone: timezone
        });
      } else {
        // If no timezone, format in UTC
        return date.toLocaleString('en-US', {
          year: 'numeric',
          month: '2-digit',
          day: '2-digit',
          hour: '2-digit',
          minute: '2-digit',
          hour12: false,
          timeZone: 'UTC'
        });
      }
    } catch (error) {
      console.error('Error formatting date:', error);
      return this.formatDateTime(dateString);
    }
  }

  getTimezoneLabel(timezone: string | null): string {
    if (!timezone) return 'UTC';

    // Map of common timezones to readable labels
    const timezoneLabels: { [key: string]: string } = {
      'America/New_York': 'EST/EDT',
      'America/Chicago': 'CST/CDT',
      'America/Denver': 'MST/MDT',
      'America/Los_Angeles': 'PST/PDT',
      'Europe/London': 'GMT/BST',
      'Europe/Paris': 'CET/CEST',
      'Asia/Shanghai': 'CST',
      'Asia/Tokyo': 'JST',
      'Australia/Sydney': 'AEDT/AEST'
    };

    return timezoneLabels[timezone] || timezone;
  }

  getExerciseIcon(type: string): string {
    const icons: { [key: string]: string } = {
      'RUN': '🏃',
      'WALK': '🚶',
      'CYCLE': '🚴',
      'SWIM': '🏊',
      'GYM': '🏋️',
      'OTHER': '💪'
    };
    return icons[type] || '❓';
  }

  updatePagination() {
    this.totalItems = this.exercises.length;
    this.totalPages = Math.ceil(this.totalItems / this.itemsPerPage);
    this.updateDisplayedExercises();
  }

  updateDisplayedExercises() {
    const startIndex = (this.currentPage - 1) * this.itemsPerPage;
    const endIndex = startIndex + this.itemsPerPage;
    this.displayedExercises = this.exercises.slice(startIndex, endIndex);
  }

  goToPage(page: number) {
    if (page >= 1 && page <= this.totalPages) {
      this.currentPage = page;
      this.updateDisplayedExercises();
    }
  }

  previousPage() {
    this.goToPage(this.currentPage - 1);
  }

  nextPage() {
    this.goToPage(this.currentPage + 1);
  }

  get pageNumbers(): number[] {
    return Array.from({ length: this.totalPages }, (_, i) => i + 1);
  }

  goBack() {
    this.router.navigate(['/dashboard']);
  }

  loadOrders() {
    this.http.get<Order[]>(`${this.apiUrl}/orders/user/${this.userId}`)
      .subscribe({
        next: (orders) => {
          this.orders = orders;
          this.updateOrdersPagination();
        },
        error: (error) => {
          console.error('Failed to load orders:', error);
        }
      });
  }

  updateOrdersPagination() {
    this.totalOrders = this.orders.length;
    this.totalOrdersPages = Math.ceil(this.totalOrders / this.ordersPerPage);
    this.updateDisplayedOrders();
  }

  updateDisplayedOrders() {
    const startIndex = (this.ordersPage - 1) * this.ordersPerPage;
    const endIndex = startIndex + this.ordersPerPage;
    this.displayedOrders = this.orders.slice(startIndex, endIndex);
  }

  goToOrdersPage(page: number) {
    if (page >= 1 && page <= this.totalOrdersPages) {
      this.ordersPage = page;
      this.updateDisplayedOrders();
    }
  }

  previousOrdersPage() {
    this.goToOrdersPage(this.ordersPage - 1);
  }

  nextOrdersPage() {
    this.goToOrdersPage(this.ordersPage + 1);
  }

  get ordersPageNumbers(): number[] {
    return Array.from({ length: this.totalOrdersPages }, (_, i) => i + 1);
  }

  formatOrderDate(dateString: string): string {
    const date = new Date(dateString);
    return date.toLocaleString('en-US', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      hour12: false
    });
  }

  getOrderStatusBadgeClass(status: string): string {
    const statusMap: { [key: string]: string } = {
      'PENDING': 'status-pending',
      'PROCESSING': 'status-processing',
      'SHIPPED': 'status-shipped',
      'DELIVERED': 'status-delivered',
      'CANCELLED': 'status-cancelled'
    };
    return statusMap[status] || 'status-pending';
  }

  renderChart() {
    if (!this.exerciseChartRef || this.chartData.length === 0) {
      return;
    }

    // Destroy existing chart if any
    if (this.chart) {
      this.chart.destroy();
    }

    const ctx = this.exerciseChartRef.nativeElement.getContext('2d');
    if (!ctx) return;

    // Calculate Y-axis max value
    const maxDuration = Math.max(...this.chartData, 0);
    const yAxisMax = Math.ceil(maxDuration / 30) * 30 + 30;

    this.chart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: this.chartLabels,
        datasets: [{
          label: 'Exercise Duration (minutes)',
          data: this.chartData,
          borderColor: '#667eea',
          backgroundColor: 'rgba(102, 126, 234, 0.1)',
          borderWidth: 2,
          fill: true,
          tension: 0.4
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          y: {
            beginAtZero: true,
            max: yAxisMax,
            ticks: {
              stepSize: 30
            }
          }
        },
        plugins: {
          legend: {
            display: true,
            position: 'top'
          }
        }
      }
    });
  }
}
