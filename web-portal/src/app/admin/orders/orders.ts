import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { OrderService, Order, OrderUpdateRequest } from '../../services/order';

@Component({
  selector: 'app-orders',
  imports: [CommonModule, FormsModule],
  templateUrl: './orders.html',
  styleUrl: './orders.scss',
})
export class Orders {
  // Expose Math for template
  Math = Math;

  // Pagination settings
  currentPage = 1;
  itemsPerPage = 10;
  totalItems = 0;
  totalPages = 0;

  // Orders data
  orders: Order[] = [];
  displayedOrders: Order[] = [];
  expandedOrderId: number | null = null;

  // Modal state
  showModal = false;
  currentOrder: OrderUpdateRequest = this.getEmptyOrder();
  currentOrderId: number | null = null;

  // Message state
  message = '';
  messageType: 'success' | 'error' | '' = '';

  constructor(private orderService: OrderService) {}

  ngOnInit() {
    this.loadOrders();
  }

  loadOrders() {
    this.orderService.getAllOrders().subscribe({
      next: (data: Order[]) => {
        this.orders = data;
        this.updatePagination();
      },
      error: (error) => {
        console.error('Failed to load orders:', error);
        this.showMessage('Failed to load orders', 'error');
      }
    });
  }

  updatePagination() {
    this.totalItems = this.orders.length;
    this.totalPages = Math.ceil(this.totalItems / this.itemsPerPage);
    this.updateDisplayedOrders();
  }

  updateDisplayedOrders() {
    const startIndex = (this.currentPage - 1) * this.itemsPerPage;
    const endIndex = startIndex + this.itemsPerPage;
    this.displayedOrders = this.orders.slice(startIndex, endIndex);
  }

  goToPage(page: number) {
    if (page >= 1 && page <= this.totalPages) {
      this.currentPage = page;
      this.updateDisplayedOrders();
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

  toggleOrderItems(orderId: number) {
    this.expandedOrderId = this.expandedOrderId === orderId ? null : orderId;
  }

  isExpanded(orderId: number): boolean {
    return this.expandedOrderId === orderId;
  }

  openEditModal(order: Order) {
    this.currentOrder = {
      status: order.status,
      shippingAddress: order.shippingAddress
    };
    this.currentOrderId = order.id;
    this.showModal = true;
  }

  closeModal() {
    this.showModal = false;
    this.currentOrder = this.getEmptyOrder();
    this.currentOrderId = null;
  }

  saveOrder() {
    if (this.currentOrderId !== null) {
      this.orderService.updateOrder(this.currentOrderId, this.currentOrder).subscribe({
        next: () => {
          this.showMessage('Order updated successfully', 'success');
          this.closeModal();
          this.loadOrders();
        },
        error: (error) => {
          console.error('Failed to update order:', error);
          this.showMessage('Failed to update order', 'error');
        }
      });
    }
  }

  deleteOrder(order: Order) {
    if (confirm(`Are you sure you want to delete order #${order.id}?`)) {
      this.orderService.deleteOrder(order.id).subscribe({
        next: () => {
          this.showMessage('Order deleted successfully', 'success');
          this.loadOrders();
        },
        error: (error) => {
          console.error('Failed to delete order:', error);
          this.showMessage('Failed to delete order', 'error');
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

  getEmptyOrder(): OrderUpdateRequest {
    return {
      status: '',
      shippingAddress: ''
    };
  }
}
