import 'package:equatable/equatable.dart';

class SavingsEntity extends Equatable {
  final String id;
  final double totalAdded;
  final double totalDebited;

  const SavingsEntity({
    required this.id,
    this.totalAdded = 0.0,
    this.totalDebited = 0.0,
  });

  double get currentBalance => totalAdded - totalDebited;

  @override
  List<Object?> get props => [id, totalAdded, totalDebited];
}
