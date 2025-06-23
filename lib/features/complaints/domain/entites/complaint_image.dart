import 'package:equatable/equatable.dart';

class ComplaintImageEntity extends Equatable {
  final int complaintImageId;
  final String url;

  const ComplaintImageEntity({
    required this.complaintImageId,
    required this.url,
  });

  @override
  List<Object?> get props => [complaintImageId, url];
}