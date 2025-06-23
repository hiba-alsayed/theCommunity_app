import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/errors/failures.dart';
import 'package:graduation_project/features/complaints/domain/entites/complaint.dart';

import '../repositories/complaints.dart';

class GetMyComplaintsUseCase {
  final ComplaintsRepository repository;

  GetMyComplaintsUseCase(this.repository);

  Future<Either<Failure, List<ComplaintEntity>>> call() async {
    return await repository.getMyComplaints();
  }
}