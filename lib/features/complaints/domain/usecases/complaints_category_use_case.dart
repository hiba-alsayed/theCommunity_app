import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../campaigns/domain/entities/category.dart';
import '../entites/complaint_category_entity.dart';
import '../repositories/complaints.dart';

class GetComplaintsCategoriesUseCase {
  final ComplaintsRepository repository;

  GetComplaintsCategoriesUseCase(this.repository);

  Future<Either<Failure, List<ComplaintCategory>>> call() async {
    return await repository.getComplaintsCategories();
  }
}