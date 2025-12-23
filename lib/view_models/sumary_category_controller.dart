import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/transaksi_model.dart';
import '../data/category_data.dart';
import '../models/category_sumary_model.dart';

class SummaryViewModel extends ChangeNotifier {
  final Box<TransactionModel> _box = Hive.box<TransactionModel>('transactions');

  List<CategorySumaryModel> expenseSummary() {
    final Map<String, double> totals = {
      for (var c in KategoryData.excategories) c.id: 0.0,
    };

    for (var tx in _box.values) {
      if (tx.type == 'expense') {
        totals[tx.categoryId.toString()] =
            (totals[tx.categoryId.toString()] ?? 0) + tx.amount;
      }
    }

    return totals.entries.map((e) {
      final category = KategoryData.getById(e.key.toString());
      return CategorySumaryModel(
        categoryId: e.key.toString(),
        categoryName: category.name,
        amount: e.value.toDouble(),
      );
    }).toList();
  }
}
