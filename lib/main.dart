import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/Donation/presentation/bloc/donation_bloc.dart';
import 'package:graduation_project/features/auth/presentation/pages/login_page.dart';
import 'package:graduation_project/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:graduation_project/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:graduation_project/navigation/main_navigation_page.dart';
import 'core/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/signup-page.dart';
import 'features/campaigns/presentation/bloc/campaign_bloc.dart';
import 'features/complaints/presentation/bloc/complaint_bloc.dart';
import 'features/notifications/presentation/firebase/api_notification_firebase.dart';
import 'features/notifications/presentation/firebase/notification_service.dart';
import 'features/suggestions/presentation/bloc/suggestion_bloc.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await Firebase.initializeApp();
  await NotificationService.init();
  await FirebaseApi().initNotifications();
  runApp(
    ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SuggestionBloc>(create: (_) => di.sl<SuggestionBloc>()),
        BlocProvider<CampaignBloc>(create: (_) => di.sl<CampaignBloc>()),
        BlocProvider<AuthBloc>(create: (_) => di.sl<AuthBloc>()),
        BlocProvider<ComplaintBloc>(create: (_) => di.sl<ComplaintBloc>()),
        BlocProvider<NotificationBloc>(create: (_) => di.sl<NotificationBloc>(),),
        BlocProvider<DonationBloc>(create: (_) => di.sl<DonationBloc>()),
        BlocProvider<ProfileBloc>(create: (_) => di.sl<ProfileBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        home:LoginPage()
      ),
    );
  }
}
