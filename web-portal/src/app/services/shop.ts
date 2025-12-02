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

export interface ShopItemRequest {
  name: string;
  description: string;
  pointsRequired: number;
  imageUrl: string;
  stock: number;
  isActive: boolean;
}

@Injectable({
  providedIn: 'root',
})
export class ShopService {
  private apiUrl = 'http://localhost:8080/api/shop';

  constructor(private http: HttpClient) {}

  getAllItems(): Observable<ShopItem[]> {
    return this.http.get<ShopItem[]>(`${this.apiUrl}`);
  }

  getItemById(id: number): Observable<ShopItem> {
    return this.http.get<ShopItem>(`${this.apiUrl}/${id}`);
  }

  createItem(request: ShopItemRequest): Observable<ShopItem> {
    return this.http.post<ShopItem>(`${this.apiUrl}`, request);
  }

  updateItem(id: number, request: ShopItemRequest): Observable<ShopItem> {
    return this.http.put<ShopItem>(`${this.apiUrl}/${id}`, request);
  }

  deleteItem(id: number): Observable<string> {
    return this.http.delete<string>(`${this.apiUrl}/${id}`);
  }
}
