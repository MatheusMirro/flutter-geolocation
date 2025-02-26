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

    // Registra o handler da tarefa de fundo
    BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.geolocalizacao.bgTask", using: nil) { task in
      self.handleBGTask(task: task)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Implementação do método handleBGTask
func handleBGTask(task: BGTask) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let currentTime = dateFormatter.string(from: Date())

    print("Tarefa em segundo plano foi chamada! Horário: \(currentTime)")

    // Finaliza a tarefa após a execução
    task.setTaskCompleted(success: true)
 }
}
