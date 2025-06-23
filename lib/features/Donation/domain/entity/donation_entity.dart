import 'package:equatable/equatable.dart';

class DonationEntity extends Equatable {
  final bool status;
  final String message;
  final String url;

  const DonationEntity({
    required this.status,
    required this.message,
    required this.url,
  });

  @override
  List<Object?> get props => [status, message, url];
}
