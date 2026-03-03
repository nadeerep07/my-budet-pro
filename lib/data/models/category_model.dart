import 'package:hive/hive.dart';
import '../../domain/entities/category_entity.dart';

part 'category_model.g.dart';

@HiveType(typeId: 0)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double monthlyBudget;

  @HiveField(3)
  final bool isCustom;

  CategoryModel({
    required this.id,
    required this.name,
    required this.monthlyBudget,
    this.isCustom = true,
  });

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      monthlyBudget: entity.monthlyBudget,
      isCustom: entity.isCustom,
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      monthlyBudget: monthlyBudget,
      isCustom: isCustom,
    );
  }
}
