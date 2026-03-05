import '../entities/service_entity.dart';

abstract class ServiceRepository {
  Future<List<ServiceEntity>> getServices();
  Future<void> addService(ServiceEntity service);
  Future<void> updateService(ServiceEntity service);
  Future<void> deleteService(String id);
}
