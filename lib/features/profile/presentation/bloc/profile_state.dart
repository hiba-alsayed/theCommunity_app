part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

//بروفايلي
class ProfileLoading extends ProfileState {
  const ProfileLoading();
}
class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;
  const ProfileLoaded({required this.profile});
  @override
  List<Object?> get props => [profile];
}
class ProfileError extends ProfileState {
  final String message;
  const ProfileError({required this.message});
  @override
  List<Object?> get props => [message];
}
//تحديث البروفايل
class UpdateProfileLoading extends ProfileState {
  const UpdateProfileLoading();
}
class UpdateProfileSuccess extends ProfileState {
  final String message;
  const UpdateProfileSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
class UpdateProfileError extends ProfileState {
  final String message;
  const UpdateProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}