import 'package:equatable/equatable.dart';

class ExpenseEntity extends Equatable {
  final String id;
  final String categoryId;
  final double amount;
  final String description;
  final DateTime date;
  final String accountId; // Corresponds to Account or Payment Method (e.g. SBI)
  final bool isFromSavings;
  final String? source;

  const ExpenseEntity({
    required this.id,
    required this.categoryId,
    required this.amount,
    required this.description,
    required this.date,
    required this.accountId,
    this.isFromSavings = false,
    this.source,
  });

  @override
  List<Object?> get props => [
    id,
    categoryId,
    amount,
    description,
    date,
    accountId,
    isFromSavings,
    source,
  ];
}
