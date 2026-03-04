import 'package:equatable/equatable.dart';

class IncomeEntity extends Equatable {
  final String id;
  final String source;
  final String description;
  final double amount;
  final DateTime date;
  final String accountId;

  const IncomeEntity({
    required this.id,
    required this.source,
    required this.description,
    required this.amount,
    required this.date,
    required this.accountId,
  });

  @override
  List<Object?> get props => [id, source, description, amount, date, accountId];
}
