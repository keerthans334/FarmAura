import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/floating_ivr.dart';
import '../widgets/location_map_popup.dart';
import '../widgets/language_change_modal.dart';
import '../utils/location_helper.dart';
import 'personal_finance_screen.dart';
import '../models/weather.dart';
import '../services/weather_api_service.dart';
import 'package:farmaura/l10n/app_localizations.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.appState});
  final AppState appState;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showLocation = false;
  
  // Weather state
  Weather? _weather;
  bool _loadingWeather = true;
  String? _weatherError;

  @override
  void initState() {
    super.initState();
    widget.appState.addListener(_onAppStateChanged);
    _initData();
  }

  @override
  void dispose() {
    widget.appState.removeListener(_onAppStateChanged);
    super.dispose();
  }

  void _onAppStateChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _initData() async {
    // Trigger location update
    await widget.appState.updateLocationFromService();
    // Load weather after location attempt (whether successful or not)
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    try {
      final service = WeatherApiService();
      final loc = widget.appState.location;
      
      double? lat;
      double? lon;
      
      // Use detected location if available
      if (loc['lat'] != null && loc['lon'] != null) {
        lat = loc['lat'];
        lon = loc['lon'];
      } else {
        // If not detected yet, try to fetch it now
        try {
          await widget.appState.updateLocationFromService().timeout(const Duration(seconds: 5));
          final newLoc = widget.appState.location;
          if (newLoc['lat'] != null && newLoc['lon'] != null) {
            lat = newLoc['lat'];
            lon = newLoc['lon'];
          }
        } catch (e) {
          print('Location fetch error: $e');
          if (e.toString().contains('Location services are disabled')) {
             if (mounted) {
               LocationHelper.showLocationServiceDialog(context, () {
                 setState(() => _loadingWeather = true);
                 _loadWeather();
               });
             }
             return; // Stop loading weather until location is enabled
          }
        }
      }

      if (lat == null || lon == null) {
         if (mounted) {
           setState(() {
             _weatherError = AppLocalizations.of(context)!.locationRequired;
             _loadingWeather = false;
           });
         }
         return;
      }

      final weather = await service.getWeatherByCoordinates(lat, lon);
      if (mounted) {
        setState(() {
          _weather = weather;
          _loadingWeather = false;
          _weatherError = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _weatherError = 'Err: $e';
          _loadingWeather = false;
        });
      }
    }
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return AppLocalizations.of(context)!.dashboardGreetingMorning;
    if (hour < 17) return AppLocalizations.of(context)!.dashboardGreetingAfternoon;
    return AppLocalizations.of(context)!.dashboardGreetingEvening;
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.appState.userData['name']?.toString().isNotEmpty == true ? widget.appState.userData['name'] as String : AppLocalizations.of(context)!.farmer;
    final location = widget.appState.location;

    final quickActions = [
      _Action(icon: LucideIcons.sprout, label: AppLocalizations.of(context)!.cropAdvisor, path: '/crop-rec', color: const Color(0xFF43A047)),
      _Action(icon: LucideIcons.bug, label: AppLocalizations.of(context)!.pestScanner, path: '/pest', color: const Color(0xFFFFC107)),
      _Action(icon: LucideIcons.testTube, label: AppLocalizations.of(context)!.soilTest, path: '/soil', color: const Color(0xFF8D6E63)),
      _Action(icon: LucideIcons.dollarSign, label: AppLocalizations.of(context)!.marketPrices, path: '/market', color: const Color(0xFF1B5E20)),
      _Action(icon: LucideIcons.trendingDown, label: AppLocalizations.of(context)!.profitAndLoss, path: '/finance', color: const Color(0xFF43A047)),
      _Action(icon: LucideIcons.users, label: AppLocalizations.of(context)!.community, path: '/community', color: const Color(0xFFFFC107)),
    ];

    final updates = [
      _Update(title: AppLocalizations.of(context)!.pestAlertNearby, icon: LucideIcons.bug, color: Colors.red.shade100, textColor: Colors.red.shade700, path: '/pest-alerts'),
      _Update(title: AppLocalizations.of(context)!.heavyRainTomorrow, icon: LucideIcons.cloudRain, color: Colors.orange.shade100, textColor: Colors.orange.shade700, path: '/weather'),
      _Update(title: AppLocalizations.of(context)!.wheatPrice, icon: LucideIcons.trendingUp, color: Colors.green.shade100, textColor: Colors.green.shade700, path: '/market'),
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
                              Text('${AppLocalizations.of(context)!.locationLabel}: ${location['district']}, ${location['state']}', style: const TextStyle(color: AppColors.muted)),
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
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)!.searchHint,
                                    border: InputBorder.none,
                                  ),
                                  onTap: () => context.go('/ai-chat'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _topCard(
                              context, 
                              title: _loadingWeather ? '...' : (_weatherError != null ? AppLocalizations.of(context)!.unavailable : '${_weather?.currentTempC ?? "--"}°C'), 
                              subtitle: _loadingWeather 
                                  ? AppLocalizations.of(context)!.loading 
                                  : (_weatherError != null 
                                      ? (_weatherError!.length > 20 ? '${_weatherError!.substring(0, 17)}...' : _weatherError!) 
                                      : (_weather?.condition ?? 'Unknown')), 
                              icon: LucideIcons.sun, 
                              colors: [const Color(0xFFFFC107), const Color(0xFFFF9800)], 
                              onTap: () {
                                if (_weatherError != null) {
                                  setState(() => _loadingWeather = true);
                                  _loadWeather();
                                } else {
                                  context.go('/weather');
                                }
                              }
                            ),
                            const SizedBox(width: 10),
                            _topCard(context, title: AppLocalizations.of(context)!.npkGood, subtitle: 'pH: 6.5', icon: LucideIcons.droplets, colors: [const Color(0xFF8D6E63), const Color(0xFF6D4C41)], onTap: () => context.go('/soil')),
                            const SizedBox(width: 10),
                            _topCard(context, title: AppLocalizations.of(context)!.wheat, subtitle: '12,150/q', icon: LucideIcons.trendingUp, colors: [AppColors.primary, AppColors.primaryDark], onTap: () => context.go('/market')),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(AppLocalizations.of(context)!.quickActions, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600, fontSize: 16)),
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
                        Text(AppLocalizations.of(context)!.importantUpdates, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600, fontSize: 16)),
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
                        Text(AppLocalizations.of(context)!.farmPerformance, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600, fontSize: 16)),
                        const SizedBox(height: 8),
                        _performanceTile(AppLocalizations.of(context)!.cropHealth, 0.92, color: [const Color(0xFF66BB6A), AppColors.primary]),
                        _performanceTile(AppLocalizations.of(context)!.profitMargin, 0.78, color: [const Color(0xFFFFC107), const Color(0xFFFF9800)]),
                        _performanceTile(AppLocalizations.of(context)!.soilQuality, 0.88, color: [const Color(0xFFA1887F), const Color(0xFF8D6E63)]),
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
                child: LocationMapPopup(
                  location: location,
                  lat: location['lat'] as double?,
                  lon: location['lon'] as double?,
                  onClose: () => setState(() => showLocation = false),
                ),
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
      _DrawerItem(icon: LucideIcons.home, label: AppLocalizations.of(context)!.home, path: '/dashboard'),
      _DrawerItem(icon: LucideIcons.user, label: AppLocalizations.of(context)!.profile, path: '/profile'),
      _DrawerItem(icon: LucideIcons.dollarSign, label: AppLocalizations.of(context)!.personalFinance, path: '/finance'),
      _DrawerItem(icon: LucideIcons.settings, label: AppLocalizations.of(context)!.settings, path: '/settings'),
      _DrawerItem(icon: LucideIcons.upload, label: AppLocalizations.of(context)!.soilHealthCardUpload, path: '/soil'),
      _DrawerItem(icon: LucideIcons.gift, label: AppLocalizations.of(context)!.governmentSchemes, path: '/community'),
      _DrawerItem(
        icon: LucideIcons.languages,
        label: AppLocalizations.of(context)!.language,
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
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white24,
                  child: Text('FA', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                ),
                SizedBox(height: 10),
                Text(AppLocalizations.of(context)!.appTitle, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                Text(AppLocalizations.of(context)!.govJharkhand, style: const TextStyle(color: Colors.white70, fontSize: 12)),
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
              title: Text(AppLocalizations.of(context)!.logout, style: const TextStyle(color: Colors.red)),
              onTap: onLogout,
            ),
          ),
        ],
      ),
    );
  }
}
