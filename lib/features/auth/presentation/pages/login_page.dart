import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/core/widgets/loading_widget.dart';
import 'package:graduation_project/features/auth/presentation/pages/signup-page.dart';
import '../../../../core/app_color.dart';
import '../../../../core/widgets/snack_bar.dart';
import '../../../../navigation/main_navigation_page.dart';
import '../../../notifications/presentation/firebase/api_notification_firebase.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/animated_widget.dart';
import 'confirm_reset_password_page.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final resetEmailController = TextEditingController();
  final firebaseApi = FirebaseApi();

  void _onLoginPressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      final String? fcmToken = await firebaseApi.getFCMToken();
      if (fcmToken == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not get notification token. Please check your connection and try again.')),
          );
        }
        return;
      }
      if (mounted) {
        context.read<AuthBloc>().add(
          PerformLogin(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            deviceToken: fcmToken,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred: $e')),
        );
      }
    }
  }

  // void _onResetPasswordPressed() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext dialogContext) {
  //       return AlertDialog(
  //         title: const Text('إعادة تعيين كلمة المرور'),
  //         content: TextField(
  //           controller: resetEmailController,
  //           keyboardType: TextInputType.emailAddress,
  //           decoration: const InputDecoration(
  //             hintText: 'أدخل بريدك الإلكتروني',
  //             labelText: 'البريد الإلكتروني',
  //             border: OutlineInputBorder(),
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('إلغاء'),
  //             onPressed: () {
  //               Navigator.of(dialogContext).pop();
  //               resetEmailController.clear();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text('إعادة تعيين'),
  //             onPressed: () {
  //               if (resetEmailController.text.trim().isEmpty) {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   buildGlassySnackBar(
  //                     message: 'يرجى إدخال البريد الإلكتروني أولاً.',
  //                     color: AppColors.RichBerry,
  //                     context: context,
  //                   ),
  //                 );
  //                 return;
  //               }
  //               final email = resetEmailController.text.trim();
  //               Navigator.of(dialogContext).pop();
  //               resetEmailController.clear();
  //               context.read<AuthBloc>().add(
  //                 ResetPasswordEvent(email: email),
  //               );
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  void _onResetPasswordPressed() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      transitionDuration: 400.ms,
      transitionBuilder: (context, anim1, anim2, child) {
        return Animate(
          effects: [
            FadeEffect(duration: 400.ms, curve: Curves.easeOut),
            ScaleEffect(duration: 400.ms, curve: Curves.easeOut),
          ],
          child: child,
        );
      },
      pageBuilder: (dialogContext, anim1, anim2) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Theme.of(dialogContext).canvasColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.OceanBlue.withOpacity(0.1),
                  child: Icon(
                    Icons.lock_reset_rounded,
                    size: 30,
                    color: AppColors.OceanBlue,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 200.ms)
                    .shake(hz: 3, duration: 800.ms),

                const SizedBox(height: 16),

                // Title
                Text(
                  'إعادة تعيين كلمة المرور',
                  style: Theme.of(dialogContext)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                )
                    .animate()
                    .fadeIn(delay: 300.ms)
                    .slideY(begin: 0.5, duration: 600.ms),

                const SizedBox(height: 24),

                // Email field
                TextField(
                  controller: resetEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    hintText: 'أدخل بريدك الإلكتروني',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.grey.shade600,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 400.ms)
                    .slideY(begin: 0.5, duration: 600.ms),

                const SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        resetEmailController.clear();
                      },
                      child: const Text(
                        'إلغاء',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.OceanBlue,
                            Colors.blue.shade400,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.OceanBlue.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (resetEmailController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              buildGlassySnackBar(
                                message: 'يرجى إدخال البريد الإلكتروني أولاً.',
                                color: AppColors.RichBerry,
                                context: context,
                              ),
                            );
                            return;
                          }
                          final email = resetEmailController.text.trim();
                          Navigator.of(dialogContext).pop();
                          resetEmailController.clear();
                          context.read<AuthBloc>().add(
                            ResetPasswordEvent(email: email),
                          );
                        },
                        label: const Text('إعادة تعيين'),
                        icon: const Icon(Icons.send_rounded, size: 18),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(delay: 500.ms)
                    .slideY(begin: 0.5, duration: 600.ms),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    resetEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              buildGlassySnackBar(
                message: state.message,
                color: AppColors.RichBerry,
                context: context,
              ),
            );
          }
          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              buildGlassySnackBar(
                message: 'تم تسجيل الدخول بنجاح',
                color: AppColors.CedarOlive,
                context: context,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MainNavigationPage()),
            );
          }
          if (state is ResetPasswordLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              buildGlassySnackBar(
                message: ' جاري إرسال بريد إعادة تعيين كلمة المرور...',
                color: AppColors.CedarOlive,
                context: context,
              ),
            );
          }

          if (state is ResetPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ConfirmResetPasswordPage(email:state.email,),
              ),
            );
          }
          if (state is ResetPasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Gradient Background
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Color(0xFF0172B2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Positioned(
                top: 40.h,
                right: 20.w,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/athar_white.png',
                      width: 40.w,
                      height: 40.h,
                    ),
                  ],
                ),
              ),
              const AnimatedCircleBackground(),
              Positioned(
                top: 280.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    "لتبدأ معنا رحلة العطاء والبناء\n قم بتسجيل الدخول!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.all(10.w),
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15.r,
                        spreadRadius: 5.r,
                        offset: Offset(0, 10.h),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'البريد الإلكتروني',
                              labelStyle: TextStyle(
                                fontSize: 11.sp,
                                color: const Color(0xFF848484),
                              ),
                              prefixIcon: const Icon(Icons.email, color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'يرجى إدخال البريد الإلكتروني';
                              }
                              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (!emailRegex.hasMatch(value.trim())) {
                                return 'يرجى إدخال بريد إلكتروني صالح';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'كلمة المرور',
                              labelStyle: TextStyle(
                                fontSize: 11.sp,
                                color: const Color(0xFF848484),
                              ),
                              prefixIcon: const Icon(Icons.lock, color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال كلمة المرور';
                              }
                              if (value.length < 6) {
                                return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24.h),
                          if (state is LoginLoading || state is ResetPasswordLoading || state is ConfirmResetPasswordLoading)
                            const LoadingWidget()
                          else
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.white, Color(0xFF0172B2)],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: _onLoginPressed,
                                child: const Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          SizedBox(height: 12.h),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SignUpPage()
                                ),
                              );
                            },
                            child: Text(
                              'إنشاء حساب جديد',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey.shade400,
                                  height: 1.h,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Text(
                                  'أو',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey.shade400,
                                  height: 1.h,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          TextButton(
                            onPressed: _onResetPasswordPressed,
                            child: Text(
                              'هل نسيت كلمة السر؟',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                        ],
                      ),
                    ),
                  ),
                ).animate().fade(duration: 800.ms).slideY(begin: 0.2, curve: Curves.easeOut),
              ),
            ],
          );
        },
      ),
    );
  }
}
