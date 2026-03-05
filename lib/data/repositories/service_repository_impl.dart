import '../../domain/entities/service_entity.dart';
import '../../domain/repositories/service_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/service_model.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final LocalDataSource localDataSource;

  ServiceRepositoryImpl(this.localDataSource);

  @override
  Future<List<ServiceEntity>> getServices() async {
    final models = await localDataSource.getServices();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addService(ServiceEntity service) async {
    final model = ServiceModel.fromEntity(service);
    await localDataSource.addService(model);
  }

  @override
  Future<void> updateService(ServiceEntity service) async {
    final model = ServiceModel.fromEntity(service);
    await localDataSource.updateService(model);
  }

  @override
  Future<void> deleteService(String id) async {
    await localDataSource.deleteService(id);
  }
}
