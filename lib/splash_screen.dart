import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_coinz/pages/home_page.dart';
// import 'navigation_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    // Start initialization and navigate only when it's finished
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    try {
      // TODO: replace these fake loads with real initialization (API, DB, auth, etc.)
      await Future.wait([
        _fakeLoad(const Duration(milliseconds: 1500)),
        _fakeLoad(const Duration(milliseconds: 500)),
      ]);

      // Stop the spinner and navigate
      _controller.stop();
      if (!mounted) return;

      // Small pause so user sees the final state
      await Future.delayed(const Duration(milliseconds: 300));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e) {
      // On error, stop the spinner and still proceed to home
      _controller.stop();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  // Helper fake load -- replace with real async work
  Future<void> _fakeLoad(Duration d) => Future.delayed(d);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF66785F),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // LOGO TENGAH
            Image.asset('assets/fix.png', width: 200),

            const SizedBox(height: 100),

            // LOADING BULAT MUTER
            RotationTransition(
              turns: _controller,
              child: const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
