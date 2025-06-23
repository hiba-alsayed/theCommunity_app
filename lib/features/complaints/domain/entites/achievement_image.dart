import 'package:equatable/equatable.dart';

class AchievementImageEntity extends Equatable {
  final int achievementImageId;
  final String url;

  const AchievementImageEntity({
    required this.achievementImageId,
    required this.url,
  });

  @override
  List<Object?> get props => [achievementImageId, url];
}