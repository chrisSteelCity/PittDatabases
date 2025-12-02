import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { UserService, User, UserRequest } from '../../services/user';

@Component({
  selector: 'app-users',
  imports: [CommonModule, FormsModule],
  templateUrl: './users.html',
  styleUrl: './users.scss',
})
export class Users {
  // Expose Math for template
  Math = Math;

  // Pagination settings
  currentPage = 1;
  itemsPerPage = 10;
  totalItems = 0;
  totalPages = 0;

  // Users data
  users: User[] = [];
  displayedUsers: User[] = [];

  // Modal state
  showModal = false;
  currentUser: UserRequest = this.getEmptyUser();
  currentUserId: number | null = null;

  // Message state
  message = '';
  messageType: 'success' | 'error' | '' = '';

  constructor(private userService: UserService) {}

  ngOnInit() {
    this.loadUsers();
  }

  loadUsers() {
    this.userService.getAllUsers().subscribe({
      next: (data: User[]) => {
        this.users = data;
        this.updatePagination();
      },
      error: (error) => {
        console.error('Failed to load users:', error);
        this.showMessage('Failed to load users', 'error');
      }
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

  get pageNumbers(): number[] {
    return Array.from({ length: this.totalPages }, (_, i) => i + 1);
  }

  openEditModal(user: User) {
    this.currentUser = {
      username: user.username,
      points: user.points,
      address: user.address
    };
    this.currentUserId = user.id;
    this.showModal = true;
  }

  closeModal() {
    this.showModal = false;
    this.currentUser = this.getEmptyUser();
    this.currentUserId = null;
  }

  saveUser() {
    if (this.currentUserId !== null) {
      this.userService.updateUser(this.currentUserId, this.currentUser).subscribe({
        next: () => {
          this.showMessage('User updated successfully', 'success');
          this.closeModal();
          this.loadUsers();
        },
        error: (error) => {
          console.error('Failed to update user:', error);
          this.showMessage('Failed to update user', 'error');
        }
      });
    }
  }

  deleteUser(user: User) {
    if (confirm(`Are you sure you want to delete user "${user.username}"?`)) {
      this.userService.deleteUser(user.id).subscribe({
        next: () => {
          this.showMessage('User deleted successfully', 'success');
          this.loadUsers();
        },
        error: (error) => {
          console.error('Failed to delete user:', error);
          this.showMessage('Failed to delete user', 'error');
        }
      });
    }
  }

  showMessage(message: string, type: 'success' | 'error') {
    this.message = message;
    this.messageType = type;
    setTimeout(() => {
      this.message = '';
      this.messageType = '';
    }, 3000);
  }

  formatDateTime(dateString: string | null): string {
    if (!dateString) return 'Never';
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

  getEmptyUser(): UserRequest {
    return {
      username: '',
      points: 0,
      address: ''
    };
  }
}
