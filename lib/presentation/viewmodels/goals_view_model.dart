import 'package:flutter/foundation.dart';
import '../../domain/entities/goal_entity.dart';
import '../../domain/repositories/goal_repository.dart';

class GoalsViewModel extends ChangeNotifier {
  final GoalRepository _repository;

  List<GoalEntity> _goals = [];
  bool _isLoading = false;

  GoalsViewModel(this._repository);

  List<GoalEntity> get goals => _goals;
  bool get isLoading => _isLoading;

  Future<void> loadGoals() async {
    _isLoading = true;
    notifyListeners();

    _goals = await _repository.getGoals();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addGoal(GoalEntity goal) async {
    await _repository.addGoal(goal);
    _goals.insert(0, goal);
    notifyListeners();
  }

  Future<void> updateGoal(GoalEntity goal) async {
    await _repository.updateGoal(goal);
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;
      notifyListeners();
    }
  }

  Future<void> deleteGoal(String id) async {
    await _repository.deleteGoal(id);
    _goals.removeWhere((g) => g.id == id);
    notifyListeners();
  }

  Future<void> addSavingsToGoal(String id, double amount) async {
    final index = _goals.indexWhere((g) => g.id == id);
    if (index != -1) {
      final goal = _goals[index];
      final newSavings = goal.currentSavings + amount;
      final updatedGoal = GoalEntity(
        id: goal.id,
        name: goal.name,
        targetAmount: goal.targetAmount,
        currentSavings: newSavings,
        targetDate: goal.targetDate,
      );
      await updateGoal(updatedGoal);
    }
  }
}
