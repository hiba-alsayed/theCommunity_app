import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graduation_project/features/notifications/domain/usecase/get_notifications_usecase.dart';
import 'package:meta/meta.dart';

import '../../domain/entity/notification_entity.dart';

part 'notification_event.dart';
part 'notification_state.dart';
final class NotificationInitial extends NotificationState {}

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotifications getNotifications;
  NotificationBloc(
  {required this.getNotifications}
      ) : super(NotificationInitial()) {
    on<GetNotificationEvent>((event, emit) async {
      emit(NotificationLoading());
      final result = await getNotifications();
      result.fold(
            (failure) {
          emit(const NotificationError(message: "Failed to load notifications"));
        },
            (notifications) {
          emit(NotificationLoaded(notifications: notifications));
        },
      );
    });

  }
}
