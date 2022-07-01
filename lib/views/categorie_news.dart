import 'package:flutter/material.dart';
import 'package:news_app_api/helper/news.dart';
import 'package:news_app_api/helper/widgets.dart';
import 'package:news_app_api/helper/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';

class CategoryNews extends StatefulWidget {
  final String newsCategory;

  CategoryNews({this.newsCategory});

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  int _inlineAdIndex = 3;
  BannerAd _bottomBannerAd;
  BannerAd _inlineBannerAd;
  bool _isBottomBannerAdLoaded = false;
  bool _isInlineBannerAdLoaded = false;
  var newslist;
  bool _loading = true;
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
    _loading = true;
    super.initState();
    _createBottomBannerAd();
    _createInlineBannerAd();
    super.initState();

    getNews();
  }

  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd.dispose();
    _inlineBannerAd.dispose();
  }

  void getNews() async {
    NewsForCategorie news = NewsForCategorie();
    await news.getNewsForCategory(widget.newsCategory);
    newslist = news.news;
    setState(() {
      _loading = false;
    });
  }

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
          Opacity(
            opacity: 0,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.share,
                )),
          )
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
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                child: Container(
                  margin: EdgeInsets.only(top: 16),
                  child: ListView.builder(
                      itemCount: newslist.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (chackads(index)) {
                          return Container(
                            padding: EdgeInsets.only(
                              bottom: 10,
                            ),
                            width: _inlineBannerAd.size.width.toDouble(),
                            height: newMethod.size.height.toDouble(),
                            child: AdWidget(ad: _inlineBannerAd),
                          );
                        } else {
                          return NewsTile(
                            imgUrl: newslist[index].urlToImage ?? "",
                            title: newslist[index].title ?? "",
                            desc: newslist[index].description ?? "",
                            content: newslist[index].content ?? "",
                            posturl: newslist[index].articleUrl ?? "",
                          );
                        }
                      }),
                ),
              ),
            ),
    );
  }

  BannerAd get newMethod => _inlineBannerAd;
}
