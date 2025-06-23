import '../../domain/entity/donation_entity.dart';

class DonationModel extends DonationEntity {
  const DonationModel({
    required bool status,
    required String message,
    required String url,
  }) : super(status: status, message: message, url: url);

  factory DonationModel.fromJson(Map<String, dynamic> json) {
    return DonationModel(
      status: json['status'],
      message: json['message'],
      url: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': url,
    };
  }
}
