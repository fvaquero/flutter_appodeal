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

enum RewardedVideoAdEvent {
  loaded,
  failedToLoad,
  present,
  willDismiss,
  finish,
}

typedef void RewardedVideoAdListener(RewardedVideoAdEvent event,
    {String rewardType, int rewardAmount});

class FlutterAppodeal {

  bool shouldCallListener;

  final MethodChannel _channel;

  /// Called when the status of the video ad changes.
  RewardedVideoAdListener videoListener;

  static const Map<String, RewardedVideoAdEvent> _methodToRewardedVideoAdEvent =
      const <String, RewardedVideoAdEvent>{
    'onRewardedVideoLoaded': RewardedVideoAdEvent.loaded,
    'onRewardedVideoFailedToLoad': RewardedVideoAdEvent.failedToLoad,
    'onRewardedVideoPresent': RewardedVideoAdEvent.present,
    'onRewardedVideoWillDismiss': RewardedVideoAdEvent.willDismiss,
    'onRewardedVideoFinished': RewardedVideoAdEvent.finish,
  };

  static final FlutterAppodeal _instance = new FlutterAppodeal.private(
    const MethodChannel('flutter_appodeal'),
  );

  FlutterAppodeal.private(MethodChannel channel) : _channel = channel {
    _channel.setMethodCallHandler(_handleMethod);
  }

  static FlutterAppodeal get instance => _instance;

  Future initialize(
    String appKey,
    List<AppodealAdType> types,
  ) async {
    shouldCallListener = false;
    List<int> itypes = new List<int>();
    for (final type in types) {
      itypes.add(type.index);
    }
    _channel.invokeMethod('initialize', <String, dynamic>{
      'appKey': appKey,
      'types': itypes,
    });
  }

  /*
    Shows an Interstitial in the root view controller or main activity
   */
  Future showInterstitial() async {
    shouldCallListener = false;
    _channel.invokeMethod('showInterstitial');
  }

  /*
    Shows an Rewarded Video in the root view controller or main activity
   */
  Future showRewardedVideo() async {
    shouldCallListener = true;
    _channel.invokeMethod('showRewardedVideo');
  }

  Future<bool> isLoaded(AppodealAdType type) async {
    shouldCallListener = false;
    final bool result = await _channel
        .invokeMethod('isLoaded', <String, dynamic>{'type': type.index});
    return result;
  }

  Future<dynamic> _handleMethod(MethodCall call) {
    final Map<dynamic, dynamic> argumentsMap = call.arguments;
    final RewardedVideoAdEvent rewardedEvent =
        _methodToRewardedVideoAdEvent[call.method];
    if (rewardedEvent != null && shouldCallListener) {
      if (this.videoListener != null) {
        if (rewardedEvent == RewardedVideoAdEvent.finish && argumentsMap != null) {
          this.videoListener(rewardedEvent,
              rewardType: argumentsMap['rewardType'],
              rewardAmount: argumentsMap['rewardAmount']);
        } else {
          this.videoListener(rewardedEvent);
        }
      }
    }

    return new Future<Null>(null);
  }
}
