import '../../domain/entities/goal_entity.dart';
import '../../domain/repositories/goal_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/goal_model.dart';

class GoalRepositoryImpl implements GoalRepository {
  final LocalDataSource localDataSource;

  GoalRepositoryImpl(this.localDataSource);

  @override
  Future<List<GoalEntity>> getGoals() async {
    final models = await localDataSource.getGoals();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addGoal(GoalEntity goal) async {
    final model = GoalModel.fromEntity(goal);
    await localDataSource.addGoal(model);
  }

  @override
  Future<void> updateGoal(GoalEntity goal) async {
    final model = GoalModel.fromEntity(goal);
    await localDataSource.updateGoal(model);
  }

  @override
  Future<void> deleteGoal(String id) async {
    await localDataSource.deleteGoal(id);
  }
}
