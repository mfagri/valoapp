//import http package
import 'dart:convert';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

class Ads {
  int? istate;
  String? interstitial;
  String? opena;
  String? banner;

  Ads({this.istate, this.interstitial, this.opena, this.banner});

  Ads.fromJson(Map<String, dynamic> json) {
    istate = json['istate'];
    interstitial = json['interstitial'];
    opena = json['opena'];
    banner = json['banner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['istate'] = istate;
    data['interstitial'] = interstitial;
    data['opena'] = opena;
    data['banner'] = banner;
    return data;
  }
}

class Adsapi {
  static Future<dynamic> getads() async {
    const url = 'hor ads api';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to load ads');
    }
    Ads ads = Ads.fromJson(jsonDecode(response.body));
    return ads;
  }

  static AppOpenAd? appOpenAd;
  static InterstitialAd? interstitalAd;
  static BannerAd? bannerAd;

  static Future nitInterstitialAd(String interstitial) async {
    await InterstitialAd.load(
      adUnitId: interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitalAd = ad;
        },
        onAdFailedToLoad: (error) {},
      ),
    );
    return null;
  }

  static Future loadBannerAd(String banner) async {
    bannerAd = BannerAd(
      adUnitId: banner,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {},
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
      ),
    );
    bannerAd?.load();
    return null;
  }

  static Future loadAppOpenAd(String ads) async {
    await AppOpenAd.load(
      adUnitId: ads,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            appOpenAd = ad;
            appOpenAd?.show();
          },
          onAdFailedToLoad: (error) {}),
      orientation: AppOpenAd.orientationPortrait,
    );
    return null;
  }
}
