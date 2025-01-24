// Modelo de dados para representar a localização
class LocationModel {
  final double latitude;
  final double longitude;
  final String? address;

  LocationModel({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  // Cria uma instância de [LocationModel] a partir de um mapa JSON

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
    );
  }

  // Converte a instancia de [LocationModel] para um mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  @override
  String toString() =>
      'LocationModel(latitude: \$latitude, longitude: \$longitude, address: \$address)';
}
