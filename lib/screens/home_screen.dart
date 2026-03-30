import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/app_data.dart';
import '../models/models.dart';
import 'send_money_screen.dart';
import 'add_money_screen.dart';
import 'cash_out_screen.dart';
import 'side_menu.dart';
import 'statements_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _balanceVisible = true;
  int _selectedTab = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  UserModel get _user => AppData.user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.bgLight,
      drawer: const SideMenu(),
      body: _selectedTab == 0 ? _buildHomeBody() : _buildStatementsBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomeBody() {
    return CustomScrollView(
      slivers: [
        // Unified dark blue header (user row + balance in one block)
        SliverToBoxAdapter(child: _buildHeaderWithBalance()),
        // White card with all services (row 1 + row 2 + See More)
        SliverToBoxAdapter(child: _buildServicesCard()),
        // Pay Bill section
        SliverToBoxAdapter(child: _buildPayBills()),
        // Remittance section
        SliverToBoxAdapter(child: _buildRemittance()),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  Widget _buildStatementsBody() {
    return const StatementsScreen();
  }

  // ── Single unified dark-blue block: top row + balance ──────────────────────
  Widget _buildHeaderWithBalance() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A3A6B),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top row: avatar + name  |  points badge
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  // Avatar circle with initials
                  GestureDetector(
                    onTap: () => _scaffoldKey.currentState?.openDrawer(),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange.shade300,
                          ),
                          child: Center(
                            child: Text(
                              _user.name[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _user.name.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Points badge – orange pill
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppTheme.accent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.emoji_events,
                            color: Colors.white, size: 15),
                        const SizedBox(width: 4),
                        Text(
                          '${_user.points} Points',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Balance block (slightly lighter bg to separate visually)
            Container(
              width: double.infinity,
              color: const Color(0xFFEEF3FA),
              padding:
                  const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
              child: Column(
                children: [
                  const Text(
                    'Your Balance',
                    style: TextStyle(
                      color: Color(0xFF555F7A),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _balanceVisible
                            ? 'Tk: ${_user.balance.toStringAsFixed(2)}'
                            : 'Tk: ******.00',
                        style: const TextStyle(
                          color: Color(0xFF1A3A6B),
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _balanceVisible = !_balanceVisible),
                        child: Icon(
                          _balanceVisible
                              ? Icons.remove_red_eye_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFF555F7A),
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── White services card: 2 rows of 4 icons + See More ──────────────────────
  Widget _buildServicesCard() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        children: [
          // Row 1 – main 4
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _serviceIcon('Cash in', Icons.account_balance_wallet_outlined,
                  null),
              _serviceIcon('Cash Out', Icons.monetization_on_outlined, () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CashOutScreen()));
              }),
              _serviceIcon('Add Money', Icons.add_circle_outline, () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AddMoneyScreen()));
              }),
              _serviceIcon('Send Money', Icons.redo_outlined, () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SendMoneyScreen()));
              }),
            ],
          ),
          const SizedBox(height: 16),
          // Row 2 – extra 4
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _serviceIcon(
                  'Mobile\nRecharge', Icons.phone_android_outlined, null),
              _serviceIcon('MRT\nRecharge', Icons.train_outlined, null),
              _serviceIcon('Make\nPayment', Icons.payment_outlined, null),
              _serviceIcon('Express\nCard Recharge',
                  Icons.credit_card_outlined, null),
            ],
          ),
          const SizedBox(height: 16),
          // See More pill
          _seeMorePill('See More'),
        ],
      ),
    );
  }

  Widget _serviceIcon(String label, IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 70,
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryDark, size: 30),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textDark,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _seeMorePill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ── Pay Bill ───────────────────────────────────────────────────────────────
  Widget _buildPayBills() {
    final bills = [
      _BillItem('Electricity', Icons.bolt_outlined),
      _BillItem('Gas', Icons.local_fire_department_outlined),
      _BillItem('Water', Icons.water_drop_outlined),
      _BillItem('Internet', Icons.wifi_outlined),
      _BillItem('Telephone', Icons.phone_outlined),
      _BillItem('Credit Card', Icons.credit_card_outlined),
      _BillItem('Govt. Fees', Icons.account_balance_outlined),
      _BillItem('Cable Network', Icons.satellite_alt_outlined),
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pay Bill',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 16),
          // 2 rows × 4 columns
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: bills
                .sublist(0, 4)
                .map((b) => _billIcon(b.name, b.icon))
                .toList(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: bills
                .sublist(4, 8)
                .map((b) => _billIcon(b.name, b.icon))
                .toList(),
          ),
          const SizedBox(height: 16),
          Center(child: _seeMorePill('See more')),
        ],
      ),
    );
  }

  Widget _billIcon(String label, IconData icon) {
    return SizedBox(
      width: 70,
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryDark, size: 28),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: AppTheme.textDark),
          ),
        ],
      ),
    );
  }

  // ── Remittance ─────────────────────────────────────────────────────────────
  Widget _buildRemittance() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Remittance',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _remittanceItem('Payoneer', Icons.account_balance_wallet),
              _remittanceItem('PayPal', Icons.payment),
              _remittanceItem('Wind', Icons.wind_power),
              _remittanceItem('Wise', Icons.currency_exchange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _remittanceItem(String name, IconData icon) {
    return SizedBox(
      width: 70,
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryDark, size: 28),
          const SizedBox(height: 6),
          Text(name,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 11, color: AppTheme.textDark)),
        ],
      ),
    );
  }

  // ── Bottom Navigation ──────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 8, offset: Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 62,
          child: Row(
            children: [
              // Home tab
              _navItem(0, Icons.home_outlined, Icons.home, 'Home'),
              // QR Scan – centre floating circle
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppTheme.divider, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.qr_code_scanner,
                          color: AppTheme.primaryDark, size: 26),
                    ),
                  ),
                ),
              ),
              // Inbox tab
              _navItem(2, Icons.inbox_outlined, Icons.inbox, 'Inbox'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
      int index, IconData icon, IconData activeIcon, String label) {
    final isActive = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppTheme.primaryDark : AppTheme.textGrey,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? AppTheme.primaryDark : AppTheme.textGrey,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceItem {
  final String name;
  final IconData icon;
  final VoidCallback? onTap;
  _ServiceItem(this.name, this.icon, this.onTap);
}

class _BillItem {
  final String name;
  final IconData icon;
  _BillItem(this.name, this.icon);
}
