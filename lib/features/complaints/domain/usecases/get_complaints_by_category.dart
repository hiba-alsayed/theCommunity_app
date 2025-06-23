import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entites/complaint.dart';
import '../repositories/complaints.dart';

class GetComplaintsByCategoryUseCase {
  final ComplaintsRepository repository;

  GetComplaintsByCategoryUseCase(this.repository);

  Future<Either<Failure, List<ComplaintEntity>>> call(int categoryId) async {
    return await repository.getComplaintsByCategory(categoryId);
  }
}