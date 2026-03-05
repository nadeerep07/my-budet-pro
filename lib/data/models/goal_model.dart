import 'package:hive/hive.dart';
import '../../domain/entities/goal_entity.dart';

part 'goal_model.g.dart';

@HiveType(typeId: 9)
class GoalModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double targetAmount;

  @HiveField(3)
  final double currentSavings;

  @HiveField(4)
  final DateTime? targetDate;

  GoalModel({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentSavings,
    this.targetDate,
  });

  factory GoalModel.fromEntity(GoalEntity entity) {
    return GoalModel(
      id: entity.id,
      name: entity.name,
      targetAmount: entity.targetAmount,
      currentSavings: entity.currentSavings,
      targetDate: entity.targetDate,
    );
  }

  GoalEntity toEntity() {
    return GoalEntity(
      id: id,
      name: name,
      targetAmount: targetAmount,
      currentSavings: currentSavings,
      targetDate: targetDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'currentSavings': currentSavings,
      'targetDate': targetDate?.toIso8601String(),
    };
  }
}
