import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/left_sidebar.dart';
import '../widgets/right_sidebar.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool isIncome = true;
  String rawAmount = "";

  double? firstNumber;
  String? operator;

  String get formattedAmount {
    if (rawAmount.isEmpty) return "0";
    final number = double.tryParse(rawAmount.replaceAll(',', ''));
    if (number == null) return rawAmount;
    return NumberFormat("#,###").format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD3B6),
      drawer: const LeftSidebar(),
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

            const SizedBox(height: 30),

            const Text(
              "Add Transaction",
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 40),

            // AMOUNT DISPLAY
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 50),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.attach_money),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      formattedAmount,
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
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // INCOME / EXPENSE SWITCH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: _transactionSwitch(),
            ),

            const SizedBox(height: 25),

            // KEYPAD
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
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
            ),
          ],
        ),
      ),
    );
  }

  // SLIDE SWITCH
  Widget _transactionSwitch() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: isIncome ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width / 2 - 50,
              height: 60,
              decoration: BoxDecoration(
                color: isIncome
                    ? const Color(0xFF8CFF9E)
                    : const Color(0xFFFF8C8C),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isIncome = true),
                  child: Center(
                    child: Text(
                      "Income",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isIncome ? Colors.black : Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isIncome = false),
                  child: Center(
                    child: Text(
                      "Expense",
                      style: TextStyle(
                        fontSize: 18,
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

  // KEYPAD BUTTON LOGIC
  Widget _keyButton(String text) {
    return GestureDetector(
      onTap: () => _onKeyTap(text),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
      // ===== CLEAR =====
      if (key == "C") {
        rawAmount = "";
        firstNumber = null;
        operator = null;
        return;
      }

      // ===== DESIMAL =====
      if (key == ".") {
        if (rawAmount.isEmpty) {
          rawAmount = "0.";
        } else if (!rawAmount.contains(".")) {
          rawAmount += ".";
        }
        return;
      }

      // ===== OPERATOR =====
      if ("+-×÷".contains(key)) {
        if (rawAmount.isEmpty && firstNumber == null) return;

        // kalau sebelumnya sudah ada hasil (=)
        if (firstNumber != null && rawAmount.isEmpty) {
          operator = key;
          return;
        }

        firstNumber = double.parse(rawAmount);
        operator = key;
        rawAmount = "";
        return;
      }

      // ===== HITUNG =====
      if (key == "=") {
        if (firstNumber == null || operator == null || rawAmount.isEmpty)
          return;

        final secondNumber = double.parse(rawAmount);
        double result = 0;

        switch (operator) {
          case "+":
            result = firstNumber! + secondNumber;
            break;
          case "-":
            result = firstNumber! - secondNumber;
            break;
          case "×":
            result = firstNumber! * secondNumber;
            break;
          case "÷":
            if (secondNumber == 0) return;
            result = firstNumber! / secondNumber;
            break;
        }

        rawAmount = result.toStringAsFixed(result % 1 == 0 ? 0 : 2);

        // simpan hasil biar bisa lanjut hitung
        firstNumber = double.parse(rawAmount);
        operator = null;
        return;
      }

      // ===== ANGKA =====
      rawAmount += key;
    });
  }
}
