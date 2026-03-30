import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'sign_up_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Matches screenshot: icon + label pairs, thin divider between each
    final menuItems = [
      _MenuItem('Home', Icons.home_outlined),
      _MenuItem('Profile', Icons.person_outline),
      _MenuItem('Statements', Icons.attach_file_outlined),
      _MenuItem('Limits', Icons.error_outline),
      _MenuItem('Coupons', Icons.monetization_on_outlined),
      _MenuItem('Points', Icons.emoji_events_outlined),
      _MenuItem('Information Update', Icons.edit_note_outlined),
      _MenuItem('Settings', Icons.settings_outlined),
      _MenuItem('Nominee Update', Icons.swap_horiz_outlined),
      _MenuItem('Support', Icons.support_agent_outlined),
      _MenuItem('Refer ekPay App', Icons.person_outline),
    ];

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header area – white bg, "ePay Menu" bold + বাংলা pill
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'ePay Menu',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                    ),
                  ),
                  SizedBox(height: 14),
                  BanglaButton(),
                ],
              ),
            ),
          ),
          // Full-width divider under header
          const Divider(height: 1, thickness: 1, color: AppTheme.divider),
          // Scrollable menu items
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: menuItems.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                thickness: 1,
                color: AppTheme.divider,
              ),
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    child: Row(
                      children: [
                        Icon(menuItems[i].icon,
                            color: AppTheme.primaryDark, size: 22),
                        const SizedBox(width: 16),
                        Text(
                          menuItems[i].label,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppTheme.primaryDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Full-width divider above Logout
          const Divider(height: 1, thickness: 1, color: AppTheme.divider),
          // Logout row – bold text
          InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const SignUpScreen()),
                (route) => false,
              );
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: const [
                  Icon(Icons.logout, color: AppTheme.primaryDark, size: 22),
                  SizedBox(width: 16),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.primaryDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom safe area padding
          SafeArea(top: false, child: const SizedBox(height: 8)),
        ],
      ),
    );
  }
}

class _MenuItem {
  final String label;
  final IconData icon;
  _MenuItem(this.label, this.icon);
}
