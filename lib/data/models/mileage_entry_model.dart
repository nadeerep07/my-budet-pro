import 'package:hive/hive.dart';
import '../../domain/entities/mileage_entry_entity.dart';

part 'mileage_entry_model.g.dart';

@HiveType(typeId: 5)
class MileageEntryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final double odometerReading;

  @HiveField(3)
  final double petrolLitres;

  @HiveField(4)
  final double pricePerLitre;

  @HiveField(5)
  final double totalCost;

  @HiveField(6)
  final double? distanceTravelled;

  @HiveField(7)
  final double? mileage;

  @HiveField(8)
  final String paymentMethodId;

  @HiveField(9)
  final String notes;

  @HiveField(10)
  final String? linkedExpenseId;

  MileageEntryModel({
    required this.id,
    required this.date,
    required this.odometerReading,
    required this.petrolLitres,
    required this.pricePerLitre,
    required this.totalCost,
    this.distanceTravelled,
    this.mileage,
    required this.paymentMethodId,
    this.notes = '',
    this.linkedExpenseId,
  });

  factory MileageEntryModel.fromEntity(MileageEntryEntity entity) {
    return MileageEntryModel(
      id: entity.id,
      date: entity.date,
      odometerReading: entity.odometerReading,
      petrolLitres: entity.petrolLitres,
      pricePerLitre: entity.pricePerLitre,
      totalCost: entity.totalCost,
      distanceTravelled: entity.distanceTravelled,
      mileage: entity.mileage,
      paymentMethodId: entity.paymentMethodId,
      notes: entity.notes,
      linkedExpenseId: entity.linkedExpenseId,
    );
  }

  MileageEntryEntity toEntity() {
    return MileageEntryEntity(
      id: id,
      date: date,
      odometerReading: odometerReading,
      petrolLitres: petrolLitres,
      pricePerLitre: pricePerLitre,
      totalCost: totalCost,
      distanceTravelled: distanceTravelled,
      mileage: mileage,
      paymentMethodId: paymentMethodId,
      notes: notes,
      linkedExpenseId: linkedExpenseId,
    );
  }
}
