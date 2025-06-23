import 'package:equatable/equatable.dart';

class ComplaintCategory extends Equatable {
  final int categoryId;
  final String name;

  ComplaintCategory({required this.categoryId, required this.name});
  @override
  List<Object?> get props => [categoryId, name];
}
