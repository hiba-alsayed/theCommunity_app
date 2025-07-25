// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:graduation_project/core/app_color.dart';
// import 'package:graduation_project/navigation/main_navigation_page.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import '../bloc/auth_bloc.dart';
//
// class ConfirmationPage extends StatefulWidget {
//   final String email;
//
//   const ConfirmationPage({
//     Key? key,
//     required this.email,
//   }) : super(key: key);
//
//   @override
//   State<ConfirmationPage> createState() => _ConfirmationPageState();
// }
//
// class _ConfirmationPageState extends State<ConfirmationPage> {
//   final TextEditingController _pinCodeController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool _isButtonEnabled = false;
//
//   @override
//   void dispose() {
//     _pinCodeController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('قم بتأكيد حسابك'),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         foregroundColor: Colors.black,
//       ),
//       body: BlocConsumer<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is ConfirmRegistrationSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('تم تأكيد الحساب بنجاح!'),
//                 backgroundColor: Colors.green,
//               ),
//             );
//             Navigator.of(context).push(MaterialPageRoute(builder: (_) => MainNavigationPage()));
//           } else if (state is ConfirmRegistrationFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           return Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 40),
//                   Text(
//                     'أدخل الرمز المكون من 6 أرقام المرسل إلى${widget.email}',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   Directionality(
//                     textDirection: TextDirection.ltr,
//                     child: PinCodeTextField(
//                       appContext: context,
//                       length: 6,
//                       obscureText: false,
//                       animationType: AnimationType.fade,
//                       pinTheme: PinTheme(
//                         shape: PinCodeFieldShape.box,
//                         borderRadius: BorderRadius.circular(8),
//                         fieldHeight: 50,
//                         fieldWidth: 40,
//                         activeFillColor:AppColors.OceanBlue.withOpacity(0.05),
//                         inactiveFillColor: Colors.grey.withOpacity(0.1),
//                         selectedFillColor: AppColors.OceanBlue.withOpacity(0.1),
//                         activeColor: AppColors.OceanBlue,
//                         inactiveColor: Colors.grey,
//                         selectedColor: AppColors.OceanBlue,
//                       ),
//                       animationDuration: const Duration(milliseconds: 300),
//                       backgroundColor: Colors.transparent,
//                       enableActiveFill: true,
//                       controller: _pinCodeController,
//                       keyboardType: TextInputType.number,
//                       onChanged: (value) {
//                         setState(() {
//                           _isButtonEnabled = value.length == 6;
//                         });
//                       },
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter the code';
//                         } else if (value.length < 6) {
//                           return 'Code must be 6 digits';
//                         }
//                         return null;
//                       },
//                       onCompleted: (v) {
//                         if (_isButtonEnabled) {
//                           _confirmRegistration(context);
//                         }
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: _isButtonEnabled && state is! ConfirmRegistrationLoading
//                           ? () => _confirmRegistration(context)
//                           : null,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.OceanBlue,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: state is ConfirmRegistrationLoading
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : const Text(
//                         'تأكيد',
//                         style: TextStyle(fontSize: 18, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextButton(
//                     onPressed: state is! ConfirmRegistrationLoading
//                         ? () {
//                       BlocProvider.of<AuthBloc>(context).add(
//                         ResendCodeEvent(email: widget.email),
//                       );
//                     }
//                         : null,
//                     child: const Text(
//                       'إعادة إرسال الرمز',
//                       style: TextStyle(
//                         color: Colors.blue,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void _confirmRegistration(BuildContext context) {
//     if (_formKey.currentState?.validate() ?? false) {
//       final String code = _pinCodeController.text;
//       context.read<AuthBloc>().add(
//         PerformConfirmRegistration(
//           email: widget.email,
//           code: code,
//         ),
//       );
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/app_color.dart';
import 'package:graduation_project/navigation/main_navigation_page.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../bloc/auth_bloc.dart';

class ConfirmationPage extends StatefulWidget {
  final String email;

  const ConfirmationPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  final TextEditingController _pinCodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;

  @override
  void dispose() {
    _pinCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قم بتأكيد حسابك'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ConfirmRegistrationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تأكيد الحساب بنجاح!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => MainNavigationPage()));
          } else if (state is ConfirmRegistrationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ResendCodeSuccess) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('تم إرسال الرمز'),
                  content: Text('تم إرسال رمز جديد إلى ${widget.email}'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text('حسناً'),
                    ),
                  ],
                );
              },
            );
          } else if (state is ResendCodeFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('فشل في إعادة إرسال الرمز: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'أدخل الرمز المكون من 6 أرقام المرسل إلى ${widget.email}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: PinCodeTextField(
                      appContext: context,
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor:AppColors.OceanBlue.withOpacity(0.05),
                        inactiveFillColor: Colors.grey.withOpacity(0.1),
                        selectedFillColor: AppColors.OceanBlue.withOpacity(0.1),
                        activeColor: AppColors.OceanBlue,
                        inactiveColor: Colors.grey,
                        selectedColor: AppColors.OceanBlue,
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      controller: _pinCodeController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _isButtonEnabled = value.length == 6;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the code';
                        } else if (value.length < 6) {
                          return 'Code must be 6 digits';
                        }
                        return null;
                      },
                      onCompleted: (v) {
                        if (_isButtonEnabled) {
                          _confirmRegistration(context);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled && state is! ConfirmRegistrationLoading
                          ? () => _confirmRegistration(context)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.OceanBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: state is ConfirmRegistrationLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'تأكيد',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: state is! ConfirmRegistrationLoading
                        ? () {
                      BlocProvider.of<AuthBloc>(context).add(
                        ResendCodeEvent(email: widget.email),
                      );
                    }
                        : null,
                    child: const Text(
                      'إعادة إرسال الرمز',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _confirmRegistration(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final String code = _pinCodeController.text;
      context.read<AuthBloc>().add(
        PerformConfirmRegistration(
          email: widget.email,
          code: code,
        ),
      );
    }
  }
}
