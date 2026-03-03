import 'package:hive/hive.dart';
import '../../domain/entities/account_entity.dart';

part 'account_model.g.dart';

@HiveType(typeId: 2)
class AccountModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  double initialBalance;

  AccountModel({
    required this.id,
    required this.name,
    required this.initialBalance,
  });

  factory AccountModel.fromEntity(AccountEntity entity) {
    return AccountModel(
      id: entity.id,
      name: entity.name,
      initialBalance: entity.initialBalance,
    );
  }

  AccountEntity toEntity() {
    return AccountEntity(
      id: id,
      name: name,
      initialBalance: initialBalance,
    );
  }
}
