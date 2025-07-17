import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/core/widgets/loading_widget.dart';
import '../../../../navigation/main_navigation_page.dart';
import '../bloc/auth_bloc.dart';

class ConfirmResetPasswordPage extends StatefulWidget {
  final String email;
  const ConfirmResetPasswordPage({super.key, required this.email});

  @override
  State<ConfirmResetPasswordPage> createState() => _ConfirmResetPasswordPageState();
}

class _ConfirmResetPasswordPageState extends State<ConfirmResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _onConfirmResetPressed() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
      ConfirmResetPasswordEvent(
        email: widget.email, // Use the email passed from the previous page
        code: _codeController.text.trim(),
        newPassword: _newPasswordController.text,
        newPasswordConfirmation: _confirmNewPasswordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تأكيد إعادة تعيين كلمة المرور', style: TextStyle(fontSize: 18.sp)),
        backgroundColor: Colors.transparent, // Adjust as per your theme
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // For back button
      ),
      extendBodyBehindAppBar: true, // Allows content to go behind AppBar

      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ConfirmResetPasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is ConfirmResetPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)), // "Password reset successfully"
            );
            // After successful password reset, navigate to login or main page
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const MainNavigationPage()), // Or LoginPage
                  (route) => false, // Remove all previous routes
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
                    colors: [Colors.black, Color(0xFF00B4D8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Animated Background (if you want to reuse it)
              // const AnimatedCircleBackground(), // Uncomment if you have this widget

              Align(
                alignment: Alignment.center,
                child: SingleChildScrollView( // For smaller screens/keyboard
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 80.h),
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
                            'تأكيد كلمة المرور الجديدة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          TextFormField(
                            controller: _codeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'رمز التحقق',
                              labelStyle: TextStyle(
                                fontSize: 11.sp,
                                color: const Color(0xFF848484),
                              ),
                              prefixIcon: const Icon(Icons.vpn_key, color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال رمز التحقق';
                              }
                              if (value.length != 6) { // Assuming 6-digit code
                                return 'رمز التحقق يجب أن يكون 6 أرقام';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                          TextFormField(
                            controller: _newPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'كلمة المرور الجديدة',
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
                                return 'يرجى إدخال كلمة المرور الجديدة';
                              }
                              if (value.length < 6) {
                                return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                          TextFormField(
                            controller: _confirmNewPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'تأكيد كلمة المرور الجديدة',
                              labelStyle: TextStyle(
                                fontSize: 11.sp,
                                color: const Color(0xFF848484),
                              ),
                              prefixIcon: const Icon(Icons.lock_open, color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى تأكيد كلمة المرور الجديدة';
                              }
                              if (value != _newPasswordController.text) {
                                return 'كلمتا المرور غير متطابقتين';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24.h),
                          if (state is ConfirmResetPasswordLoading)
                            const LoadingWidget()
                          else
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.black, Color(0xFF00B4D8)],
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
                                onPressed: _onConfirmResetPressed,
                                child: const Text(
                                  'تأكيد وإعادة تعيين',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                      .animate().fade(duration: 800.ms).slideY(begin: 0.2, curve: Curves.easeOut),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}