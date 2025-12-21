import 'package:flutter/material.dart';
import '../widgets/left_sidebar.dart';
import '../widgets/right_sidebar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD3B6),

      // ===== SIDEBAR =====
      drawer: const LeftSidebar(),
      endDrawer: const RightSidebar(),

      body: Column(
        children: [
          // HEADER
          Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
                decoration: const BoxDecoration(
                  color: Color(0xFF7A8C6A),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(60),
                  ),
                ),
                child: Column(
                  children: const [
                    SizedBox(height: 20),
                    Text(
                      'Good Morning',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Your Money',
                      style: TextStyle(fontSize: 20, color: Colors.black54),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '\$ 10,000,000',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '\$ 2,000,000',
                      style: TextStyle(fontSize: 19, color: Colors.red),
                    ),
                  ],
                ),
              ),

              // ICON KIRI → SIDEBAR KIRI
              Positioned(
                top: 45,
                left: 20,
                child: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.black,
                    ),
                    iconSize: 30,
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              ),

              // ICON KANAN → SIDEBAR KANAN
              Positioned(
                top: 45,
                right: 20,
                child: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.black),
                    iconSize: 30,
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // PIE CHART
          Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: CustomPaint(painter: _PiePainter()),
          ),

          const SizedBox(height: 30),

          // BUTTON
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6E7F63),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              '+ Add Transaction',
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),

          const SizedBox(height: 30),

          // CATEGORY
          _categoryItem('Tagihan', '50%'),
          _categoryItem('Transportasi', '20%'),
          _categoryItem('Konsumsi', '20%'),
        ],
      ),
    );
  }

  Widget _categoryItem(String title, String percent) {
    IconData icon;

    switch (title) {
      case 'Tagihan':
        icon = Icons.receipt_long;
        break;
      case 'Transportasi':
        icon = Icons.directions_car;
        break;
      case 'Konsumsi':
        icon = Icons.fastfood;
        break;
      default:
        icon = Icons.category;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 65, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: const Color(0xFF7A8C6A),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          Text(percent, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _PiePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = Colors.green.shade800;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.57,
      2,
      true,
      paint,
    );

    paint.color = Colors.cyanAccent;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0.5,
      1,
      true,
      paint,
    );

    paint.color = Colors.red;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      1.8,
      2.5,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
