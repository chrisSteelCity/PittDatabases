import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface UserSummary {
  id: number;
  username: string;
  lastReportTime: string | null;
  daysSinceReport: number; // Number of days since last report, -1 if no reports
}

@Injectable({
  providedIn: 'root',
})
export class DashboardService {
  private apiUrl = 'http://localhost:8080/api';

  constructor(private http: HttpClient) {}

  getAllUsersWithLastReport(): Observable<UserSummary[]> {
    return this.http.get<UserSummary[]>(`${this.apiUrl}/coaches/users`);
  }
}
