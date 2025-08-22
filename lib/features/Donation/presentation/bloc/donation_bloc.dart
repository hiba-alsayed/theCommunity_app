import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graduation_project/features/Donation/domain/usecase/make_donation.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/strings/failures.dart';
import '../../domain/entity/donation_entity.dart';
import '../../domain/entity/my_donations_entity.dart';
import '../../domain/usecase/get_my_donations.dart';

part 'donation_event.dart';
part 'donation_state.dart';

 class DonationInitial extends DonationState {}

class DonationBloc extends Bloc<DonationEvent, DonationState> {
   final MakeDonation makeDonation;
   final GetMyDonations getMyDonations;
   DonationBloc({
      required this.makeDonation,
     required this.getMyDonations,
}) : super(DonationInitial()) {

    on<MakeDonationEvent>((event, emit) async {
     // print("✅ BLOC LAYER: Received event for projectId: ${event.projectId}, amount: ${event.amount}");
      emit(DonationLoading());
      final result = await makeDonation(
        projectId: event.projectId,
        amount: event.amount,
      );
      result.fold(
            (failure) =>
            emit(DonationFailure(errorMessage: _mapFailureToMessage(failure))),
            (donationEntity) =>
            emit(DonationSuccess(donationEntity: donationEntity)),
      );
    });
    on<GetMyDonationsEvent>((event, emit) async {
      emit(MyDonationLoading());
      final result = await getMyDonations();
      result.fold(
            (failure) =>
            emit(MyDonationFailure(errorMessage: _mapFailureToMessage(failure))),
            (donations) =>
            emit(MyDonationsSuccess(donations: donations)),
      );
    });
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case EmptyCacheFailure:
      return EMPTY_CACHE_FAILURE_MESSAGE;
    case OfflineFailure:
      return OFFLINE_FAILURE_MESSAGE;
    default:
      return 'حدث خطأ غير متوقع';
  }
}