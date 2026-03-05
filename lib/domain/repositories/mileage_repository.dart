import '../../domain/entities/mileage_entry_entity.dart';

abstract class MileageRepository {
  Future<List<MileageEntryEntity>> getMileageEntries();
  Future<void> addMileageEntry(MileageEntryEntity entry);
  Future<void> updateMileageEntry(MileageEntryEntity entry);
  Future<void> deleteMileageEntry(String id);
}
