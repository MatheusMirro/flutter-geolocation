import 'package:workmanager/workmanager.dart';
import 'package:geolocalizacao/data/services/location_service.dart';

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
    print("Registrando tarefa periódica...");

    Workmanager()
        .registerPeriodicTask(
      captureLocationTask, // ID único da tarefa
      captureLocationTaskName, // Nome da tarefa
      frequency: const Duration(minutes: 15), // Frequência de execução
      constraints: Constraints(
        networkType: NetworkType.connected, // Executa apenas com rede conectada
        requiresBatteryNotLow: true, // Não executa quando a bateria está baixa
        requiresCharging: false, // Não precisa estar carregando
      ),
    )
        .then((_) {
      print("Tarefa periódica registrada com sucesso!");
    }).catchError((e) {
      print("Erro ao registrar tarefa periódica: $e");
    });
  }
}
