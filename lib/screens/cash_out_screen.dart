import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/app_data.dart';

class CashOutScreen extends StatefulWidget {
  const CashOutScreen({super.key});

  @override
  State<CashOutScreen> createState() => _CashOutScreenState();
}

class _CashOutScreenState extends State<CashOutScreen> {
  bool _isAtm = true;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banks = AppData.partnerBanks;
    final balance = 13999;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cash Out'),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          // Toggle: Agent / ATM
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isAtm = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: !_isAtm ? AppTheme.primaryDark : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.divider),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.people_outline,
                            color: !_isAtm
                                ? Colors.white
                                : AppTheme.primaryDark,
                            size: 32,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Agent',
                            style: TextStyle(
                              color: !_isAtm
                                  ? Colors.white
                                  : AppTheme.primaryDark,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isAtm = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: _isAtm ? AppTheme.primaryDark : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.divider),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.atm_outlined,
                            color: _isAtm ? Colors.white : AppTheme.primaryDark,
                            size: 32,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'ATM',
                            style: TextStyle(
                              color: _isAtm
                                  ? Colors.white
                                  : AppTheme.primaryDark,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Balance
          Text(
            'Available Balance: $balance TK',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 16),
          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.inputBg,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search for Partner Bank',
                  hintStyle: TextStyle(color: AppTheme.textGrey),
                  prefixIcon: Icon(Icons.search, color: AppTheme.textGrey),
                  border: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Bank list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: banks.length,
              itemBuilder: (context, i) {
                final bank = banks[i];
                final icons = [
                  Icons.account_balance,
                  Icons.trending_up,
                  Icons.mosque,
                  Icons.public,
                  Icons.east,
                ];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AgentCashOutConfirmScreen(
                          agentPhone: '01730805499',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bank.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Branch Name: ${bank.branch}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppTheme.bgLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icons[i % icons.length],
                              color: AppTheme.primaryDark, size: 28),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Did you face any issue? ',
                    style: TextStyle(color: AppTheme.textGrey, fontSize: 13)),
                const Text('Contact Us',
                    style: TextStyle(
                        color: AppTheme.primaryDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AgentCashOutConfirmScreen extends StatefulWidget {
  final String agentPhone;

  const AgentCashOutConfirmScreen({super.key, required this.agentPhone});

  @override
  State<AgentCashOutConfirmScreen> createState() =>
      _AgentCashOutConfirmScreenState();
}

class _AgentCashOutConfirmScreenState extends State<AgentCashOutConfirmScreen> {
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
                text: 'Cash Out',
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
                    const Text('Agent',
                        style: TextStyle(color: AppTheme.textGrey, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(widget.agentPhone,
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
                            hintText: 'TK: 0',
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
                    backgroundColor: _amount > 0
                        ? AppTheme.primaryDark
                        : AppTheme.btnDisabled,
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
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.accent, width: 4),
                ),
                child: const Icon(Icons.check, color: AppTheme.accent, size: 44),
              ),
              const SizedBox(height: 16),
              const Text(
                'Cash Out Successful',
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
                  text: 'You have successfully\nWithdraw ',
                  style: const TextStyle(color: AppTheme.textGrey, fontSize: 14),
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
