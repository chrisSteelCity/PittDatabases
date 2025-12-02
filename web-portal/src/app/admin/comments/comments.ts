import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

interface Comment {
  id: number;
  shopItemId: number;
  shopItemName?: string;
  userId: number;
  userName: string;
  commentText: string;
  createdAt: string;
}

interface ShopItem {
  id: number;
  name: string;
}

@Component({
  selector: 'app-comments',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './comments.html',
  styleUrls: ['./comments.scss']
})
export class Comments implements OnInit {
  allComments: Comment[] = [];
  filteredComments: Comment[] = [];
  shopItems: ShopItem[] = [];

  // Filters
  selectedItemId: number | null = null;
  searchText: string = '';

  // Delete confirmation
  commentToDelete: Comment | null = null;

  constructor() {}

  ngOnInit() {
    this.loadShopItems();
    this.loadAllComments();
  }

  loadShopItems() {
    fetch('http://localhost:8080/api/shop')
      .then(res => res.json())
      .then((items: ShopItem[]) => {
        this.shopItems = items;
      })
      .catch(err => {
        console.error('Failed to load shop items:', err);
      });
  }

  loadAllComments() {
    // Get all shop items and their comments
    fetch('http://localhost:8080/api/shop')
      .then(res => res.json())
      .then((items: ShopItem[]) => {
        const commentPromises = items.map(item =>
          fetch(`http://localhost:8080/api/items/${item.id}/comments`)
            .then(res => res.json())
            .then((comments: any[]) =>
              comments.map(comment => ({
                ...comment,
                shopItemId: item.id,
                shopItemName: item.name
              }))
            )
            .catch(() => [])
        );

        return Promise.all(commentPromises);
      })
      .then(commentsArrays => {
        this.allComments = commentsArrays.flat().sort((a, b) =>
          new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()
        );
        this.applyFilters();
      })
      .catch(err => {
        console.error('Failed to load comments:', err);
        alert('Failed to load comments');
      });
  }

  applyFilters() {
    this.filteredComments = this.allComments.filter(comment => {
      // Filter by shop item
      if (this.selectedItemId && comment.shopItemId !== this.selectedItemId) {
        return false;
      }

      // Filter by search text
      if (this.searchText) {
        const search = this.searchText.toLowerCase();
        return (
          comment.userName.toLowerCase().includes(search) ||
          comment.commentText.toLowerCase().includes(search) ||
          (comment.shopItemName && comment.shopItemName.toLowerCase().includes(search))
        );
      }

      return true;
    });
  }

  onFilterChange() {
    this.applyFilters();
  }

  clearFilters() {
    this.selectedItemId = null;
    this.searchText = '';
    this.applyFilters();
  }

  confirmDelete(comment: Comment) {
    this.commentToDelete = comment;
  }

  cancelDelete() {
    this.commentToDelete = null;
  }

  deleteComment() {
    if (!this.commentToDelete) return;

    const commentId = this.commentToDelete.id;

    fetch(`http://localhost:8080/api/comments/${commentId}`, {
      method: 'DELETE'
    })
      .then(res => {
        if (!res.ok) {
          throw new Error('Failed to delete comment');
        }
        // Remove from local array
        this.allComments = this.allComments.filter(c => c.id !== commentId);
        this.applyFilters();
        this.commentToDelete = null;
        alert('Comment deleted successfully');
      })
      .catch(err => {
        console.error('Error deleting comment:', err);
        alert('Failed to delete comment');
      });
  }

  formatDate(dateString: string): string {
    const date = new Date(dateString);
    return date.toLocaleString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  }
}
