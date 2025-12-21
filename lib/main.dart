import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CoinZ',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'K2D', 
      ),
      home: const SplashScreen(),
    );
  }
}
