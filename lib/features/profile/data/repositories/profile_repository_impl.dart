import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/errors/failures.dart';
import 'package:graduation_project/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:graduation_project/features/profile/domain/entity/profile_entity.dart';
import 'package:graduation_project/features/profile/domain/repository/profile.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';

class ProfileRepositoryImpl implements ProfileRepository{
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl( {required this.remoteDataSource,required this.networkInfo,});

  @override
  Future<Either<Failure, ProfileEntity>> getMyProfile() async {
    if (await networkInfo.isConnected) {
      try {
        final profileModel = await remoteDataSource.getMyProfile();
        return Right(profileModel);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());

    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> getProfileByUserId(int userId) async{
    if (await networkInfo.isConnected) {
      try {
        final profileModel = await remoteDataSource.getProfileByUserId(userId);
        return Right(profileModel);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, String>> updateClientProfile({required int age, required String phone, required String gender, required String bio, required String deviceToken, required List<String> volunteerFields, required String longitude, required String latitude, required String area, required List<String> skills}) async {
    if (await networkInfo.isConnected) {
      try {
        final successMessage = await remoteDataSource.updateClientProfile(
          age: age,
          phone: phone,
          gender: gender,
          bio: bio,
          deviceToken: deviceToken,
          volunteerFields: volunteerFields,
          longitude: longitude,
          latitude: latitude,
          area: area,
          skills: skills,
        );
        return Right(successMessage);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}