import 'package:equatable/equatable.dart';

class GoalEntity extends Equatable {
  final String id;
  final String name;
  final double targetAmount;
  final double currentSavings;
  final DateTime? targetDate;

  const GoalEntity({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.currentSavings = 0.0,
    this.targetDate,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    targetAmount,
    currentSavings,
    targetDate,
  ];
}
