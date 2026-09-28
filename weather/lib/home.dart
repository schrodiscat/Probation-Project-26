import 'package:flutter/material.dart';
import 'model.dart';
import 'weatherapi.dart';
import 'firestore_service.dart';
import 'favorites.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  final FirestoreService _firestoreService = FirestoreService();

  Weather? _weather;
  bool _isLoading = false;
  String? _errorMessage;

  void _getWeather() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _weather = null;
    });

    try {
      final weather = await _weatherService.fetchWeather(_controller.text);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _saveToFavorites() async {
    if (_weather == null) return;
    try {
      await _firestoreService.addFavorite(_weather!.cityName);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_weather!.cityName} added to favorites!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'NIMBUS',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, letterSpacing: 2.0),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesScreen()),
              );
            },
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF355C5B), 
              Color(0xFF6B8E7B), 
              Color(0xFFD4B483), 
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                
                TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter city name',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: _getWeather,
                    ),
                  ),
                  onSubmitted: (_) => _getWeather(),
                ),
                const SizedBox(height: 30),
                
                if (_isLoading)
                  const CircularProgressIndicator(color: Colors.white)
                else if (_errorMessage != null)
                  Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent, fontSize: 16))
                else if (_weather != null)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _weather!.cityName,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _weather!.condition.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Icon(
                          Icons.wb_sunny_rounded,
                          size: 100,
                          color: Color(0xFFF4D06F),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '${_weather!.temperature.toStringAsFixed(0)}°C',
                          style: const TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: _saveToFavorites,
                          icon: const Icon(Icons.favorite_border, color: Colors.redAccent),
                          label: const Text('Add to Favorites'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  )
                else
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Search for a city to see the weather',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}