import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface OrderItem {
  shopItemId: number;
  shopItemName: string;
  quantity: number;
  pointsPerItem: number;
}

export interface Order {
  id: number;
  userId: number;
  totalPoints: number;
  status: string;
  shippingAddress: string;
  createdAt: string;
  orderItems: OrderItem[];
}

export interface OrderUpdateRequest {
  status: string;
  shippingAddress: string;
}

@Injectable({
  providedIn: 'root',
})
export class OrderService {
  private apiUrl = 'http://localhost:8080/api/orders';

  constructor(private http: HttpClient) {}

  getAllOrders(): Observable<Order[]> {
    return this.http.get<Order[]>(`${this.apiUrl}`);
  }

  getOrderById(id: number): Observable<Order> {
    return this.http.get<Order>(`${this.apiUrl}/${id}`);
  }

  updateOrder(id: number, request: OrderUpdateRequest): Observable<Order> {
    return this.http.put<Order>(`${this.apiUrl}/${id}`, request);
  }

  deleteOrder(id: number): Observable<string> {
    return this.http.delete<string>(`${this.apiUrl}/${id}`);
  }
}
