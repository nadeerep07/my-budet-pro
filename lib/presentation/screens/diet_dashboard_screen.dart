import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../viewmodels/diet_view_model.dart';
import 'diet_profile_screen.dart';
import 'add_meal_screen.dart';

class DietDashboardScreen extends StatefulWidget {
  const DietDashboardScreen({super.key});

  @override
  State<DietDashboardScreen> createState() => _DietDashboardScreenState();
}

class _DietDashboardScreenState extends State<DietDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DietViewModel>().loadDietData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dietVM = context.watch<DietViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Diet Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DietProfileScreen()),
            ),
          ),
        ],
      ),
      body: dietVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : dietVM.profile == null
          ? _buildSetupProfile(context)
          : _buildDashboard(context, dietVM),
    );
  }

  Widget _buildSetupProfile(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to your AI Diet Planner',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Set up your physical profile to get a personalized daily calorie target based on the Mifflin-St Jeor formula.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DietProfileScreen()),
              ),
              child: const Text('Setup Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, DietViewModel vm) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCalorieSummary(context, vm),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today's Meals",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddMealScreen()),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Add Meal'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (vm.todayMeals.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No meals logged today yet.'),
              ),
            )
          else
            ...vm.todayMeals.map(
              (meal) => Dismissible(
                key: Key(meal.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => vm.deleteMeal(meal.id),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: IOSCard(
                    padding: const EdgeInsets.all(12),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            meal.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${meal.calories} kcal',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        '${meal.mealType} • ${DateFormat("hh:mm a").format(meal.date)}\nP: ${meal.protein}g  C: ${meal.carbs}g  F: ${meal.fat}g',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCalorieSummary(BuildContext context, DietViewModel vm) {
    final target = vm.profile!.dailyCalorieTarget;
    final consumed = vm.totalConsumedCalories;
    final remaining = target - consumed;
    final progress = target > 0 ? (consumed / target).clamp(0.0, 1.0) : 0.0;

    return IOSCard(
      child: Column(
        children: [
          Text(
            'Daily Calorie Target',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 12,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  color: remaining < 0
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
              Column(
                children: [
                  Text(
                    '${remaining.abs()}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: remaining < 0
                          ? Theme.of(context).colorScheme.error
                          : null,
                    ),
                  ),
                  Text(
                    remaining < 0 ? 'Over' : 'Remaining',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn('Target', target.toString()),
              _buildStatColumn('Consumed', consumed.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
