import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD3B6),
      body: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            color: const Color(0xFF7A8C6A),
            alignment: Alignment.center,
            child: const Text(
              "HOME",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),

          const Expanded(
            child: Center(
              child: Text(
                "Swipe UP ⬆️\nke halaman Category",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
