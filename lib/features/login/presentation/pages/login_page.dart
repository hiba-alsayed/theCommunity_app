import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/core/widgets/loading_widget.dart';
import '../../../../navigation/main_navigation_page.dart';
import '../../../notifications/presentation/firebase/api_notification_firebase.dart';
import '../bloc/login_bloc.dart';
import '../widgets/animated_widget.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
        context.read<LoginBloc>().add(
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم تسجيل الدخول بنجاح')),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MainNavigationPage()),
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
                    colors: [Colors.black,  Color(0xFF00B4D8)],
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            fontSize: 24.sp,
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
                              color: Color(0xFF848484),
                            ),
                            prefixIcon: Icon(Icons.email, color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'كلمة المرور',
                            labelStyle: TextStyle(
                              fontSize: 11.sp,
                              color: Color(0xFF848484),
                            ),
                            prefixIcon: Icon(Icons.lock, color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black, Color(0xFF00B4D8)],
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              minimumSize: Size(double.infinity, 50.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            onPressed: _onLoginPressed,
                            child: Text(
                              'تسجيل الدخول',
                              style: TextStyle(fontSize: 18.sp),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'إنشاء حساب جديد',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    .animate().fade(duration: 800.ms).slideY(begin: 0.2, curve: Curves.easeOut),
              ),
            ],
          );
        },
      ),
    );
  }
}
