import 'package:flutter/material.dart';
import 'package:geolocalizacao/routes/app_routes.dart';
import 'package:geolocalizacao/core/notifications/user_notification.dart';
import 'core/background/schedule_task.dart';
import 'core/utils/location_helper.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa notificações do usuário
  UserNotification userNotification = UserNotification();
  await userNotification.initialize();

  // Garante que as permissões de localização foram concedidas
  await ensurePermissionsGranted();

  // Inicializa o WorkManager para tarefas em background
  await ScheduleTask.initialize();

  // Agenda a tarefa para executar a cada 15 minutos
  await ScheduleTask.registerPeriodicTask();

  // (Opcional) Registra uma tarefa imediata para teste
  // ScheduleTask.registerImmediateTask();

  // Inicia o aplicativo
  runApp(const MyApp());
}

// Verifica e solicita as permissões necessárias
Future<void> ensurePermissionsGranted() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception(
          "As permissões de localização são necessárias para o funcionamento do app.");
    }
  }

  if (permission != LocationPermission.always) {
    permission = await Geolocator.requestPermission();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final LocationHelper _locationHelper = LocationHelper();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _locationHelper.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Geolocalização',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
