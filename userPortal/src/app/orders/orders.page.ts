import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import {
  IonContent, IonHeader, IonTitle, IonToolbar, IonCard, IonCardHeader,
  IonCardTitle, IonCardContent, IonList, IonItem, IonLabel, IonBadge,
  IonSpinner, IonIcon, IonText, IonRefresher, IonRefresherContent,
  IonSelect, IonSelectOption, IonButton, AlertController
} from '@ionic/angular/standalone';
import { addIcons } from 'ionicons';
import { bagCheckOutline, timeOutline, locationOutline, checkmarkCircle, syncCircle, carOutline, airplaneOutline, closeCircle } from 'ionicons/icons';
import { ShopService, Order } from '../services/shop.service';

@Component({
  selector: 'app-orders',
  templateUrl: './orders.page.html',
  styleUrls: ['./orders.page.scss'],
  standalone: true,
  imports: [
    CommonModule, FormsModule,
    IonContent, IonHeader, IonTitle, IonToolbar, IonCard, IonCardHeader,
    IonCardTitle, IonCardContent, IonList, IonItem, IonLabel, IonBadge,
    IonSpinner, IonIcon, IonText, IonRefresher, IonRefresherContent,
    IonSelect, IonSelectOption, IonButton
  ]
})
export class OrdersPage implements OnInit {
  orders: Order[] = [];
  filteredOrders: Order[] = [];
  loading: boolean = true;
  userId: number = 1;
  selectedFilter: string = 'CURRENT';

  constructor(
    private shopService: ShopService,
    private alertController: AlertController
  ) {
    addIcons({
      'bag-check-outline': bagCheckOutline,
      'time-outline': timeOutline,
      'location-outline': locationOutline,
      'checkmark-circle': checkmarkCircle,
      'sync-circle': syncCircle,
      'car-outline': carOutline,
      'airplane-outline': airplaneOutline,
      'close-circle': closeCircle
    });
  }

  ngOnInit() {
    this.userId = parseInt(localStorage.getItem('currentUserId') || '1');
    this.loadOrders();
  }

  ionViewWillEnter() {
    // Reload orders when entering the view
    this.loadOrders();
  }

  loadOrders() {
    this.loading = true;
    this.shopService.getUserOrders(this.userId).subscribe({
      next: (orders) => {
        this.orders = orders;
        this.applyFilter();
        this.loading = false;
      },
      error: (error) => {
        console.error('Failed to load orders:', error);
        this.loading = false;
      }
    });
  }

  applyFilter() {
    if (this.selectedFilter === 'ALL') {
      this.filteredOrders = this.orders;
    } else if (this.selectedFilter === 'CURRENT') {
      // Current orders include PENDING, PROCESSING, and SHIPPED
      this.filteredOrders = this.orders.filter(order =>
        order.status === 'PENDING' ||
        order.status === 'PROCESSING' ||
        order.status === 'SHIPPED'
      );
    } else {
      this.filteredOrders = this.orders.filter(order => order.status === this.selectedFilter);
    }
  }

  onFilterChange() {
    this.applyFilter();
  }

  handleRefresh(event: any) {
    this.loadOrders();
    setTimeout(() => {
      event.target.complete();
    }, 1000);
  }

  getStatusColor(status: string): string {
    const statusColors: { [key: string]: string } = {
      'PENDING': 'warning',
      'PROCESSING': 'primary',
      'SHIPPED': 'secondary',
      'DELIVERED': 'success',
      'CANCELLED': 'danger'
    };
    return statusColors[status] || 'medium';
  }

  getStatusIcon(status: string): string {
    const statusIcons: { [key: string]: string } = {
      'PENDING': 'time-outline',
      'PROCESSING': 'sync-circle',
      'SHIPPED': 'car-outline',
      'DELIVERED': 'checkmark-circle',
      'CANCELLED': 'close-circle'
    };
    return statusIcons[status] || 'bag-check-outline';
  }

  formatDate(dateString: string): string {
    if (!dateString) return 'N/A';
    try {
      const date = new Date(dateString);
      return date.toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      });
    } catch (error) {
      return dateString;
    }
  }

  canCancelOrder(status: string): boolean {
    return status === 'PENDING' || status === 'PROCESSING';
  }

  async cancelOrder(order: Order) {
    const confirm = await this.alertController.create({
      header: 'Cancel Order',
      message: `Are you sure you want to cancel Order #${order.id}? You will be refunded ${order.totalPoints} points.`,
      buttons: [
        {
          text: 'No',
          role: 'cancel'
        },
        {
          text: 'Yes, Cancel',
          handler: () => {
            this.performCancelOrder(order.id);
          }
        }
      ]
    });

    await confirm.present();
  }

  performCancelOrder(orderId: number) {
    this.shopService.cancelOrder(orderId, this.userId).subscribe({
      next: async () => {
        const alert = await this.alertController.create({
          header: 'Order Cancelled',
          message: 'Your order has been cancelled and points have been refunded.',
          buttons: ['OK']
        });
        await alert.present();
        this.loadOrders();
      },
      error: async (error) => {
        const alert = await this.alertController.create({
          header: 'Error',
          message: error.error || 'Failed to cancel order.',
          buttons: ['OK']
        });
        await alert.present();
      }
    });
  }

  getEmptyStateMessage(): string {
    switch (this.selectedFilter) {
      case 'ALL':
        return "You haven't placed any orders yet";
      case 'CURRENT':
        return 'No current orders (pending, processing, or shipped)';
      case 'DELIVERED':
        return 'No delivered orders';
      case 'CANCELLED':
        return 'No cancelled orders';
      default:
        return 'No orders found';
    }
  }
}
