import 'package:hive/hive.dart';

part 'transaksi_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  int amount;

  @HiveField(1)
  int categoryId;

  @HiveField(2)
  String type; // income | expense

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String note;

  TransactionModel({
    required this.amount,
    required this.categoryId,
    required this.type,
    required this.date,
    required this.note,
  });
}
