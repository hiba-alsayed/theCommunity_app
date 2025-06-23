import 'package:equatable/equatable.dart';

class MyCategory extends Equatable{
  final int id;
  final String name;

  MyCategory({required this.id, required this.name});
  @override

  List<Object?> get props => [id,name];

}