import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';

class AdvertService {
  static final AdvertService _instance = AdvertService._internal();

  factory AdvertService() => _instance;
  MobileAdTargetingInfo _targetingInfo;
  int counter = 0;
  final String _bannerAd = Platform.isAndroid
      ? 'ca-app-pub-2812099030925263~4624829420'
      : 'ca-app-pub-1985780481766193/9671340266';
  static final String _rewbannerAd = "ca-app-pub-2812099030925263/2736214440";

  AdvertService._internal() {
    _targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['gamer', 'games', 'game', "player", "players"],
      contentUrl: 'https://www.wcrop.com',
      nonPersonalizedAds: true,
    );
  }

  showBanner() {
    BannerAd bannerAd = BannerAd(
      adUnitId: _bannerAd,
      size: AdSize.smartBanner,
      targetingInfo: _targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );

    bannerAd
      ..load()
      ..show(
        anchorOffset: 50,
      );

    bannerAd.dispose();
  }

  showInterstitial() {
    InterstitialAd interstitialAd = InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: _targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );

    interstitialAd
      ..load()
      ..show();

    interstitialAd.dispose();
  }

  showRewar() {
    RewardedVideoAd.instance.load(
      adUnitId: _rewbannerAd,
      targetingInfo: _targetingInfo,
    );

    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.rewarded) {
        print("ödül verildi");
        odullereklam();
        counter += rewardAmount;
        print(counter);
      } else if(event == RewardedVideoAdEvent.loaded){
        print("reklam yuklendi ve gösterilecek");
        RewardedVideoAd.instance.show();
      }else if (event == RewardedVideoAdEvent.closed) {
        print("reklam kapatıldı");
        odullereklam();
      } else if (event == RewardedVideoAdEvent.failedToLoad) {
        print("reklam bulunamadı");
      } else if (event == RewardedVideoAdEvent.completed) {
        print("reklam tamamlandı");
        odullereklam();
      }
    };
  }
  void odullereklam(){
    RewardedVideoAd.instance.load(
      adUnitId: _bannerAd,
      targetingInfo: _targetingInfo,
    );
  }

}
