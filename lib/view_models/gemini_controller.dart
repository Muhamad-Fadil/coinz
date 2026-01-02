import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../models/gemini_model.dart';
import '../data/repositories/transaksi_repositories.dart';

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

      // 2️⃣ Ringkas data transaksi
      final dbSummary = _buildTransactionSummary(transactions);

      // 3️⃣ Gabungkan ke prompt
      final finalPrompt =
          '''
Kamu adalah asisten keuangan pribadi.

DATA TRANSAKSI USER:
$dbSummary

PERTANYAAN USER:
$userPrompt

Jawab dengan bahasa Indonesia yang jelas dan mudah dipahami.
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

String _buildTransactionSummary(List transactions) {
  if (transactions.isEmpty) {
    return 'Tidak ada data transaksi.';
  }

  final buffer = StringBuffer();
  buffer.writeln('Total transaksi: ${transactions.length}');
  double totalAmount = 0.0;

  for (var tx in transactions) {
    totalAmount += tx.amount;
  }

  buffer.writeln(
    'Total jumlah transaksi: Rp ${totalAmount.toStringAsFixed(2)}',
  );

  final categoryCount = <String, int>{};
  for (var tx in transactions) {
    categoryCount[tx.category] = (categoryCount[tx.category] ?? 0) + 1;
  }

  buffer.writeln('Transaksi per kategori:');
  categoryCount.forEach((category, count) {
    buffer.writeln('- $category: $count transaksi');
  });

  return buffer.toString();
}
