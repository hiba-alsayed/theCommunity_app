import '../../domain/entites/achievement_image.dart';

class AchievementImageModel extends AchievementImageEntity {
  const AchievementImageModel({
    required int achievementImageId,
    required String url,
  }) :super(achievementImageId: achievementImageId, url:url);

  factory AchievementImageModel.fromJson(Map<String, dynamic> json) {
    return AchievementImageModel(
      achievementImageId: json['achievement_image_id'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'achievement_image_id': achievementImageId, 'url': url};
  }
}
