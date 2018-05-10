package com.divertap.flutter.flutterappodeal;

import android.app.Activity;

import com.appodeal.ads.Appodeal;

import java.util.List;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.presage.finder.model.App;

/**
 * FlutterAppodealPlugin
 */
public class FlutterAppodealPlugin implements MethodCallHandler {

    private final Registrar registrar;
    private final MethodChannel channel;

    public FlutterAppodealPlugin(Registrar registrar, MethodChannel channel) {
        this.registrar = registrar;
        this.channel = channel;
    }

    /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_appodeal");
    channel.setMethodCallHandler(new FlutterAppodealPlugin(registrar, channel));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
      Activity activity = registrar.activity();
      if (activity == null) {
          result.error("no_activity", "firebase_admob plugin requires a foreground activity", null);
          return;
      }
      if (call.method.equals("initialize")) {
          String appKey = call.argument("appKey");
          List<Integer> types = call.argument("types");
          int type = Appodeal.NONE;
          for (int type2: types){
              type = type | this.appodealAdType(type2);
          }
          Appodeal.initialize(activity, appKey, type);
          result.success(Boolean.TRUE);
      } else if (call.method.equals("showInterstitial")) {
          Appodeal.show(activity, Appodeal.INTERSTITIAL);
          result.success(Boolean.TRUE);
      } else if (call.method.equals("showRewardedVideo")) {
          Appodeal.show(activity, Appodeal.REWARDED_VIDEO);
          result.success(Boolean.TRUE);
      } else if (call.method.equals("isLoaded")) {
          int type = call.argument("type");
          int adType = this.appodealAdType(type);
          result.success(Appodeal.isLoaded(adType));
      } else {
          result.notImplemented();
      }
  }

  int appodealAdType(int innerType){
      switch (innerType){
          case 0:
              return Appodeal.INTERSTITIAL;
          case 1:
              return Appodeal.NON_SKIPPABLE_VIDEO;
          case 2:
              return Appodeal.BANNER;
          case 3:
              return Appodeal.NATIVE;
          case 4:
              return Appodeal.REWARDED_VIDEO;
          case 5:
              return Appodeal.MREC;
          case 6:
              return Appodeal.NON_SKIPPABLE_VIDEO;
      }
      return Appodeal.INTERSTITIAL;
  }
}
