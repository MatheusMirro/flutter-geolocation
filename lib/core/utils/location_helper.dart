import 'dart:async';
import 'dart:ui';
import 'package:geolocator/geolocator.dart';
import 'package:geolocalizacao/core/notifications/user_notification.dart';

class LocationHelper {
  static StreamSubscription<Position>? _positionStream;
  static final UserNotification userNotification = UserNotification();

  // Configurações de localização padrão
  static AndroidSettings defaultLocationSettings = AndroidSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 15,
    forceLocationManager: true,
    intervalDuration: const Duration(seconds: 10),
    foregroundNotificationConfig: const ForegroundNotificationConfig(
      notificationText: "Localização em tempo real ativa.",
      notificationTitle: "Rastreamento em segundo plano",
      enableWakeLock: true,
    ),
  );

  // Solicita a permissão de acesso à localização do dispositivo
  static Future<bool> _hasLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print("Permissão negada.");
      return false;
    }

    print("Permissão concedida.");
    return true;
  }

  // Captura a posição atual do usuário
  static Future<Position?> getCurrentPosition() async {
    try {
      bool hasPermission = await _hasLocationPermission();
      if (!hasPermission) return null;
      return await Geolocator.getCurrentPosition(
        locationSettings: defaultLocationSettings,
      );
    } catch (e) {
      print("Erro ao capturar a localização: $e");
      return null;
    }
  }

  // Inicia o monitoramento contínuo da localização
  static void startLocationTracking({LocationSettings? customSettings}) {
    stopLocationTracking(); // Garantir que não existam streams duplicados

    final settings = customSettings ?? defaultLocationSettings;

    _positionStream = Geolocator.getPositionStream(
      locationSettings: settings,
    ).listen(
      (Position? position) {
        if (position != null) {
          print(
              "Localização atual: Latitude ${position.latitude}, Longitude ${position.longitude}");
          print("Velocidade estimada: ${position.speed} m/s");
          print("Precisão: ${position.accuracy} metros");
        }
      },
      onError: (e) {
        print("Erro no rastreamento de localização: $e");
      },
    );
  }

  // Para o monitoramento da localização
  static void stopLocationTracking() {
    print("Parando monitoramento de localização...");
    _positionStream?.cancel();
    _positionStream = null;
  }

  // Detecta quando o app vai para o segundo plano e envia uma notificação
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('AppLifecycleState mudou para: $state');
    if (state == AppLifecycleState.paused) {
      print('App está em segundo plano, enviando notificação...');
      userNotification.createBasicNotification();
    }
  }
}
