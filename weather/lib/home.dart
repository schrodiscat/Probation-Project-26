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
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesScreen()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter city name',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _getWeather,
                ),
              ),
              onSubmitted: (_) => _getWeather(),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            if (_weather != null) ...[
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(_weather!.cityName,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text('${_weather!.temperature.toStringAsFixed(1)} °C',
                          style: const TextStyle(fontSize: 32)),
                      const SizedBox(height: 10),
                      Text(_weather!.condition,
                          style: const TextStyle(
                              fontSize: 18, fontStyle: FontStyle.italic)),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _saveToFavorites,
                        icon: const Icon(Icons.favorite_border),
                        label: const Text('Add to Favorites'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}