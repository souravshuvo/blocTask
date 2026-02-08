import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../widgets/account_info_card.dart';
import '../widgets/trades_list.dart';
import '../widgets/promo_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  AccountInfo? _accountInfo;
  bool _isLoadingAccount = true;

  @override
  void initState() {
    super.initState();
    _loadAccountInfo();
  }

  Future<void> _loadAccountInfo() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final apiService = context.read<ApiService>();
      final accountInfo = await apiService.getAccountInfo(authState.login);
      
      if (accountInfo != null) {
        final phone = await apiService.getLastFourPhone(authState.login);
        setState(() {
          _accountInfo = accountInfo.copyWith(lastFourPhone: phone);
          _isLoadingAccount = false;
        });
      } else {
        setState(() {
          _isLoadingAccount = false;
        });
      }
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(AuthLogoutRequested());
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final login = authState is AuthAuthenticated ? authState.login : '';

    final List<Widget> pages = [
      _buildDashboard(login),
      TradesListScreen(login: login),
      const PromoSection(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peanut Trader'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoadingAccount = true;
              });
              _loadAccountInfo();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Trades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Promos',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(String login) {
    return RefreshIndicator(
      onRefresh: () async {
        await _loadAccountInfo();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoadingAccount)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_accountInfo != null)
              AccountInfoCard(accountInfo: _accountInfo!)
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.orange),
                      const SizedBox(height: 8),
                      const Text('Failed to load account information'),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadAccountInfo,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildActionCard(
                  icon: Icons.show_chart,
                  title: 'View Trades',
                  color: Colors.green,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
                _buildActionCard(
                  icon: Icons.card_giftcard,
                  title: 'Promotions',
                  color: Colors.orange,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                ),
                _buildActionCard(
                  icon: Icons.account_circle,
                  title: 'Profile',
                  color: Colors.blue,
                  onTap: () {
                    // Navigate to profile
                  },
                ),
                _buildActionCard(
                  icon: Icons.settings,
                  title: 'Settings',
                  color: Colors.grey,
                  onTap: () {
                    // Navigate to settings
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
