//here we will create a class that will be responsible for loading ads

//this is my ad unit : ca-app-pub-7459783790569609/6557854588

import 'dart:developer';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static String get bannerAdUnitId => 'ca-app-pub-7459783790569609/6557854588';

  //we are only gonna display the banner add in the appbar;

  bool isBannerAdLoaded = false;
  late BannerAd bannerAd;

  //initializing the banner ad
  void loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          log('Banner Ad loaded');
          isBannerAdLoaded = true;
        },
        onAdFailedToLoad: (ad, error) {
          log('Banner Ad failed to load');
          isBannerAdLoaded = false;
          ad.dispose();
        },
      ),
    );

    bannerAd.load();
  }
}
