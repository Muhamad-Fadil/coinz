import 'package:flutter/material.dart';
import 'package:flutter_application_coinz/pages/transaction_page.dart';
import 'package:flutter_application_coinz/widgets/chart_pie.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_coinz/widgets/left_sidebar.dart';
import 'package:flutter_application_coinz/widgets/right_sidebar.dart';
import 'package:flutter_application_coinz/data/category_data.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String selectedType = 'All';

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final total = controller.balance();
    final allCats = KategoryData.allCategories();
    final types = allCats.map((e) => e.type).toSet().toList();
    final dropdownTypes = ['All', ...types];
    final displayCats = selectedType == 'All'
        ? allCats
        : allCats.where((c) => c.type == selectedType).toList();

    return Scaffold(
      drawer: const LeftSidebar(),
      endDrawer: const RightSidebar(),
      backgroundColor: const Color(0xFFBFD3B6),

      body: GestureDetector(
        onVerticalDragEnd: (details) {
          // SWIPE KE BAWAH → BALIK KE HOME
          if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
            Navigator.pop(context);
          }
        },
        child: Column(
          children: [
            // ===== HEADER =====
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
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Balance',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currency.format(total),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // SIDEBAR KIRI
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

                // SIDEBAR KANAN
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

            // ===== DROPDOWN =====
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
                      value: selectedType,
                      isExpanded: true,
                      items: dropdownTypes
                          .map(
                            (t) => DropdownMenuItem(
                              value: t,
                              child: Text(
                                t == 'All'
                                    ? 'All'
                                    : '${t[0].toUpperCase()}${t.substring(1)}',
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => selectedType = value);
                      },
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
                children: displayCats
                    .map(
                      (c) => _categoryItem(
                        c.name,
                        currency.format(controller.totalForCategory(c.id)),
                      ),
                    )
                    .toList(),
              ),
            ),

            // ===== ADD BUTTON =====
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFF7A8C6A),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 28, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TransactionPage(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
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
      case 'konsumsi':
        return Icons.restaurant;
      case 'dana darurat':
        return Icons.savings;
      case 'job':
        return Icons.work;
      case 'pemberian':
        return Icons.card_giftcard;
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
