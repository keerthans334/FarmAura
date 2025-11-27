import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../models/app_state.dart';
import '../models/weather.dart';
import '../services/weather_api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/floating_ivr.dart';

class WeatherDetailsScreen extends StatefulWidget {
  const WeatherDetailsScreen({super.key, required this.appState});
  final AppState appState;

  @override
  State<WeatherDetailsScreen> createState() => _WeatherDetailsScreenState();
}

class _WeatherDetailsScreenState extends State<WeatherDetailsScreen> {
  late Future<Weather> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = WeatherApiService().fetchWeather('Ranchi');
  }

  String _formatTemp(num temp) => '${temp.round()}\u00B0C';
  String _formatDay(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    if (target == today) return 'Today';
    if (target == today.add(const Duration(days: 1))) return 'Tomorrow';
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[target.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                AppHeader(appState: widget.appState, showBack: true, onBack: () => context.go('/dashboard')),
                Expanded(
                  child: FutureBuilder<Weather>(
                    future: _weatherFuture,
                    builder: (context, snapshot) {
                      final weather = snapshot.data ?? Weather.sample();
                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton.icon(
                              onPressed: () => context.go('/dashboard'),
                              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                              label: const Text('Back', style: TextStyle(color: AppColors.primary)),
                            ),
                            const SizedBox(height: 6),
                            Text('Weather Forecast', style: Theme.of(context).textTheme.headlineSmall),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [Color(0xFFFFC107), Color(0xFFFF9800)]),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 16, offset: const Offset(0, 10))],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(weather.iconAsset, width: 64, height: 64, fit: BoxFit.contain),
                                      const SizedBox(width: 12),
                                      Text(_formatTemp(weather.currentTempC), style: const TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(weather.condition, style: const TextStyle(color: Colors.white, fontSize: 18)),
                                  const SizedBox(height: 2),
                                  Text('Feels like ${_formatTemp(weather.feelsLikeC)}', style: const TextStyle(color: Colors.white70)),
                                  const SizedBox(height: 10),
                                  const Divider(color: Colors.white70),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _Metric(icon: Icons.water_drop, label: 'Humidity', value: '${weather.humidity}%'),
                                      _Metric(icon: Icons.air, label: 'Wind', value: '${weather.windKph} km/h'),
                                      _Metric(icon: Icons.remove_red_eye, label: 'Visibility', value: '${weather.visibilityKm} km'),
                                      _Metric(icon: Icons.speed, label: 'Pressure', value: '${weather.pressureMb} mb'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text('7-Day Forecast', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600, fontSize: 16)),
                            const SizedBox(height: 8),
                            ...weather.dailyForecast.take(7).map((day) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 8))]),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(day.iconAsset, width: 26, height: 26, fit: BoxFit.contain),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(_formatDay(day.date), style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
                                        Text('${day.date.month}/${day.date.day}', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(_formatTemp(day.maxTempC), style: const TextStyle(color: AppColors.primaryDark)),
                                        Text(_formatTemp(day.minTempC), style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    Row(
                                      children: [
                                        const Icon(Icons.water_drop, color: Colors.blue, size: 16),
                                        Text('${day.rainChance}%', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.blue.shade200)),
                              child: const Text('Heavy rainfall expected later this week. Plan your farming activities accordingly.', style: TextStyle(color: AppColors.primaryDark)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const Positioned(bottom: 0, left: 0, right: 0, child: AppFooter()),
            const FloatingIVR(),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
