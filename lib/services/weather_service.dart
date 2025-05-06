import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '86d9ee800e0e82e5c5221611e2d00981';

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Weather API error');
    }
  }
}
