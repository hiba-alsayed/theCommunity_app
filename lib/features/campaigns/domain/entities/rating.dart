import 'package:equatable/equatable.dart';
import 'package:google_fonts/google_fonts.dart';

class Rating extends Equatable {
  final int ratingid;
  final int rating;
  final String comment;
  final String user;
  final String date;

  const Rating({
    required this.ratingid,
    required this.rating,
    required this.comment,
    required this.user,
    required this.date,
  });

  @override
  List<Object?> get props => [
    ratingid,rating,comment,user,date,
  ];
}
