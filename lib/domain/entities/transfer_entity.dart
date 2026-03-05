import 'package:equatable/equatable.dart';

class TransferEntity extends Equatable {
  final String id;
  final String fromAccountId;
  final String toAccountId;
  final double amount;
  final DateTime date;
  final String description;

  const TransferEntity({
    required this.id,
    required this.fromAccountId,
    required this.toAccountId,
    required this.amount,
    required this.date,
    required this.description,
  });

  @override
  List<Object?> get props => [
    id,
    fromAccountId,
    toAccountId,
    amount,
    date,
    description,
  ];
}
