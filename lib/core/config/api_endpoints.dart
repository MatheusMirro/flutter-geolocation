import 'package:geolocator/geolocator.dart';

class GpsEndpoints {
  // Método para capturar o IP público
  Future<void> getCurrentGPSPosition() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();
      print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
    } else {
      print("Permissão negada para acessar o GPS.");
    }
  }
}
