import 'package:geolocalizacao/data/models/location_model.dart';
import 'package:geolocalizacao/data/repositories/location_repository.dart';
import 'package:geolocator/geolocator.dart';

// Serviço para interação e gerenciamento de localização
class LocationService {
  final LocationRepository _locationRepository = LocationRepository();

  // Obtém a localização atual do dispositivo e os dados da API
  Future<LocationModel?> getCurrentLocation() async {
    Position? position = await _locationRepository.determinePosition();
    print('Position GPS: $position');
    return LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}
