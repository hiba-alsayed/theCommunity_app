import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        title: const Text('Confirm Your Account'),
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
                content: Text('Account confirmed successfully!'),
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
                    'Enter the 6-digit code sent to ${widget.email}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 30),
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.blue.withOpacity(0.05),
                      inactiveFillColor: Colors.grey.withOpacity(0.1),
                      selectedFillColor: Colors.blue.withOpacity(0.1),
                      activeColor: Colors.blue,
                      inactiveColor: Colors.grey,
                      selectedColor: Colors.blue,
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
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled && state is! ConfirmRegistrationLoading
                          ? () => _confirmRegistration(context)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: state is ConfirmRegistrationLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'Verify',
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Resend code functionality not yet implemented.')),
                      );
                    }
                        : null,
                    child: const Text(
                      'Resend Code',
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