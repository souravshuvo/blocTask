import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/app_data.dart';
import '../models/models.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final _searchController = TextEditingController();
  String? _selectedPhone;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recentContacts = AppData.recentContacts;
    final allContacts = AppData.allContacts;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Send Money'),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppTheme.inputBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Enter The Name or Number',
                              hintStyle: TextStyle(color: AppTheme.textGrey),
                              isDense: true,
                              filled: false,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                            onChanged: (v) {
                              if (v.length >= 8) {
                                setState(() => _selectedPhone = v);
                              }
                            },
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: AppTheme.textGrey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryDark,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.contacts_outlined,
                      color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                if (recentContacts.isNotEmpty) ...[
                  const Text(
                    'Recent Contacts',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...recentContacts.map((c) => _buildContact(context, c)),
                  const SizedBox(height: 16),
                ],
                const Text(
                  'All Contacts',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                ...allContacts.map((c) => _buildContact(context, c)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContact(BuildContext context, ContactModel contact) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SendMoneyConfirmScreen(
              phone: contact.phone,
              contactName: contact.name,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.bgLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: AppTheme.textGrey, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                Text(
                  '${contact.type} - ${contact.phone}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SendMoneyConfirmScreen extends StatefulWidget {
  final String phone;
  final String contactName;

  const SendMoneyConfirmScreen({
    super.key,
    required this.phone,
    required this.contactName,
  });

  @override
  State<SendMoneyConfirmScreen> createState() => _SendMoneyConfirmScreenState();
}

class _SendMoneyConfirmScreenState extends State<SendMoneyConfirmScreen> {
  double _amount = 0;
  final _amountController = TextEditingController();
  double _balance = 13999;
  bool _showSuccess = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            text: 'Confirm to ',
            style: TextStyle(color: AppTheme.textDark, fontSize: 18),
            children: [
              TextSpan(
                text: 'Send Money',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        leading: const BackButton(),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Contact Number',
                        style: TextStyle(color: AppTheme.textGrey, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(widget.phone,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    const Divider(height: 24),
                    const Text('Amount',
                        style: TextStyle(color: AppTheme.textGrey, fontSize: 14)),
                    const SizedBox(height: 16),
                    Center(
                      child: IntrinsicWidth(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: _amount > 0
                                ? AppTheme.textDark
                                : AppTheme.textGrey,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Tk: 0',
                            hintStyle: const TextStyle(
                                fontSize: 32, color: AppTheme.textGrey),
                            filled: false,
                            border: InputBorder.none,
                            prefixText: _amount > 0 ? 'TK: ' : '',
                            prefixStyle: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.w700),
                          ),
                          onChanged: (val) {
                            setState(() {
                              _amount = double.tryParse(val) ?? 0;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Available Balance: ${(_balance - _amount).toStringAsFixed(0)} TK',
                        style: const TextStyle(
                          color: AppTheme.primaryLight,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _amount > 0
                      ? () => setState(() => _showSuccess = true)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _amount > 0 ? AppTheme.primaryDark : AppTheme.btnDisabled,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Confirm',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ),
          if (_showSuccess) _buildSuccessDialog(context),
        ],
      ),
    );
  }

  Widget _buildSuccessDialog(BuildContext context) {
    return Container(
      color: Colors.black38,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Illustration using AssetImage
              SizedBox(
                height: 120,
                child: Image.asset(
                  'assets/images/sendMoney.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Send Money Successful',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'You have successfully\nSend ',
                  style: const TextStyle(
                      color: AppTheme.textGrey, fontSize: 14),
                  children: [
                    TextSpan(
                      text: 'TK ${_amount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppTheme.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (r) => r.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Back To Home',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
