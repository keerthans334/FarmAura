class MarketPrice {
  MarketPrice({
    required this.cropName,
    required this.mandiName,
    required this.location,
    required this.currentPrice,
    required this.previousPrice,
  });

  final String cropName;
  final String mandiName;
  final String location;
  final int currentPrice;
  final int previousPrice;

  double get percentChange {
    if (previousPrice == 0) return 0;
    return ((currentPrice - previousPrice) / previousPrice) * 100;
  }

  String get cropKey => cropName.toLowerCase();

  double get estimatedProfit => (currentPrice - previousPrice).toDouble();
}
