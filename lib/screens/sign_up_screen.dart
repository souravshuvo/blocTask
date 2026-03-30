import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'login_screen.dart';
import 'sign_up_step2_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
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
              const Spacer(),
              _buildIllustration(),
              const SizedBox(height: 48),
              const Text(
                'Create Your Epay\nAccount',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                  height: 1.3,
                ),
              ),
              const Spacer(),
              AppButton(
                text: 'Sign Up',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpStep2Screen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.btnDisabled.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const ContactUsText(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: 220,
            height: 220,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF0F3F8),
            ),
          ),
          // Decorative dots
          _dot(color: const Color(0xFF1A3A6B), size: 14, top: 30, left: 90),
          _dot(color: const Color(0xFFE74C3C), size: 28, top: 40, right: 20),
          _dot(color: const Color(0xFF2ECC71), size: 16, top: 115, left: 30),
          _dot(color: const Color(0xFFF5A623), size: 24, bottom: 35, left: 60),
          _dot(color: const Color(0xFF3498DB), size: 14, bottom: 45, right: 60),
          // Phone illustration
          Container(
            width: 90,
            height: 150,
            decoration: BoxDecoration(
              color: AppTheme.primaryDark,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot({
    required Color color,
    required double size,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
