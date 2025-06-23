part of 'notification_bloc.dart';


sealed class NotificationEvent extends Equatable{
  const NotificationEvent();
  @override
  List<Object?> get props => [];
}
//جلب الاشعارات
class GetNotificationEvent extends NotificationEvent {}