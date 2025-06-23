import '../../domain/entites/complaint_image.dart';

class ComplaintImageModel extends ComplaintImageEntity {
  const ComplaintImageModel({
    required int complaintImageId,
    required String url,
  }) : super(complaintImageId: complaintImageId, url: url);

  factory ComplaintImageModel.fromJson(Map<String, dynamic> json) {
    return ComplaintImageModel(
      complaintImageId: json['complaint_image_id'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'complaint_image_id': complaintImageId,
      'url': url,
    };
  }
}
