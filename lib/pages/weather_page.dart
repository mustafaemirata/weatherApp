import 'package:flutter/material.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/service/weather_service.dart';
import 'package:geolocator/geolocator.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService("0204b318f6c20c75db16572fbde570f6");
  Weather? _weather;

  _fetchWeather() async {
    try {
      Position position = await _weatherService.getCurrentPosition();
      final weather = await _weatherService.getWeatherByPosition(position);

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print("Hata: $e");
      _fetchIstanbulWeather();
    }
  }

  _fetchIstanbulWeather() async {
    try {
      final weather = await _weatherService.getWeatherByCity("Istanbul");
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print("Istanbul hava durumu hatası: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Widget getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return Image.asset("assets/gunes.gif", width: 150, height: 150);
    }
    switch (mainCondition.toLowerCase()) {
      case "clouds":
        return Image.asset("assets/bulut.gif", width: 150, height: 150);
      case "rain":
        return Image.asset("assets/yagmur.gif", width: 150, height: 150);
      case "snow":
        return Image.asset("assets/kar.gif", width: 150, height: 150);
      case "clear":
        return Image.asset("assets/gunes.gif", width: 150, height: 150);
      default:
        return Image.asset("assets/gunes.gif", width: 150, height: 150);
    }
  }

  void _showAppInfo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("App Info"),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("App Name: Weather"),
              Text("Version: 1.0.0"),
              Text("Developer: Mustafa Emir Ata"),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Weather App"),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchWeather),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showAppInfo,
          ),
        ],
      ),
      body: Center(
        child: _weather == null
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _weather!.cityName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    getWeatherAnimation(_weather!.mainCondition),
                    const SizedBox(height: 20),

                    Text(
                      '${_weather!.temperature.round()}°C',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 10,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text("Nem"),
                                const SizedBox(height: 5),
                                Text("${_weather!.humidity}%"),
                              ],
                            ),
                            Column(
                              children: [
                                const Text("Rüzgar"),
                                const SizedBox(height: 5),
                                Text("${_weather!.windSpeed} m/s"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          const Text(
                            "3 Günlük Tahmin",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              Text("Paz 25°C"),
                              Text("Pzt 27°C"),
                              Text("Sal 26°C"),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
      ),
    );
  }
}
