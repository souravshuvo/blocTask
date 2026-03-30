import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/app_data.dart';

class CashOutScreen extends StatefulWidget {
  const CashOutScreen({super.key});

  @override
  State<CashOutScreen> createState() => _CashOutScreenState();
}

class _CashOutScreenState extends State<CashOutScreen> {
  bool _isAtm = false; // false = Agent (default), true = ATM
  final _agentController = TextEditingController();
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _agentController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cash Out'),
        leading: const BackButton(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Agent / ATM toggle (same for both tabs) ─────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: _tabButton('Agent', Icons.people, isAgent: true),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _tabButton(
                    'ATM',
                    Icons.local_atm_outlined,
                    isAgent: false,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Switching body content ───────────────────────────────────────
          Expanded(child: _isAtm ? _buildAtmBody() : _buildAgentBody()),
        ],
      ),
    );
  }

  // ── AGENT tab content ────────────────────────────────────────────────────
  Widget _buildAgentBody() {
    final recentContacts = AppData.recentContacts;
    final allContacts = AppData.allContacts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input row: underline field + contacts icon
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _agentController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontSize: 15),
                      decoration: const InputDecoration(
                        hintText: 'Input Agent Number',
                        hintStyle: TextStyle(color: AppTheme.textGrey),
                        border: InputBorder.none,
                        filled: false,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ), // add padding here
                        suffixIcon: Icon(
                          Icons.chevron_right,
                          color: AppTheme.textGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.contacts,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Tap To Scan QR Code
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.qr_code_scanner,
              color: AppTheme.primaryDark,
              size: 20,
            ),
            label: const Text(
              'Tap To Scan QR Code',
              style: TextStyle(
                color: AppTheme.primaryDark,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              side: const BorderSide(color: AppTheme.primaryDark, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Contacts list
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              const Text(
                'Recent Contacts',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 12),
              ...recentContacts.map(
                (c) => _contactTile(c.name, c.phone, c.type),
              ),
              const SizedBox(height: 16),
              const Text(
                'All Contacts',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 12),
              ...allContacts.map((c) => _contactTile(c.name, c.phone, c.type)),
            ],
          ),
        ),
      ],
    );
  }

  // ── ATM tab content ──────────────────────────────────────────────────────
  Widget _buildAtmBody() {
    final banks = AppData.partnerBanks;
    final balance = 13999;
    final bankImage = [
      'assets/images/basicBank.png',
      'assets/images/bracBank.png',
      'assets/images/islamicBank.png',
      'assets/images/basicBank.png',
      'assets/images/bracBank.png',
    ];

    return Column(
      children: [
        // Available Balance
        Text(
          'Available Balance: $balance TK',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 16),

        // Search for Partner Bank
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
        const SizedBox(height: 12),

        // Bank list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: banks.length,
            itemBuilder: (context, i) {
              final bank = banks[i];
              return GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => AgentCashOutConfirmScreen(
                              agentPhone: '01730805499',
                            ),
                      ),
                    ),
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
                        child: Image.asset(
                          bankImage[i % bankImage.length],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Contact Us footer
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Did you face any issue? ',
                style: TextStyle(color: AppTheme.textGrey, fontSize: 13),
              ),
              Text(
                'Contact Us',
                style: TextStyle(
                  color: AppTheme.primaryDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Shared helpers ───────────────────────────────────────────────────────
  Widget _tabButton(String label, IconData icon, {required bool isAgent}) {
    final isActive = _isAtm == !isAgent;
    return GestureDetector(
      onTap: () => setState(() => _isAtm = !isAgent),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryDark : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : AppTheme.primaryDark,
              size: 32,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : AppTheme.primaryDark,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactTile(String name, String phone, String type) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AgentCashOutConfirmScreen(agentPhone: phone),
            ),
          ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEEEEEE),
              ),
              child: const Icon(Icons.person, color: Colors.grey, size: 28),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                Text(
                  '$type - $phone',
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
                    const Text(
                      'Agent',
                      style: TextStyle(color: AppTheme.textGrey, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.agentPhone,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Divider(height: 24),
                    const Text(
                      'Amount',
                      style: TextStyle(color: AppTheme.textGrey, fontSize: 14),
                    ),
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
                            color:
                                _amount > 0
                                    ? AppTheme.textDark
                                    : AppTheme.textGrey,
                          ),
                          decoration: InputDecoration(
                            hintText: 'TK: 0',
                            hintStyle: const TextStyle(
                              fontSize: 32,
                              color: AppTheme.textGrey,
                            ),
                            filled: false,
                            border: InputBorder.none,
                            prefixText: _amount > 0 ? 'TK: ' : '',
                            prefixStyle: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
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
                  onPressed:
                      _amount > 0
                          ? () => setState(() => _showSuccess = true)
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _amount > 0
                            ? AppTheme.primaryDark
                            : AppTheme.btnDisabled,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
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
              // Replace the Icon with Image.asset
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.accent, width: 4),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/cashOut.png', // <-- your image path
                    fit: BoxFit.cover,
                  ),
                ),
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
                  style: const TextStyle(
                    color: AppTheme.textGrey,
                    fontSize: 14,
                  ),
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
                  child: const Text(
                    'Back To Home',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
