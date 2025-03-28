import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'expense_model.dart';

class UserDataModel extends Equatable {
  final String userId;
  final double? salary;
  final Map<String, ExpenseModel> expenses;
  final DateTime? updatedAt;

  const UserDataModel({
    required this.userId,
    this.salary,
    this.expenses = const {},
    this.updatedAt,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json, String userId) {
    // Extract expenses from the JSON
    Map<String, ExpenseModel> expenseObject = {};
    final Map<String, dynamic> userData = Map<String, dynamic>.from(json);

    // Known fields that aren't expenses
    final nonExpenseFields = [
      'salary',
      'updatedAt',
      'userId',
      'email',
      'displayName',
      'fcmToken'
    ];

    // Remove known non-expense fields
    for (var field in nonExpenseFields) {
      userData.remove(field);
    }

    // Process remaining fields as potential expenses
    userData.forEach((key, value) {
      expenseObject[key] = ExpenseModel(
        amount: value['amount'] is int
            ? value['amount'].toDouble()
            : value['amount'] as double,
        dueDate: value['dueDate'],
        updatedAt: value['updatedAt'] != null
            ? (value['updatedAt'] is Timestamp
                ? (value['updatedAt'] as Timestamp).toDate()
                : DateTime.now())
            : null,
      );
    });

    // Sort expenses by amount (highest first)
    var sortedEntries = expenseObject.entries.toList()
    ..sort((a, b) => b.value.amount.compareTo(a.value.amount));
    expenseObject = Map.fromEntries(sortedEntries);

    return UserDataModel(
      userId: userId,
      salary: json['salary'] != null
          ? (json['salary'] is int)
              ? (json['salary'] as int).toDouble()
              : json['salary'] as double
          : null,
      expenses: expenseObject,
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] is Timestamp
              ? (json['updatedAt'] as Timestamp).toDate()
              : DateTime.now())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (salary != null) {
      data['salary'] = salary;
    }

    // Add expenses to the main document
    expenses.forEach((k, v) {
      data[k] = v;
    });

    return data;
  }

  @override
  List<Object?> get props => [userId, salary, expenses, updatedAt];
}
