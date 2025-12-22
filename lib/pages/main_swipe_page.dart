import 'package:flutter/material.dart';
import 'home_page.dart';
import 'category_page.dart';

class MainSwipePage extends StatefulWidget {
  const MainSwipePage({super.key});

  @override
  State<MainSwipePage> createState() => _MainSwipePageState();
}

class _MainSwipePageState extends State<MainSwipePage> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        scrollDirection: Axis.vertical, // 🔥 SWIPE ATAS-BAWAH
        physics: const BouncingScrollPhysics(),
        children: const [HomePage(), CategoryPage()],
      ),
    );
  }
}
