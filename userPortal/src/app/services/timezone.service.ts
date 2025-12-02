import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class TimezoneService {
  private readonly TIMEZONE_KEY = 'userTimezone';
  private readonly DEFAULT_TIMEZONE = 'America/New_York';

  constructor() {}

  /**
   * Get current selected timezone
   */
  getTimezone(): string {
    return localStorage.getItem(this.TIMEZONE_KEY) || this.DEFAULT_TIMEZONE;
  }

  /**
   * Set timezone
   */
  setTimezone(timezone: string): void {
    localStorage.setItem(this.TIMEZONE_KEY, timezone);
  }

  /**
   * Convert date to user's timezone and return formatted string
   */
  formatDateInTimezone(date: Date | string, timezone?: string): string {
    const tz = timezone || this.getTimezone();
    const dateObj = typeof date === 'string' ? new Date(date) : date;

    return dateObj.toLocaleString('en-US', {
      timeZone: tz,
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      hour12: false
    });
  }

  /**
   * Get current date/time in user's timezone
   */
  getNowInTimezone(timezone?: string): Date {
    const tz = timezone || this.getTimezone();
    const now = new Date();

    // Get the time in the user's timezone
    const timeString = now.toLocaleString('en-US', {
      timeZone: tz,
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
      hour12: false
    });

    return new Date(timeString);
  }

  /**
   * Get today's date string (YYYY-MM-DD) in user's timezone
   */
  getTodayInTimezone(timezone?: string): string {
    const tz = timezone || this.getTimezone();
    const now = new Date();

    const dateString = now.toLocaleString('en-US', {
      timeZone: tz,
      year: 'numeric',
      month: '2-digit',
      day: '2-digit'
    });

    // Convert from MM/DD/YYYY to YYYY-MM-DD
    const [month, day, year] = dateString.split('/');
    return `${year}-${month}-${day}`;
  }

  /**
   * Convert local time to UTC ISO string
   * Input: date in user's timezone
   * Output: UTC ISO string for database storage
   */
  toUTC(date: Date | string): string {
    const dateObj = typeof date === 'string' ? new Date(date) : date;
    return dateObj.toISOString();
  }

  /**
   * Convert UTC ISO string to Date in user's timezone
   */
  fromUTC(utcString: string, timezone?: string): Date {
    return new Date(utcString);
  }

  /**
   * Format date for display (YYYY-MM-DD HH:mm)
   */
  formatForDisplay(dateString: string, timezone?: string): string {
    const tz = timezone || this.getTimezone();
    const date = new Date(dateString);

    const year = date.toLocaleString('en-US', { timeZone: tz, year: 'numeric' });
    const month = date.toLocaleString('en-US', { timeZone: tz, month: '2-digit' });
    const day = date.toLocaleString('en-US', { timeZone: tz, day: '2-digit' });
    const hour = date.toLocaleString('en-US', { timeZone: tz, hour: '2-digit', hour12: false });
    const minute = date.toLocaleString('en-US', { timeZone: tz, minute: '2-digit' });

    return `${year}-${month}-${day} ${hour}:${minute}`;
  }

  /**
   * Get date part (YYYY-MM-DD) from ISO string in user's timezone
   */
  getDatePart(isoString: string, timezone?: string): string {
    const tz = timezone || this.getTimezone();
    const date = new Date(isoString);

    const year = date.toLocaleString('en-US', { timeZone: tz, year: 'numeric' });
    const month = date.toLocaleString('en-US', { timeZone: tz, month: '2-digit' });
    const day = date.toLocaleString('en-US', { timeZone: tz, day: '2-digit' });

    return `${year}-${month}-${day}`;
  }

  /**
   * Get time part (HH:mm) from ISO string in user's timezone
   */
  getTimePart(isoString: string, timezone?: string): string {
    const tz = timezone || this.getTimezone();
    const date = new Date(isoString);

    const hour = date.toLocaleString('en-US', { timeZone: tz, hour: '2-digit', hour12: false });
    const minute = date.toLocaleString('en-US', { timeZone: tz, minute: '2-digit' });

    return `${hour}:${minute}`;
  }

  /**
   * Check if it's 23:59 in user's timezone
   */
  isEndOfDay(timezone?: string): boolean {
    const tz = timezone || this.getTimezone();
    const now = new Date();

    const hour = parseInt(now.toLocaleString('en-US', { timeZone: tz, hour: '2-digit', hour12: false }));
    const minute = parseInt(now.toLocaleString('en-US', { timeZone: tz, minute: '2-digit' }));

    return hour === 23 && minute === 59;
  }

  /**
   * Get milliseconds until 23:59 in user's timezone
   */
  getMillisecondsUntilEndOfDay(timezone?: string): number {
    const tz = timezone || this.getTimezone();
    const now = new Date();

    // Get current time components in user's timezone
    const year = parseInt(now.toLocaleString('en-US', { timeZone: tz, year: 'numeric' }));
    const month = parseInt(now.toLocaleString('en-US', { timeZone: tz, month: '2-digit' })) - 1;
    const day = parseInt(now.toLocaleString('en-US', { timeZone: tz, day: '2-digit' }));

    // Create end of day (23:59:59) in user's timezone
    const endOfDay = new Date(year, month, day, 23, 59, 59, 999);

    return endOfDay.getTime() - now.getTime();
  }
}
