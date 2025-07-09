import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final double width;
  final double height;
  final Text tittleText;
  final VoidCallback onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    this.width = double.infinity,
    required this.height,
    required this.onPressed,
    required this.tittleText,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF004D60),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // No border radius
          ),
        ),
        child:
            isLoading
                ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                : DefaultTextStyle(
                  style: const TextStyle(color: Colors.white),
                  child: tittleText,
                ),
      ),
    );
  }
}
