import 'dart:io';
import 'package:bibletalkapp/screen/bible_list_screen.dart';
import 'package:bibletalkapp/screen/bible_search_screen.dart';
import 'package:bibletalkapp/screen/bookmark_list_screen.dart';
import 'package:bibletalkapp/screen/faith_question_screen.dart';
import 'package:bibletalkapp/screen/setting_screen.dart';
import 'package:bibletalkapp/screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BibleTalkTalk',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BibleTalkApp extends StatefulWidget {
  final int index;
  const BibleTalkApp({Key? key, this.index = 0}) : super(key: key);

  @override
  State<BibleTalkApp> createState() => _BibleTalkAppState();

}

class _BibleTalkAppState extends State<BibleTalkApp> {
  int _selectedIndex = 0;

  late final BannerAd _bannerAd;
  bool _isAdLoaded = false;

  List<Widget> _widgetOptions = <Widget>[
    // 신앙 질문 화면
    FaithQuestionScreen(),
    // 구절 검색 화면
    BibleListScreen(),
    // 성경 채팅 화면
    BibleSearchScreen(),
    // 북마크 화면
    BookMarkListScreen(),
    // 설정 화면
    SettingScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;

    if(!kIsWeb) {
      String adUnitId = Platform.isAndroid
          ? 'ca-app-pub-2858510929768013/7715043109'
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height-50,
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  backgroundColor: Colors.brown,
                  toolbarHeight: 60,
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                  title: Text('성경톡'),
                  centerTitle: true,
                ),
                body: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      child: _widgetOptions.elementAt(_selectedIndex),
                    ),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  fixedColor: Colors.grey,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.question_answer_outlined, color: Colors.brown,),
                      label: '신앙 질문',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.menu_book_outlined, color: Colors.brown,),
                      label: '구절 검색',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.search, color: Colors.brown,),
                      label: '단어 검색',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.bookmark, color: Colors.brown,),
                      label: '북마크',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings, color: Colors.brown,),
                      label: '설정',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Container(
                color: Colors.grey[200],
                child: (_isAdLoaded && !kIsWeb) ? Center(child: AdWidget(ad: _bannerAd)) : Center(child: Text('광고를 불러오는 중입니다.')),
              ),
            )
          ],
        ),
      ),
    );
  }
}