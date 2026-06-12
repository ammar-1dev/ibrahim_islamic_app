import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../storage/local_storage.dart';
import 'prayer_calculator.dart';
import 'location_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {},
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'ibrahim_channel',
      'Ibrahim Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: platformDetails,
    );
  }

  Future<void> schedulePrayerNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    if (scheduledTime.isBefore(DateTime.now())) return;

    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_times',
          'أوقات الصلاة',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleAllPrayerNotifications() async {
    try {
      final location = await LocationService().getCurrentLocation();
      final date = DateTime.now();
      final schedule = PrayerCalculator.calculate(
        latitude: location.latitude,
        longitude: location.longitude,
        date: date,
      );

      final prayers = [
        (name: 'الفجر', time: schedule.fajr),
        (name: 'الظهر', time: schedule.dhuhr),
        (name: 'العصر', time: schedule.asr),
        (name: 'المغرب', time: schedule.maghrib),
        (name: 'العشاء', time: schedule.isha),
      ];

      for (var i = 0; i < prayers.length; i++) {
        await schedulePrayerNotification(
          id: 10 + i,
          title: 'حان وقت الصلاة',
          body: 'حان وقت صلاة ${prayers[i].name}',
          scheduledTime: prayers[i].time,
        );
      }
    } catch (_) {}
  }

  Future<void> cancelPrayerNotifications() async {
    for (var i = 0; i < 5; i++) {
      await _notificationsPlugin.cancel(id: 10 + i);
    }
  }

  Future<void> _scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    required String channelId,
    required String channelName,
  }) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleMorningAzkarNotification() async {
    try {
      final location = await LocationService().getCurrentLocation();
      final schedule = PrayerCalculator.calculate(
        latitude: location.latitude,
        longitude: location.longitude,
      );
      final sunrise = schedule.sunrise;
      final notifTime = sunrise.add(const Duration(minutes: 30));

      await _scheduleDailyNotification(
        id: 20,
        title: 'أذكار الصباح',
        body: '🌅 قال رسول الله ﷺ: من قال حين يصبح لا إله إلا الله وحده لا شريك له...',
        hour: notifTime.hour,
        minute: notifTime.minute,
        channelId: 'azkar_morning',
        channelName: 'أذكار الصباح',
      );
    } catch (_) {}
  }

  Future<void> scheduleEveningAzkarNotification() async {
    try {
      final location = await LocationService().getCurrentLocation();
      final schedule = PrayerCalculator.calculate(
        latitude: location.latitude,
        longitude: location.longitude,
      );
      final asr = schedule.asr;
      final notifTime = asr.add(const Duration(minutes: 10));

      await _scheduleDailyNotification(
        id: 21,
        title: 'أذكار المساء',
        body: '🌆 قال رسول الله ﷺ: من قال حين يمسي أعوذ بكلمات الله التامات من شر ما خلق...',
        hour: notifTime.hour,
        minute: notifTime.minute,
        channelId: 'azkar_evening',
        channelName: 'أذكار المساء',
      );
    } catch (_) {}
  }

  Future<void> cancelAzkarNotifications() async {
    await _notificationsPlugin.cancel(id: 20);
    await _notificationsPlugin.cancel(id: 21);
  }

  Future<void> scheduleReminderNotifications() async {
    final now = DateTime.now();
    final rng = Random();

    final reminderMessages = [
      (title: 'ﷺ', body: 'قال رسول الله ﷺ: من صلى عليَّ صلاةً صلى الله عليه بها عشراً'),
      (title: 'ﷺ', body: 'اللهم صلِّ وسلم على نبينا محمد ﷺ'),
      (title: 'ﷺ', body: 'أكثروا من الصلاة عليَّ يوم الجمعة فإن صلاتكم معروضة عليَّ'),
      (title: 'ذكر الله', body: '﴿ الَّذِينَ آمَنُوا وَتَطْمَئِنُّ قُلُوبُهُم بِذِكْرِ اللَّهِ ۗ أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ ﴾'),
      (title: 'ذكر الله', body: 'سبحان الله وبحمده، سبحان الله العظيم'),
      (title: 'ذكر الله', body: 'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير'),
      (title: 'استغفار', body: 'أستغفر الله الذي لا إله إلا هو الحي القيوم وأتوب إليه'),
      (title: 'حمد', body: 'الحمد لله الذي بنعمته تتم الصالحات'),
    ];

    for (var i = 0; i < 6; i++) {
      final hour = 9 + rng.nextInt(11);
      final minute = rng.nextInt(60);
      final msg = reminderMessages[rng.nextInt(reminderMessages.length)];
      final scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);

      if (scheduledDate.isBefore(now)) continue;

      await _notificationsPlugin.zonedSchedule(
        id: 30 + i,
        title: msg.title,
        body: msg.body,
        scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminders',
            'تذكيرات',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> cancelReminderNotifications() async {
    for (var i = 0; i < 6; i++) {
      await _notificationsPlugin.cancel(id: 30 + i);
    }
  }

  Future<void> scheduleAll() async {
    final storage = LocalStorage();

    if (storage.isPrayerNotificationEnabled()) {
      await scheduleAllPrayerNotifications();
    }

    if (storage.isAzkarMorningNotificationEnabled()) {
      await scheduleMorningAzkarNotification();
    }

    if (storage.isAzkarEveningNotificationEnabled()) {
      await scheduleEveningAzkarNotification();
    }

    if (storage.isReminderNotificationEnabled()) {
      await scheduleReminderNotifications();
    }
  }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}
