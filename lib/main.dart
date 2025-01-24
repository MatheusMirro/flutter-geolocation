import 'package:flutter/material.dart';
import 'package:geolocalizacao/routes/app_routes.dart';
import 'package:geolocalizacao/core/notifications/user_notification.dart';
import 'core/utils/location_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa notificações do usuário
  UserNotification userNotification = UserNotification();
  await userNotification.initialize();

  runApp(const MyApp());
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
