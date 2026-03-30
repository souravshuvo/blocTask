import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/app_data.dart';
import '../models/models.dart';

class StatementsScreen extends StatelessWidget {
  const StatementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = AppData.transactions;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Statements',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.bgLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.divider),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.filter_list, size: 16, color: AppTheme.textGrey),
                      SizedBox(width: 4),
                      Text('Filter',
                          style: TextStyle(
                              color: AppTheme.textGrey, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: AppTheme.divider),
              itemBuilder: (context, i) {
                return _buildTransactionItem(transactions[i]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(TransactionModel t) {
    final iconData = _getIcon(t.type);
    final iconColor = _getIconColor(t.type);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  t.subtitle,
                  style: const TextStyle(fontSize: 13, color: AppTheme.textGrey),
                ),
                Text(
                  t.date,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textGrey),
                ),
              ],
            ),
          ),
          Text(
            '${t.isCredit ? '+' : ''}${t.amount.toStringAsFixed(0)} TK',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: t.isCredit ? AppTheme.success : AppTheme.error,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'send':
        return Icons.send_outlined;
      case 'add':
        return Icons.add_circle_outline;
      case 'cashout':
        return Icons.money_off_outlined;
      case 'bill':
        return Icons.receipt_outlined;
      default:
        return Icons.swap_horiz;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'send':
        return AppTheme.error;
      case 'add':
        return AppTheme.success;
      case 'cashout':
        return AppTheme.accent;
      case 'bill':
        return AppTheme.primaryDark;
      default:
        return AppTheme.textGrey;
    }
  }
}
