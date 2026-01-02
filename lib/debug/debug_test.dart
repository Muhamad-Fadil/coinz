import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/gemini_controller.dart';
import '../models/message_model.dart';

class DebugTest extends StatelessWidget {
  DebugTest({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GeminiViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Chatbot')),
      body: Column(
        children: [
          Expanded(
            child: vm.messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline,
                          size: 56,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Belum ada pesan. Ketik dan tekan kirim.',
                          style: TextStyle(color: Colors.grey),
                        ),
                        if (vm.error.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            'Error: ${"${vm.error}"}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: vm.messages.length,
                    itemBuilder: (context, index) {
                      final msg = vm.messages[index];
                      final isUser = msg.role == ChatRole.user;

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUser
                                ? Colors.blue.shade100
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(msg.message),
                        ),
                      );
                    },
                  ),
          ),

          if (vm.isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Tulis pesan...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final text = _controller.text;
                    _controller.clear();
                    vm.sendMessage(text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
