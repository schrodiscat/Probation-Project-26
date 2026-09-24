import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

class WeatherService {
  final String apiKey = '2246cef66244d965371c25290a174ca0';

  Future<Weather> fetchWeather(String cityName) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric');
    
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data. Please check the city name.');
    }
  }
}