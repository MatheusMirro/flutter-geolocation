import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class ApiEndpoints {
  static String _ipv4 = "179.127.251.181"; // Valor padrão
  static const String apiKey = "127ecd671a4c4b65af798eb3ed8c0ce9";

  static String get baseURL =>
      "https://api.ipgeolocation.io/ipgeo?apiKey=$apiKey&ip=$_ipv4";
}
