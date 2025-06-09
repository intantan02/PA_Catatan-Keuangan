import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 2)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? remoteId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String type;

  @HiveField(6)
  final String date;

  @HiveField(7)
  final String note;

  @HiveField(8)
  final int userId;

  TransactionModel({
    this.id,
    this.remoteId,
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
    required this.note,
    required this.userId,
  });

  // Untuk data dari API (remote)
  factory TransactionModel.fromRemoteJson(Map<String, dynamic> json) {
    return TransactionModel(
      remoteId: json['id']?.toString(),
      title: json['title']?.toString() ?? '',
      amount: (json['amount'] is num)
          ? (json['amount'] as num).toDouble()
          : double.tryParse(json['amount'].toString()) ?? 0.0,
      category: json['category']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      date: json['date']?.toString() ?? DateTime.now().toIso8601String(),
      note: json['note']?.toString() ?? '',
      userId: 0, // Data remote biasanya tidak menyimpan userId lokal
    );
  }

  // Untuk data dari database lokal
  factory TransactionModel.fromLocalJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as int?,
      remoteId: json['remote_id']?.toString(),
      title: json['title'] as String? ?? '',
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String? ?? '',
      type: json['type'] as String? ?? '',
      date: json['date'] as String? ?? DateTime.now().toIso8601String(),
      note: json['note'] as String? ?? '',
      userId: json['user_id'] as int? ?? 0,
    );
  }

  // Untuk insert/update ke database lokal
  Map<String, Object?> toLocalJson() {
    return {
      'id': id,
      'remote_id': remoteId,
      'title': title,
      'amount': amount,
      'category': category,
      'type': type,
      'date': date,
      'note': note,
      'user_id': userId,
    };
  }

  // Untuk insert/update ke API (remote)
  Map<String, dynamic> toRemoteJson() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'type': type,
      'date': date,
      'note': note,
    };
  }

  TransactionModel copyWith({
    int? id,
    String? remoteId,
    String? title,
    double? amount,
    String? category,
    String? type,
    String? date,
    String? note,
    int? userId,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      type: type ?? this.type,
      date: date ?? this.date,
      note: note ?? this.note,
      userId: userId ?? this.userId,
    );
  }
}