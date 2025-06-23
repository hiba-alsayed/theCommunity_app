import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/complaints/domain/entites/complaint.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/complaints.dart';


class GetNearbyComplaintsUseCase  {
  final ComplaintsRepository  repository;

  GetNearbyComplaintsUseCase (this.repository);

  Future<Either<Failure, List<ComplaintEntity>>> call(int categoryId, double distance) async {
    return await repository.getNearbyComplaints(distance, categoryId);
  }
}