part of 'donation_bloc.dart';

sealed class DonationState extends Equatable {
  const DonationState();
  @override
  List<Object?> get props => [];
}

final class DonationLoading extends DonationState {}
final class DonationSuccess extends DonationState {
  final DonationEntity donationEntity;

  const DonationSuccess({required this.donationEntity});

  @override
  List<Object?> get props => [donationEntity];
}
final class DonationFailure extends DonationState {
  final String errorMessage;

  const DonationFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class MyDonationsSuccess extends DonationState {
  final List<DonationItemEntity> donations;

  const MyDonationsSuccess({required this.donations});

  @override
  List<Object?> get props => [donations];
}
final class MyDonationLoading extends DonationState {}
final class MyDonationFailure extends DonationState {
  final String errorMessage;

  const MyDonationFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}