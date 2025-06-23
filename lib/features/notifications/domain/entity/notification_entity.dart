import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final int id;
  final String title;
  final String body;
  final String createdAt;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, body, createdAt];
}