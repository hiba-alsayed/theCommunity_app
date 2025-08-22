import 'package:get_it/get_it.dart';
import 'package:graduation_project/features/Donation/domain/usecase/make_donation.dart';
import 'package:graduation_project/features/auth/domain/usecase/confirm_reset_password.dart';
import 'package:graduation_project/features/auth/domain/usecase/log_out.dart';
import 'package:graduation_project/features/auth/domain/usecase/reset_password.dart';
import 'package:graduation_project/features/campaigns/domain/usecases/get_my_campaigns.dart';
import 'package:graduation_project/features/campaigns/domain/usecases/get_promoted_campaigns.dart';
import 'package:graduation_project/features/campaigns/domain/usecases/get_related_campaign.dart';
import 'package:graduation_project/features/campaigns/domain/usecases/join_campaign.dart';
import 'package:graduation_project/features/campaigns/domain/usecases/rate_completed_campaign.dart';
import 'package:graduation_project/features/campaigns/presentation/bloc/campaign_bloc.dart';
import 'package:graduation_project/features/complaints/domain/repositories/complaints.dart';
import 'package:graduation_project/features/complaints/domain/usecases/get_all_regions.dart';
import 'package:graduation_project/features/complaints/domain/usecases/submit_complaint.dart';
import 'package:graduation_project/features/notifications/domain/repository/notification_repository.dart';
import 'package:graduation_project/features/notifications/domain/usecase/get_notifications_usecase.dart';
import 'package:graduation_project/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:graduation_project/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:graduation_project/features/profile/domain/repository/profile.dart';
import 'package:graduation_project/features/profile/domain/usecases/get_my_profile.dart';
import 'package:graduation_project/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/auth_token_provider.dart';
import 'core/base_url.dart';
import 'core/network/network_info.dart';
import 'features/Donation/data/datasources/donation_remote_data_source.dart';
import 'features/Donation/data/repositories/donation_repository_imp.dart';
import 'features/Donation/domain/repository/donation_repository.dart';
import 'features/Donation/domain/usecase/get_my_donations.dart';
import 'features/Donation/presentation/bloc/donation_bloc.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_imp.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecase/confirm_regestration.dart';
import 'features/auth/domain/usecase/log_in.dart';
import 'features/auth/domain/usecase/resend_code.dart';
import 'features/auth/domain/usecase/sign_up.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/campaigns/data/datasources/campaigns_local_data_source.dart';
import 'features/campaigns/data/datasources/campaigns_remote_data_source.dart';
import 'features/campaigns/data/repositories/campaign_repository_imp.dart';
import 'features/campaigns/domain/repositories/campaign_repository.dart';
import 'features/campaigns/domain/usecases/category_use_case.dart';
import 'features/campaigns/domain/usecases/get_all_campaigns.dart';
import 'features/campaigns/domain/usecases/get_all_campaigns_by_category.dart';
import 'features/campaigns/domain/usecases/get_nearby_campaigns.dart';
import 'features/campaigns/domain/usecases/get_recommended_campaigns.dart';
import 'features/complaints/data/datasources/complaints_local_data_source.dart';
import 'features/complaints/data/datasources/complaints_remote_data_source.dart';
import 'features/complaints/data/repositories/complaints_repository_imp.dart';
import 'features/complaints/domain/usecases/complaints_category_use_case.dart';
import 'features/complaints/domain/usecases/get_all_complaints.dart';
import 'features/complaints/domain/usecases/get_all_nearby_complaints.dart';
import 'features/complaints/domain/usecases/get_complaints_by_category.dart';
import 'features/complaints/domain/usecases/get_nearby_complaints.dart';
import 'features/complaints/domain/usecases/grt_my_complaints.dart';
import 'features/complaints/presentation/bloc/complaint_bloc.dart';
import 'features/notifications/data/datasource/notification_remote_data_source.dart';
import 'features/notifications/data/repository/notification_repository_imp.dart';
import 'features/notifications/presentation/bloc/notification_bloc.dart';
import 'features/profile/domain/usecases/get_profile_by_userid.dart';
import 'features/profile/domain/usecases/update_client_profile.dart';
import 'features/suggestions/data/datasources/suggestion_local_data_source.dart';
import 'features/suggestions/data/datasources/suggestion_remote_data_source.dart';
import 'features/suggestions/data/repositories/suggestions_repository_imp.dart';
import 'features/suggestions/domain/repositories/suggestions_repository.dart';
import 'features/suggestions/domain/usecases/delete_my_suggestion.dart';
import 'features/suggestions/domain/usecases/get_all_suggestions.dart';
import 'features/suggestions/domain/usecases/get_my_suggestions.dart';
import 'features/suggestions/domain/usecases/get_nearby_suggestions.dart';
import 'features/suggestions/domain/usecases/get_suggestion_category.dart';
import 'features/suggestions/domain/usecases/get_suggestions_by_category.dart';
import 'features/suggestions/domain/usecases/submit_suggestion.dart';
import 'features/suggestions/domain/usecases/vote_on_suggestion.dart';
import 'features/suggestions/presentation/bloc/suggestion_bloc.dart';

final sl = GetIt.instance;
Future<void> init() async {

  //Bloc
  sl.registerFactory<SuggestionBloc>(
    () => SuggestionBloc(
      getAllSuggestions: sl(),
      getMySuggestions: sl(),
      submitSuggestion: sl(),
      voteOnSuggestion: sl(),
      getSuggestionsByCategory: sl(),
      getNearbySuggestions:sl(),
      deleteMySuggestion: sl(),
      getSuggestionCategories: sl(),
    ),
  );
sl.registerFactory<CampaignBloc>(
    ()=>CampaignBloc(
      getAllCampaigns: sl(),
      getCategoriesUseCase: sl(),
      getAllCampaignsByCategory: sl(),
      joinCampaign: sl(),
      getMyCampaigns: sl(),
      getNearbyCampaigns: sl(),
      rateCompletedCampaign: sl(),
      getRecommendedCampaigns: sl(),
      getPromotedCampaigns: sl(),
      getRelatedCampaigns: sl(),
    ),
);

  sl.registerFactory<AuthBloc>(
        () => AuthBloc(logIn: sl(), signUp: sl(), confirmRegistrationUseCase: sl(), resendCodeUseCase: sl(), resetPasswordUseCase: sl(), confirmResetPasswordUseCase: sl(), logOut: sl()),
  );
  sl.registerFactory<ComplaintBloc>(
        ()=>ComplaintBloc(
          getComplaintsCategoriesUseCase: sl(),
          getAllComplaintsUseCase: sl(),
          getComplaintsByCategoryUseCase: sl(),
          getMyComplaintsUseCase: sl(),
          getNearbyComplaintsUseCase: sl(),
          getAllRegionsUseCase: sl(),
          submitComplaintUseCase: sl(),
          getAllNearbyComplaintsUseCase: sl(),
    ),
  );
  sl.registerFactory<NotificationBloc>(
        ()=>NotificationBloc(getNotifications: sl()
    ),
  );
  sl.registerFactory<DonationBloc>(
        ()=>DonationBloc(makeDonation: sl(), getMyDonations: sl()
    ),
  );
  sl.registerFactory<ProfileBloc>(
        ()=>ProfileBloc(
            getMyProfileUseCase: sl(),
            getProfileByUserIdUseCase: sl(),
            updateClientProfileUseCase: sl()
    ),
  );

  //Use cases
  sl.registerLazySingleton<GetAllSuggestions>(() => GetAllSuggestions(sl()));
  sl.registerLazySingleton<GetMySuggestions>(() => GetMySuggestions(sl()));
  sl.registerLazySingleton<SubmitSuggestion>(() => SubmitSuggestion(sl()));
  sl.registerLazySingleton<VoteOnSuggestion>(() => VoteOnSuggestion(sl()));
  sl.registerLazySingleton<GetSuggestionsByCategory>(() => GetSuggestionsByCategory(sl()));
  sl.registerLazySingleton<GetSuggestionCategory>(() => GetSuggestionCategory(sl()));
  sl.registerLazySingleton<GetNearbySuggestions>(() => GetNearbySuggestions(sl()));
  sl.registerLazySingleton<DeleteMySuggestion>(() => DeleteMySuggestion(sl()));

sl.registerLazySingleton<GetAllCampaigns>(()=>GetAllCampaigns(sl()));
sl.registerLazySingleton<GetCategoriesUseCase>(()=>GetCategoriesUseCase(sl()));
sl.registerLazySingleton<GetAllCampaignsByCategory>(()=>GetAllCampaignsByCategory(sl()));
sl.registerLazySingleton<JoinCampaign>(()=>JoinCampaign(sl()));
sl.registerLazySingleton<GetMyCampaigns>(()=>GetMyCampaigns(sl()));
sl.registerLazySingleton<GetNearbyCampaigns>(()=>GetNearbyCampaigns(sl()));
sl.registerLazySingleton<RateCompletedCampaign>(()=>RateCompletedCampaign(sl()));
sl.registerLazySingleton<GetRecommendedCampaigns>(()=>GetRecommendedCampaigns(sl()));
sl.registerLazySingleton<GetPromotedCampaigns >(()=>GetPromotedCampaigns (sl()));
sl.registerLazySingleton<GetRelatedCampaigns >(()=>GetRelatedCampaigns (sl()));

  sl.registerLazySingleton<LogIn>(() => LogIn(sl()));
  sl.registerLazySingleton<SignUp>(() => SignUp(sl()));
  sl.registerLazySingleton<ConfirmRegistrationUseCase>(() => ConfirmRegistrationUseCase(sl()));
  sl.registerLazySingleton<ResendCode>(() => ResendCode(sl()));
  sl.registerLazySingleton<ResetPassword>(() => ResetPassword(sl()));
  sl.registerLazySingleton<ConfirmResetPassword>(() => ConfirmResetPassword(sl()));
  sl.registerLazySingleton<LogOut>(() => LogOut(sl()));


  sl.registerLazySingleton<GetComplaintsCategoriesUseCase>(()=>GetComplaintsCategoriesUseCase(sl()));
  sl.registerLazySingleton<GetAllComplaintsUseCase>(()=>GetAllComplaintsUseCase(sl()));
  sl.registerLazySingleton<GetComplaintsByCategoryUseCase>(()=>GetComplaintsByCategoryUseCase(sl()));
  sl.registerLazySingleton<GetMyComplaintsUseCase>(()=>GetMyComplaintsUseCase(sl()));
  sl.registerLazySingleton<GetNearbyComplaintsUseCase >(()=>GetNearbyComplaintsUseCase (sl()));
  sl.registerLazySingleton<GetAllRegionsUseCase >(()=>GetAllRegionsUseCase (sl()));
  sl.registerLazySingleton<SubmitComplaintUseCase >(()=>SubmitComplaintUseCase (sl()));
  sl.registerLazySingleton<GetAllNearbyComplaintsUseCase >(()=>GetAllNearbyComplaintsUseCase (sl()));

  sl.registerLazySingleton<GetNotifications>(()=>GetNotifications(sl()));

  sl.registerLazySingleton<MakeDonation>(()=>MakeDonation(sl()));
  sl.registerLazySingleton<GetMyDonations>(()=>GetMyDonations(sl()));

  sl.registerLazySingleton<GetMyProfile>(()=>GetMyProfile(sl()));
  sl.registerLazySingleton<GetProfileByUserId>(()=>GetProfileByUserId(sl()));
  sl.registerLazySingleton<UpdateClientProfile>(()=>UpdateClientProfile(sl()));


  // Repository
  sl.registerLazySingleton<SuggestionsRepository>(
    () => SuggestionsRepositoryImp(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<CampaignRepository>(
        () => CampaignRepositoryImp(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      sl(),
    ),
  );
  sl.registerLazySingleton<ComplaintsRepository>(
        () => ComplaintsRepositoryImp(
          remoteDataSource: sl(),
          localDataSource: sl(),
          networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<NotificationRepository>(
        () => NotificationRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<DonationRepository>(
        () => DonationRepositoryImp(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Datasources
  sl.registerLazySingleton<SuggestionRemoteDataSource>(
    () => SuggestionRemoteDataSourceImp(client: sl(), tokenProvider: sl(),),
  );
  sl.registerLazySingleton<SuggestionLocalDataSource>(
    () => SuggestionLocalDataSourceImp(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<CampaignRemoteDataSource>(
        () => CampaignRemoteDataSourceImp(client: sl(), tokenProvider: sl(),),
  );
  sl.registerLazySingleton<CampaignLocalDataSource>(
        () => CampaignLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
      client: sl(), tokenProvider:  sl(),
    ),
  );
  sl.registerLazySingleton<ComplaintsRemoteDataSource>(
        () => ComplaintsRemoteDataSourceImp(client: sl(), tokenProvider: sl(),),
  );
  sl.registerLazySingleton<ComplaintLocalDataSource>(
        () => ComplaintLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<NotificationRemoteDataSource>(
        () => NotificationRemoteDataSourceImpl(client: sl(),tokenProvider: sl()),
  );
  sl.registerLazySingleton<DonationRemoteDataSource>(
        () => DonationRemoteDataSourceImp(client: sl(),tokenProvider: sl()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
        () => ProfileRemoteDataSourceImpl(client: sl(),tokenProvider: sl()),
  );


  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImp(sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  sl.registerLazySingleton(() => AuthTokenProvider(sl()));
}
