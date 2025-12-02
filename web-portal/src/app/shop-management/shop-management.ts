import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ShopService, ShopItem, ShopItemRequest } from '../services/shop';
import { Router, NavigationEnd } from '@angular/router';
import { filter } from 'rxjs/operators';

@Component({
  selector: 'app-shop-management',
  imports: [CommonModule, FormsModule],
  templateUrl: './shop-management.html',
  styleUrl: './shop-management.scss',
})
export class ShopManagement implements OnInit {
  shopItems: ShopItem[] = [];
  loading: boolean = true;

  // Form state
  showForm: boolean = false;
  isEditMode: boolean = false;
  editingItemId: number | null = null;

  // Form data
  formData: ShopItemRequest = {
    name: '',
    description: '',
    pointsRequired: 0,
    imageUrl: '',
    stock: 0,
    isActive: true
  };

  constructor(
    private shopService: ShopService,
    private router: Router
  ) {}

  ngOnInit() {
    this.loadShopItems();

    // Reload data when navigating back to this route
    this.router.events.pipe(
      filter(event => event instanceof NavigationEnd)
    ).subscribe(() => {
      if (this.router.url.includes('/shop-management')) {
        this.loadShopItems();
      }
    });
  }

  loadShopItems() {
    this.loading = true;
    this.shopService.getAllItems().subscribe({
      next: (items) => {
        this.shopItems = items;
        this.loading = false;
      },
      error: (error) => {
        console.error('Failed to load shop items:', error);
        alert('Failed to load shop items');
        this.loading = false;
      }
    });
  }

  openAddForm() {
    this.showForm = true;
    this.isEditMode = false;
    this.editingItemId = null;
    this.resetForm();
  }

  openEditForm(item: ShopItem) {
    this.showForm = true;
    this.isEditMode = true;
    this.editingItemId = item.id;
    this.formData = {
      name: item.name,
      description: item.description,
      pointsRequired: item.pointsRequired,
      imageUrl: item.imageUrl,
      stock: item.stock,
      isActive: item.isActive
    };
  }

  cancelForm() {
    this.showForm = false;
    this.resetForm();
  }

  resetForm() {
    this.formData = {
      name: '',
      description: '',
      pointsRequired: 0,
      imageUrl: '',
      stock: 0,
      isActive: true
    };
    this.editingItemId = null;
    this.isEditMode = false;
  }

  submitForm() {
    if (this.isEditMode && this.editingItemId !== null) {
      this.updateItem();
    } else {
      this.createItem();
    }
  }

  createItem() {
    this.shopService.createItem(this.formData).subscribe({
      next: (created) => {
        alert('Item created successfully!');
        this.loadShopItems();
        this.cancelForm();
      },
      error: (error) => {
        console.error('Failed to create item:', error);
        alert('Failed to create item: ' + (error.error || 'Unknown error'));
      }
    });
  }

  updateItem() {
    if (this.editingItemId === null) return;

    this.shopService.updateItem(this.editingItemId, this.formData).subscribe({
      next: (updated) => {
        alert('Item updated successfully!');
        this.loadShopItems();
        this.cancelForm();
      },
      error: (error) => {
        console.error('Failed to update item:', error);
        alert('Failed to update item: ' + (error.error || 'Unknown error'));
      }
    });
  }

  deleteItem(item: ShopItem) {
    if (!confirm(`Are you sure you want to delete "${item.name}"?`)) {
      return;
    }

    this.shopService.deleteItem(item.id).subscribe({
      next: () => {
        alert('Item deleted successfully!');
        this.loadShopItems();
      },
      error: (error) => {
        console.error('Failed to delete item:', error);
        alert('Failed to delete item: ' + (error.error || 'Unknown error'));
      }
    });
  }

  isFormValid(): boolean {
    return (
      this.formData.name.trim() !== '' &&
      this.formData.description.trim() !== '' &&
      this.formData.pointsRequired > 0 &&
      this.formData.stock >= 0
    );
  }
}
