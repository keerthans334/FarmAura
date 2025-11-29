import 'dart:math';

class NarrationTemplates {
  static String getCropSummary(String crop, String suitability, String profit, String yieldVal) {
    final templates = [
      "I highly recommend growing $crop. It is $suitability percent suitable for your land, and you could earn around $profit rupees.",
      "$crop is a fantastic choice for you! It matches your farm conditions by $suitability percent, with a profit potential of $profit rupees.",
      "Based on your soil, $crop looks excellent. It has a $suitability percent match and can yield about $yieldVal.",
      "You should definitely consider $crop. It fits your farm perfectly with a $suitability percent score and good returns.",
      "For your land, $crop is a top pick. It offers $suitability percent suitability and an expected profit of $profit rupees per hectare."
    ];
    return templates[Random().nextInt(templates.length)];
  }

  static String getWhyThisCropSummary(String crop, String suitability, String ph, String temp, String rain, String market) {
    final templates = [
      "$crop is perfect because your soil pH of $ph is just right. The weather, with $temp degrees and $rain mm rainfall, is also ideal.",
      "Your farm has the right conditions for $crop. With a $suitability percent match and good market demand at $market, it's a smart choice.",
      "We recommend $crop because of the excellent soil match and favorable weather conditions this season. It's $suitability percent suitable.",
      "With a $suitability percent score, $crop thrives in your soil's pH of $ph. The current weather is also very supportive.",
      "The conditions are ideal for $crop. Your soil fertility and the current weather forecast make it a strong candidate for high profit."
    ];
    return templates[Random().nextInt(templates.length)];
  }

  static String getDetailedExplanation(String crop, String suitability, String profit, String yieldVal, String fertilizer, String reason) {
    final templates = [
      "Here is a detailed look at why $crop is a great choice for you. It has a high suitability score of $suitability percent. You can expect a yield of $yieldVal, which translates to a profit of roughly $profit rupees. $reason Additionally, regarding fertilizers: $fertilizer",
      "We strongly recommend $crop for your farm. It matches your land conditions by $suitability percent. The expected yield is $yieldVal, giving you a profit of around $profit rupees. The main technical reason is: $reason. For best results, follow this fertilizer advice: $fertilizer",
      "Based on our analysis, $crop is an excellent option. It fits your soil and climate with a $suitability percent match. With a yield of $yieldVal, you could earn $profit rupees. $reason Don't forget: $fertilizer",
      "$crop is a top recommendation with $suitability percent suitability. It offers a good balance of yield ($yieldVal) and profit ($profit rupees). $reason As for nutrition: $fertilizer",
    ];
    return templates[Random().nextInt(templates.length)];
  }
}
