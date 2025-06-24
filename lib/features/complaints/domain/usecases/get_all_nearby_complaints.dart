import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entites/complaint.dart';
import '../repositories/complaints.dart';


class GetAllNearbyComplaintsUseCase {
  final ComplaintsRepository repository;
  GetAllNearbyComplaintsUseCase(this.repository);
  Future<Either<Failure, List<ComplaintEntity>>> call() async {
    return await repository.getAllNearbyComplaints();
  }
}