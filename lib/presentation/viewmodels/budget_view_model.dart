import 'package:flutter/material.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';

class BudgetViewModel extends ChangeNotifier {
  final CategoryRepository _categoryRepository;

  List<CategoryEntity> _categories = [];
  List<CategoryEntity> get categories => _categories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  BudgetViewModel(this._categoryRepository);

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    _categories = await _categoryRepository.getCategories();
    
    // Add defaults if empty
    if (_categories.isEmpty) {
      final defaults = [
        const CategoryEntity(id: 'rent', name: 'Rent', monthlyBudget: 3000, isCustom: false),
        const CategoryEntity(id: 'food', name: 'Food', monthlyBudget: 7000, isCustom: false),
        const CategoryEntity(id: 'travel', name: 'Travel', monthlyBudget: 2000, isCustom: false),
        const CategoryEntity(id: 'petrol', name: 'Petrol', monthlyBudget: 3000, isCustom: false),
        const CategoryEntity(id: 'others', name: 'Others', monthlyBudget: 3000, isCustom: false),
      ];
      for (var cat in defaults) {
        await _categoryRepository.addCategory(cat);
      }
      _categories = defaults;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addCategory(String name, double budget) async {
    final cat = CategoryEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      monthlyBudget: budget,
      isCustom: true,
    );
    await _categoryRepository.addCategory(cat);
    await loadCategories();
  }

  Future<void> updateCategory(CategoryEntity category) async {
    await _categoryRepository.updateCategory(category);
    await loadCategories();
  }

  Future<void> deleteCategory(String id) async {
    await _categoryRepository.deleteCategory(id);
    await loadCategories();
  }
}
