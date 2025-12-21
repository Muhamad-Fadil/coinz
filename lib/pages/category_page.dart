import 'package:flutter/material.dart';
import 'package:flutter_application_coinz/widgets/left_sidebar.dart';
import 'package:flutter_application_coinz/widgets/right_sidebar.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const LeftSidebar(),
      endDrawer: const RightSidebar(),
      backgroundColor: const Color(0xFFBFD3B6),
      body: Column(
        children: [
          // ===== HEADER =====
          Stack(
            children: [
              // BACKGROUND HEADER
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
                    SizedBox(height: 10),
                    Text(
                      'Balance',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '\$ 10,000,000',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
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
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
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
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          // ===== DROPDOWN FILTER =====
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: 220,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF7A8C6A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: 'All',
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All')),
                      DropdownMenuItem(value: 'Income', child: Text('Income')),
                      DropdownMenuItem(
                        value: 'Expense',
                        child: Text('Expense'),
                      ),
                    ],
                    onChanged: (value) {},
                    dropdownColor: const Color(0xFF7A8C6A),
                    icon: const Icon(Icons.keyboard_arrow_down),
                  ),
                ),
              ),
            ),
          ),

          // ===== LIST CATEGORY =====
          Expanded(
            child: ListView(
              children: [
                _categoryItem('Deposit', '\$10,000,000'),
                _categoryItem('Tagihan', '20%'),
                _categoryItem('Transportasi', '20%'),
                _categoryItem('Entertain', '10%'),
                _categoryItem('Internet', '10%'),
                _categoryItem('Investasi', '10%'),
              ],
            ),
          ),

          // ===== ADD BUTTON =====
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFF7A8C6A),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 28, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== ITEM CATEGORY =====
  Widget _categoryItem(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 55, vertical: 9),
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
            child: Icon(_getCategoryIcon(title), size: 16, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String title) {
    switch (title.toLowerCase()) {
      case 'deposit':
        return Icons.account_balance_wallet;
      case 'tagihan':
        return Icons.receipt_long;
      case 'transportasi':
        return Icons.directions_car;
      case 'entertain':
        return Icons.movie;
      case 'internet':
        return Icons.wifi;
      case 'investasi':
        return Icons.trending_up;
      default:
        return Icons.category;
    }
  }
}
