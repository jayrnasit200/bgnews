import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app_api/helper/data.dart';
import 'package:news_app_api/helper/widgets.dart';
import 'package:news_app_api/models/categorie_model.dart';
import 'package:news_app_api/views/categorie_news.dart';
import '../helper/news.dart';
import 'package:news_app_api/helper/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _inlineAdIndex = 3;
  BannerAd _bottomBannerAd;
  BannerAd _inlineBannerAd;
  bool _isBottomBannerAdLoaded = false;
  bool _isInlineBannerAdLoaded = false;
  bool _loading;
  var newslist;
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
  // int _getListViewItemIndex(int index) {
  //   if (index >= _inlineAdIndex && _isInlineBannerAdLoaded) {
  //     return index - 1;
  //   }
  //   return index;
  // }

  List<CategorieModel> categories = List<CategorieModel>();

  void getNews() async {
    News news = News();
    await news.getNews();
    newslist = news.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    _loading = true;
    super.initState();
    _createBottomBannerAd();
    _createInlineBannerAd();
    super.initState();

    categories = getCategories();
    getNews();
  }

  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd.dispose();
    _inlineBannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      bottomNavigationBar: _isBottomBannerAdLoaded
          ? Container(
              height: _bottomBannerAd.size.height.toDouble(),
              width: _bottomBannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bottomBannerAd),
            )
          : null,
      body: SafeArea(
        child: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      /// Categories
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 70,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return CategoryCard(
                                imageAssetUrl: categories[index].imageAssetUrl,
                                categoryName: categories[index].categorieName,
                              );
                            }),
                      ),

                      /// News Article
                      Container(
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
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  BannerAd get newMethod => _inlineBannerAd;
}

class CategoryCard extends StatelessWidget {
  final String imageAssetUrl, categoryName;

  CategoryCard({this.imageAssetUrl, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryNews(
                      newsCategory: categoryName.toLowerCase(),
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 14),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                imageUrl: imageAssetUrl,
                height: 60,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 60,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black26),
              child: Text(
                categoryName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
