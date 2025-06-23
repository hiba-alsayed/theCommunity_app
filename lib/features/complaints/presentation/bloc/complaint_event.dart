part of 'complaint_bloc.dart';


sealed class ComplaintEvent extends Equatable{
  const ComplaintEvent();
  @override
  List<Object?> get props => [];
}

// جلب التصنيفات
class GetCategoriesEvent extends ComplaintEvent {}

// جلب جميع الشكاوي
class GetAllComplaintsEvent extends ComplaintEvent {}
// جلب الشكاوي حسب التصنيف
class GetComplaintsByCategoryEvent extends ComplaintEvent {
  final int categoryId;

  const GetComplaintsByCategoryEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}
//جلب الشكاوى الخاصة بالمستخدم
class GetMyComplaintsEvent extends ComplaintEvent {}
//جلب الشكاوى القريبة حسب المسافة والتصنيف
class GetNearbyComplaintsEvent extends ComplaintEvent {
  final double distance;
  final int categoryId;

  const GetNearbyComplaintsEvent(this.distance, this.categoryId);

  @override
  List<Object?> get props => [distance, categoryId];
}
// جلب جميع المناطق
class GetAllRegionsEvent extends ComplaintEvent {}
// تقديم شكوى جديدة
class SubmitComplaintEvent extends ComplaintEvent {
  final double latitude;
  final double longitude;
  final String area;
  final String title;
  final String description;
  final int complaintCategoryId;
  final List<File> complaintImages;

  const SubmitComplaintEvent({
    required this.latitude,
    required this.longitude,
    required this.area,
    required this.title,
    required this.description,
    required this.complaintCategoryId,
    required this.complaintImages,
  });

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    area,
    title,
    description,
    complaintCategoryId,
    complaintImages,
  ];
}