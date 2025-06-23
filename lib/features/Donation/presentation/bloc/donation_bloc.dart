import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graduation_project/features/Donation/domain/usecase/make_donation.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/strings/failures.dart';
import '../../domain/entity/donation_entity.dart';

part 'donation_event.dart';
part 'donation_state.dart';

 class DonationInitial extends DonationState {}

class DonationBloc extends Bloc<DonationEvent, DonationState> {
   final MakeDonation makeDonation;
  DonationBloc({
      required this.makeDonation
}) : super(DonationInitial()) {
    on<MakeDonationEvent>((event, emit) async {
      print("✅ BLOC LAYER: Received event for projectId: ${event.projectId}, amount: ${event.amount}");
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