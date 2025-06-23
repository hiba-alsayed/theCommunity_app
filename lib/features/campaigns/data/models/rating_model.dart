import '../../domain/entities/rating.dart';

class RatingModel extends Rating {
  RatingModel({
    int? ratingid,
    int? rating,
    String? comment,
    String? user,
    String? date,
  }) : super(
    ratingid: ratingid!,
    rating: rating!,
    comment: comment!,
    user: user!,
    date: date!,
  );

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      ratingid: json['ratingID'],
      rating: json['rating'],
      comment: json['comment'],
      user: json['user'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() => {
    'ratingID': ratingid,
    'rating': rating,
    'comment': comment,
    'user': user,
    'date': date,
  };
}
