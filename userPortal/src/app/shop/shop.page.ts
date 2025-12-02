import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import {
  IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardHeader,
  IonCardTitle, IonCardContent, IonButton, IonIcon, IonBadge, IonGrid,
  IonRow, IonCol, IonSpinner, IonText, AlertController, IonRefresher,
  IonRefresherContent
} from '@ionic/angular/standalone';
import { addIcons } from 'ionicons';
import { cartOutline, addCircle } from 'ionicons/icons';
import { ShopService, ShopItem } from '../services/shop.service';

@Component({
  selector: 'app-shop',
  templateUrl: './shop.page.html',
  styleUrls: ['./shop.page.scss'],
  standalone: true,
  imports: [
    CommonModule,
    IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardHeader,
    IonCardTitle, IonCardContent, IonButton, IonIcon, IonBadge, IonGrid,
    IonRow, IonCol, IonSpinner, IonText, IonRefresher, IonRefresherContent
  ]
})
export class ShopPage implements OnInit {
  shopItems: ShopItem[] = [];
  userPoints: number = 0;
  userId: number = 1;
  loading: boolean = true;

  constructor(
    private shopService: ShopService,
    private alertController: AlertController,
    private router: Router
  ) {
    addIcons({ 'cart-outline': cartOutline, 'add-circle': addCircle });
  }

  ngOnInit() {
    this.userId = parseInt(localStorage.getItem('currentUserId') || '1');
  }

  ionViewWillEnter() {
    // Reload data every time the page is entered
    this.loadShopItems();
    this.loadUserProfile();
  }

  loadShopItems() {
    this.loading = true;
    this.shopService.getAvailableItems().subscribe({
      next: (items) => {
        this.shopItems = items;
        this.loading = false;
      },
      error: (error) => {
        console.error('Failed to load shop items:', error);
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

  async addToCart(item: ShopItem) {
    if (item.stock <= 0) {
      const alert = await this.alertController.create({
        header: 'Out of Stock',
        message: 'This item is currently out of stock.',
        buttons: ['OK']
      });
      await alert.present();
      return;
    }

    this.shopService.addToCart(this.userId, item.id).subscribe({
      next: async () => {
        const alert = await this.alertController.create({
          header: 'Added to Cart',
          message: `${item.name} has been added to your cart!`,
          buttons: ['OK']
        });
        await alert.present();
      },
      error: async (error) => {
        const alert = await this.alertController.create({
          header: 'Error',
          message: error.error || 'Failed to add item to cart.',
          buttons: ['OK']
        });
        await alert.present();
      }
    });
  }

  canAfford(item: ShopItem): boolean {
    return this.userPoints >= item.pointsRequired;
  }

  viewItemDetail(item: ShopItem) {
    this.router.navigate(['/item-detail', item.id]);
  }

  handleRefresh(event: any) {
    this.loadShopItems();
    this.loadUserProfile();
    setTimeout(() => {
      event.target.complete();
    }, 1000);
  }
}
