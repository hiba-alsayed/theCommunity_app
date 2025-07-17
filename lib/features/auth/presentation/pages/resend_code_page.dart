import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
class ConfirmRegistrationScreen extends StatefulWidget {

  final String email;

  const ConfirmRegistrationScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<ConfirmRegistrationScreen> createState() => _ConfirmRegistrationScreenState();
}
class _ConfirmRegistrationScreenState extends State<ConfirmRegistrationScreen> {
  final _emailController = TextEditingController();
   final _codeController =TextEditingController();
  @override
  void initState() {
    super.initState();
    // If you have an email input field, initialize its text:
    _emailController.text = widget.email;
  }

  @override
  void dispose() {
    _emailController.dispose(); // Dispose if used
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Registration')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // Listen for ResendCode states
          if (state is ResendCodeLoading) {
            // Optionally show a loading indicator or disable UI
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('sending_code' ?? 'Sending code...')),
            );
          } else if (state is ResendCodeSuccess) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide loading snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('code_resent_success' ?? 'Code resent successfully!')),
            );
            // Optionally, restart a timer for the new code expiration
          } else if (state is ResendCodeFailure) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide loading snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }

        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // ... other UI elements for code input, etc.
            children: [
              // Example: Your code input field
              TextFormField(
                controller: _codeController, // Assuming you have a _codeController
                decoration: InputDecoration(labelText: 'Verification Code'),
              ),
              const SizedBox(height: 20),
              // Your Confirm Registration button (if applicable)
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(
                    PerformConfirmRegistration(
                      email: widget.email, // or _emailController.text
                      code: _codeController.text,
                    ),
                  );
                },
                child: Text('Confirm'),
              ),
              const SizedBox(height: 10),

              // Your Resend Code Button
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return TextButton(
                    onPressed: (state is! ResendCodeLoading)
                        ? () {
                      // Dispatch the ResendCodeEvent
                      BlocProvider.of<AuthBloc>(context).add(
                        ResendCodeEvent(
                          email: widget.email, // Use the email from widget properties
                          // If you had an email input field here:
                          // email: _emailController.text,
                        ),
                      );
                    }
                        : null, // Disable button while loading
                    child: Text(
                     'resend_code' ?? 'Resend Code',
                      style: TextStyle(
                        color: (state is ResendCodeLoading) ? Colors.grey : Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}