import 'dart:io';

import 'package:bibletalkapp/model/bookmark.dart';
import 'package:bibletalkapp/service/bookmark_dbhelper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class BibleSearchResultScreen extends StatefulWidget {
  final String searchQuery;
  final String response;

  const BibleSearchResultScreen({Key? key, required this.searchQuery, required this.response})
      : super(key: key);

  @override
  State<BibleSearchResultScreen> createState() => _BibleSearchResultScreenState();
}

class _BibleSearchResultScreenState extends State<BibleSearchResultScreen> {
  late final BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();

    if(!kIsWeb) {
      String adUnitId = Platform.isAndroid
          ? 'ca-app-pub-2858510929768013/1520697082'
          : 'ca-app-pub-2858510929768013/5710405298';
      _bannerAd = BannerAd(
        adUnitId: adUnitId,
        size: AdSize.fullBanner,
        request: AdRequest(),
        listener: AdManagerBannerAdListener(
          onAdLoaded: (Ad ad) {
            setState(() {
              _isAdLoaded = true;
            });
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            print('Ad failed to load: $error');
            ad.dispose();
          },
        ),
      );
      _bannerAd.load();
    }
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        toolbarHeight: 60,
        title: Text('성경톡', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize:36,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        actions: [
          //북마크 추가
          IconButton(
            onPressed: () async {
              Bookmark bookmark = Bookmark(
                title: widget.searchQuery,
                response: widget.response,
              );

              await BookmarkDBHelper().insertBookmark(bookmark);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  padding: EdgeInsets.all(20),
                  content: Center(child: Text('북마크에 추가되었습니다.', style: TextStyle(fontSize: 24))),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: Icon(Icons.bookmark_add),
            color: Colors.white,
            padding: EdgeInsets.only(right: 20),
          ),
        ],
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height-145,
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 40,),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                child: Text(widget.searchQuery, style: TextStyle(fontSize: 32),)
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(widget.response, style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24,),
                          ],
                        ),
                      ),
                      SizedBox(height: 12,),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: _isAdLoaded && !kIsWeb ?
                Container(
                    color: Colors.grey[200],
                    child: Center(child: AdWidget(ad: _bannerAd))
                )
                    : Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Text('광고를 불러오는 중입니다.'),
                    )
                )
            )
          ],
        ),
      ),
    );
  }
}

