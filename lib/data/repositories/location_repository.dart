import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocalizacao/core/config/api_endpoints.dart';
import 'package:geolocalizacao/data/models/location_model.dart';

// Repositorio para gerenciar chamadas relacionadas a localizacao
class LocationRepository {
  // Busca a localizacao atual usando a API configurada
  Future<LocationModel?> fetchCurrentLocation() async {
    try {
      final response = await http.get(Uri.parse(ApiEndpoints.baseURL));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return LocationModel.fromJson(data);
      } else {
        print('Erro ao buscar localizacao:  ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erro na requisicao de localizacao $e');
      return null;
    }
  }
}
