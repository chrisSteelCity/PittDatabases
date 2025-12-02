import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface ShopItem {
  id: number;
  name: string;
  description: string;
  pointsRequired: number;
  imageUrl: string;
  stock: number;
  isActive: boolean;
}

export interface CartItem {
  id: number;
  shopItemId: number;
  shopItemName: string;
  pointsRequired: number;
  quantity: number;
  imageUrl: string;
}

export interface Order {
  id: number;
  userId: number;
  totalPoints: number;
  shippingAddress: string;
  status: string;
  createdAt: string;
  items: OrderItem[];
}

export interface OrderItem {
  id: number;
  shopItemId: number;
  shopItemName: string;
  quantity: number;
  pointsPerItem: number;
}

export interface UserProfile {
  id: number;
  username: string;
  points: number;
  address: string;
  lastCheckinDate: string;
}

export interface Review {
  id: number;
  shopItemId: number;
  userId: number;
  userName: string;
  reviewText: string;
  createdAt: string;
}

@Injectable({
  providedIn: 'root'
})
export class ShopService {
  private baseUrl = 'http://localhost:8080/api';

  constructor(private http: HttpClient) { }

  // Shop APIs
  getShopItems(): Observable<ShopItem[]> {
    return this.http.get<ShopItem[]>(`${this.baseUrl}/shop`);
  }

  getAvailableItems(): Observable<ShopItem[]> {
    return this.http.get<ShopItem[]>(`${this.baseUrl}/shop/available`);
  }

  // Cart APIs
  getCartItems(userId: number): Observable<CartItem[]> {
    return this.http.get<CartItem[]>(`${this.baseUrl}/cart/${userId}`);
  }

  addToCart(userId: number, shopItemId: number, quantity: number = 1): Observable<CartItem> {
    return this.http.post<CartItem>(`${this.baseUrl}/cart/${userId}`, {
      shopItemId,
      quantity
    });
  }

  updateCartQuantity(userId: number, cartItemId: number, quantity: number): Observable<CartItem> {
    return this.http.put<CartItem>(`${this.baseUrl}/cart/${userId}/${cartItemId}`, {
      quantity
    });
  }

  removeFromCart(userId: number, cartItemId: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/cart/${userId}/${cartItemId}`);
  }

  clearCart(userId: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/cart/${userId}`);
  }

  // Order APIs
  createOrder(userId: number, shippingAddress?: string): Observable<Order> {
    return this.http.post<Order>(`${this.baseUrl}/orders/${userId}`, {
      shippingAddress
    });
  }

  getUserOrders(userId: number): Observable<Order[]> {
    return this.http.get<Order[]>(`${this.baseUrl}/orders/user/${userId}`);
  }

  cancelOrder(orderId: number, userId: number): Observable<Order> {
    return this.http.post<Order>(`${this.baseUrl}/orders/${orderId}/cancel?userId=${userId}`, {});
  }

  // User Profile APIs
  getUserProfile(userId: number): Observable<UserProfile> {
    return this.http.get<UserProfile>(`${this.baseUrl}/user/profile/${userId}`);
  }

  updateAddress(userId: number, address: string): Observable<UserProfile> {
    return this.http.put<UserProfile>(`${this.baseUrl}/user/profile/${userId}/address`, {
      address
    });
  }

  checkin(userId: number): Observable<UserProfile> {
    return this.http.post<UserProfile>(`${this.baseUrl}/user/profile/${userId}/checkin`, {});
  }

  // Like APIs
  toggleLike(itemId: number, userId: number): Observable<boolean> {
    return this.http.post<boolean>(`${this.baseUrl}/items/${itemId}/like`, { userId });
  }

  getLikeStatus(itemId: number, userId: number): Observable<boolean> {
    return this.http.get<boolean>(`${this.baseUrl}/items/${itemId}/like/status?userId=${userId}`);
  }

  getLikeCount(itemId: number): Observable<number> {
    return this.http.get<number>(`${this.baseUrl}/items/${itemId}/like/count`);
  }

  // Review APIs
  addReview(itemId: number, userId: number, reviewText: string): Observable<Review> {
    return this.http.post<Review>(`${this.baseUrl}/items/${itemId}/reviews`, { userId, reviewText });
  }

  getReviews(itemId: number): Observable<Review[]> {
    return this.http.get<Review[]>(`${this.baseUrl}/items/${itemId}/reviews`);
  }
}
