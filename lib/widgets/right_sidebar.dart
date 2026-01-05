import 'package:flutter/material.dart';
// import 'package:flutter_application_coinz/debug/debug_test.dart';
import 'package:flutter_application_coinz/pages/category_page.dart';
import 'package:flutter_application_coinz/pages/chat_bot_page.dart';
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

          _menu(context, Icons.library_books_sharp, 'Categories', CategoryPage()),
          // _menu(context, Icons.settings, 'Setting', DebugTest()),
          _menu(context, Icons.chat_bubble_outline, 'Chatbot', ChatBotPage()),
        ],
      ),
    );
  }

  Widget _menu(BuildContext context, IconData icon, String text, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
        child: Column(
          children: [
            Icon(icon, size: 65),
            const SizedBox(height: 6),
            Text(text, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
