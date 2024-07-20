import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  OtpScreen({super.key, required this.phoneNumber});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  late Timer _timer;
  int _start = 60;
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _start = 60;
    _isResendEnabled = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isResendEnabled = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _resendCode() {
    context.read<AuthBloc>().add(SendOtp(phoneNumber: widget.phoneNumber));
    _startTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Enter the 6-digit OTP sent to ${widget.phoneNumber}'),
            const SizedBox(height: 20),
            TextFormField(
              controller: _otpController,
              decoration: const InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                  VerifyOtp(phoneNumber: widget.phoneNumber, otp: _otpController.text),
                );
              },
              child: const Text('Verify OTP'),
            ),
            const SizedBox(height: 20),
            Text(
              'Resend code in $_start seconds',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isResendEnabled ? _resendCode : null,
              child: const Text('Resend Code'),
            ),
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is OtpVerified) {
                  Navigator.of(context).pop();
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}