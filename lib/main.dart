import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/transaksi_model.dart';
import 'debug/debug_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TransactionModelAdapter());
  await Hive.openBox<TransactionModel>('transactions');

  await runDebugTest();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CoinZ',
      theme: ThemeData(useMaterial3: true, fontFamily: 'K2D'),
      home: const SplashScreen(),
    );
  }
}
