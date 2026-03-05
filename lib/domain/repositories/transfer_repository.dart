import '../entities/transfer_entity.dart';

abstract class TransferRepository {
  Future<List<TransferEntity>> getTransfers();
  Future<void> addTransfer(TransferEntity transfer);
  Future<void> updateTransfer(TransferEntity transfer);
  Future<void> deleteTransfer(String id);
}
