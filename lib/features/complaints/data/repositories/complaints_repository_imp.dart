import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/errors/failures.dart';
import 'package:graduation_project/features/complaints/domain/entites/complaint.dart';
import 'package:graduation_project/features/complaints/domain/entites/complaint_category_entity.dart';
import 'package:graduation_project/features/complaints/domain/entites/regions_entity.dart';
import 'package:graduation_project/features/complaints/domain/repositories/complaints.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../../campaigns/data/datasources/campaigns_local_data_source.dart';
import '../datasources/complaints_remote_data_source.dart';

class ComplaintsRepositoryImp implements ComplaintsRepository{
  final ComplaintsRemoteDataSource remoteDataSource;
  final CampaignLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ComplaintsRepositoryImp({required this.remoteDataSource,required this.localDataSource, required this.networkInfo, });
  @override
  Future<Either<Failure, List<ComplaintCategory>>> getComplaintsCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCategories = await remoteDataSource.getComplaintsCategories();
        return Right(remoteCategories);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ComplaintEntity>>> getAllComplaints() async{
    if (await networkInfo.isConnected) {
      try {
        final remoteComplaints = await remoteDataSource.getAllComplaints();
        return Right(remoteComplaints);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ComplaintEntity>>> getComplaintsByCategory(int categoryId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteComplaints = await remoteDataSource.getComplaintsByCategory(categoryId);
        return Right(remoteComplaints);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<ComplaintEntity>>> getMyComplaints() async{
    if (await networkInfo.isConnected) {
      try {
        final remoteComplaints = await remoteDataSource.getMyComplaints();
        return Right(remoteComplaints);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<ComplaintEntity>>> getNearbyComplaints(double distance, int categoryId) async{
    if (await networkInfo.isConnected) {
      try {
        final remoteComplaints = await remoteDataSource.getNearbyComplaints(distance, categoryId);
        return Right(remoteComplaints);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<RegionEntity>>> getAllRegions() async{
    if (await networkInfo.isConnected) {
      try {
        final remoteRegions = await remoteDataSource.getAllRegions();
        return Right(remoteRegions);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> submitComplaint(double latitude, double longitude, String area, String title, String description, int complaintCategoryId, List<File> complaintImages) async{
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.submitComplaint(
          latitude,
          longitude,
          area,
          title,
          description,
          complaintCategoryId,
          complaintImages,
        );
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<ComplaintEntity>>> getAllNearbyComplaints() async{
    if (await networkInfo.isConnected) {
      try {
        final remoteComplaints = await remoteDataSource.getAllNearbyComplaints();
        return Right(remoteComplaints);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }}