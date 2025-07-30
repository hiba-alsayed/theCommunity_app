import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graduation_project/features/complaints/domain/usecases/complaints_category_use_case.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/strings/failures.dart';
import '../../domain/entites/complaint.dart';
import '../../domain/entites/complaint_category_entity.dart';
import '../../domain/entites/regions_entity.dart';
import '../../domain/usecases/get_all_complaints.dart';
import '../../domain/usecases/get_all_nearby_complaints.dart';
import '../../domain/usecases/get_all_regions.dart';
import '../../domain/usecases/get_complaints_by_category.dart';
import '../../domain/usecases/get_nearby_complaints.dart';
import '../../domain/usecases/grt_my_complaints.dart';
import '../../domain/usecases/submit_complaint.dart';

part 'complaint_event.dart';
part 'complaint_state.dart';

class ComplaintInitialState extends ComplaintState{}
class ComplaintBloc extends Bloc<ComplaintEvent, ComplaintState> {
  final GetComplaintsCategoriesUseCase getComplaintsCategoriesUseCase;
  final GetAllComplaintsUseCase getAllComplaintsUseCase;
  final GetComplaintsByCategoryUseCase getComplaintsByCategoryUseCase;
  final GetMyComplaintsUseCase getMyComplaintsUseCase;
  final GetNearbyComplaintsUseCase getNearbyComplaintsUseCase;
  final GetAllRegionsUseCase getAllRegionsUseCase;
  final SubmitComplaintUseCase submitComplaintUseCase;
  final GetAllNearbyComplaintsUseCase getAllNearbyComplaintsUseCase;

  ComplaintBloc( {
    required this.getComplaintsCategoriesUseCase,
    required this.getAllComplaintsUseCase,
    required this.getComplaintsByCategoryUseCase,
    required this.getMyComplaintsUseCase,
    required this.getNearbyComplaintsUseCase,
     required this.getAllRegionsUseCase,
    required this.submitComplaintUseCase,
    required this.getAllNearbyComplaintsUseCase,
  }) : super(ComplaintInitialState()) {


    //  جلب التصنيفات
    on<GetCategoriesEvent>((event, emit) async {
      emit(LoadingCategories());
      final result = await getComplaintsCategoriesUseCase();
      result.fold(
            (failure) {
          emit(ComplaintErrorState(message: "Failed to load categories"));
        },
            (categories) {
          emit(CategoriesLoaded(categories: categories));
        },
      );
    });

    // جلب جميع الشكاوى
    on<GetAllComplaintsEvent>((event, emit) async {
      emit(LoadingComplaints());
      final result = await getAllComplaintsUseCase();
      result.fold(
            (failure) {
              print("Failure: ${failure.toString()}");
          emit(ComplaintErrorState(message: _mapFailureToMessage(failure)));
        },
            (complaints) {
          emit(ComplaintsLoaded(complaints: complaints));
        },
      );
    });
    //جلب الشكاوى حسب التصنيف
    on<GetComplaintsByCategoryEvent>((event, emit) async {
      emit(LoadingComplaintsByCategory());
      final result = await getComplaintsByCategoryUseCase(event.categoryId);
      result.fold(
            (failure) {
          emit(ComplaintErrorState(message: _mapFailureToMessage(failure)));
        },
            (complaints) {
          emit(ComplaintsByCategoryLoaded(complaints: complaints));
        },
      );
    });
    //جلب الشكاوى الخاصة بالمستخدم
    on<GetMyComplaintsEvent>((event, emit) async {
      emit(LoadingMyComplaints());
      final result = await getMyComplaintsUseCase();
      result.fold(
            (failure) {
          emit(ComplaintErrorState(message: _mapFailureToMessage(failure)));
        },
            (complaints) {
          emit(MyComplaintsLoaded(complaints: complaints));
        },
      );
    });
    //جلب الشكاوى القريبة حسب التصنيف والمسافة
    on<GetNearbyComplaintsEvent>((event, emit) async {
      emit(LoadingNearbyComplaints());
      final result = await getNearbyComplaintsUseCase(event.categoryId, event.distance);
      result.fold(
            (failure) => emit(ComplaintErrorState(message: _mapFailureToMessage(failure))),
            (complaints) => emit(NearbyComplaintsLoaded(complaints: complaints)),
      );
    });

    // جلب جميع الشكاوي القريبة
    on<GetAllNearbyComplaintsEvent>((event, emit) async {
      emit(LoadingAllNearbyComplaints());
      final result = await getAllNearbyComplaintsUseCase();
      result.fold(
            (failure) {
          emit(ComplaintErrorState(message: _mapFailureToMessage(failure)));
        },
            (complaints) {
          emit(AllNearbyComplaintsLoaded(complaints: complaints));
        },
      );
    });

    //جلب جميع المناطق
    on<GetAllRegionsEvent>((event, emit) async {
      emit(LoadingRegions());
      final result = await getAllRegionsUseCase();
      result.fold(
            (failure) => emit(ComplaintErrorState(message: _mapFailureToMessage(failure))),
            (regions) => emit(RegionsLoaded(regions: regions)),
      );
    });
   // تقديم شكوى جديدة
    on<SubmitComplaintEvent>((event, emit) async {
      emit(SubmittingComplaint());
      final result = await submitComplaintUseCase(
        event.latitude,
        event.longitude,
        event.area,
        event.title,
        event.description,
        event.complaintCategoryId,
        event.complaintImages,
      );
      result.fold(
            (failure) =>
            emit(ComplaintErrorState(message: _mapFailureToMessage(failure))),
            (unit) => emit(ComplaintSubmittedSuccessfully()),
      );
    });
  }
}


String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case AlreadyJoinedFailure:
      return AlreadyJoinedMessage;
    case EmptyCacheFailure:
      return EMPTY_CACHE_FAILURE_MESSAGE;
    case OfflineFailure:
      return OFFLINE_FAILURE_MESSAGE;
    case AlreadyRatedFailure:
      return ALREADY_RATED_FAILURE_MESSAGE;

    default:
      return 'حدث خطأ غير متوقع';
  }
}