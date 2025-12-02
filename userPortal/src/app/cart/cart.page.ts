import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import {
  IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardHeader,
  IonCardTitle, IonCardContent, IonButton, IonIcon, IonBadge, IonList,
  IonItem, IonLabel, IonText, IonSpinner, AlertController, IonButtons,
  IonRefresher, IonRefresherContent
} from '@ionic/angular/standalone';
import { addIcons } from 'ionicons';
import { trashOutline, addCircle, removeCircle, cartOutline } from 'ionicons/icons';
import { ShopService, CartItem } from '../services/shop.service';

@Component({
  selector: 'app-cart',
  templateUrl: './cart.page.html',
  styleUrls: ['./cart.page.scss'],
  standalone: true,
  imports: [
    CommonModule,
    IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardHeader,
    IonCardTitle, IonCardContent, IonButton, IonIcon, IonBadge, IonList,
    IonItem, IonLabel, IonText, IonSpinner, IonButtons, IonRefresher,
    IonRefresherContent
  ]
})
export class CartPage implements OnInit {
  cartItems: CartItem[] = [];
  userPoints: number = 0;
  userId: number = 1;
  loading: boolean = true;

  constructor(
    private shopService: ShopService,
    private alertController: AlertController,
    private router: Router
  ) {
    addIcons({
      'trash-outline': trashOutline,
      'add-circle': addCircle,
      'remove-circle': removeCircle,
      'cart-outline': cartOutline
    });
  }

  ngOnInit() {
    this.userId = parseInt(localStorage.getItem('currentUserId') || '1');
    this.loadCart();
    this.loadUserProfile();
  }

  ionViewWillEnter() {
    // Reload cart and user profile when entering the view
    this.loadCart();
    this.loadUserProfile();
  }

  loadCart() {
    this.loading = true;
    this.shopService.getCartItems(this.userId).subscribe({
      next: (items) => {
        this.cartItems = items;
        this.loading = false;
      },
      error: (error) => {
        console.error('Failed to load cart:', error);
        this.loading = false;
      }
    });
  }

  loadUserProfile() {
    this.shopService.getUserProfile(this.userId).subscribe({
      next: (profile) => {
        this.userPoints = profile.points;
      },
      error: (error) => {
        console.error('Failed to load user profile:', error);
      }
    });
  }

  getTotalPoints(): number {
    return this.cartItems.reduce((sum, item) => sum + (item.pointsRequired * item.quantity), 0);
  }

  increaseQuantity(item: CartItem) {
    this.shopService.updateCartQuantity(this.userId, item.id, item.quantity + 1).subscribe({
      next: () => {
        item.quantity++;
      },
      error: async (error) => {
        const alert = await this.alertController.create({
          header: 'Error',
          message: error.error || 'Failed to update quantity.',
          buttons: ['OK']
        });
        await alert.present();
      }
    });
  }

  decreaseQuantity(item: CartItem) {
    if (item.quantity > 1) {
      this.shopService.updateCartQuantity(this.userId, item.id, item.quantity - 1).subscribe({
        next: () => {
          item.quantity--;
        },
        error: async (error) => {
          const alert = await this.alertController.create({
            header: 'Error',
            message: error.error || 'Failed to update quantity.',
            buttons: ['OK']
          });
          await alert.present();
        }
      });
    }
  }

  async removeItem(item: CartItem) {
    const alert = await this.alertController.create({
      header: 'Confirm Remove',
      message: `Remove ${item.shopItemName} from cart?`,
      buttons: [
        {
          text: 'Cancel',
          role: 'cancel'
        },
        {
          text: 'Remove',
          role: 'destructive',
          handler: () => {
            this.shopService.removeFromCart(this.userId, item.id).subscribe({
              next: () => {
                this.loadCart();
              },
              error: async (error) => {
                const errorAlert = await this.alertController.create({
                  header: 'Error',
                  message: 'Failed to remove item from cart.',
                  buttons: ['OK']
                });
                await errorAlert.present();
              }
            });
          }
        }
      ]
    });
    await alert.present();
  }

  async checkout() {
    const totalPoints = this.getTotalPoints();

    if (totalPoints > this.userPoints) {
      const alert = await this.alertController.create({
        header: 'Insufficient Points',
        message: `You need ${totalPoints} points but only have ${this.userPoints} points.`,
        buttons: ['OK']
      });
      await alert.present();
      return;
    }

    const alert = await this.alertController.create({
      header: 'Confirm Order',
      message: `Total: ${totalPoints} points\n\nThis will be deducted from your account.`,
      buttons: [
        {
          text: 'Cancel',
          role: 'cancel'
        },
        {
          text: 'Confirm',
          handler: () => {
            this.shopService.createOrder(this.userId).subscribe({
              next: async (order) => {
                const successAlert = await this.alertController.create({
                  header: 'Order Placed!',
                  message: `Your order has been placed successfully!\n\nOrder ID: ${order.id}`,
                  buttons: ['OK']
                });
                await successAlert.present();
                this.loadCart();
                this.loadUserProfile();
              },
              error: async (error) => {
                const errorAlert = await this.alertController.create({
                  header: 'Order Failed',
                  message: error.error || 'Failed to place order.',
                  buttons: ['OK']
                });
                await errorAlert.present();
              }
            });
          }
        }
      ]
    });
    await alert.present();
  }

  handleRefresh(event: any) {
    this.loadCart();
    this.loadUserProfile();
    setTimeout(() => {
      event.target.complete();
    }, 1000);
  }
}
