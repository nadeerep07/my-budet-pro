import '../entities/emi_tracker_entity.dart';

abstract class EmiTrackerRepository {
  Future<List<EmiTrackerEntity>> getEmis();
  Future<void> addEmi(EmiTrackerEntity emi);
  Future<void> updateEmi(EmiTrackerEntity emi);
  Future<void> deleteEmi(String id);
}
