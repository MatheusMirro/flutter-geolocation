import 'package:flutter/material.dart';
import 'package:geolocalizacao/data/services/location_service.dart';
import 'package:geolocalizacao/data/models/location_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocationService _locationService = LocationService();
  LocationModel? _currentLocation;
  String _statusMessageIP = "Clique para obter a localização via GPS";

  Future<void> _getLocationIP() async {



    setState(() => _statusMessageIP = "Obtendo localização...");
    try {
      final location = await _locationService.getCurrentLocation();
      setState(() {
        if (location != null) {
          _currentLocation = location as LocationModel?;
          _statusMessageIP = "Localização obtida com sucesso!@!";
        } else {
          _statusMessageIP = "Não foi possível obter a localização.";
        }
      });
    } catch (e) {
      setState(() => _statusMessageIP = "Erro ao obter a localização: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Geolocalização!"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _statusMessageIP,
              style: const TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            if (_currentLocation != null)
              Text(
                "Latitude: ${_currentLocation?.latitude} Longitude: ${_currentLocation?.longitude}",
                style: const TextStyle(fontSize: 14.0),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _getLocationIP,
              child: const Text("Obter Localização"),
            ),
          ],
        ),
      ),
    );
  }
}
