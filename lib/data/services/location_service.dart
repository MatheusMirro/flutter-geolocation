import 'package:geolocalizacao/data/models/location_model.dart';
import 'package:geolocalizacao/data/repositories/location_repository.dart';
import 'package:geolocalizacao/core/utils/location_helper.dart';
import 'package:geolocator/geolocator.dart';

// Serviço para interação e gerenciamento de localização
class LocationService {
  final LocationRepository _locationRepository = LocationRepository();

  // Obtém a localização atual do dispositivo e os dados da API
  Future<LocationModel?> getCurrentLocation() async {
    Position? position = await LocationHelper.getCurrentPosition();

    if (position != null) {
      return await _locationRepository.fetchCurrentLocation();
    } else {
      print('Erro ao obter a posição atual.');
      return null;
    }
  }

  // Verifica se os serviços de localização estão habilitados
  Future<bool> isLocationServiceEnable() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Solicita a habilitação de serviços de localização se estiverem desabilitados
  Future<void> promptEnableLocationServices() async {
    if (!await isLocationServiceEnable()) {
      print(
          'Serviço de localização desabilitado. Solicite ao usuário que o habilite.');
    }
  }
}
