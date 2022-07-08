import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // return "ca-app-pub-3940256099942544/6300978111";
      return "ca-app-pub-4652444325266246/7054672320";
    } else if (Platform.isIOS) {
      // return "ca-app-pub-3940256099942544/2934735716";
      return "ca-app-pub-4652444325266246/2057781922";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      // return "ca-app-pub-3940256099942544/8691691433";
      return "ca-app-pub-4652444325266246/3377755960";
    } else if (Platform.isIOS) {
      // return "ca-app-pub-3940256099942544/5135589807";
      return "ca-app-pub-4652444325266246/4089306053";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  // static String get nativeAdUnitId {
  //   if (Platform.isAndroid) {
  //     return 'ca-app-pub-3940256099942544/2247696110';
  //   } else if (Platform.isIOS) {
  //     return 'ca-app-pub-3940256099942544/3986624511';
  //   }
  //   throw new UnsupportedError("Unsupported platform");
  // }
}
