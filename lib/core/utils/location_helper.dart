import 'dart:ui';
import 'package:geolocalizacao/core/notifications/user_notification.dart';

class LocationHelper {
  static final UserNotification userNotification = UserNotification();

  // Detecta quando o app vai para o segundo plano e envia uma notificação
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('AppLifecycleState mudou para: $state');
    if (state == AppLifecycleState.paused) {
      print('App está em segundo plano, enviando notificação...');
      userNotification.createBasicNotification();
    }
  }
}
