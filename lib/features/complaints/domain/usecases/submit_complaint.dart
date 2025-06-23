import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/errors/failures.dart';
import 'package:graduation_project/features/complaints/domain/repositories/complaints.dart';

class SubmitComplaintUseCase {
  final ComplaintsRepository repository;

  SubmitComplaintUseCase(this.repository);
  Future<Either<Failure, Unit>> call(
      double latitude,
      double longitude,
      String area,
      String title,
      String description,
      int complaintCategoryId,
      List<File> complaintImages,
      ) async {
    return await repository.submitComplaint(
      latitude,
      longitude,
      area,
      title,
      description,
      complaintCategoryId,
      complaintImages,
    );
  }
}