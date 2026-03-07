import 'package:flutter_local_notifications/flutter_local_notifications.dart';
void test() {
  const AndroidNotificationDetails detail = AndroidNotificationDetails(
    'id',
    'name',
    channelDescription: 'desc',
  );
}
