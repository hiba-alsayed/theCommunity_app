// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:graduation_project/core/widgets/loading_widget.dart';
// import '../../../../navigation/main_navigation_page.dart';
// import '../../../notifications/presentation/firebase/api_notification_firebase.dart';
// import '../bloc/auth_bloc.dart';
// import '../widgets/animated_widget.dart';
//
//
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final firebaseApi = FirebaseApi();
//
//   void _onLoginPressed() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//     try {
//       final String? fcmToken = await firebaseApi.getFCMToken();
//       if (fcmToken == null) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Could not get notification token. Please check your connection and try again.')),
//           );
//         }
//         return;
//       }
//       if (mounted) {
//         context.read<AuthBloc>().add(
//           PerformLogin(
//             email: emailController.text.trim(),
//             password: passwordController.text.trim(),
//             deviceToken: fcmToken,
//           ),
//         );
//       }
//
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('An unexpected error occurred: $e')),
//         );
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocConsumer<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is LoginFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//           if (state is LoginSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('تم تسجيل الدخول بنجاح')),
//             );
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => MainNavigationPage()),
//             );
//           }
//         },
//         builder: (context, state) {
//           return Stack(
//             fit: StackFit.expand,
//             children: [
//               // Gradient Background
//               Container(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.black,  Color(0xFF00B4D8)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 40.h,
//                 right: 20.w,
//                 child: Row(
//                   children: [
//                     Image.asset(
//                       'assets/athar_white.png',
//                       width: 40.w,
//                       height: 40.h,
//                     ),
//                   ],
//                 ),
//               ),
//               const AnimatedCircleBackground(),
//               Positioned(
//                 top: 280.h,
//                 left: 0,
//                 right: 0,
//                 child: Center(
//                   child: Text(
//                     "لتبدأ معنا رحلة العطاء والبناء\n قم بتسجيل الدخول!",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Container(
//                   margin: EdgeInsets.all(10.w),
//                   padding: EdgeInsets.all(24.w),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(32.r),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 15.r,
//                         spreadRadius: 5.r,
//                         offset: Offset(0, 10.h),
//                       ),
//                     ],
//                   ),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           'تسجيل الدخول',
//                           style: TextStyle(
//                             fontSize: 24.sp,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         SizedBox(height: 24.h),
//                         TextFormField(
//                           controller: emailController,
//                           decoration: InputDecoration(
//                             labelText: 'البريد الإلكتروني',
//                             labelStyle: TextStyle(
//                               fontSize: 11.sp,
//                               color: Color(0xFF848484),
//                             ),
//                             prefixIcon: Icon(Icons.email, color: Colors.black),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12.r),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.trim().isEmpty) {
//                               return 'يرجى إدخال البريد الإلكتروني';
//                             }
//                             final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//                             if (!emailRegex.hasMatch(value.trim())) {
//                               return 'يرجى إدخال بريد إلكتروني صالح';
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: 16.h),
//                         TextFormField(
//                           controller: passwordController,
//                           obscureText: true,
//                           decoration: InputDecoration(
//                             labelText: 'كلمة المرور',
//                             labelStyle: TextStyle(
//                               fontSize: 11.sp,
//                               color: Color(0xFF848484),
//                             ),
//                             prefixIcon: Icon(Icons.lock, color: Colors.black),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12.r),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'يرجى إدخال كلمة المرور';
//                             }
//                             if (value.length < 6) {
//                               return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: 24.h),
//                         state is LoginLoading
//                             ? const LoadingWidget()
//                             : Container(
//                           decoration: BoxDecoration(
//                             gradient: const LinearGradient(
//                               colors: [Colors.black, Color(0xFF00B4D8)],
//                             ),
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.transparent,
//                               shadowColor: Colors.transparent,
//                               foregroundColor: Colors.white,
//                               minimumSize: const Size(double.infinity, 50),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                             ),
//                             onPressed: _onLoginPressed,
//                             child: const Text(
//                               'تسجيل الدخول',
//                               style: TextStyle(
//                                 fontSize: 18,
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 12.h),
//                         TextButton(
//                           onPressed: () {},
//                           child: Text(
//                             'إنشاء حساب جديد',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black54,
//                               fontSize: 14.sp,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//                     .animate().fade(duration: 800.ms).slideY(begin: 0.2, curve: Curves.easeOut),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/core/widgets/loading_widget.dart';
import 'package:graduation_project/features/auth/presentation/pages/signup-page.dart';
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

  void _onResetPasswordPressed() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('إعادة تعيين كلمة المرور'),
          content: TextField(
            controller: resetEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'أدخل بريدك الإلكتروني',
              labelText: 'البريد الإلكتروني',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('إلغاء'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                resetEmailController.clear(); // Clear controller if dialog is dismissed
              },
            ),
            TextButton(
              child: const Text('إعادة تعيين'),
              onPressed: () {
                if (resetEmailController.text.trim().isEmpty) {
                  // Show a local snackbar within the dialog context
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('يرجى إدخال البريد الإلكتروني أولاً.')),
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
            ),
          ],
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
          if (state is ResetPasswordLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('جاري إرسال بريد إعادة تعيين كلمة المرور...')),
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
                    // colors: [Colors.black, Color(0xFF00B4D8)],
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            fontSize: 22.sp,
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
                                // tileMode: TileMode.repeated,
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _onResetPasswordPressed,
                            child: Text(
                              'هل نسيت كلمة السر؟',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                                fontSize: 14.sp,
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
