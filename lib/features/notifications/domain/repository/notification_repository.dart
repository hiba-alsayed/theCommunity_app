import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entity/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
}