part of 'complaint_bloc.dart';


sealed class ComplaintState extends Equatable{
  const ComplaintState();
  @override
  List<Object?> get props => [];
}

// جلب التصنيفات
class LoadingCategories extends ComplaintState {}
class CategoriesLoaded extends ComplaintState {
  final List<ComplaintCategory> categories;

  CategoriesLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}


// جلب جميع الشكاوى
class LoadingComplaints extends ComplaintState {}
class ComplaintsLoaded extends ComplaintState {
  final List<ComplaintEntity> complaints;

  ComplaintsLoaded({required this.complaints});

  @override
  List<Object> get props => [complaints];
}

//جلب الشكاوى حسب التصنيف
class LoadingComplaintsByCategory extends ComplaintState {}
class ComplaintsByCategoryLoaded extends ComplaintState {
  final List<ComplaintEntity> complaints;

  const ComplaintsByCategoryLoaded({required this.complaints});

  @override
  List<Object> get props => [complaints];
}

//جلب الشكاوى الخاصة بالمستخدم
class LoadingMyComplaints extends ComplaintState {}
class MyComplaintsLoaded extends ComplaintState {
  final List<ComplaintEntity> complaints;

  const MyComplaintsLoaded({required this.complaints});

  @override
  List<Object> get props => [complaints];
}

// جلب الشكاوي القريبة
class LoadingNearbyComplaints extends ComplaintState {}
class NearbyComplaintsLoaded extends ComplaintState {
  final List<ComplaintEntity> complaints;

  const NearbyComplaintsLoaded({required this.complaints});

  @override
  List<Object> get props => [complaints];
}

// جلب جميع المناطق
class LoadingRegions extends ComplaintState {}
class RegionsLoaded extends ComplaintState {
  final List<RegionEntity> regions;

  const RegionsLoaded({required this.regions});

  @override
  List<Object> get props => [regions];
}

// تقديم شكوى جديدة
class SubmittingComplaint extends ComplaintState {}
class ComplaintSubmittedSuccessfully extends ComplaintState {}

// حالة الخطأ
class ComplaintErrorState extends ComplaintState {
  final String message;

  ComplaintErrorState({required this.message});


  @override
  List<Object> get props => [message];
}

// حالة نجاح مع رسالة
class MessageState extends ComplaintState {
  final String message;

  MessageState({required this.message});

  @override
  List<Object> get props => [message];
}
