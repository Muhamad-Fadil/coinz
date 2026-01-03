import 'package:flutter/material.dart';
import 'package:flutter_application_coinz/data/category_data.dart';
import '../models/message_model.dart';
import '../models/gemini_model.dart';
import '../data/repositories/transaksi_repositories.dart';
import '../models/transaksi_model.dart';

class GeminiViewModel extends ChangeNotifier {
  final GeminiService _service;
  final TransaksiRepositories _repo = TransaksiRepositories();

  GeminiViewModel(this._service);

  final List<ChatMessageModel> _messages = [];
  bool _isLoading = false;
  String _error = '';

  List<ChatMessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> sendMessage(String text) async {
    final userPrompt = text.trim();
    if (userPrompt.isEmpty) return;

    _messages.add(ChatMessageModel(role: ChatRole.user, message: userPrompt));
    notifyListeners();

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // 1️⃣ Ambil data transaksi
      final transactions = _repo.getAllTransactions();

      // 👉 TARUH PRINT DI SINI
      print('TOTAL TRANSAKSI: ${transactions.length}');

      // 2️⃣ Ringkas data transaksi
      final dbSummary = _buildTransactionSummary(transactions);
      final categoryInfo = _buildCategoryInfo();

      // 3️⃣ Gabungkan ke prompt
      final finalPrompt =
          '''
Kamu adalah asisten keuangan pribadi.
Jawaban HARUS berdasarkan data di bawah.
Jika data tidak ada, katakan dengan jujur.

DAFTAR KATEGORI DALAM SISTEM:
$categoryInfo

DATA TRANSAKSI USER:
$dbSummary

PERTANYAAN USER:
$userPrompt
''';

      final reply = await _service.sendMessage(finalPrompt);

      _messages.add(ChatMessageModel(role: ChatRole.bot, message: reply));
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

String _buildTransactionSummary(List<TransactionModel> transactions) {
  if (transactions.isEmpty) {
    return 'Tidak ada data transaksi.';
  }

  final buffer = StringBuffer();

  buffer.writeln('JUMLAH TRANSAKSI: ${transactions.length}');
  buffer.writeln('');

  double totalExpense = 0;
  double totalIncome = 0;

  final Map<String, double> expenseByCategory = {};
  final Map<String, int> countByCategory = {};

  for (final tx in transactions) {
    final category = KategoryData.getById(tx.categoryId.toString());

    if (tx.type == 'expense') {
      totalExpense += tx.amount;
      expenseByCategory[category.name] =
          (expenseByCategory[category.name] ?? 0) + tx.amount;
    } else {
      totalIncome += tx.amount;
    }

    countByCategory[category.name] = (countByCategory[category.name] ?? 0) + 1;
  }

  buffer.writeln('TOTAL PEMASUKAN: Rp ${totalIncome.toStringAsFixed(0)}');
  buffer.writeln('TOTAL PENGELUARAN: Rp ${totalExpense.toStringAsFixed(0)}');
  buffer.writeln('');

  buffer.writeln('RINCIAN PER KATEGORI:');
  expenseByCategory.forEach((cat, amount) {
    buffer.writeln('- $cat: Rp ${amount.toStringAsFixed(0)}');
  });

  buffer.writeln('');
  buffer.writeln('JUMLAH TRANSAKSI PER KATEGORI:');
  countByCategory.forEach((cat, count) {
    buffer.writeln('- $cat: $count transaksi');
  });

  return buffer.toString();
}

String _buildCategoryInfo() {
  final buffer = StringBuffer();

  buffer.writeln('KATEGORI PENGELUARAN (EXPENSE):');
  for (final cat in KategoryData.excategories) {
    buffer.writeln('- ${cat.name} (id: ${cat.id})');
  }

  buffer.writeln('');
  buffer.writeln('KATEGORI PEMASUKAN (INCOME):');
  for (final cat in KategoryData.incategories) {
    buffer.writeln('- ${cat.name} (id: ${cat.id})');
  }

  return buffer.toString();
}
