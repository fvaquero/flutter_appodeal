# flutter_appodeal

A Flutter plugin for iOS and Android to use Appodel SDK in your apps

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/platform-plugins/#edit-code).

You need to configure your apps first you use this plugin. Please refer to [Appodeal](https://www.appodeal.com/) documentation to get your apps configured.
If you have any problems configuring your Flutter project, please take a look to Example project in the plugin code.

Import the library via
``` dart
import 'package:flutter_appodeal/flutter_appodeal.dart';
```

Declare your listener to get notified about RewardedVideos callbacks
``` dart
  FlutterAppodeal.instance.videoListener = (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
    print("RewardedVideoAd event $event");
    setState(() {
      videoState = "State $event";
    });
  };
```

Initialize the plugin with your App Keys
``` dart
  List<AppodealAdType> types = new List<AppodealAdType>();
  types.add(AppodealAdType.AppodealAdTypeInterstitial);
  types.add(AppodealAdType.AppodealAdTypeRewardedVideo);

   // You should use here your APP Key from Appodeal
   await FlutterAppodeal.instance.initialize(Platform.isIOS ? 'IOSAPPKEY' : 'ANDROIDAPPKEY', types);
```

And the you can use it in your code
``` dart
  void loadInterstital() async {
    bool loaded = await FlutterAppodeal.instance.isLoaded(AppodealAdType.AppodealAdTypeInterstitial);
    if (loaded) {
      FlutterAppodeal.instance.showInterstitial();
    }else{
      print("Interstitial not loaded");
    }
  }
```

## Features

You can use, for now, Interstitials and Rewarded Videos. And there is a way to get notified for the RewardedVideos callbacks
