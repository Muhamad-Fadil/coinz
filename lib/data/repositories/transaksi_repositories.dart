import 'package:hive/hive.dart';
import '../../models/transaksi_model.dart';

class TransaksiRepositories {
  final Box<TransactionModel> transaksiBox = Hive.box<TransactionModel>(
    'transactions',
  );

  List<TransactionModel> getAllTransactions() {
    return transaksiBox.values.toList();
  }

  void addTransaction(TransactionModel transaction) {
    transaksiBox.add(transaction);
  }

  void deleteTransaction(TransactionModel transaction) {
    transaction.delete();
  }
}
