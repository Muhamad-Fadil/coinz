import 'package:hive/hive.dart';
import '../view_models/transaksi_controller.dart';
import '../models/transaksi_model.dart';
import '../data/category_data.dart';

Future<void> runDebugTest() async {
  final transaksiController = TransaksiController();
  Box<TransactionModel> transactionsBox;
  try {
    transactionsBox = await Hive.openBox<TransactionModel>('transactions');
    print('runDebugTest: opened box transactions');
  } catch (e) {
    print('runDebugTest: openBox error: $e');
    rethrow;
  }

  await transactionsBox.clear();

  final testData = [
    TransactionModel(
      amount: 50000,
      categoryId: 1,
      type: 'expense',
      date: DateTime.now(),
      note: 'Electricity Bill',
    ),
    TransactionModel(
      amount: 200000,
      categoryId: 101,
      type: 'income',
      date: DateTime.now(),
      note: 'Freelance Job',
    ),
    TransactionModel(
      amount: 75000,
      categoryId: 2,
      type: 'expense',
      date: DateTime.now(),
      note: 'Groceries',
    ),
    TransactionModel(
      amount: 150000,
      categoryId: 102,
      type: 'income',
      date: DateTime.now(),
      note: 'Part-time Work',
    ),
  ];

  await transactionsBox.addAll(testData);
  print('runDebugTest: added ${testData.length} test transactions');
  print('runDebugTest: transactionsBox.length = ${transactionsBox.length}');

  print('TOTAL TRANSAKSI: ${transactionsBox.length}');

  final expenseSummary = transaksiController.expenseSummary();
  for (var summary in expenseSummary) {
    final category = KategoryData.getById(summary.categoryId);
    print('Category: ${category.name}, Total: ${summary.amount}');
  }
}
