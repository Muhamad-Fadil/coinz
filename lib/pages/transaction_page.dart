import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/right_sidebar.dart';
import '../widgets/chart_pie.dart';
import 'home_page.dart';
import '../data/category_data.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool isIncome = true;
  String rawAmount = "";
  late String selectedCategory;
  final TextEditingController noteController = TextEditingController();

  double? firstNumber;
  String? operator;

  List<String> get categories =>
      (isIncome ? KategoryData.incategories : KategoryData.excategories)
          .map((c) => c.name)
          .toList();

  @override
  void initState() {
    super.initState();
    selectedCategory = categories.isNotEmpty ? categories.first : '';
  }

  String get formattedAmount {
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    if (rawAmount.isEmpty) return currency.format(0);
    final number = double.tryParse(rawAmount.replaceAll(',', ''));
    if (number == null) return rawAmount;
    return currency.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD3B6),
      endDrawer: const RightSidebar(),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
                  decoration: const BoxDecoration(color: Color(0xFF7A8C6A)),
                ),

                // ICON KIRI → SIDEBAR KIRI
                Positioned(
                  top: 20,
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
                  top: 20,
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

            const SizedBox(height: 20),
            const Text(
              "Add Transaction",
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 30),

            // ===== AMOUNT + CATEGORY =====
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: categories.contains(selectedCategory)
                          ? selectedCategory
                          : null,
                      hint: const Text('Select'),
                      items: categories
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() => selectedCategory = value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      formattedAmount,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        rawAmount = "";
                        noteController.clear();
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // INCOME / EXPENSE SWITCH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: _transactionSwitch(),
            ),

            const SizedBox(height: 25),

            // ===== KEYPAD + ENTER =====
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        children: [
                          ...["1", "2", "3", "+"],
                          ...["4", "5", "6", "-"],
                          ...["7", "8", "9", "×"],
                          ...[".", "0", "=", "÷"],
                        ].map((e) => _keyButton(e)).toList(),
                      ),
                    ),

                    // ===== ENTER BUTTON =====
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7A8C6A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () async {
                          if (rawAmount.isEmpty) return;

                          // log values
                          debugPrint("Amount: $rawAmount");
                          debugPrint("Category: $selectedCategory");
                          debugPrint("Note: ${noteController.text}");
                          debugPrint(
                            "Type: ${isIncome ? "Income" : "Expense"}",
                          );

                          // prepare data for repository
                          final amount =
                              double.tryParse(rawAmount.replaceAll(',', '')) ??
                              0.0;
                          final type = isIncome ? 'income' : 'expense';
                          final allCats = [
                            ...KategoryData.excategories,
                            ...KategoryData.incategories,
                          ];
                          final cat = allCats.firstWhere(
                            (c) => c.name == selectedCategory,
                            orElse: () => allCats.first,
                          );
                          final categoryId = int.tryParse(cat.id) ?? 0;

                          await controller.addTransaction(
                            amount: amount,
                            type: type,
                            categoryId: categoryId,
                            date: DateTime.now(),
                            note: noteController.text.isEmpty
                                ? null
                                : noteController.text,
                          );

                          // navigate back to HomePage and rebuild it
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          );
                        },
                        child: const Text(
                          "ENTER",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== SWITCH =====
  Widget _transactionSwitch() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          // SLIDING INDICATOR
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            alignment: isIncome ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width / 2 - 50,
              height: 55,
              decoration: BoxDecoration(
                color: isIncome
                    ? const Color(0xFF8CFF9E)
                    : const Color(0xFFFF8C8C),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),

          // TEXT BUTTONS
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() {
                    isIncome = true;
                    selectedCategory = categories.isNotEmpty
                        ? categories.first
                        : '';
                  }),
                  child: Center(
                    child: Text(
                      "Income",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isIncome ? Colors.black : Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() {
                    isIncome = false;
                    selectedCategory = categories.isNotEmpty
                        ? categories.first
                        : '';
                  }),
                  child: Center(
                    child: Text(
                      "Expense",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: !isIncome ? Colors.black : Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===== KEYPAD BUTTON =====
  Widget _keyButton(String text) {
    return GestureDetector(
      onTap: () => _onKeyTap(text),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _onKeyTap(String key) {
    setState(() {
      if ("+-×÷".contains(key)) {
        if (rawAmount.isEmpty) return;
        firstNumber = double.parse(rawAmount);
        operator = key;
        rawAmount = "";
        return;
      }

      if (key == "=") {
        if (firstNumber == null || operator == null || rawAmount.isEmpty)
          return;

        final second = double.parse(rawAmount);
        double result = 0;

        switch (operator) {
          case "+":
            result = firstNumber! + second;
            break;
          case "-":
            result = firstNumber! - second;
            break;
          case "×":
            result = firstNumber! * second;
            break;
          case "÷":
            if (second == 0) return;
            result = firstNumber! / second;
            break;
        }

        rawAmount = result.toStringAsFixed(result % 1 == 0 ? 0 : 2);
        operator = null;
        firstNumber = null;
        return;
      }

      if (key == "." && rawAmount.contains(".")) return;

      rawAmount += key;
    });
  }
}
