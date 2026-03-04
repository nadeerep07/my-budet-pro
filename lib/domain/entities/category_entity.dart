import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final double monthlyBudget;
  final bool isCustom;
  final int? month;
  final int? year;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.monthlyBudget,
    this.isCustom = true,
    this.month,
    this.year,
  });

  @override
  List<Object?> get props => [id, name, monthlyBudget, isCustom, month, year];

  CategoryEntity copyWith({
    String? id,
    String? name,
    double? monthlyBudget,
    bool? isCustom,
    int? month,
    int? year,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      isCustom: isCustom ?? this.isCustom,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }
}
