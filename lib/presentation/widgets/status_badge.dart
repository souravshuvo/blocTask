import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool small;

  const StatusBadge({super.key, required this.status, this.small = false});

  Color _getColor() {
    switch (status.toLowerCase()) {
      case 'alive':
        return const Color(0xFF97CE4C);
      case 'dead':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final dotSize = small ? 7.0 : 9.0;
    final fontSize = small ? 11.0 : 13.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.6), blurRadius: 4),
            ],
          ),
        ),
        const SizedBox(width: 5),
        Text(
          status,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
