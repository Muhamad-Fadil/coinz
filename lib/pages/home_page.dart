import 'package:flutter/material.dart';
import 'package:flutter_application_coinz/data/category_data.dart';
import 'package:intl/intl.dart';
import '../widgets/left_sidebar.dart';
import '../widgets/right_sidebar.dart';
import 'category_page.dart';
import 'transaction_page.dart';
import '../widgets/chart_pie.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final sumary = controller.expenseSummary();
        final total = controller.balance();
        final expenses = controller.totalExpense();

        return Scaffold(
          backgroundColor: const Color(0xFFBFD3B6),

          // ===== SIDEBAR =====
          drawer: const LeftSidebar(),
          endDrawer: const RightSidebar(),

          body: GestureDetector(
            onVerticalDragEnd: (details) {
              // SWIPE DARI BAWAH KE ATAS
              if (details.primaryVelocity != null &&
                  details.primaryVelocity! < -300) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 400),
                    pageBuilder: (_, animation, __) => const CategoryPage(),
                    transitionsBuilder: (_, animation, __, child) {
                      return SlideTransition(
                        position:
                            Tween<Offset>(
                              begin: const Offset(0, 1), // dari bawah
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOut,
                              ),
                            ),
                        child: child,
                      );
                    },
                  ),
                );
              }
            },

            child: Column(
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
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'Good Morning',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Your Money',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            currency.format(total),
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            ' ${currency.format(expenses)}',
                            style: const TextStyle(
                              fontSize: 19,
                              color: Colors.black,
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ICON KIRI
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

                    // ICON KANAN
                    Positioned(
                      top: 45,
                      right: 20,
                      child: Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.black,
                          ),
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
                SizedBox(
                  width: 200,
                  height: 200,
                  // decoration: const BoxDecoration(
                  //   shape: BoxShape.circle,
                  //   color: Colors.white,
                  // ),
                  child: sumary.isEmpty
                      ? const Center(
                          child: Text(
                            'No Data',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      : ExpensePieChart(data: sumary),
                  // child: CustomPaint(painter: _PiePainter()),
                ),

                const SizedBox(height: 30),

                // BUTTON
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 350),
                        pageBuilder: (_, animation, __) =>
                            const TransactionPage(),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(0, 1), // dari bawah
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOut,
                                  ),
                                ),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6E7F63),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
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

                // TOP 3 EXPENSE CATEGORIES
                Builder(
                  builder: (context) {
                    final top = sumary.where((s) => s.amount > 0).toList()
                      ..sort((a, b) => b.amount.compareTo(a.amount));

                    final top3 = top.take(3).toList();

                    if (top3.isEmpty) return const SizedBox();

                    return Column(
                      children: top3.map((s) {
                        final cat = KategoryData.getById(s.categoryId);
                        return _categoryItemAmount(
                          cat.name,
                          s.amount,
                          cat.color,
                          cat.icon,
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _categoryItemAmount(
    String title,
    double amount,
    Color bgColor,
    dynamic icon,
  ) {
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    IconData iconData;
    if (icon is IconData) {
      iconData = icon;
    } else if (icon is String) {
      iconData = _iconFromString(icon);
    } else {
      iconData = Icons.category;
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
            backgroundColor: bgColor,
            child: Icon(iconData, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            currency.format(amount),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  IconData _iconFromString(String s) {
    final key = s.replaceAll('Icons.', '');
    switch (key) {
      case 'receipt_long':
        return Icons.receipt_long;
      case 'directions_car':
        return Icons.directions_car;
      case 'restaurant':
        return Icons.restaurant;
      case 'movie':
        return Icons.movie;
      case 'savings':
        return Icons.savings;
      case 'trending_up':
        return Icons.trending_up;
      case 'work':
        return Icons.work;
      case 'card_giftcard':
        return Icons.card_giftcard;
      default:
        return Icons.category;
    }
  }
}
