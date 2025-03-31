import UIKit
import Flutter
import BackgroundTasks

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Registrar a tarefa no iOS
    BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.geolocalizacao.bgTask", using: nil) { task in
      self.handleBGTask(task: task)
    }

    // Agendar a primeira execução da tarefa
    scheduleBackgroundTask()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private let methodChannel = "background_location"

  // Implementação do método handleBGTask
func handleBGTask(task: BGTask) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let currentTime = dateFormatter.string(from: Date())

    print("📢 Tarefa em segundo plano executada! Horário: \(currentTime)")

    DispatchQueue.main.async {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let controller = window.rootViewController as? FlutterViewController {

            let channel = FlutterMethodChannel(name: self.methodChannel, binaryMessenger: controller.binaryMessenger)

            channel.invokeMethod("captureLocation", arguments: nil) { (result) in
                if let locationResult = result as? String {
                    print("📍 Localização recebida do Flutter: \(locationResult)")
                } else {
                    print("⚠️ Erro ao capturar localização: \(String(describing: result))")
                }
            }
        } else {
            print("⚠️ Não foi possível acessar o FlutterViewController. A tarefa pode não ser concluída corretamente.")
        }
    }

    // Reagendar a tarefa
    scheduleBackgroundTask()

    // Finalizar a tarefa informando que foi bem-sucedida
    task.setTaskCompleted(success: true)
}


func scheduleBackgroundTask() {
    let request = BGAppRefreshTaskRequest(identifier: "com.example.geolocalizacao.bgTask")

    // Agendar para rodar daqui a 15 minutos (o iOS pode ajustar esse tempo)
    request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15 minutos

    Task {
        do {
            let pendingTasks = await BGTaskScheduler.shared.pendingTaskRequests()
            if pendingTasks.first(where: { $0.identifier == "com.example.geolocalizacao.bgTask" }) == nil {
                try BGTaskScheduler.shared.submit(request)
                print("Tarefa de fundo reagendada para daqui 15 minutos.")
            } else {
                print("Tarefa já agendada, evitando múltiplos registros.")
            }
        } catch {
            print("Erro ao reagendar a tarefa de fundo: \(error)")
        }
    }
  }
}