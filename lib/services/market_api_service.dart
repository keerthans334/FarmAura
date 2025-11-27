import 'dart:async';
import '../models/market_price.dart';

class MarketApiService {
  Future<List<MarketPrice>> fetchMarketPrices() async {
    // Placeholder implementation; replace with real API integration when available.
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      MarketPrice(cropName: 'Wheat', mandiName: 'Ranchi APMC Mandi', location: 'Ranchi, Jharkhand', currentPrice: 12180, previousPrice: 11500),
      MarketPrice(cropName: 'Paddy', mandiName: 'Hazaribagh Mandi', location: 'Hazaribagh, Jharkhand', currentPrice: 10250, previousPrice: 9950),
      MarketPrice(cropName: 'Maize', mandiName: 'Bokaro Mandi', location: 'Bokaro, Jharkhand', currentPrice: 8900, previousPrice: 9050),
      MarketPrice(cropName: 'Mustard', mandiName: 'Dhanbad Mandi', location: 'Dhanbad, Jharkhand', currentPrice: 15200, previousPrice: 14600),
      MarketPrice(cropName: 'Cotton', mandiName: 'Ahmedabad APMC', location: 'Ahmedabad, Gujarat', currentPrice: 7200, previousPrice: 6620),
      MarketPrice(cropName: 'Tomato', mandiName: 'Local Mandi', location: 'Ranchi, Jharkhand', currentPrice: 2400, previousPrice: 2600),
      MarketPrice(cropName: 'Potato', mandiName: 'Patna Mandi', location: 'Patna, Bihar', currentPrice: 1300, previousPrice: 1200),
    ];
  }
}
