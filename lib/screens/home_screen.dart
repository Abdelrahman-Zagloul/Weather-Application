import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_app1/screens/weekly_forecast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _WeatherHomePage2State();
}

class _WeatherHomePage2State extends State<HomeScreen> {
  String city = "Cairo";
  double temperature = 0.0;
  double minTemp = 0.0;
  double maxTemp = 0.0;
  String description = "";
  double lat = 0.0;
  double lon = 0.0;
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchWeather(city); 
  }

  Future<void> fetchWeather(String cityName) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=86d9ee800e0e82e5c5221611e2d00981&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          temperature = data['main']['temp'];
          minTemp = data['main']['temp_min'];
          maxTemp = data['main']['temp_max'];
          description = data['weather'][0]['main'];
          city = data['name'];
          lat = data['coord']['lat'];
          lon = data['coord']['lon'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "Failed to fetch weather data. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error fetching weather: $e";
      });
    }
  }

  Future<void> _signOut() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.disconnect();
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(
        context,
        "login",
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error signing out: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        backgroundColor: const Color(0xFF1F0C4D),
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.exit_to_app_outlined),
            color: Colors.white,
            tooltip: "Sign Out",
          ),
        ],
      ),
      body: Container(
  decoration: const BoxDecoration(
    gradient: LinearGradient( 
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF1F0C4D), Color(0xFF693E99)],
    ),
  
  // باقي الكود زي ما هو
),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Image.asset('image/weather_header.png', height: 120),
                const SizedBox(height: 10),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                        ? Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              errorMessage!,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  city,
                                  style: const TextStyle(
                                    fontSize: 40,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${temperature.round()}°',
                                  style: const TextStyle(
                                    fontSize: 35,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  description,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Max: ${maxTemp.round()}°   Min: ${minTemp.round()}°',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Image.asset('image/house.png', height: 250),
                    const SizedBox(height: 10),
                    Container(
                      height: 225,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3E2D8F), Color(0xFF693E99)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WeatherHomePage(
                                        cityName: city,
                                        temperature: temperature,
                                        minTemp: minTemp,
                                        maxTemp: maxTemp,
                                        description: description,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Today",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Text(
                                "${_getMonthName(DateTime.now().month)} ${DateTime.now().day}, ${DateTime.now().year}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white24, thickness: 1),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(4, (index) {
                              final time = DateTime.now().add(
                                Duration(hours: index + 1),
                              );
                              final formattedTime =
                                  "${time.hour.toString().padLeft(2, '0')}:00";
                              return CustomWeatherTile(
                                image: 'image/weather_header.png',
                                temp: '${temperature.round()}°',
                                time: formattedTime,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => showModalBottomSheet(
                              context: context,
                              backgroundColor: const Color(0xFF3E2D8F),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(8),
                                ),
                              ),
                              builder: (_) => LocationSelector(
                                onCitySelected: (newCity) {
                                  Navigator.pop(context);
                                  fetchWeather(newCity);
                                },
                              ),
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: const Color(0xFF3E2D8F),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(8),
                                  ),
                                ),
                                isScrollControlled: true,
                                builder: (context) {
                                  final TextEditingController cityController =
                                      TextEditingController();
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                      left: 20,
                                      right: 20,
                                      top: 20,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Enter City Name',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: cityController,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'City Name',
                                            hintStyle: const TextStyle(
                                              color: Colors.white70,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white24,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                          ),
                                          onSubmitted: (value) {
                                            String newCity = value.trim();
                                            if (newCity.isNotEmpty) {
                                              Navigator.pop(context);
                                              fetchWeather(newCity);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Please enter a city name"),
                                                ),
                                              );
                                            }
                                          },
                                          autofocus: true,
                                          textInputAction: TextInputAction.search,
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.add_circle,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WeatherHomePage(
                                    cityName: city,
                                    temperature: temperature,
                                    minTemp: minTemp,
                                    maxTemp: maxTemp,
                                    description: description,
                                  ),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomWeatherTile extends StatelessWidget {
  final String image;
  final String temp;
  final String time;

  const CustomWeatherTile({
    super.key,
    required this.image,
    required this.temp,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(image, height: 28),
        const SizedBox(height: 5),
        Text(temp, style: const TextStyle(color: Colors.white, fontSize: 15)),
        const SizedBox(height: 5),
        Text(time, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

class LocationSelector extends StatelessWidget {
  final void Function(String) onCitySelected;

  const LocationSelector({super.key, required this.onCitySelected});

  @override
  Widget build(BuildContext context) {
    final List<String> countries = [
      'Cairo',
      'Riyadh',
      'Dubai',
      'Kuwait',
      'Doha',
      'Manama',
      'Muscat',
      'Amman',
      'Beirut',
      'Casablanca',
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Choose Your City',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 250,
            child: ListView.separated(
              itemCount: countries.length,
              separatorBuilder: (_, __) => const Divider(color: Colors.white24),
              itemBuilder: (context, index) => ListTile(
                title: Text(
                  countries[index],
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () => onCitySelected(countries[index]),
              ),
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
      width: MediaQuery.of(context).size.width * 0.48,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7B61FF), Color(0xFF8F71F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

String _getMonthName(int month) {
  const List<String> monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  return monthNames[month - 1];
}