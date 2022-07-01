import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:news_app_api/helper/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ArticleView extends StatefulWidget {
  final String postUrl;
  ArticleView({@required this.postUrl});

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  int _inlineAdIndex = 3;
  BannerAd _bottomBannerAd;
  BannerAd _inlineBannerAd;
  bool _isBottomBannerAdLoaded = false;
  bool _isInlineBannerAdLoaded = false;

  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd.load();
  }

  void _createInlineBannerAd() {
    _inlineBannerAd = BannerAd(
      size: AdSize.mediumRectangle,
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isInlineBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _inlineBannerAd.load();
  }

  bool chackads(int index) {
    if (index == _inlineAdIndex) {
      _inlineAdIndex == index + 3;
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    _createBottomBannerAd();
    _createInlineBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd.dispose();
    _inlineBannerAd.dispose();
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "BG",
              style:
                  TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
            ),
            Text(
              "News",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            )
          ],
        ),
        actions: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.share,
              ))
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      bottomNavigationBar: _isBottomBannerAdLoaded
          ? Container(
              height: _bottomBannerAd.size.height.toDouble(),
              width: _bottomBannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bottomBannerAd),
            )
          : null,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: WebView(
          initialUrl: widget.postUrl,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}
