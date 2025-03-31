import 'package:geolocalizacao/data/models/location_model.dart';
import 'package:geolocalizacao/data/repositories/location_repository.dart';
import 'package:geolocator/geolocator.dart';

// Serviço para interação e gerenciamento de localização
class LocationService {
  final LocationRepository _locationRepository = LocationRepository();

  // Obtém a localização atual com tratamento de erro
  Future<Position> getCurrentLocation() async {
    try {
      Position position = await _locationRepository.determinePosition();
      print('✅ Posição capturada: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      print('❌ Erro ao obter localização: $e');
      throw Exception("Falha ao obter localização: ${e.toString()}");
    }
  }
}
