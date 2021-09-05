import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:global_template/global_template.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../utils.dart';

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

BehaviorSubject<String?> selectNotificationSubject = BehaviorSubject<String?>();

/// Step send notification with API Firebase
/// 1. Use this url API :  [https://fcm.googleapis.com/fcm/send]
/// 2. Get authentication key for sending messaging, How to get it ?
///    a.Go to project setting in your firebase console
///    b.Go to tab [Cloud Messaging]
///    c.Your key is in "Server Key", Use this key to authentication send firebase messaging

/// Step Step Configurasi Flutter Local Notification
/// 1. Copy semua source code dibawah ini
/// 2. Pastikan meng-install package [1.timezone, 2.flutter_native_timezone, 3.rxdart]
/// 3. Buat/copy gambar bernama app_icon.png di folder [android/app/src/main/res/drawable/app_icon.png]
/// 4. Buat/copy gambar bernama sample_large_icon.png di folder [android/app/src/main/res/drawable/app_icon.png]
/// 5. Buat/copy Folder bernama [raw] di folder [android/app/src/main/res] yang berisikan file [1.keep.xml, 2.slow_spring_board.mp3]
/// 6. Buat/copy musik bernama [slow_spring_board.aiff] di folder [ios/slow_spring_board.aiff]

/// Release Build Konfigurasi
/// 1. Buat file bernama [proguard-rules.pro] di folder [android/app/proguard-rules.pro]

class ReceivedNotification {
  final int? id;
  final String? title;
  final String? body;
  final String? payload;

  ReceivedNotification({
    this.id,
    this.title,
    this.body,
    this.payload,
  });
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationHelperRevision {
  static NotificationHelperRevision? _instance;
  factory NotificationHelperRevision() => _instance ?? NotificationHelperRevision._internal();
  NotificationHelperRevision._internal() {
    _instance = this;
  }

  static const _channelId = "01";
  static const _channelName = "channel_01";
  static const _channelDesc = "Basa Basi Channel";
  static const _firebaseMessagingUrl = 'https://fcm.googleapis.com/fcm/send';
  //TODO: Hidden when push to github
  static const _serverKey = firebaseServerKey;

  static final _dio = Dio();

  Future<void> init() async {
    await _configureLocalTimeZone();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (
          int id,
          String? title,
          String? body,
          String? payload,
        ) async {
          didReceiveLocalNotificationSubject.add(
            ReceivedNotification(
              id: id,
              title: title,
              body: body,
              payload: payload,
            ),
          );
        });
    const MacOSInitializationSettings initializationSettingsMacOS = MacOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      selectNotificationSubject.add(payload);
    });
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  /// Must Initialize in splashscreen/welcomescreen [1 | 2 | 3]
  ///! 1.
  void requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  ///TODO: Change this route location
  ///! 2.
  void configureDidReceiveLocalNotificationSubject(BuildContext context) {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null ? Text(receivedNotification.title!) : null,
          content: receivedNotification.body != null ? Text(receivedNotification.body!) : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  ///! 3.
  void configureSelectNotificationSubject(
    BuildContext context, {
    required Function(String payload) onSelectNotification,
  }) {
    selectNotificationSubject.stream.listen((String? payload) async {
      final length = payload?.length ?? 0;
      if (length > 0) {
        onSelectNotification(payload!);
      }
    });
  }

  ///* STAR FUNCTION SHOW NOTIFICATION
  Future<void> showNotification({
    required int id,
    required String title,
    required String description,
    required String? payload,
  }) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId,
      _channelName,
      _channelDesc,
      importance: Importance.max,
      priority: Priority.max,
      ticker: 'ticker',
      styleInformation: BigTextStyleInformation(
        '',
        htmlFormatContent: true,
        htmlFormatTitle: true,
        htmlFormatContentTitle: true,
        htmlFormatBigText: true,
        htmlFormatSummaryText: true,
      ),
    );

    const iOSPlatformChannelSpecifics = IOSNotificationDetails();

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      description,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> showNotificationWithNoBody({
    required int id,
    required String title,
    required String? payload,
  }) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId,
      _channelName,
      _channelDesc,
      importance: Importance.max,
      priority: Priority.max,
      ticker: 'ticker',
    );

    const iOSPlatformChannelSpecifics = IOSNotificationDetails();

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      null,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> showScheduleNotification() async {
    final vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId,
      _channelName,
      _channelDesc,
      icon: 'secondary_icon',
      sound: const RawResourceAndroidNotificationSound('slow_spring_board'),
      largeIcon: const DrawableResourceAndroidBitmap('sample_large_icon'),
      vibrationPattern: vibrationPattern,
      enableLights: true,
      color: const Color.fromARGB(255, 255, 0, 0),
      ledColor: const Color.fromARGB(255, 255, 0, 0),
      ledOnMs: 1000,
      ledOffMs: 500,
      priority: Priority.max,
      importance: Importance.max,
    );

    const iOSPlatformChannelSpecifics = IOSNotificationDetails(sound: 'slow_spring_board.aiff');

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'title schedule',
      'Body Schedule',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'Payloadd Schedule',
    );
  }

  Future<void> showGroupedNotifications() async {
    const groupKey = 'com.android.example.WORK_EMAIL';

    const firstNotificationAndroidSpecifics = AndroidNotificationDetails(
      _channelId,
      _channelName,
      _channelDesc,
      priority: Priority.max,
      importance: Importance.max,
      groupKey: groupKey,
    );

    const firstNotificationPlatformSpecifics =
        NotificationDetails(android: firstNotificationAndroidSpecifics);

    await flutterLocalNotificationsPlugin.show(
      1,
      'Alex Faarborg',
      'You will not believe...',
      firstNotificationPlatformSpecifics,
    );

    const secondNotificationAndroidSpecifics = AndroidNotificationDetails(
      _channelId,
      _channelName,
      _channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      groupKey: groupKey,
    );

    const secondNotificationPlatformSpecifics = NotificationDetails(
      android: secondNotificationAndroidSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      2,
      'Jeff Chang',
      'Please join us to celebrate the...',
      secondNotificationPlatformSpecifics,
    );

    final lines = <String>[];
    lines.add('Alex Faarborg  Check this out');
    lines.add('Jeff Chang    Launch Party');

    final inboxStyleInformation = InboxStyleInformation(
      lines,
      contentTitle: '2 messages',
      summaryText: 'janedoe@example.com',
    );

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId,
      _channelName,
      _channelDesc,
      styleInformation: inboxStyleInformation,
      groupKey: groupKey,
      setAsGroupSummary: true,
    );

    final platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      3,
      'Attention',
      'Two messages',
      platformChannelSpecifics,
    );
  }

  Future<void> showProgressNotification() async {
    const maxProgress = 5;
    for (var i = 0; i <= maxProgress; i++) {
      await Future.delayed(const Duration(seconds: 1), () async {
        final androidPlatformChannelSpecifics = AndroidNotificationDetails(
          _channelId,
          _channelName,
          _channelDesc,
          channelShowBadge: false,
          priority: Priority.max,
          importance: Importance.max,
          onlyAlertOnce: true,
          showProgress: true,
          maxProgress: maxProgress,
          progress: i,
        );

        final platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
        );

        await flutterLocalNotificationsPlugin.show(
          0,
          'progress notification title',
          'progress notification body',
          platformChannelSpecifics,
          payload: 'item x',
        );
      });
    }
  }

  Future<void> showBigPictureNotification() async {
    final largeIconPath =
        await downloadAndSaveFile('http://via.placeholder.com/48x48', 'largeIcon');
    final bigPicturePath =
        await downloadAndSaveFile('http://via.placeholder.com/400x800', 'bigPicture');

    final bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      contentTitle: 'overridden <b>big</b> content title',
      htmlFormatContentTitle: true,
      summaryText: 'summary <i>text</i>',
      htmlFormatSummaryText: true,
    );

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId,
      _channelName,
      _channelDesc,
      styleInformation: bigPictureStyleInformation,
      priority: Priority.max,
      importance: Importance.max,
    );

    final platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'big text title',
      'silent body',
      platformChannelSpecifics,
    );
  }

  Future<void> showNotificationWithAttachment() async {
    final bigPicturePath =
        await downloadAndSaveFile('http://via.placeholder.com/600x200', 'bigPicture.jpg');

    final bigPictureAndroidStyle =
        BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath));

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId,
      _channelName,
      _channelDesc,
      importance: Importance.max,
      priority: Priority.max,
      styleInformation: bigPictureAndroidStyle,
    );

    final iOSPlatformChannelSpecifics =
        IOSNotificationDetails(attachments: [IOSNotificationAttachment(bigPicturePath)]);

    final notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'notification with attachment title',
      'notification with attachment body',
      notificationDetails,
    );
  }

  Future<void> showSingleConversationNotification(
    int uniqId, {
    required Person pairing,
    required List<Message> messages,
    String? payload,
  }) async {
    /// First two person objects will use icons that part of the Android app's
    /// drawable resources
    // const Person me = Person(
    //   name: 'Me',
    //   key: '1',
    //   uri: 'tel:1234567890',
    //   icon: DrawableResourceAndroidIcon('me'),
    // );
    // const Person coworker = Person(
    //   name: 'Coworker',
    //   key: '2',
    //   uri: 'tel:9876543210',
    //   icon: FlutterBitmapAssetAndroidIcon('icons/coworker.png'),
    // );
    // download the icon that would be use for the lunch bot person
    // final String largeIconPath =
    //     await downloadAndSaveFile('https://via.placeholder.com/48x48', 'largeIcon');
    // this person object will use an icon that was downloaded
    // final Person lunchBot = Person(
    //   name: 'Lunch bot',
    //   key: 'bot',
    //   bot: true,
    //   icon: BitmapFilePathAndroidIcon(largeIconPath),
    // );

    // final List<Message> messages = <Message>[
    //   Message('Hi', DateTime.now(), null),
    //   Message("What's up?", DateTime.now().add(const Duration(minutes: 5)), coworker),
    //   Message('What kind of food would you prefer?',
    //       DateTime.now().add(const Duration(minutes: 10)), lunchBot),
    // ];

    final MessagingStyleInformation messagingStyle = MessagingStyleInformation(
      pairing,
      // groupConversation: true,
      // conversationTitle: 'Team lunch',
      htmlFormatContent: true,
      htmlFormatTitle: true,
      messages: messages,
    );

    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '${pairing.key}_${pairing.name}',
      'Basa Basi dengan ${pairing.name}',
      'Basa Basi Deskripsi',
      category: 'msg',
      styleInformation: messagingStyle,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      uniqId,
      '',
      '',
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<String> downloadAndSaveFile(String url, String fileName) async {
    try {
      final _dio = Dio();
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/$fileName.png';
      if (File(filePath).existsSync()) {
        log('File sudah ada, gunakan yang existing');
        return filePath;
      }
      // final http.Response response = await http.get(Uri.parse(url));
      final Response<List<int>> response =
          await _dio.get<List<int>>(url, options: Options(responseType: ResponseType.bytes));
      final File file = File(filePath);
      await file.writeAsBytes(response.data ?? []);
      return filePath;
    } on DioError catch (error) {
      if (error.message.toLowerCase().contains('socketexception')) {
        throw CustomException('Error : Membutuhkan internet untuk pertama kali mendownload gambar');
      }
      throw CustomException('Terjadi masalah, coba beberapa saat lagi');
    } catch (e) {
      throw CustomException('Terjadi masalah, coba beberapa saat lagi');
    }
  }

  Future<void> sendSingleNotificationFirebase(
    String tokenFirebase, {
    required String title,
    required String body,
    required String payload,
    Map<String, dynamic> paramData = const {},
  }) async {
    final defaultParam = {
      "title": title,
      "body": body,
      'payload': payload,
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "sound": "default",
      ...paramData,
    };

    log('defaultParam $defaultParam');
    try {
      final _data = {
        'to': tokenFirebase,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': defaultParam,
        'priority': 'high'
      };
      final response = await _dio.post(
        _firebaseMessagingUrl,
        data: jsonEncode(_data),
        options: Options(
          headers: {
            'Authorization': "key=$_serverKey",
          },
          contentType: Headers.jsonContentType,
          validateStatus: (status) => (status ?? 0) < 500,
        ),
      );

      log('Response Send Single Notification Firebase ${response.data}');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendMultipleNotificationFirebase(
    List<String> tokensFirebase, {
    required String title,
    required String body,
    Map<String, dynamic> paramData = const {},
  }) async {
    try {
      final _data = {
        'registration_ids': tokensFirebase,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': paramData,
        'priority': 'high'
      };
      final response = await _dio.post(
        _firebaseMessagingUrl,
        data: jsonEncode(_data),
        options: Options(
          headers: {
            'Authorization': "key=$_serverKey",
          },
          contentType: Headers.jsonContentType,
          validateStatus: (status) => (status ?? 0) < 500,
        ),
      );

      log('Response Send Single Notification Firebase ${response.data}');
    } catch (e) {
      rethrow;
    }
  }

  ///* END FUNCTION SHOW NOTIFICATION
}
