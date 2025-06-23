import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entites/complaint.dart';
import '../repositories/complaints.dart';


class GetAllComplaintsUseCase {
  final ComplaintsRepository repository;

  GetAllComplaintsUseCase(this.repository);

  Future<Either<Failure, List<ComplaintEntity>>> call() async {
    return await repository.getAllComplaints();
  }
}