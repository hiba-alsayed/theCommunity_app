import 'package:equatable/equatable.dart';
import 'package:graduation_project/features/Suggestions/domain/entities/user.dart';
import 'package:graduation_project/features/suggestions/data/models/user_model.dart';
import 'location.dart';

class Suggestions extends Equatable {
  final int id;
  final String title;
  final String description;
  final String status;
  final String createdat;
  final UserModel user;
  final dynamic imageUrl;
  final dynamic category;
  final MyLocation location;
  final int votesCount;
   int likes;
   int dislikes;
  final int numberOfParticipants;
  final String requiredAmount;
  final String type;
  Suggestions({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdat,
    required this.user,
    required this.imageUrl,
    required this.category,
    required this.location,
    required this.votesCount,
    required this.likes,
    required this.dislikes,
    required this.numberOfParticipants,
    required this.requiredAmount,
    required this.type,
  });
  @override
  List<Object?> get props => [
    id,
    title,
    description,
    status,
    createdat,
    user,
    imageUrl,
    category,
    location,
    votesCount,
    likes,
    dislikes,
    numberOfParticipants,
    requiredAmount,
  ];
}




