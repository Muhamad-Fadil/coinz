import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/gemini_controller.dart';
import '../models/message_model.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GeminiViewModel>();

    // If there's an error from the AI service, show an alert then clear it (with Retry for network)
    final error = vm.error;
    if (error.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final isLimit = _isLimitError(error);
        final isNetwork = _isNetworkError(error);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(
              isNetwork
                  ? 'Tidak Ada Koneksi'
                  : isLimit
                  ? 'Batas AI Terpenuhi'
                  : 'Terjadi Kesalahan',
            ),
            content: Text(
              isNetwork
                  ? 'Sepertinya perangkat tidak tersambung ke internet. Periksa koneksi dan coba lagi.'
                  : isLimit
                  ? 'Permintaan terhambat karena batas penggunaan AI tercapai. Silakan coba lagi nanti atau periksa kuota API Anda.'
                  : 'Terjadi kesalahan: $error',
            ),
            actions: [
              if (isNetwork)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    vm.clearError();
                    vm.retryLast();
                  },
                  child: const Text('Retry'),
                ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  vm.clearError();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ===== HEADER =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 40),
            decoration: const BoxDecoration(
              color: Color(0xFF6E7F63),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(60)),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Hii 👋", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 10),
                const Text(
                  "Mau aku bantu pantau\npengeluaran kamu?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ===== CHAT LIST =====
          Expanded(
            child: vm.messages.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada pesan",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: vm.messages.length,
                    itemBuilder: (context, index) {
                      final msg = vm.messages[index];
                      final isUser = msg.role == ChatRole.user;

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isUser
                                ? const Color(0xFF8FAE7C)
                                : const Color.fromARGB(255, 217, 236, 205),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            msg.message,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // ===== LOADING =====
          if (vm.isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),

          // ===== INPUT =====
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.black54),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Ask anything",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final text = _controller.text;
                    _controller.clear();
                    vm.sendMessage(text); // 🔥 INI KUNCI
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isLimitError(String msg) {
    final s = msg.toLowerCase();
    return s.contains('rate limit') ||
        s.contains('quota') ||
        s.contains('429') ||
        s.contains('too many requests') ||
        s.contains('limit') ||
        s.contains('exceeded');
  }

  bool _isNetworkError(String msg) {
    final s = msg.toLowerCase();
    return s.contains('socketexception') ||
        s.contains('failed host') ||
        s.contains('no address') ||
        s.contains('network') ||
        s.contains('network:');
  }
}
