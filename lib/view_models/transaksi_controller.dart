import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/sumary_model.dart';
import '../models/transaksi_model.dart';
import '../data/repositories/transaksi_repositories.dart';
import '../data/category_data.dart';

class TransaksiController extends ChangeNotifier {
  final TransaksiRepositories _transaksi = TransaksiRepositories();

  List<SummaryModel> expenseSummary() {
    final Map<String, double> result = {
      for (var category in KategoryData.excategories) category.id: 0.0,
    };

    final transactions = _transaksi.getAllTransactions();

    for (var t in transactions) {
      if (t.type == 'expense') {
        result[t.categoryId.toString()] =
            result[t.categoryId.toString()]! + t.amount;
      }
    }

    return result.entries
        .map((e) => SummaryModel(categoryId: e.key, amount: e.value.toDouble()))
        .toList();
  }

  Future<void> addTransaction({
    required double amount,
    required String type,
    required int categoryId,
    required DateTime date,
    String? note,
  }) async {
    final transaction = TransactionModel(
      amount: amount,
      type: type,
      categoryId: categoryId,
      date: date,
    );
    await _transaksi.addTransaction(transaction);

    notifyListeners();
  }

  double totalIncome() {
    final transactions = _transaksi.getAllTransactions();
    return transactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double totalExpense() {
    final transactions = _transaksi.getAllTransactions();
    return transactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double balance() {
    return totalIncome() - totalExpense();
  }

  double totalForCategory(String categoryId) {
    final transactions = _transaksi.getAllTransactions();
    return transactions
        .where((t) => t.categoryId.toString() == categoryId)
        .fold(0.0, (sum, t) => sum + t.amount);
  }
}
