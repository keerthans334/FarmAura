import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/app_state.dart';
import '../models/market_price.dart';
import '../services/market_api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';
import '../widgets/floating_ivr.dart';

import 'package:farmaura/l10n/app_localizations.dart';
class MarketPriceScreen extends StatefulWidget {
  const MarketPriceScreen({super.key, required this.appState});
  final AppState appState;

  @override
  State<MarketPriceScreen> createState() => _MarketPriceScreenState();
}

class _MarketPriceScreenState extends State<MarketPriceScreen> {
  late Future<List<MarketPrice>> _pricesFuture;

  @override
  void initState() {
    super.initState();
    _pricesFuture = MarketApiService().fetchMarketPrices();
  }

  Future<void> _retry() async {
    setState(() {
      _pricesFuture = MarketApiService().fetchMarketPrices();
    });
  }

  String _formatPrice(num value) => '₹${value.toStringAsFixed(0)}';

  List<MarketPrice> _pickTop(List<MarketPrice> prices, {int count = 3}) {
    final sorted = [...prices]..sort((a, b) => b.estimatedProfit.compareTo(a.estimatedProfit));
    if (sorted.length > count) return sorted.sublist(0, count);
    return sorted;
  }

  Widget _updatedCard() {
    final now = DateTime.now();
    final timeText = '${AppLocalizations.of(context)!.today}, ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFFC107), Color(0xFFFF9800)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 16, offset: const Offset(0, 10))],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.updated, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Text(timeText, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
            ],
          ),
          const Spacer(),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const Icon(LucideIcons.trendingUp, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _bestMandiCard(MarketPrice price, {String badge = 'Recommended'}) {
    final transportCost = 200;
    final estimatedProfit = price.currentPrice * 12 - transportCost;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 8))],
        border: Border.all(color: Colors.orange.shade200, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.bestMandi(price.cropName),
                  style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.green.shade200)),
                child: Text(badge, style: const TextStyle(color: AppColors.primaryDark, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            price.mandiName,
            style: const TextStyle(color: AppColors.primaryDark, fontSize: 16, fontWeight: FontWeight.w700),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text('15 km away • ${price.location}', style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 12),
          Row(
            children: [
              _infoChip(AppLocalizations.of(context)!.sellingPrice, '${_formatPrice(price.currentPrice)}/quintal', Colors.green.shade50, AppColors.primaryDark),
              const SizedBox(width: 10),
              _infoChip(AppLocalizations.of(context)!.transportCost, _formatPrice(transportCost), Colors.orange.shade50, Colors.orange.shade800),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
              alignment: Alignment.center,
              child: Text('${AppLocalizations.of(context)!.estimatedNetProfit} ${_formatPrice(estimatedProfit)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String label, String value, Color bg, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(color: textColor, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _allPrices(List<MarketPrice> prices) {
    if (prices.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.allMarketPrices, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700, fontSize: 16)),
        const SizedBox(height: 12),
        ListView.separated(
          itemCount: prices.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final p = prices[index];
            return _MarketPriceCard(price: p, formatPrice: _formatPrice);
          },
        ),
      ],
    );
  }

  List<Widget> _bestMandiSection(List<MarketPrice> prices) {
    if (prices.isEmpty) return [];
    final labels = [
      AppLocalizations.of(context)!.recommended,
      AppLocalizations.of(context)!.alsoGoodOption,
      AppLocalizations.of(context)!.alternativeMandi
    ];
    final limited = prices.take(3).toList();
    return List.generate(
      limited.length,
      (i) => Padding(
        padding: EdgeInsets.only(top: i == 0 ? 0 : 12),
        child: _bestMandiCard(limited[i], badge: labels[i]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                AppHeader(title: AppLocalizations.of(context)!.marketPrices, showBack: true, showProfile: false, appState: widget.appState, onBack: () => Navigator.canPop(context) ? context.pop() : context.go('/dashboard')),
                Expanded(
                  child: FutureBuilder<List<MarketPrice>>(
                    future: _pricesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(height: 12),
                                Text(AppLocalizations.of(context)!.fetchingPrices),
                              ],
                            ),
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(AppLocalizations.of(context)!.couldNotLoadPrices),
                              const SizedBox(height: 8),
                              ElevatedButton(onPressed: _retry, child: Text(AppLocalizations.of(context)!.retry)),
                            ],
                          ),
                        );
                      }
                      final prices = snapshot.data ?? [];
                      if (prices.isEmpty) {
                        return Center(child: Text(AppLocalizations.of(context)!.noPricesAvailable));
                      }
                      final bestList = _pickTop(prices);
                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16 + kBottomNavigationBarHeight),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(AppLocalizations.of(context)!.marketPrices, style: const TextStyle(color: AppColors.primaryDark, fontSize: 20, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text(AppLocalizations.of(context)!.livePrices, style: const TextStyle(color: AppColors.muted)),
                            const SizedBox(height: 16),
                            _updatedCard(),
                            const SizedBox(height: 20),
                            ..._bestMandiSection(bestList),
                            const SizedBox(height: 24),
                            _allPrices(prices),
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

class _MarketPriceCard extends StatelessWidget {
  const _MarketPriceCard({required this.price, required this.formatPrice});

  final MarketPrice price;
  final String Function(num) formatPrice;

  @override
  Widget build(BuildContext context) {
    final change = price.percentChange;
    final isNegative = change < 0;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 8))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _cropIcon(price.cropName),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(price.cropName, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(price.mandiName, style: const TextStyle(color: AppColors.primaryDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(price.location, style: const TextStyle(color: AppColors.muted, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(formatPrice(price.currentPrice), style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text('MSP/Prev ${formatPrice(price.previousPrice)}', style: const TextStyle(color: AppColors.muted, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 52, maxWidth: 72),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isNegative ? Colors.red.shade50 : Colors.green.shade50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${isNegative ? '' : '+'}${change.toStringAsFixed(1)}%',
                  style: TextStyle(color: isNegative ? Colors.red : Colors.green, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cropIcon(String crop) {
    final key = crop.toLowerCase();
    final emoji = () {
      if (key.contains('wheat') || key.contains('paddy') || key.contains('rice')) return '🌾';
      if (key.contains('cotton')) return '🌱';
      if (key.contains('tomato')) return '🍅';
      if (key.contains('potato')) return '🥔';
      if (key.contains('soy')) return '🌿';
      return '🌱';
    }();
    return CircleAvatar(
      radius: 22,
      backgroundColor: AppColors.primary.withOpacity(0.1),
      child: Text(emoji, style: const TextStyle(fontSize: 20)),
    );
  }
}
