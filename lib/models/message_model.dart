enum ChatRole { user, bot }

class ChatMessageModel {
  final ChatRole role;
  final String message;

  ChatMessageModel({required this.role, required this.message});
}
