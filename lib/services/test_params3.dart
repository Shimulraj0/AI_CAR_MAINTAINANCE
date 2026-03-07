import 'package:flutter_local_notifications/flutter_local_notifications.dart';
void test() {
  final plugin = FlutterLocalNotificationsPlugin();
  plugin.show(1, 'title', 'body', const NotificationDetails(android: AndroidNotificationDetails('id', 'name')));
}
