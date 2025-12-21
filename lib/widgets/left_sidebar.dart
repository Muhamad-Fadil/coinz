import 'package:flutter/material.dart';

class LeftSidebar extends StatelessWidget {
  const LeftSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF7A8C6A), // ⬅️ GANTI BACKGROUND PUTIH
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),

          // ICON KALENDER (TANPA BACKGROUND)
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.black87,
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          ),

          const SizedBox(height: 20),

          _item('Day'),
          _item('Week'),
          _item('Month'),
          _item('Year'),
          _item('All'),
          _item('Interval'),
        ],
      ),
    );
  }

  Widget _item(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 14),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF9DB59A), // item lebih terang
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
    );
  }
}
