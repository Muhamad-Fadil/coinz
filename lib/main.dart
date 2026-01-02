import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/transaksi_model.dart';
import 'models/gemini_model.dart';
import 'view_models/gemini_controller.dart';
import 'debug/debug_test.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // load env
  await dotenv.load(fileName: ".env");

  // Hive hanya untuk mobile/desktop

  await Hive.initFlutter();
  Hive.registerAdapter(TransactionModelAdapter());
  await Hive.openBox<TransactionModel>('transactions');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GeminiViewModel(GeminiService())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CoinZ',
      theme: ThemeData(useMaterial3: true, fontFamily: 'K2D'),
      home: DebugTest(), // halaman chat kamu
    );
  }
}
