import 'package:awesome_notifications/awesome_notifications.dart';

class UserNotification {
  Future<void> initialize() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Notifications for basic tests',
          importance: NotificationImportance.High,
        ),
      ],
      debug: true,
    );
  }

  Future<void> createBasicNotification() async {
    print("xDDDD");
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            title: 'App em segundo plano',
            body: 'O aplicativo está sendo executado em segundo plano.'));
  }
}
