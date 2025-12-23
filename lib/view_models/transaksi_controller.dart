import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/sumary_model.dart';
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
}
