import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../data/app_data.dart';
import 'sign_up_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Trusted by millions an essential part of your Financial journey',
      'icon': 'trust',
    },
    {
      'title': 'Pay all Bills in Bangladesh in hassle Free',
      'icon': 'payment',
    },
    {
      'title': 'Reliable and secure money transaction over the world',
      'icon': 'security',
    },
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _goToSignUp();
    }
  }

  void _goToSignUp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignUpScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: const BanglaButton(),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _OnboardingPage(data: _pages[index]);
                },
              ),
            ),
            _buildDots(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: AppButton(
                text: 'Next',
                onPressed: _next,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _goToSignUp,
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: AppTheme.primaryDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (i) {
        final isActive = i == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 28 : 10,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primaryDark : AppTheme.divider,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 220,
            height: 220,
            child: _buildIllustration(data['icon']),
          ),
          const SizedBox(height: 48),
          Text(
            data['title'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration(String icon) {
    switch (icon) {
      case 'trust':
        return CustomPaint(painter: _TrustPainter());
      case 'payment':
        return CustomPaint(painter: _PaymentPainter());
      case 'security':
        return CustomPaint(painter: _SecurityPainter());
      default:
        return const SizedBox();
    }
  }
}

// Handshake + shield illustration
class _TrustPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width / 2;
    final cy = size.height / 2 + 20;

    // Shield
    final shieldPath = Path()
      ..moveTo(cx, cy - 90)
      ..lineTo(cx + 35, cy - 70)
      ..lineTo(cx + 35, cy - 40)
      ..quadraticBezierTo(cx + 35, cy - 10, cx, cy + 5)
      ..quadraticBezierTo(cx - 35, cy - 10, cx - 35, cy - 40)
      ..lineTo(cx - 35, cy - 70)
      ..close();
    canvas.drawPath(shieldPath, paint);

    // Checkmark in shield
    final checkPaint = Paint()
      ..color = AppTheme.primaryDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final checkPath = Path()
      ..moveTo(cx - 12, cy - 52)
      ..lineTo(cx - 4, cy - 44)
      ..lineTo(cx + 14, cy - 62);
    canvas.drawPath(checkPath, checkPaint);

    // Left arm
    final leftArmPath = Path()
      ..moveTo(cx - 60, cy + 10)
      ..lineTo(cx - 35, cy + 10)
      ..lineTo(cx - 15, cy - 5);
    canvas.drawPath(leftArmPath, paint);

    // Right arm
    final rightArmPath = Path()
      ..moveTo(cx + 60, cy + 10)
      ..lineTo(cx + 35, cy + 10)
      ..lineTo(cx + 15, cy - 5);
    canvas.drawPath(rightArmPath, paint);

    // Hands
    canvas.drawCircle(Offset(cx - 60, cy + 10), 8, paint..style = PaintingStyle.stroke);
    canvas.drawCircle(Offset(cx + 60, cy + 10), 8, paint..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Card/payment illustration
class _PaymentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Card shape rotated
    canvas.save();
    canvas.translate(cx, cy - 10);
    canvas.rotate(-0.4);

    final rect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-70, -45, 140, 90),
      const Radius.circular(14),
    );
    canvas.drawRRect(rect, paint);

    // Chip on card
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-50, -20, 30, 22),
        const Radius.circular(4),
      ),
      paint,
    );

    // Lines on card
    paint.strokeWidth = 3;
    canvas.drawLine(
      const Offset(-50, 15),
      const Offset(50, 15),
      paint,
    );

    canvas.restore();

    // Hand holding card
    final handPath = Path()
      ..moveTo(cx - 40, cy + 60)
      ..quadraticBezierTo(cx - 20, cy + 85, cx, cy + 80)
      ..quadraticBezierTo(cx + 20, cy + 75, cx + 40, cy + 60);
    canvas.drawPath(handPath, paint..strokeWidth = 5);

    // Wrist/sleeve
    canvas.drawLine(
      Offset(cx - 30, cy + 70),
      Offset(cx - 25, cy + 95),
      paint,
    );
    canvas.drawLine(
      Offset(cx + 30, cy + 70),
      Offset(cx + 25, cy + 95),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Shield + phone security illustration
class _SecurityPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Phone
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + 5, cy - 75, 60, 100),
        const Radius.circular(12),
      ),
      paint,
    );
    // Phone camera
    canvas.drawCircle(Offset(cx + 35, cy - 62), 4, paint..style = PaintingStyle.fill);
    paint.style = PaintingStyle.stroke;
    // Phone button
    canvas.drawCircle(Offset(cx + 35, cy + 18), 6, paint);

    // Shield
    final shieldPath = Path()
      ..moveTo(cx - 20, cy - 75)
      ..lineTo(cx + 10, cy - 60)
      ..lineTo(cx + 10, cy - 35)
      ..quadraticBezierTo(cx + 10, cy - 10, cx - 20, cy)
      ..quadraticBezierTo(cx - 50, cy - 10, cx - 50, cy - 35)
      ..lineTo(cx - 50, cy - 60)
      ..close();
    canvas.drawPath(shieldPath, paint);

    // Check on shield
    final checkPath = Path()
      ..moveTo(cx - 38, cy - 42)
      ..lineTo(cx - 27, cy - 32)
      ..lineTo(cx - 8, cy - 55);
    canvas.drawPath(checkPath, paint..strokeWidth = 4);

    // Plus decoration
    paint.strokeWidth = 4;
    canvas.drawLine(Offset(cx - 30, cy - 90), Offset(cx - 30, cy - 78), paint);
    canvas.drawLine(Offset(cx - 36, cy - 84), Offset(cx - 24, cy - 84), paint);

    // Dotted circle arc
    final dotPaint = Paint()
      ..color = AppTheme.primaryDark
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 10; i++) {
      final angle = (i / 10) * 3.14159 + 3.14159 / 2;
      final dx = cx - 20 + 90 * (0 - 1) * 0;
      canvas.drawCircle(
        Offset(
          cx - 30 + 95 * (0.5 - i / 20),
          cy - 75 - i * 4.0,
        ),
        3,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
