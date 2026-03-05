import '../../domain/entities/transfer_entity.dart';
import '../../domain/repositories/transfer_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/transfer_model.dart';

class TransferRepositoryImpl implements TransferRepository {
  final LocalDataSource localDataSource;

  TransferRepositoryImpl(this.localDataSource);

  @override
  Future<List<TransferEntity>> getTransfers() async {
    final models = await localDataSource.getTransfers();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addTransfer(TransferEntity transfer) async {
    final model = TransferModel.fromEntity(transfer);
    await localDataSource.addTransfer(model);
  }

  @override
  Future<void> updateTransfer(TransferEntity transfer) async {
    final model = TransferModel.fromEntity(transfer);
    await localDataSource.updateTransfer(model);
  }

  @override
  Future<void> deleteTransfer(String id) async {
    await localDataSource.deleteTransfer(id);
  }
}
