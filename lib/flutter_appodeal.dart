import 'dart:async';
import 'package:flutter/services.dart';

enum AppodealAdType {
  AppodealAdTypeInterstitial,
  AppodealAdTypeSkippableVideo,
  AppodealAdTypeBanner,
  AppodealAdTypeNativeAd,
  AppodealAdTypeRewardedVideo,
  AppodealAdTypeMREC,
  AppodealAdTypeNonSkippableVideo,
}

class FlutterAppodeal {
  static const MethodChannel _channel = const MethodChannel('flutter_appodeal');

  static void setMethodCallHandler(handler) {
    _channel.setMethodCallHandler(handler);
  }

  static Future initialize(
    String appKey,
    List<AppodealAdType> types,
  ) async {
    List<int> itypes = new List<int>();
    for (final type in types){
      itypes.add(type.index);
    }
    _channel.invokeMethod('initialize', <String, dynamic>{
      'appKey': appKey,
      'types': itypes,
    });
  }

  /*
    Shows an interstitial in the root view controller or main activity
   */
  static Future showInterstitial() async {
    _channel.invokeMethod('showInterstitial');
  }

  static Future showRewardedVideo() async {
    _channel.invokeMethod('showRewardedVideo');
  }

  static Future<bool> isLoaded(AppodealAdType type) async {
    final bool result = await _channel.invokeMethod('isLoaded', <String, dynamic>{'type': type.index});
    return result;
  }
}
