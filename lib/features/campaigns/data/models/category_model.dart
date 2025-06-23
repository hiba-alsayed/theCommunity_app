import 'package:graduation_project/features/campaigns/domain/entities/category.dart';

import '../../../suggestions/presentation/pages/submit_suggestion_page.dart';

class CategoryModel extends MyCategory {
  CategoryModel({required int id, required String name})
    : super(id: id, name: name);

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(id: json['id'], name: json['name']);
  }
  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
