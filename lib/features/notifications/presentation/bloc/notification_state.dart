part of 'notification_bloc.dart';


sealed class NotificationState extends Equatable{
  const NotificationState();
  @override
  List<Object?> get props => [];
}


 class NotificationLoading extends NotificationState {}
 class NotificationLoaded extends NotificationState {
   List<NotificationEntity> notifications;

   NotificationLoaded({required this.notifications});

  @override
  List<Object?> get props => [notifications];
}
 class NotificationError extends NotificationState {
  final String message;

  const NotificationError({required this.message});

  @override
  List<Object?> get props => [message];
}