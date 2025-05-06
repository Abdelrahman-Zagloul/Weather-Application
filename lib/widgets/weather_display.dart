import 'package:flutter/material.dart';

class WeatherDisplay extends StatelessWidget {
  final Map<String, dynamic> data;

  const WeatherDisplay({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final weather = data['weather'][0];
    final main = data['main'];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          data['name'],
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text(
          '${main['temp'].round()}°C',
          style: const TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          weather['description'],
          style: const TextStyle(fontSize: 18, color: Colors.white70),
        ),
        Text(
          'Max: ${main['temp_max']}°  Min: ${main['temp_min']}°',
          style: const TextStyle(fontSize: 16, color: Colors.white60),
        ),
      ],
    );
  }
}
