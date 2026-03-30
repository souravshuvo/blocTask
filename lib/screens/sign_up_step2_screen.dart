import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'otp_screen.dart';

class SignUpStep2Screen extends StatefulWidget {
  const SignUpStep2Screen({super.key});

  @override
  State<SignUpStep2Screen> createState() => _SignUpStep2ScreenState();
}

class _SignUpStep2ScreenState extends State<SignUpStep2Screen> {
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  final _rePinController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _pinController.dispose();
    _rePinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const BanglaButton(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Create an account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 32),
                    AppTextField(
                      label: 'Phone Number',
                      hint: '+8801701*****4',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      isRequired: true,
                    ),
                    const SizedBox(height: 20),
                    AppTextField(
                      label: 'Enter 4 Digit PIN',
                      hint: '123456',
                      isPassword: true,
                      controller: _pinController,
                      keyboardType: TextInputType.number,
                      isRequired: true,
                    ),
                    const SizedBox(height: 20),
                    AppTextField(
                      label: 'Re-Enter PIN',
                      hint: '123456',
                      isPassword: true,
                      controller: _rePinController,
                      keyboardType: TextInputType.number,
                      isRequired: true,
                    ),
                    const SizedBox(height: 88),
                    AppButton(
                      text: 'Sign Up',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const OtpScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const Center(child: ContactUsText()),
            const SizedBox(height: 24),
          ],
        ),

      ),
    );
  }
}
