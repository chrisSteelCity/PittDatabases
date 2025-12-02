import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ShopService, ShopItem, ShopItemRequest } from '../../services/shop';
import { ActivatedRoute, NavigationEnd, Router } from '@angular/router';
import { filter } from 'rxjs/operators';

@Component({
  selector: 'app-shop-items',
  imports: [CommonModule, FormsModule],
  templateUrl: './shop-items.html',
  styleUrl: './shop-items.scss',
})
export class ShopItems implements OnInit {
  // Expose Math for template
  Math = Math;

  // Pagination settings
  currentPage = 1;
  itemsPerPage = 10;
  totalItems = 0;
  totalPages = 0;

  // Shop items data
  items: ShopItem[] = [];
  displayedItems: ShopItem[] = [];

  // Modal state
  showModal = false;
  isEditMode = false;
  currentItem: ShopItemRequest = this.getEmptyItem();
  currentItemId: number | null = null;

  // Message state
  message = '';
  messageType: 'success' | 'error' | '' = '';

  constructor(
    private shopService: ShopService,
    private router: Router,
    private route: ActivatedRoute
  ) {}

  ngOnInit() {
    this.loadItems();

    // Reload data when navigating back to this route
    this.router.events.pipe(
      filter(event => event instanceof NavigationEnd)
    ).subscribe(() => {
      if (this.router.url.includes('/admin/shop-items')) {
        this.loadItems();
      }
    });
  }

  loadItems() {
    this.shopService.getAllItems().subscribe({
      next: (data: ShopItem[]) => {
        this.items = data;
        this.updatePagination();
      },
      error: (error) => {
        console.error('Failed to load shop items:', error);
        this.showMessage('Failed to load shop items', 'error');
      }
    });
  }

  updatePagination() {
    this.totalItems = this.items.length;
    this.totalPages = Math.ceil(this.totalItems / this.itemsPerPage);
    this.updateDisplayedItems();
  }

  updateDisplayedItems() {
    const startIndex = (this.currentPage - 1) * this.itemsPerPage;
    const endIndex = startIndex + this.itemsPerPage;
    this.displayedItems = this.items.slice(startIndex, endIndex);
  }

  goToPage(page: number) {
    if (page >= 1 && page <= this.totalPages) {
      this.currentPage = page;
      this.updateDisplayedItems();
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

  openCreateModal() {
    this.isEditMode = false;
    this.currentItem = this.getEmptyItem();
    this.currentItemId = null;
    this.showModal = true;
  }

  openEditModal(item: ShopItem) {
    this.isEditMode = true;
    this.currentItem = {
      name: item.name,
      description: item.description,
      pointsRequired: item.pointsRequired,
      imageUrl: item.imageUrl,
      stock: item.stock,
      isActive: item.isActive
    };
    this.currentItemId = item.id;
    this.showModal = true;
  }

  closeModal() {
    this.showModal = false;
    this.currentItem = this.getEmptyItem();
    this.currentItemId = null;
  }

  saveItem() {
    if (this.isEditMode && this.currentItemId !== null) {
      this.shopService.updateItem(this.currentItemId, this.currentItem).subscribe({
        next: () => {
          this.showMessage('Item updated successfully', 'success');
          this.closeModal();
          this.loadItems();
        },
        error: (error) => {
          console.error('Failed to update item:', error);
          this.showMessage('Failed to update item', 'error');
        }
      });
    } else {
      this.shopService.createItem(this.currentItem).subscribe({
        next: () => {
          this.showMessage('Item created successfully', 'success');
          this.closeModal();
          this.loadItems();
        },
        error: (error) => {
          console.error('Failed to create item:', error);
          this.showMessage('Failed to create item', 'error');
        }
      });
    }
  }

  hideItem(item: ShopItem) {
    if (confirm(`Are you sure you want to hide "${item.name}" from the shop?`)) {
      const updatedItem: ShopItemRequest = {
        name: item.name,
        description: item.description,
        pointsRequired: item.pointsRequired,
        imageUrl: item.imageUrl,
        stock: item.stock,
        isActive: false
      };

      this.shopService.updateItem(item.id, updatedItem).subscribe({
        next: () => {
          this.showMessage('Item hidden successfully', 'success');
          this.loadItems();
        },
        error: (error) => {
          console.error('Failed to hide item:', error);
          this.showMessage('Failed to hide item', 'error');
        }
      });
    }
  }

  showItem(item: ShopItem) {
    if (confirm(`Are you sure you want to show "${item.name}" in the shop?`)) {
      const updatedItem: ShopItemRequest = {
        name: item.name,
        description: item.description,
        pointsRequired: item.pointsRequired,
        imageUrl: item.imageUrl,
        stock: item.stock,
        isActive: true
      };

      this.shopService.updateItem(item.id, updatedItem).subscribe({
        next: () => {
          this.showMessage('Item is now visible in shop', 'success');
          this.loadItems();
        },
        error: (error) => {
          console.error('Failed to show item:', error);
          this.showMessage('Failed to show item', 'error');
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

  getEmptyItem(): ShopItemRequest {
    return {
      name: '',
      description: '',
      pointsRequired: 0,
      imageUrl: '',
      stock: 0,
      isActive: true
    };
  }
}
