import 'package:equatable/equatable.dart';

class MileageEntryEntity extends Equatable {
  final String id;
  final DateTime date;
  final double odometerReading;
  final double petrolLitres;
  final double pricePerLitre;
  final double totalCost;
  final double? distanceTravelled;
  final double? mileage;
  final String paymentMethodId;
  final String notes;
  final String? linkedExpenseId;

  const MileageEntryEntity({
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

  @override
  List<Object?> get props => [
    id,
    date,
    odometerReading,
    petrolLitres,
    pricePerLitre,
    totalCost,
    distanceTravelled,
    mileage,
    paymentMethodId,
    notes,
    linkedExpenseId,
  ];
}
