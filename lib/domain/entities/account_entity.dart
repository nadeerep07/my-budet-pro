import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {
  final String id;
  final String name; // e.g. SBI, HDFC, Cash
  final double openingBalance; // Used to track base balance before calculations

  const AccountEntity({
    required this.id,
    required this.name,
    required this.openingBalance,
  });

  @override
  List<Object?> get props => [id, name, openingBalance];
}
