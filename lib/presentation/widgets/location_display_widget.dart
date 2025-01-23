import 'package:flutter/material.dart';
import 'package:geolocalizacao/data/models/location_model.dart';
import 'package:geolocalizacao/presentation/styles/text_styles.dart';

class LocationDisplayWidget extends StatelessWidget {
  final LocationModel? location;

  const LocationDisplayWidget({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    if (location == null) {
      return const Text(
        "Nenhuma localização disponível.",
        style: AppTextStyles.caption,
        textAlign: TextAlign.center,
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Latitude: ${location?.latitude}",
          style: AppTextStyles.body,
        ),
        Text(
          "Longitude: ${location?.longitude}",
          style: AppTextStyles.body,
        ),
        Text(
          "Endereço: ${location?.address ?? 'Não disponível'}",
          style: AppTextStyles.body,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
