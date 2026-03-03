import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final double monthlyBudget;
  final bool isCustom;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.monthlyBudget,
    this.isCustom = true,
  });

  @override
  List<Object?> get props => [id, name, monthlyBudget, isCustom];
}
