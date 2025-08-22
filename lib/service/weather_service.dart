import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String BASE_URL =
      "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;
  WeatherService(this.apiKey);

  Future<Weather> getWeatherByPosition(Position position) async {
    print("Koordinatlar: ${position.latitude}, ${position.longitude}");
    
    final response = await http.get(
      Uri.parse(
          "$BASE_URL?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric&lang=tr"),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print("API Yanıtı: ${jsonData['name']}");
      return Weather.fromJson(jsonData);
    } else {
      throw Exception("Hava durumu verisi alınamadı: ${response.statusCode}");
    }
  }

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Konum servisleri kapalı.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Konum izni reddedildi.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Konum izinleri kalıcı olarak reddedildi.");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<Weather> getWeatherByCity(String cityName) async {
    final response = await http.get(
      Uri.parse(
          "$BASE_URL?q=$cityName&appid=$apiKey&units=metric&lang=tr"),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print("Şehir API Yanıtı: ${jsonData['name']}");
      return Weather.fromJson(jsonData);
    } else {
      throw Exception("Hava durumu verisi alınamadı: ${response.statusCode}");
    }
  }

  Future<String> getCurrentCity() async {
    Position position = await getCurrentPosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemarks.isNotEmpty ? placemarks[0].locality : null;
    return city ?? "";
  }
}
