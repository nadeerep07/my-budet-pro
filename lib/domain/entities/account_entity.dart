import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {
  final String id;
  final String name; // e.g. SBI, HDFC, Cash
  final double initialBalance; // Can be used to track available balance

  const AccountEntity({
    required this.id,
    required this.name,
    required this.initialBalance,
  });

  @override
  List<Object?> get props => [id, name, initialBalance];
}
