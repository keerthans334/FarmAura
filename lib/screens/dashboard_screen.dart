import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/floating_ivr.dart';
import '../widgets/location_map_popup.dart';
import '../widgets/language_change_modal.dart';
import 'personal_finance_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.appState});
  final AppState appState;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showLocation = false;

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.appState.userData['name']?.toString().isNotEmpty == true ? widget.appState.userData['name'] as String : 'Farmer';
    final location = widget.appState.location;

    final quickActions = [
      _Action(icon: LucideIcons.sprout, label: 'Crop Advisor', path: '/crop-rec', color: const Color(0xFF43A047)),
      _Action(icon: LucideIcons.bug, label: 'Pest Scanner', path: '/pest', color: const Color(0xFFFFC107)),
      _Action(icon: LucideIcons.testTube, label: 'Soil Test', path: '/soil', color: const Color(0xFF8D6E63)),
      _Action(icon: LucideIcons.dollarSign, label: 'Market Prices', path: '/market', color: const Color(0xFF1B5E20)),
      _Action(icon: LucideIcons.trendingDown, label: 'Profit & Loss', path: '/finance', color: const Color(0xFF43A047)),
      _Action(icon: LucideIcons.users, label: 'Community', path: '/community', color: const Color(0xFFFFC107)),
    ];

    final updates = [
      _Update(title: 'Pest Alert Nearby', icon: LucideIcons.bug, color: Colors.red.shade100, textColor: Colors.red.shade700, path: '/pest-alerts'),
      _Update(title: 'Heavy Rain Tomorrow', icon: LucideIcons.cloudRain, color: Colors.orange.shade100, textColor: Colors.orange.shade700, path: '/weather'),
      _Update(title: 'Wheat Price ? ?12,180', icon: LucideIcons.trendingUp, color: Colors.green.shade100, textColor: Colors.green.shade700, path: '/market'),
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: _AppDrawer(
        appState: widget.appState,
        onNavigate: (path) {
          Navigator.of(context).pop();
          if (path == '/finance') {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => PersonalFinanceScreen(appState: widget.appState)));
          } else {
            context.go(path);
          }
        },
        onFinanceTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => PersonalFinanceScreen(appState: widget.appState)));
        },
        onLanguageChange: () async {
          Navigator.of(context).pop();
          await showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => LanguageChangeModal(appState: widget.appState),
          );
        },
        onLogout: () {
          Navigator.of(context).pop();
          context.go('/');
        },
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                AppHeader(
                  appState: widget.appState,
                  showBack: false,
                  showProfile: true,
                  showMenu: false,
                  onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text('$greeting, $name ', style: Theme.of(context).textTheme.headlineSmall),
                        GestureDetector(
                          onTap: () => setState(() => showLocation = true),
                          child: Row(
                            children: [
                              const Icon(LucideIcons.mapPin, color: Colors.red, size: 18),
                              const SizedBox(width: 6),
                              Text('Location: ${location['district']}, ${location['state']}', style: const TextStyle(color: AppColors.muted)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 14, offset: const Offset(0, 10))],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(LucideIcons.mic, color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    hintText: 'Ask AI Assistant anything...',
                                    border: InputBorder.none,
                                  ),
                                  onTap: () => context.go('/ai-chat'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _topCard(context, title: '32 C', subtitle: 'Sunny', icon: LucideIcons.sun, colors: [const Color(0xFFFFC107), const Color(0xFFFF9800)], onTap: () => context.go('/weather')),
                            const SizedBox(width: 10),
                            _topCard(context, title: 'NPK Good', subtitle: 'pH: 6.5', icon: LucideIcons.droplets, colors: [const Color(0xFF8D6E63), const Color(0xFF6D4C41)], onTap: () => context.go('/soil')),
                            const SizedBox(width: 10),
                            _topCard(context, title: 'Wheat', subtitle: '12,150/q', icon: LucideIcons.trendingUp, colors: [AppColors.primary, AppColors.primaryDark], onTap: () => context.go('/market')),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const Text('Quick Actions', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600, fontSize: 16)),
                        const SizedBox(height: 10),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: quickActions.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.95),
                          itemBuilder: (context, index) {
                            final action = quickActions[index];
                            return GestureDetector(
                              onTap: () {
                                if (action.path == '/finance') {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => PersonalFinanceScreen(appState: widget.appState)));
                                } else {
                                  context.go(action.path);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: action.color,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 6))],
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(action.icon, color: Colors.white, size: 28),
                                    const SizedBox(height: 8),
                                    Text(action.label, style: const TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text('Important Updates', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600, fontSize: 16)),
                        const SizedBox(height: 8),
                        Column(
                          children: updates
                              .map(
                                (u) => GestureDetector(
                                  onTap: () => context.go(u.path),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: u.color,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(u.icon, color: u.textColor),
                                        const SizedBox(width: 10),
                                        Expanded(child: Text(u.title, style: TextStyle(color: u.textColor, fontWeight: FontWeight.w600))),
                                        const Icon(LucideIcons.chevronRight, color: AppColors.muted, size: 18),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        const Text('Farm Performance', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600, fontSize: 16)),
                        const SizedBox(height: 8),
                        _performanceTile('Crop Health', 0.92, color: [const Color(0xFF66BB6A), AppColors.primary]),
                        _performanceTile('Profit Margin', 0.78, color: [const Color(0xFFFFC107), const Color(0xFFFF9800)]),
                        _performanceTile('Soil Quality', 0.88, color: [const Color(0xFFA1887F), const Color(0xFF8D6E63)]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Positioned(bottom: 0, left: 0, right: 0, child: AppFooter()),
            const FloatingIVR(),
            if (showLocation)
              Center(
                child: LocationMapPopup(location: location, onClose: () => setState(() => showLocation = false)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _topCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required List<Color> colors, VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: colors.last.withOpacity(0.35), blurRadius: 10, offset: const Offset(0, 8))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const Spacer(),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _performanceTile(String title, double value, {required List<Color> color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(20)),
                child: Text('${(value * 100).round()}%', style: TextStyle(color: color.last, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: value,
              backgroundColor: AppColors.background,
              valueColor: AlwaysStoppedAnimation(color.last),
            ),
          ),
        ],
      ),
    );
  }
}

class _Action {
  _Action({required this.icon, required this.label, required this.path, required this.color});
  final IconData icon;
  final String label;
  final String path;
  final Color color;
}

class _Update {
  _Update({required this.title, required this.icon, required this.color, required this.textColor, required this.path});
  final String title;
  final IconData icon;
  final Color color;
  final Color textColor;
  final String path;
}

class _DrawerItem {
  _DrawerItem({required this.icon, required this.label, required this.path, this.trailing});
  final IconData icon;
  final String label;
  final String path;
  final Widget? trailing;
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer({
    required this.appState,
    required this.onNavigate,
    required this.onFinanceTap,
    required this.onLanguageChange,
    required this.onLogout,
  });

  final AppState appState;
  final void Function(String path) onNavigate;
  final VoidCallback onFinanceTap;
  final VoidCallback onLanguageChange;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final items = [
      _DrawerItem(icon: LucideIcons.home, label: 'Home', path: '/dashboard'),
      _DrawerItem(icon: LucideIcons.user, label: 'Profile', path: '/profile'),
      _DrawerItem(icon: LucideIcons.dollarSign, label: 'Personal Finance', path: '/finance'),
      _DrawerItem(icon: LucideIcons.settings, label: 'Settings', path: '/settings'),
      _DrawerItem(icon: LucideIcons.upload, label: 'Soil Health Card Upload', path: '/soil'),
      _DrawerItem(icon: LucideIcons.gift, label: 'Government Schemes', path: '/community'),
      _DrawerItem(
        icon: LucideIcons.languages,
        label: 'Language',
        path: '',
        trailing: Text(appState.userLanguage, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
      ),
    ];

    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 48, 16, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white24,
                  child: Text('FA', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                ),
                SizedBox(height: 10),
                Text('FarmAura', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                Text('Government of Jharkhand', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    tileColor: AppColors.background,
                    leading: Icon(item.icon, color: AppColors.primaryDark, size: 20),
                    title: Text(item.label, style: const TextStyle(color: AppColors.primaryDark)),
                    trailing: item.trailing,
                    onTap: () {
                      if (item.path.isEmpty) {
                        onLanguageChange();
                      } else if (item.path == '/finance') {
                        onFinanceTap();
                      } else {
                        onNavigate(item.path);
                      }
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border.withOpacity(0.6))),
            ),
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              tileColor: Colors.red.shade50,
              leading: const Icon(LucideIcons.logOut, color: Colors.red, size: 20),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: onLogout,
            ),
          ),
        ],
      ),
    );
  }
}
