import 'dart:io';

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entites/complaint.dart';
import '../entites/complaint_category_entity.dart';
import '../entites/regions_entity.dart';


abstract class ComplaintsRepository {
  Future<Either<Failure, List<ComplaintCategory>>> getComplaintsCategories();
  Future<Either<Failure, List<ComplaintEntity>>> getAllComplaints();
  Future<Either<Failure, List<ComplaintEntity>>> getComplaintsByCategory(int categoryId);
  Future<Either<Failure, List<ComplaintEntity>>> getMyComplaints();
  Future<Either<Failure, List<ComplaintEntity>>> getNearbyComplaints(double distance, int categoryId);
  Future<Either<Failure, List<RegionEntity>>> getAllRegions();
  Future<Either<Failure, Unit>> submitComplaint(
     double latitude,
     double longitude,
     String area,
     String title,
     String description,
     int complaintCategoryId,
     List<File> complaintImages);
}
