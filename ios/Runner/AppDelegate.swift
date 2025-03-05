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

  // Implementação do método handleBGTask
  func handleBGTask(task: BGTask) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let currentTime = dateFormatter.string(from: Date())

    print("Tarefa em segundo plano foi chamada! Horário: \(currentTime)")

    // Reagendar a tarefa para rodar novamente em 15 minutos
    scheduleBackgroundTask()

    // Finaliza a tarefa após a execução
    task.setTaskCompleted(success: true)
  }

  // Função para agendar a próxima execução da tarefa em segundo plano
  func scheduleBackgroundTask() {
    let request = BGAppRefreshTaskRequest(identifier: "com.example.geolocalizacao.bgTask")

    // Agendar para rodar daqui a 15 minutos (o iOS pode ajustar esse tempo)
    request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15 minutos

    do {
      try BGTaskScheduler.shared.submit(request)
      print("Tarefa de fundo reagendada para daqui 15 minutos.")
    } catch {
      print("Erro ao reagendar a tarefa de fundo: \(error)")
    }
  }
}
