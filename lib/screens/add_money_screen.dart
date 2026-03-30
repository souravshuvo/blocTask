import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  bool _isBankToEkpay = true;
  int _selectedSource = 0; // 0 = Bank Account, 1 = Internet Banking

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Money'),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab selector
            Row(
              children: [
                Expanded(child: _buildTab('Bank to Ekpay', Icons.food_bank, true)),
                const SizedBox(width: 8),
                Expanded(child: _buildTab('Card to Ekpay', Icons.credit_card_outlined, false)),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Select Your Add Money Source',
                style: TextStyle(color: AppTheme.textGrey, fontSize: 13),
              ),
            ),
            const Divider(height: 24),
            _buildSourceOption(0, 'Bank Account', Icons.account_balance_outlined),
            const SizedBox(height: 12),
            _buildSourceOption(1, 'Internet Banking', Icons.language),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, IconData icon, bool isBankTab) {
    final isActive = _isBankToEkpay == isBankTab;
    return GestureDetector(
      onTap: () => setState(() => _isBankToEkpay = isBankTab),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryDark : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? AppTheme.primaryDark : AppTheme.divider,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isActive ? Colors.white : AppTheme.primaryDark, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : AppTheme.primaryDark,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption(int index, String label, IconData icon) {
    final isSelected = _selectedSource == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedSource = index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppTheme.primaryDark : AppTheme.divider,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryDark, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.primaryDark,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const Spacer(),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppTheme.primaryDark : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppTheme.primaryDark : AppTheme.divider,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}


