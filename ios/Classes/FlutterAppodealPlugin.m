#import "FlutterAppodealPlugin.h"

@interface FlutterAppodealPlugin(){
    FlutterMethodChannel* channel;
}
@end

@implementation FlutterAppodealPlugin

+ (UIViewController *)rootViewController {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_appodeal"
            binaryMessenger:[registrar messenger]];
    FlutterAppodealPlugin* instance = [[FlutterAppodealPlugin alloc] init];
    [instance setChannel:channel];
    [Appodeal setRewardedVideoDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void) setChannel:(FlutterMethodChannel*) chan{
    channel = chan;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"initialize" isEqualToString:call.method]) {
      NSString* appKey = call.arguments[@"appKey"];
      NSArray* types = call.arguments[@"types"];
      AppodealAdType type = types.count > 0 ? [self typeFromParameter:types.firstObject] : AppodealAdTypeInterstitial;
      int i = 1;
      while (i < types.count) {
          type = type | [self typeFromParameter:types[i]];
          i++;
      }
      [Appodeal initializeWithApiKey:appKey types:type];
      result([NSNumber numberWithBool:YES]);
  }else if ([@"showInterstitial" isEqualToString:call.method]) {
      [Appodeal showAd:AppodealShowStyleInterstitial rootViewController:[FlutterAppodealPlugin rootViewController]];
      result([NSNumber numberWithBool:YES]);
  }else if ([@"showRewardedVideo" isEqualToString:call.method]) {
      [Appodeal showAd:AppodealShowStyleRewardedVideo rootViewController:[FlutterAppodealPlugin rootViewController]];
      result([NSNumber numberWithBool:YES]);
  }else if ([@"isLoaded" isEqualToString:call.method]) {
      NSNumber *type = call.arguments[@"type"];
      result([NSNumber numberWithBool:[Appodeal isReadyForShowWithStyle:[self showStyleFromParameter:type]]]);
  }else {
    result(FlutterMethodNotImplemented);
  }
}

- (AppodealAdType) typeFromParameter:(NSNumber*) parameter{
    switch ([parameter intValue]) {
        case 0:
            return AppodealAdTypeInterstitial;
        case 4:
            return AppodealAdTypeRewardedVideo;
            
        default:
            break;
    }
    return AppodealAdTypeInterstitial;
}

- (AppodealShowStyle) showStyleFromParameter:(NSNumber*) parameter{
    switch ([parameter intValue]) {
        case 0:
            return AppodealShowStyleInterstitial;
        case 4:
            return AppodealShowStyleRewardedVideo;
            
        default:
            break;
    }
    return AppodealShowStyleInterstitial;
}

#pragma mark - RewardedVideo Delegate

- (void)rewardedVideoDidLoadAd {
    [channel invokeMethod:@"onRewardedVideoLoaded" arguments:nil];
}

- (void)rewardedVideoDidFailToLoadAd {
    [channel invokeMethod:@"onRewardedVideoFailedToLoad" arguments:nil];
}

- (void)rewardedVideoDidPresent {
    [channel invokeMethod:@"onRewardedVideoPresent" arguments:nil];
}

- (void)rewardedVideoWillDismiss {
    [channel invokeMethod:@"onRewardedVideoWillDismiss" arguments:nil];
}

- (void)rewardedVideoDidFinish:(NSUInteger)rewardAmount name:(NSString *)rewardName {
    NSDictionary *params = rewardName != nil ? @{
                                                 @"rewardAmount" : @(rewardAmount),
                                                 @"rewardType" : rewardName
                                                 }: nil;
    [channel invokeMethod:@"onRewardedVideoFinished" arguments: params];
}

@end
