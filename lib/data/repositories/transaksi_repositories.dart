import 'package:flutter_application_coinz/models/transaksi_model.dart';
import 'package:hive/hive.dart';

class TransaksiRepositories {
  final Box<TransactionModel> transaksiBox = Hive.box<TransactionModel>(
    'transactions',
  );

  List<TransactionModel> getAllTransactions() {
    return transaksiBox.values.toList();
  }

  /// 🔑 UBAH DATA JADI TEKS UNTUK AI
  String buildContextForAI() {
    final txs = getAllTransactions();

    if (txs.isEmpty) {
      return 'Database transaksi kosong.';
    }

    return txs
        .map((t) {
          return '''
- Tanggal: ${t.date.toIso8601String()}
- Jumlah: ${t.amount}
- Tipe: ${t.type}
- CategoryId: ${t.categoryId}
''';
        })
        .join('\n');
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await transaksiBox.add(transaction);
  }

  void deleteTransaction(TransactionModel transaction) {
    transaction.delete();
  }
}
