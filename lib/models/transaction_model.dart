<<<<<<< HEAD
// data/models/transaction_model.dart

class TransactionModel {
  final int? id;
=======
class TransactionModel {
  final int? id;
  final String? remoteId;
>>>>>>> 0c7b4a4 ( perbaikan file)
  final String title;
  final double amount;
  final String category;
  final String type;
  final String date;
<<<<<<< HEAD

  TransactionModel({
    this.id,
=======
  final String note;
  final int userId; // Tambahan penting

  TransactionModel({
    this.id,
    this.remoteId,
>>>>>>> 0c7b4a4 ( perbaikan file)
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
<<<<<<< HEAD
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      category: json['category'],
      type: json['type'],
      date: json['date'],
    );
  }

  get categoryId => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
=======
    required this.note,
    required this.userId,
  });

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
      userId: 0, // Default, karena data remote tidak menyimpan user
    );
  }

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

  Map<String, Object?> toLocalJson() {
    return {
      'remote_id': remoteId,
>>>>>>> 0c7b4a4 ( perbaikan file)
      'title': title,
      'amount': amount,
      'category': category,
      'type': type,
      'date': date,
<<<<<<< HEAD
    };
  }
=======
      'note': note,
      'user_id': userId,
    };
  }

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
>>>>>>> 0c7b4a4 ( perbaikan file)
}
