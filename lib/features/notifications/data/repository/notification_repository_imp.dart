import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/errors/failures.dart';
import 'package:graduation_project/features/notifications/domain/entity/notification_entity.dart';
import 'package:graduation_project/features/notifications/domain/repository/notification_repository.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../datasource/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository{
  final NotificationRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  NotificationRepositoryImpl( {required this.remoteDataSource,required this.networkInfo,});
  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async{
if (await networkInfo.isConnected) {
    try {
      final remoteNotifications = await remoteDataSource.getNotifications();
      return Right(remoteNotifications);
    } on ServerException {
      return Left(ServerFailure());
    }
    } else {
      return Left(OfflineFailure());
    }
  }
}