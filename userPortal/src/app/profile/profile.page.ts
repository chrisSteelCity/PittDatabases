import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import {
  IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardHeader,
  IonCardTitle, IonCardContent, IonButton, IonIcon, IonList,
  IonItem, IonLabel, IonText, IonInput, IonSpinner, AlertController,
  IonRefresher, IonRefresherContent
} from '@ionic/angular/standalone';
import { addIcons } from 'ionicons';
import { personOutline, locationOutline, trophyOutline, calendarOutline, checkmarkCircle, logOutOutline } from 'ionicons/icons';
import { ShopService, UserProfile } from '../services/shop.service';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.page.html',
  styleUrls: ['./profile.page.scss'],
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardHeader,
    IonCardTitle, IonCardContent, IonButton, IonIcon, IonList,
    IonItem, IonLabel, IonText, IonInput, IonSpinner, IonRefresher,
    IonRefresherContent
  ]
})
export class ProfilePage implements OnInit {
  profile: UserProfile | null = null;
  userId: number = 1;
  loading: boolean = true;
  editingAddress: boolean = false;
  newAddress: string = '';
  canCheckinToday: boolean = false;

  constructor(
    private shopService: ShopService,
    private alertController: AlertController,
    private router: Router
  ) {
    addIcons({
      'person-outline': personOutline,
      'location-outline': locationOutline,
      'trophy-outline': trophyOutline,
      'calendar-outline': calendarOutline,
      'checkmark-circle': checkmarkCircle,
      'log-out-outline': logOutOutline
    });
  }

  ngOnInit() {
    this.userId = parseInt(localStorage.getItem('currentUserId') || '1');
  }

  ionViewWillEnter() {
    // Reload profile every time the page is entered
    this.loadProfile();
  }

  loadProfile() {
    this.loading = true;
    this.shopService.getUserProfile(this.userId).subscribe({
      next: (profile) => {
        this.profile = profile;
        this.newAddress = profile.address || '';
        this.checkCanCheckin();
        this.loading = false;
      },
      error: (error) => {
        console.error('Failed to load profile:', error);
        this.loading = false;
      }
    });
  }

  checkCanCheckin() {
    if (!this.profile) return;

    const today = new Date().toISOString().split('T')[0];
    this.canCheckinToday = !this.profile.lastCheckinDate || this.profile.lastCheckinDate !== today;
  }

  async checkin() {
    this.shopService.checkin(this.userId).subscribe({
      next: async (updatedProfile) => {
        this.profile = updatedProfile;
        this.checkCanCheckin();

        const alert = await this.alertController.create({
          header: 'Check-in Successful!',
          message: 'You earned 20 points!',
          buttons: ['OK']
        });
        await alert.present();
      },
      error: async (error) => {
        const alert = await this.alertController.create({
          header: 'Check-in Failed',
          message: error.error || 'You have already checked in today.',
          buttons: ['OK']
        });
        await alert.present();
      }
    });
  }

  startEditAddress() {
    this.editingAddress = true;
  }

  cancelEditAddress() {
    this.editingAddress = false;
    this.newAddress = this.profile?.address || '';
  }

  async saveAddress() {
    if (!this.newAddress.trim()) {
      const alert = await this.alertController.create({
        header: 'Invalid Address',
        message: 'Please enter a valid address.',
        buttons: ['OK']
      });
      await alert.present();
      return;
    }

    this.shopService.updateAddress(this.userId, this.newAddress).subscribe({
      next: async (updatedProfile) => {
        this.profile = updatedProfile;
        this.editingAddress = false;

        const alert = await this.alertController.create({
          header: 'Success',
          message: 'Address updated successfully!',
          buttons: ['OK']
        });
        await alert.present();
      },
      error: async (error) => {
        const alert = await this.alertController.create({
          header: 'Error',
          message: 'Failed to update address.',
          buttons: ['OK']
        });
        await alert.present();
      }
    });
  }

  handleRefresh(event: any) {
    this.loadProfile();
    setTimeout(() => {
      event.target.complete();
    }, 1000);
  }

  async logout() {
    const alert = await this.alertController.create({
      header: 'Confirm Logout',
      message: 'Are you sure you want to logout?',
      buttons: [
        {
          text: 'Cancel',
          role: 'cancel'
        },
        {
          text: 'Logout',
          role: 'confirm',
          handler: () => {
            // Clear localStorage
            localStorage.removeItem('currentUsername');
            localStorage.removeItem('currentUserId');
            // Navigate to auth page
            this.router.navigateByUrl('/auth');
          }
        }
      ]
    });

    await alert.present();
  }
}
