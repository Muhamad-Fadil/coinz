import 'package:flutter/material.dart';
import 'package:flutter_application_coinz/pages/home_page.dart';

class RightSidebar extends StatelessWidget {
  const RightSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // ===== HEADER =====
          Container(
            height: 120,
            width: double.infinity,
            color: const Color(0xFF7A8C6A),
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ===== ICON HOME (KIRI) =====
                IconButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.home, size: 30, color: Colors.black87),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),

                // ===== ICON CLOSE (KANAN) =====
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_forward,
                    size: 30,
                    color: Colors.black87,
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          _menu(Icons.library_books_sharp, 'Categories'),
          _menu(Icons.settings, 'Setting'),
          _menu(Icons.chat_bubble_outline, 'Chatbot'),
        ],
      ),
    );
  }

  Widget _menu(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Icon(icon, size: 65),
          const SizedBox(height: 6),
          Text(text, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
