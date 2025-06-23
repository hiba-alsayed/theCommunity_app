import 'package:graduation_project/features/suggestions/data/models/user_model.dart';
import 'package:graduation_project/features/suggestions/domain/entities/Suggestions.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/user.dart';
import 'location_model.dart';

class SuggestionModel extends Suggestions {
  SuggestionModel({
    required int id,
    required String title,
    required String description,
    required String status,
    required dynamic createdat,
    required UserModel user,
    required dynamic imageUrl,
    required dynamic category,
    required MyLocation location,
    required int votesCount,
    required int likes,
    required int dislikes,
    required int numberOfParticipants,
    required String requiredAmount,
    required String type,
  }) : super(
         id: id,
         title: title,
         description: description,
         status: status,
    createdat: createdat,
         user: user,
         imageUrl: imageUrl,
         category: category,
         location: location,
         votesCount: votesCount,
         likes: likes,
         dislikes: dislikes,
         numberOfParticipants: numberOfParticipants,
         requiredAmount: requiredAmount,
         type: type,
       );

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {

    // print("Suggestion JSON: $json");
    // print("🔗 Extracted imageUrl: ${json['image_url']}");

    return SuggestionModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      createdat: json['created_at'],
      user: UserModel.fromJson(json['user']),
      imageUrl: json['image_url'] ?? null,
       category: json['category'],
      location: LocationModel.fromJson(json['location']),
      votesCount: json['votes_count'],
      likes: json['likes'],
      dislikes: json['dislikes'],
      numberOfParticipants: json['number_of_participants'],
      requiredAmount: json['required_amount'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'created_at': createdat,
      'user': user.toJson(),
      'image_url': imageUrl ?? "",
      'category': category,
      'location':
          location is LocationModel
              ? (location as LocationModel).toJson()
              : null,
      'votes_count': votesCount,
      'likes': likes,
      'dislikes': dislikes,
      'number_of_participants': numberOfParticipants,
      'required_amount': requiredAmount,
      'type': type,
    };
  }
}
