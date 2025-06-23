import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/errors/failures.dart';
import 'package:graduation_project/features/complaints/domain/repositories/complaints.dart';
import '../entites/regions_entity.dart';

class GetAllRegionsUseCase {
  final ComplaintsRepository repository;

  GetAllRegionsUseCase(this.repository);
  Future<Either<Failure, List<RegionEntity>>> call() async {
    return await repository.getAllRegions();
  }
}