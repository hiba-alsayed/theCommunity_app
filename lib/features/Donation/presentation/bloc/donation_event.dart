part of 'donation_bloc.dart';

sealed class DonationEvent extends Equatable {
  const DonationEvent();
  @override
  List<Object?> get props => [];
}
class MakeDonationEvent extends DonationEvent {
  final int projectId;
  final double amount;

  const MakeDonationEvent({
    required this.projectId,
    required this.amount,
  });

  @override
  List<Object?> get props => [projectId, amount];
}