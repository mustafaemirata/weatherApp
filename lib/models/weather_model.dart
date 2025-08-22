class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final double windSpeed; 
  final int humidity; 

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.windSpeed,
    required this.humidity,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json["name"],
      temperature: (json["main"]["temp"] as num).toDouble(),
      mainCondition: json["weather"][0]["main"],
      windSpeed: (json["wind"]["speed"] as num).toDouble(),
      humidity: (json["main"]["humidity"] as num).toInt(),
    );
  }
}
