import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { HttpClient } from '@angular/common/http';
import {
  IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardHeader,
  IonCardTitle, IonCardContent, IonItem, IonLabel, IonText, IonInput,
  IonButton, IonList, IonIcon, IonModal, IonButtons, IonDatetime,
  IonGrid, IonRow, IonCol, IonSelect, IonSelectOption, AlertController
} from '@ionic/angular/standalone';
import { addIcons } from 'ionicons';
import {
  checkmarkCircle, chevronDown, chevronUp, homeOutline, sunnyOutline, timeOutline,
  walkOutline, bicycleOutline, waterOutline, barbellOutline, fitnessOutline,
  calendarOutline, globeOutline, createOutline, trashOutline, addCircle, statsChart,
  personCircle, refreshOutline
} from 'ionicons/icons';
import { TimezoneService } from '../services/timezone.service';

@Component({
  selector: 'app-tab1',
  templateUrl: 'tab1.page.html',
  styleUrls: ['tab1.page.scss'],
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardHeader,
    IonCardTitle, IonCardContent, IonItem, IonLabel, IonText, IonInput,
    IonButton, IonList, IonIcon, IonModal, IonButtons, IonDatetime,
    IonGrid, IonRow, IonCol, IonSelect, IonSelectOption
  ]
})
export class Tab1Page implements OnInit {

  // 用户信息
  username: string = ''; // 将在构造函数中初始化
  selectedTimezone: string = ''; // 从TimezoneService获取

  // API URL
  private apiUrl = 'http://localhost:8080/api/exercises';

  // 时区列表
  timezones = [
    // 美国
    { label: 'America/New York', value: 'America/New_York' },
    { label: 'America/Chicago', value: 'America/Chicago' },
    { label: 'America/Denver', value: 'America/Denver' },
    { label: 'America/Los Angeles', value: 'America/Los_Angeles' },

    // 加拿大
    { label: 'Canada/Toronto', value: 'America/Toronto' },
    { label: 'Canada/Vancouver', value: 'America/Vancouver' },

    // 英国
    { label: 'UK/London', value: 'Europe/London' },

    // 法国
    { label: 'France/Paris', value: 'Europe/Paris' },

    // 德国
    { label: 'Germany/Berlin', value: 'Europe/Berlin' },

    // 中国
    { label: 'China/Beijing', value: 'Asia/Shanghai' },

    // 日本
    { label: 'Japan/Tokyo', value: 'Asia/Tokyo' },

    // 韩国
    { label: 'Korea/Seoul', value: 'Asia/Seoul' },

    // 澳大利亚
    { label: 'Australia/Sydney', value: 'Australia/Sydney' },
    { label: 'Australia/Melbourne', value: 'Australia/Melbourne' },

    // 新西兰
    { label: 'New Zealand/Auckland', value: 'Pacific/Auckland' },

    // 印度
    { label: 'India/New Delhi', value: 'Asia/Kolkata' },

    // 新加坡
    { label: 'Singapore', value: 'Asia/Singapore' },

    // 巴西
    { label: 'Brazil/São Paulo', value: 'America/Sao_Paulo' },

    // 阿根廷
    { label: 'Argentina/Buenos Aires', value: 'America/Argentina/Buenos_Aires' },

    // 墨西哥
    { label: 'Mexico/Mexico City', value: 'America/Mexico_City' },

    // 俄罗斯
    { label: 'Russia/Moscow', value: 'Europe/Moscow' },
    { label: 'Russia/Vladivostok', value: 'Asia/Vladivostok' },

    // 南非
    { label: 'South Africa/Johannesburg', value: 'Africa/Johannesburg' },

    // 阿联酋
    { label: 'UAE/Dubai', value: 'Asia/Dubai' },
  ];

  // 表单字段
  type: string = 'RUN'; // 默认运动类型
  duration: number = 0; // 持续时间（分钟）
  when: string = new Date().toISOString(); // 日期时间（主表单的最终值）
  location: 'inside' | 'outside' = 'inside'; // 位置（默认室内）

  // 运动类型选项
  exerciseTypes: string[] = ['RUN', 'WALK', 'CYCLE', 'SWIM', 'GYM', 'OTHER'];

  // 模态框控制
  showTypeOptions: boolean = false;
  showLocationModal: boolean = false;
  showViewModal: boolean = false;

  // 编辑记录相关
  editingIndex: number = -1;
  editType: string = 'RUN';
  editDuration: number = 0;
  editWhen: string = new Date().toISOString();
  editLocation: 'inside' | 'outside' = 'inside';
  editTimezone: string = 'America/New_York'; // 记录的时区（只读）
  editTempDate: string = ''; // 编辑的日期部分
  editTempTime: string = ''; // 编辑的时间部分
  showEditTypeOptions: boolean = false;
  showEditLocationModal: boolean = false;

  // 保存原始编辑记录，用于比较是否有修改
  originalEditRecord: {
    type: string;
    duration: number;
    when: string;
    location: 'inside' | 'outside';
  } | null = null;

  // 日期时间相关
  tempWhen: string = new Date().toISOString(); // 模态框中的临时值
  tempDate: string = ''; // 手动输入的日期部分
  tempTime: string = ''; // 手动输入的时间部分
  maxDate: string = new Date().toISOString(); // 最大日期（今天）
  maxDateString: string = this.getTodayDateString(); // 最大日期字符串（格式：YYYY-MM-DD）

  // 记录列表
  records: Array<{
    type: string;
    duration: number;
    when: string;
    location: 'inside' | 'outside';
    timezone?: string; // 记录添加时的时区
  }> = [];

  constructor(
    private alertController: AlertController,
    private http: HttpClient,
    private timezoneService: TimezoneService
  ) {
    // 立即从 localStorage 读取用户名
    this.username = localStorage.getItem('currentUsername') || 'Guest';
    console.log('Constructor - Username loaded:', this.username);

    // 从TimezoneService获取时区
    this.selectedTimezone = this.timezoneService.getTimezone();
    console.log('Constructor - Timezone loaded:', this.selectedTimezone);

    // 注册所有需要的图标
    addIcons({
      'checkmark-circle': checkmarkCircle,
      'chevron-down': chevronDown,
      'chevron-up': chevronUp,
      'home-outline': homeOutline,
      'sunny-outline': sunnyOutline,
      'time-outline': timeOutline,
      'walk-outline': walkOutline,
      'bicycle-outline': bicycleOutline,
      'water-outline': waterOutline,
      'barbell-outline': barbellOutline,
      'fitness-outline': fitnessOutline,
      'calendar-outline': calendarOutline,
      'globe-outline': globeOutline,
      'create-outline': createOutline,
      'trash-outline': trashOutline,
      'add-circle': addCircle,
      'stats-chart': statsChart,
      'person-circle': personCircle,
      'refresh-outline': refreshOutline
    });
  }

  ngOnInit() {
    // 从 localStorage 读取登录的用户名
    const savedUsername = localStorage.getItem('currentUsername');
    console.log('Saved username from localStorage:', savedUsername);
    if (savedUsername) {
      this.username = savedUsername;
      console.log('Username set to:', this.username);
    } else {
      console.log('No username found in localStorage, using default:', this.username);
    }

    // 初始化手动输入的日期和时间
    this.updateManualInputs(this.when);

    // 检查是否需要同步昨天的数据
    this.checkAndSyncOldData();

    // 从 localStorage 加载今天的记录
    this.loadTodayRecords();

    // 设置每日 23:59 的同步任务
    this.scheduleEndOfDaySync();
  }

  ionViewWillEnter() {
    // Reload username when view is entered (e.g., after login)
    const savedUsername = localStorage.getItem('currentUsername');
    if (savedUsername) {
      this.username = savedUsername;
      console.log('Username reloaded on view enter:', this.username);
    }
  }

  // 运动类型选择 - 切换展开/收起
  toggleTypeSelector() {
    this.showTypeOptions = !this.showTypeOptions;
  }

  selectType(type: string) {
    this.type = type;
    this.showTypeOptions = false; // 选择后自动收起
  }

  // ═══════════════════════════════════════════════════════
  // 位置选择
  // ═══════════════════════════════════════════════════════
  openLocationModal() {
    this.showLocationModal = true;
  }

  selectLocation(location: 'inside' | 'outside') {
    this.location = location;
    this.showLocationModal = false; // 选择后自动关闭
  }

  // 保存表单
  async save() {
    // 验证表单
    if (!this.type || !this.duration || this.duration <= 0) {
      const alert = await this.alertController.create({
        header: 'Validation Error',
        message: 'Please fill in all required fields correctly.',
        buttons: ['OK']
      });
      await alert.present();
      return;
    }

    // 创建新记录
    const newRecord = {
      type: this.type,
      duration: this.duration,
      when: this.when,
      location: this.location,
      timezone: this.selectedTimezone
    };

    try {
      // 立即保存到后端
      await this.saveToBackendImmediately(newRecord);

      // 添加记录到列表（保存当前时区信息）
      this.records.push(newRecord);

      // 同步保存到 localStorage
      this.saveRecordsToLocalStorage();

      // 打印表单数据到控制台（调试用）
      console.log('Exercise saved to backend and localStorage:', newRecord);

      // 提示用户保存成功并显示积分增加
      const successAlert = await this.alertController.create({
        header: 'Success! 🎉',
        message: `Exercise saved successfully!\n\nType: ${this.type}\nDuration: ${this.duration} min\n\n✨ Points Earned: +50 ✨`,
        buttons: ['OK']
      });
      await successAlert.present();

      // 重置表单
      this.resetForm();
    } catch (error) {
      console.error('Failed to save exercise:', error);

      // 显示错误提示
      const errorAlert = await this.alertController.create({
        header: 'Error',
        message: 'Failed to save exercise record. Please try again.',
        buttons: ['OK']
      });
      await errorAlert.present();
    }
  }

  // 重置表单
  resetForm() {
    this.type = 'RUN';
    this.duration = 0;
    this.when = new Date().toISOString();
    this.location = 'inside';
    this.tempWhen = this.when;
    this.updateManualInputs(this.when);
  }

  // ═══════════════════════════════════════════════════════
  // 日期时间相关方法
  // ═══════════════════════════════════════════════════════

  /**
   * 当模态框即将打开时，初始化临时值
   */
  onDateModalWillPresent() {
    this.tempWhen = this.when;
    this.updateManualInputs(this.when);
    console.log('Modal opened, tempWhen:', this.tempWhen);
    console.log('Date:', this.tempDate, 'Time:', this.tempTime);
  }

  /**
   * 将 ISO 字符串拆分为日期和时间，用于手动输入
   */
  updateManualInputs(isoString: string) {
    const date = new Date(isoString);
    // 格式化日期为 YYYY-MM-DD
    this.tempDate = date.getFullYear() + '-' +
                    String(date.getMonth() + 1).padStart(2, '0') + '-' +
                    String(date.getDate()).padStart(2, '0');
    // 格式化时间为 HH:mm
    this.tempTime = String(date.getHours()).padStart(2, '0') + ':' +
                    String(date.getMinutes()).padStart(2, '0');
  }

  /**
   * 当日历选择器变化时，同步更新手动输入框
   */
  onDatetimeChange() {
    this.updateManualInputs(this.tempWhen);
  }

  /**
   * 当手动输入日期或时间时，合并并更新 tempWhen
   */
  onManualInputChange() {
    // 验证输入格式
    if (this.tempDate && this.tempTime) {
      try {
        // 合并日期和时间
        const dateTimeString = `${this.tempDate}T${this.tempTime}:00`;
        const newDate = new Date(dateTimeString);

        // 检查日期是否有效
        if (!isNaN(newDate.getTime())) {
          // 检查日期是否超过今天
          const now = new Date();
          const today = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 23, 59, 59, 999);

          if (newDate <= today) {
            this.tempWhen = newDate.toISOString();
          } else {
            // 如果日期超过今天，重置为当前日期和输入的时间
            const resetDateTime = new Date(now.getFullYear(), now.getMonth(), now.getDate(),
                                          newDate.getHours(), newDate.getMinutes());
            this.tempWhen = resetDateTime.toISOString();
            this.updateManualInputs(this.tempWhen);
          }
        }
      } catch (e) {
        console.error('Invalid date/time input', e);
      }
    }
  }

  /**
   * 确认日期时间选择
   */
  confirmDatePicker() {
    this.when = this.tempWhen;
  }

  /**
   * 设置时间为当前时间（主表单）
   */
  setToNow() {
    const now = new Date().toISOString();
    this.tempWhen = now;
    this.updateManualInputs(now);
  }

  // ═══════════════════════════════════════════════════════
  // LocalStorage 相关方法
  // ═══════════════════════════════════════════════════════

  /**
   * 从 localStorage 加载今天的记录
   */
  loadTodayRecords() {
    try {
      const today = this.getTodayDateString();
      const key = `exercise_records_${today}`;
      const stored = localStorage.getItem(key);

      if (stored) {
        this.records = JSON.parse(stored);

        // 确保所有记录都有timezone字段（为旧记录添加当前时区）
        this.records = this.records.map(record => {
          if (!record.timezone) {
            // 如果记录没有timezone字段，使用当前选择的时区并保存
            record.timezone = this.selectedTimezone;
          }
          return record;
        });

        // 更新localStorage以保存timezone字段
        this.saveRecordsToLocalStorage();

        console.log('Loaded records from localStorage:', this.records);
      }
    } catch (e) {
      console.error('Failed to load records from localStorage', e);
    }
  }

  /**
   * 保存记录到 localStorage（按记录的实际日期分组存储）
   */
  saveRecordsToLocalStorage() {
    try {
      const today = this.getTodayDateString();
      const todayKey = `exercise_records_${today}`;

      // 如果今天没有记录了，删除localStorage中的key
      if (this.records.length === 0) {
        localStorage.removeItem(todayKey);
        console.log(`Removed ${todayKey} from localStorage (no records)`);
        return;
      }

      // 按日期分组
      const recordsByDate: { [date: string]: any[] } = {};

      this.records.forEach(record => {
        // 从记录的 when 字段提取日期
        const recordDate = new Date(record.when);
        const dateKey = recordDate.getFullYear() + '-' +
                       String(recordDate.getMonth() + 1).padStart(2, '0') + '-' +
                       String(recordDate.getDate()).padStart(2, '0');

        if (!recordsByDate[dateKey]) {
          recordsByDate[dateKey] = [];
        }
        recordsByDate[dateKey].push(record);
      });

      // 保存每个日期的记录
      Object.keys(recordsByDate).forEach(date => {
        const key = `exercise_records_${date}`;
        localStorage.setItem(key, JSON.stringify(recordsByDate[date]));
        console.log(`Saved ${recordsByDate[date].length} records to ${key}`);
      });

    } catch (e) {
      console.error('Failed to save records to localStorage', e);
    }
  }

  /**
   * 获取今天的日期字符串（格式：YYYY-MM-DD）
   */
  getTodayDateString(): string {
    const today = new Date();
    return today.getFullYear() + '-' +
           String(today.getMonth() + 1).padStart(2, '0') + '-' +
           String(today.getDate()).padStart(2, '0');
  }

  /**
   * 检查并同步旧数据到后端
   */
  async checkAndSyncOldData() {
    try {
      const today = this.getTodayDateString();
      const lastSyncDate = localStorage.getItem('lastSyncDate');

      console.log('Last sync date:', lastSyncDate);
      console.log('Today:', today);

      // 如果上次同步日期不是今天，说明过夜了
      if (lastSyncDate && lastSyncDate !== today) {
        console.log('Detected date change, syncing old data...');

        // 获取昨天的数据
        const yesterdayKey = `exercise_records_${lastSyncDate}`;
        const yesterdayData = localStorage.getItem(yesterdayKey);

        if (yesterdayData) {
          const records = JSON.parse(yesterdayData);
          console.log('Syncing records:', records);

          // 调用后端 API 同步数据
          await this.syncToBackend(lastSyncDate, records);

          // 同步成功后，删除旧数据
          localStorage.removeItem(yesterdayKey);
          console.log('Old data removed from localStorage');
        }
      }

      // 更新 lastSyncDate 为今天
      localStorage.setItem('lastSyncDate', today);
    } catch (e) {
      console.error('Failed to check and sync old data', e);
    }
  }

  /**
   * 立即保存单条记录到后端
   */
  async saveToBackendImmediately(record: any) {
    try {
      const apiUrl = 'http://localhost:8080/api/exercises';
      const userId = parseInt(localStorage.getItem('currentUserId') || '1');

      const response = await fetch(apiUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          userId: userId,
          type: record.type,
          durationMinutes: record.duration,
          location: record.location,
          occurredAt: record.when
        })
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const result = await response.json();
      console.log('Saved to backend immediately:', result);
      return result;
    } catch (error) {
      console.error('Failed to save to backend immediately:', error);
      throw error;
    }
  }

  /**
   * 同步数据到后端（批量）
   */
  async syncToBackend(date: string, records: any[]) {
    try {
      console.log(`Syncing ${records.length} records for date ${date} to backend...`);

      const apiUrl = 'http://localhost:8080/api/exercises/sync';
      const userId = parseInt(localStorage.getItem('currentUserId') || '1');

      // 转换前端数据格式为后端格式（包含timezone信息）
      const backendRecords = records.map(record => ({
        type: record.type,
        duration: record.duration,
        when: record.when,
        location: record.location,
        timezone: record.timezone || this.selectedTimezone  // 包含时区信息
      }));

      const response = await fetch(apiUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          date: date,
          userId: userId,
          records: backendRecords
        })
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const result = await response.json();
      console.log('Sync successful:', result);

      // 显示同步成功提示
      const alert = await this.alertController.create({
        header: 'Sync Complete',
        message: `Successfully synced ${result.successCount}/${result.totalRecords} exercise records from ${date} to server.`,
        buttons: ['OK']
      });
      await alert.present();

    } catch (error) {
      console.error('Failed to sync to backend:', error);

      // 显示同步失败提示
      const alert = await this.alertController.create({
        header: 'Sync Failed',
        message: 'Failed to sync data to server. Data will be kept locally and retried next time.',
        buttons: ['OK']
      });
      await alert.present();

      // 如果同步失败，抛出错误，这样旧数据不会被删除
      throw error;
    }
  }

  /**
   * 设置每日 23:59 的同步任务
   */
  scheduleEndOfDaySync() {
    // 获取当前时间
    const now = new Date();

    // 设置目标时间为今天 23:59:00
    const targetTime = new Date();
    targetTime.setHours(23, 59, 0, 0);

    // 如果当前时间已经过了 23:59，设置为明天的 23:59
    if (now >= targetTime) {
      targetTime.setDate(targetTime.getDate() + 1);
    }

    // 计算时间差（毫秒）
    const timeUntilSync = targetTime.getTime() - now.getTime();

    console.log(`Next sync scheduled at ${targetTime.toLocaleString()}`);
    console.log(`Time until sync: ${Math.round(timeUntilSync / 1000 / 60)} minutes`);

    // 设置定时器
    setTimeout(async () => {
      console.log('End of day sync triggered at 23:59');
      await this.performEndOfDaySync();

      // 同步完成后，重新设置明天的同步任务
      this.scheduleEndOfDaySync();
    }, timeUntilSync);
  }

  /**
   * 执行每日结束时的同步
   */
  async performEndOfDaySync() {
    try {
      const today = this.getTodayDateString();
      const todayKey = `exercise_records_${today}`;
      const todayData = localStorage.getItem(todayKey);

      if (todayData) {
        const records = JSON.parse(todayData);
        console.log('End of day sync: syncing today\'s records:', records);

        // 同步到后端
        await this.syncToBackend(today, records);

        console.log('End of day sync completed successfully');
      } else {
        console.log('No records to sync for today');
      }
    } catch (e) {
      console.error('Failed to perform end of day sync', e);
    }
  }

  // ═══════════════════════════════════════════════════════
  // 记录操作方法
  // ═══════════════════════════════════════════════════════

  /**
   * 查看/编辑记录详情
   */
  viewRecord(index: number) {
    const record = this.records[index];
    this.editingIndex = index;

    // 填充编辑表单
    this.editType = record.type;
    this.editDuration = record.duration;
    this.editWhen = record.when;
    this.editLocation = record.location;
    this.editTimezone = record.timezone || this.selectedTimezone; // 加载记录的时区（只读显示）

    // 初始化日期和时间输入框
    const date = new Date(record.when);
    this.editTempDate = date.getFullYear() + '-' +
                       String(date.getMonth() + 1).padStart(2, '0') + '-' +
                       String(date.getDate()).padStart(2, '0');
    this.editTempTime = String(date.getHours()).padStart(2, '0') + ':' +
                        String(date.getMinutes()).padStart(2, '0');

    // 保存原始记录用于比较
    this.originalEditRecord = {
      type: record.type,
      duration: record.duration,
      when: record.when,
      location: record.location
    };

    // 显示编辑模态框
    this.showViewModal = true;
  }

  /**
   * 切换编辑表单的运动类型选择器
   */
  toggleEditTypeSelector() {
    this.showEditTypeOptions = !this.showEditTypeOptions;
  }

  /**
   * 选择编辑表单的运动类型
   */
  selectEditType(type: string) {
    this.editType = type;
    this.showEditTypeOptions = false;
  }

  /**
   * 打开编辑表单的位置选择器
   */
  openEditLocationModal() {
    this.showEditLocationModal = true;
  }

  /**
   * 选择编辑表单的位置
   */
  selectEditLocation(location: 'inside' | 'outside') {
    this.editLocation = location;
    this.showEditLocationModal = false;
  }

  /**
   * 编辑表单日期时间变化（日期和时间都可以改，但日期不能超过今天）
   */
  onEditDateTimeChange() {
    if (this.editTempDate && this.editTempTime) {
      try {
        // 合并日期和时间
        const dateTimeString = `${this.editTempDate}T${this.editTempTime}:00`;
        const newDate = new Date(dateTimeString);

        // 检查日期是否有效
        if (!isNaN(newDate.getTime())) {
          // 检查日期是否超过今天
          const now = new Date();
          const today = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 23, 59, 59, 999);

          if (newDate <= today) {
            this.editWhen = newDate.toISOString();
          } else {
            // 如果日期超过今天，重置为当前日期和输入的时间
            const resetDateTime = new Date(now.getFullYear(), now.getMonth(), now.getDate(),
                                          newDate.getHours(), newDate.getMinutes());
            this.editWhen = resetDateTime.toISOString();
            // 更新日期输入框为今天
            this.editTempDate = now.getFullYear() + '-' +
                               String(now.getMonth() + 1).padStart(2, '0') + '-' +
                               String(now.getDate()).padStart(2, '0');
          }
        }
      } catch (e) {
        console.error('Invalid date/time input', e);
      }
    }
  }

  /**
   * 保存编辑
   */
  async saveEdit() {
    // 验证表单
    if (!this.editType || !this.editDuration || this.editDuration <= 0) {
      const alert = await this.alertController.create({
        header: 'Validation Error',
        message: 'Please fill in all required fields correctly.',
        buttons: ['OK']
      });
      await alert.present();
      return;
    }

    // 更新记录（保留原始时区信息）
    const originalRecord = this.records[this.editingIndex];
    this.records[this.editingIndex] = {
      type: this.editType,
      duration: this.editDuration,
      when: this.editWhen,
      location: this.editLocation,
      timezone: originalRecord.timezone || this.selectedTimezone // 保留原时区或使用当前时区
    };

    // 同步保存到 localStorage
    this.saveRecordsToLocalStorage();

    console.log('Record updated:', this.records[this.editingIndex]);

    // 关闭模态框并清除原始记录
    this.showViewModal = false;
    this.originalEditRecord = null;

    // 显示成功提示
    const successAlert = await this.alertController.create({
      header: 'Success',
      message: 'Exercise record updated successfully!',
      buttons: ['OK']
    });
    await successAlert.present();
  }

  /**
   * 检查编辑表单是否有变化
   */
  hasEditChanges(): boolean {
    if (!this.originalEditRecord) {
      return false;
    }

    return this.editType !== this.originalEditRecord.type ||
           this.editDuration !== this.originalEditRecord.duration ||
           this.editWhen !== this.originalEditRecord.when ||
           this.editLocation !== this.originalEditRecord.location;
  }

  /**
   * 关闭编辑模态框（带变化检测）
   */
  async closeEditModal() {
    // 检查是否有未保存的更改
    if (this.hasEditChanges()) {
      const alert = await this.alertController.create({
        header: 'Unsaved Changes',
        message: 'You have unsaved changes. Are you sure you want to discard them?',
        buttons: [
          {
            text: 'Cancel',
            role: 'cancel'
          },
          {
            text: 'Discard',
            role: 'destructive',
            handler: () => {
              this.showViewModal = false;
              this.originalEditRecord = null;
            }
          }
        ]
      });
      await alert.present();
    } else {
      // 没有变化，直接关闭
      this.showViewModal = false;
      this.originalEditRecord = null;
    }
  }

  /**
   * 删除记录
   */
  async deleteRecord(index: number) {
    const record = this.records[index];

    // 弹出确认对话框
    const alert = await this.alertController.create({
      header: 'Confirm Delete',
      message: `Are you sure you want to delete this record?<br><br>` +
               `<strong>Type:</strong> ${record.type}<br>` +
               `<strong>Duration:</strong> ${record.duration} min<br>` +
               `<strong>Location:</strong> ${record.location === 'inside' ? 'Inside' : 'Outside'}`,
      buttons: [
        {
          text: 'Cancel',
          role: 'cancel'
        },
        {
          text: 'Delete',
          role: 'destructive',
          handler: async () => {
            // 从数组中删除记录
            this.records.splice(index, 1);

            // 同步更新 localStorage
            this.saveRecordsToLocalStorage();

            console.log('Record deleted, remaining records:', this.records);

            // 显示删除成功提示
            const successAlert = await this.alertController.create({
              header: 'Deleted',
              message: 'Exercise record deleted successfully.',
              buttons: ['OK']
            });
            await successAlert.present();
          }
        }
      ]
    });

    await alert.present();
  }

  /**
   * 时区变化处理
   */
  onTimezoneChange() {
    console.log('Selected timezone:', this.selectedTimezone);

    // 保存时区到localStorage
    this.timezoneService.setTimezone(this.selectedTimezone);

    // 更新当前显示的日期时间为新时区的当前时间
    this.when = new Date().toISOString();
    this.updateManualInputs(this.when);

    // 更新maxDateString为新时区的今天
    this.maxDateString = this.getTodayDateString();

    console.log('Timezone changed to:', this.selectedTimezone);
    console.log('Updated today to:', this.maxDateString);
  }

  /**
   * Format record time for display with timezone info
   */
  formatRecordTime(record: any): string {
    // 使用记录保存的timezone（所有记录在加载时都会有timezone字段）
    const timezone = record.timezone;
    const formattedTime = this.timezoneService.formatForDisplay(record.when, timezone);

    // 获取时区的简称
    const timezoneLabel = this.getTimezoneLabel(timezone);

    return `${formattedTime} (${timezoneLabel})`;
  }

  /**
   * Format record datetime only (without timezone)
   */
  formatRecordDateTime(record: any): string {
    const timezone = record.timezone;
    return this.timezoneService.formatForDisplay(record.when, timezone);
  }

  /**
   * Get timezone label from timezone value
   */
  getTimezoneLabel(timezone: string | undefined): string {
    if (!timezone) {
      return 'Unknown';
    }
    const tz = this.timezones.find(t => t.value === timezone);
    return tz ? tz.label : timezone;
  }

  /**
   * Get exercise emoji icon
   */
  getExerciseEmoji(type: string): string {
    const emojiMap: { [key: string]: string } = {
      'RUN': '🏃',
      'WALK': '🚶',
      'CYCLE': '🚴',
      'SWIM': '🏊',
      'GYM': '🏋️',
      'OTHER': '💪'
    };
    return emojiMap[type] || '❓';
  }

  /**
   * Get exercise icon name for ion-icon
   */
  getExerciseIconName(type: string): string {
    const iconMap: { [key: string]: string } = {
      'RUN': 'walk-outline',
      'WALK': 'walk-outline',
      'CYCLE': 'bicycle-outline',
      'SWIM': 'water-outline',
      'GYM': 'barbell-outline',
      'OTHER': 'fitness-outline'
    };
    return iconMap[type] || 'fitness-outline';
  }
}
