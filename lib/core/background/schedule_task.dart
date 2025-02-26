import 'package:workmanager/workmanager.dart';
import 'package:geolocalizacao/data/services/location_service.dart';
import 'dart:io';

// Nome da tarefa para captura de geolocalização
const String captureLocationTask = "captureLocationTask";
const String captureLocationTaskName = "captureLocationTaskName";

// Callback para lidar com a execução da tarefa
@pragma('vm:entry-point')
void callbackDispatcher() {
  print("Callback Dispatcher foi chamado!");
  Workmanager().executeTask((taskName, inputData) async {
    print("Tarefa executada: $taskName");

    if (taskName == captureLocationTaskName) {
      // Aqui chama o serviço para capturar a geolocalização
      final locationService = LocationService();
      try {
        final location = await locationService.getCurrentLocation();
        print("Localização capturada no background: $location");
      } catch (e) {
        print("Erro ao capturar localização no background: $e");
      }
      return Future.value(true);
    }

    print("Tarefa não encontrada: $taskName");
    return Future.value(false);
  });
}

class ScheduleTask {
  // Inicializa o WorkManager
  static Future<void> initialize() async {
    print("Inicializando Workmanager...");
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
    print("Workmanager inicializado.");
  }

  // Registra uma tarefa periódica para execução recorrente
  static Future<void> registerPeriodicTask() async {
    try {
      print("Registrando tarefa de geolocalização...");
      await Workmanager().cancelAll();

      if (Platform.isAndroid) {
        print("Registrando tarefa periódica para Android...");
        await Workmanager().registerPeriodicTask(
          captureLocationTask,
          captureLocationTaskName,
          frequency: const Duration(minutes: 15),
          constraints: Constraints(
            networkType: NetworkType.connected,
            requiresBatteryNotLow: true,
          ),
        );
        print("Tarefa periódica registrada no Android!");
      } else if (Platform.isIOS) {
        print("Registrando tarefa única para iOS...");
        Workmanager().registerOneOffTask(
            "com.example.geolocalizacao.bgTask",
            "task-geolocation", // Ignored on iOS
            initialDelay: Duration(minutes: 15),
            constraints: Constraints(
              networkType: NetworkType.connected,
              requiresBatteryNotLow: true,
            ),
            inputData: <String, dynamic>{
              'taskType': 'geolocalizacao', // Tipo de tarefa a ser executada
              'shouldNotify': true,  // Indicador para enviar notificação após execução
            }
        );
        print("Tarefa única registrada no iOS!");
      }
    } catch (e) {
      print("Erro ao registrar tarefa: $e");
    }
  }



}
