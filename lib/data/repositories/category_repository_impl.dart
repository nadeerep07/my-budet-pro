import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final LocalDataSource localDataSource;

  CategoryRepositoryImpl(this.localDataSource);

  @override
  Future<void> addCategory(CategoryEntity category) async {
    final model = CategoryModel.fromEntity(category);
    await localDataSource.addCategory(model);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await localDataSource.deleteCategory(id);
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final models = await localDataSource.getCategories();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateCategory(CategoryEntity category) async {
    final model = CategoryModel.fromEntity(category);
    await localDataSource.updateCategory(model);
  }
}
