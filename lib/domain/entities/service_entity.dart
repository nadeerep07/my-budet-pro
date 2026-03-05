import 'package:equatable/equatable.dart';

class ServiceEntity extends Equatable {
  final String id;
  final String title;
  final DateTime date;
  final int mileageAtService;
  final double cost;
  final String notes;
  final DateTime? nextServiceDate;
  final int? nextServiceMileage;

  const ServiceEntity({
    required this.id,
    required this.title,
    required this.date,
    required this.mileageAtService,
    required this.cost,
    required this.notes,
    this.nextServiceDate,
    this.nextServiceMileage,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    date,
    mileageAtService,
    cost,
    notes,
    nextServiceDate,
    nextServiceMileage,
  ];
}
