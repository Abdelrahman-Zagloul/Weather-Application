import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app1/screens/home_screen.dart';

class WeatherHomePage extends StatefulWidget {
  final String cityName;
  final double temperature;
  final double minTemp;
  final double maxTemp;
  final String description;

  const WeatherHomePage({
    super.key,
    required this.cityName,
    required this.temperature,
    required this.minTemp,
    required this.maxTemp,
    required this.description,
  });

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final List<Map<String, dynamic>> forecast = [
    {"day": "Mon", "temp": "19°C", "icon": "🌦️"},
    {"day": "Tue", "temp": "18°C", "icon": "🌧️"},
    {"day": "Wed", "temp": "18°C", "icon": "🌧️"},
    {"day": "Thu", "temp": "19°C", "icon": "🌦️"},
    {"day": "Fri", "temp": "20°C", "icon": "☀️"},
    {"day": "Sat", "temp": "21°C", "icon": "🌤️"},
    {"day": "Sun", "temp": "22°C", "icon": "⛅"},
  ];

  int _startIndex = 0;
  final int _visibleCards = 4;
  int? _selectedIndex;

  void _nextForecast() {
    setState(() {
      if (_startIndex + _visibleCards < forecast.length) {
        _startIndex++;
      }
    });
  }

  void _previousForecast() {
    setState(() {
      if (_startIndex > 0) {
        _startIndex--;
      }
    });
  }

  void _selectCard(int index) {
    setState(() {
      _selectedIndex = _startIndex + index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1D50),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF10002B), Color(0xFF3C096C), Color(0xFF9D4EDD)],
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Text(
                        widget.cityName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              offset: Offset(1, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.maxTemp.round()}°  Min: ${widget.minTemp.round()}°',
                        style: const TextStyle(color: Colors.white70, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '7-Days Forecasts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 10,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _previousForecast,
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25, // Dynamic height
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(_visibleCards, (index) {
                              int dataIndex = _startIndex + index;
                              if (dataIndex < forecast.length) {
                                final forecastItem = forecast[dataIndex];
                                return GestureDetector(
                                  onTap: () => _selectCard(index),
                                  child: WeatherCard(
                                    day: forecastItem['day'],
                                    temp: forecastItem['temp'],
                                    icon: forecastItem['icon'],
                                    isSelected: _selectedIndex == dataIndex,
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            }),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _nextForecast,
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7B2CBF), Color(0xFF9D4EDD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.air, size: 16, color: Colors.white70),
                          SizedBox(width: 8),
                          Text(
                            'AIR QUALITY',
                            style: TextStyle(color: Colors.white70, fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        '3-Low Health Risk',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: double.infinity,
                        height: 4,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'See more',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InfoCard(
                        title: 'SUNRISE',
                        subtitle: '5:28 AM\nSunset: 7:25PM',
                        icon: Icons.wb_sunny,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InfoCard(
                        title: 'UV INDEX',
                        subtitle: '4\nModerate',
                        icon: Icons.wb_incandescent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    child: const Icon(Icons.menu, color: Colors.white, size: 30),
                  ),
                ),
                const SizedBox(height: 20), // Add padding at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WeatherCard extends StatelessWidget {
  final String day;
  final String temp;
  final String icon;
  final bool isSelected;

  const WeatherCard({
    super.key,
    required this.day,
    required this.temp,
    required this.icon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5), // Reduced margin
      padding: const EdgeInsets.all(10), // Reduced padding
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF9D4EDD)
            : const Color(0xFF7B2CBF).withOpacity(0.8),
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: isSelected
            ? [
                const BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            temp,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14, // Reduced font size
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(icon, style: const TextStyle(fontSize: 24)), // Reduced icon size
          const SizedBox(height: 10),
          Text(
            day,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12, // Reduced font size
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20), // Reduced padding
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5A189A), Color(0xFF9D4EDD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white70, size: 14), // Reduced icon size
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 10), // Reduced font size
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white, fontSize: 12), // Reduced font size
          ),
        ],
      ),
    );
  }
}