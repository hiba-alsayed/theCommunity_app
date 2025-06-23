import '../../domain/entites/complaint_category_entity.dart';

class ComplaintCategoryModel  extends ComplaintCategory {
  ComplaintCategoryModel({required int categoryId, required String name})
      : super(categoryId: categoryId, name: name);

  factory ComplaintCategoryModel.fromJson(Map<String, dynamic> json) {
    // print("Complaint JSON: $json");
    return ComplaintCategoryModel (categoryId: json['category_id'], name: json['name']);

  }
  Map<String, dynamic> toJson() => {'category_id': categoryId, 'name': name};
}
