import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'services/storage_service.dart';

class NourElQalbApp extends StatelessWidget {
  const NourElQalbApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نور قلبك',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.cairoTextTheme(
          ThemeData.dark().textTheme,
        ).copyWith(
          bodyLarge: const TextStyle(color: Colors.white),
          bodyMedium: const TextStyle(color: Colors.white),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    final hasCompletedOnboarding = await StorageService.hasCompletedOnboarding();
    
    if (!mounted) return;
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => hasCompletedOnboarding
            ? const HomeScreen()
            : const OnboardingScreen(),
      ),
    );
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
              Color(0xFF0a0a1a),
              Color(0xFF1a0a2a),
              Color(0xFF0a0a1a),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // شعار التطبيق
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00d4ff).withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.nightlight_round,
                  size: 80,
                  color: Color(0xFF00d4ff),
                ),
              ),
              const SizedBox(height: 30),
              // اسم التطبيق
              Text(
                'نور قلبك',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFffd966),
                  shadows: [
                    Shadow(
                      color: const Color(0xFFffd966).withOpacity(0.8),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'أذكارك اليومية',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 50),
              // مؤشر التحميل
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFF00d4ff),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
