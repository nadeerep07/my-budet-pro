import '../entities/account_entity.dart';

abstract class AccountRepository {
  Future<List<AccountEntity>> getAccounts();
  Future<void> addAccount(AccountEntity account);
  Future<void> updateAccount(AccountEntity account);
  Future<void> deleteAccount(String id);
}
