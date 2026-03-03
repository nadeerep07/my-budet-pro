import '../../domain/entities/account_entity.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/account_model.dart';

class AccountRepositoryImpl implements AccountRepository {
  final LocalDataSource localDataSource;

  AccountRepositoryImpl(this.localDataSource);

  @override
  Future<void> addAccount(AccountEntity account) async {
    final model = AccountModel.fromEntity(account);
    await localDataSource.addAccount(model);
  }

  @override
  Future<void> deleteAccount(String id) async {
    await localDataSource.deleteAccount(id);
  }

  @override
  Future<List<AccountEntity>> getAccounts() async {
    final models = await localDataSource.getAccounts();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateAccount(AccountEntity account) async {
    final model = AccountModel.fromEntity(account);
    await localDataSource.updateAccount(model);
  }
}
