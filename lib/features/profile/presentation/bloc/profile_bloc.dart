import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/strings/failures.dart';
import '../../domain/entity/profile_entity.dart';
import '../../domain/usecases/get_my_profile.dart';
import '../../domain/usecases/get_profile_by_userid.dart';
import '../../domain/usecases/update_client_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

final class ProfileInitial extends ProfileState {}
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetMyProfile getMyProfileUseCase;
  final GetProfileByUserId getProfileByUserIdUseCase;
  final UpdateClientProfile updateClientProfileUseCase;

  ProfileBloc({required this.getMyProfileUseCase,required this.getProfileByUserIdUseCase, required this.updateClientProfileUseCase, }) : super(ProfileInitial()) {


    on<GetMyProfileEvent>((event, emit) async {
      emit(const ProfileLoading());
      try {
        final result = await getMyProfileUseCase();

        result.fold(
              (failure) => emit(ProfileError(message: _mapFailureToMessage(failure))),
              (profile) => emit(ProfileLoaded(profile: profile)),
        );
      } catch (e) {
        print("❌ UNHANDLED ERROR in GetMyProfileEvent: $e");
        emit(const ProfileError(message: "An unexpected error occurred while loading your profile."));
      }
    });

    on<GetProfileByUserIdEvent>((event, emit) async {
      emit(const ProfileLoading());
      try {
        final result = await getProfileByUserIdUseCase(event.userId);
        result.fold(
              (failure) => emit(ProfileError(message: _mapFailureToMessage(failure))),
              (profile) => emit(ProfileLoaded(profile: profile)),
        );
      } catch (e) {
        print("❌ UNHANDLED ERROR in GetProfileByUserIdEvent for user ${event.userId}: $e");
        emit(const ProfileError(message: "An unexpected error occurred while loading the user's profile."));
      }
    });

    on<UpdateClientProfileEvent>((event, emit) async {
      emit(const UpdateProfileLoading());
      try {
        final result = await updateClientProfileUseCase(
          age: event.age,
          phone: event.phone,
          gender: event.gender,
          bio: event.bio,
          deviceToken: event.deviceToken,
          volunteerFields: event.volunteerFields,
          longitude: event.longitude,
          latitude: event.latitude,
          area: event.area,
          skills: event.skills,
        );
        result.fold(
              (failure) => emit(UpdateProfileError(message: _mapFailureToMessage(failure))),
              (message) => emit(UpdateProfileSuccess(message: message)),
        );
      } catch (e) {
        print("❌ UNHANDLED ERROR in UpdateClientProfileEvent: $e");
        emit(const UpdateProfileError(message: "An unexpected error occurred while updating your profile."));
      }
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