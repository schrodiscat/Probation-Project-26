import 'package:flutter/material.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.wb_sunny_rounded,
                    size: 60,
                    color: Color(0xFFF4D06F), 
                  ),
                  Icon(
                    Icons.cloud_outlined,
                    size: 100,
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(height: 15),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.water_drop, size: 18, color: Color(0xFFF4D06F)),
                  SizedBox(width: 8),
                  Icon(Icons.water_drop, size: 18, color: Color(0xFFF4D06F)),
                  SizedBox(width: 8),
                  Icon(Icons.water_drop, size: 18, color: Color(0xFFF4D06F)),
                ],
              ),
              SizedBox(height: 40),
              
              Text(
                'NIMBUS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 6.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}