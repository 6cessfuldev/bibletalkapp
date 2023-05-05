import 'dart:io';

import 'package:bibletalkapp/screen/bible_search_result_screen.dart';
import 'package:bibletalkapp/screen/result_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simple_tooltip/simple_tooltip.dart';
import '../model/bible_book.dart';
import '../model/token.dart';
import '../service/token_dbhelper.dart';

class BibleListScreen extends StatefulWidget {
  const BibleListScreen({Key? key}) : super(key: key);

  @override
  State<BibleListScreen> createState() => _BibleListScreenState();
}

class _BibleListScreenState extends State<BibleListScreen> {
  bool _showOldTestament = true;
  int selectedChapter = 1;
  int selectedVerse = 1;
  bool _isLoading = false;
  bool _isTooltipVisible = false;

  late InterstitialAd? _interstitialAd;

  final List<String> _oldTestamentBooks = [
    '창세기',
    '출애굽기',
    '레위기',
    '민수기',
    '신명기',
    '여호수아',
    '사사기',
    '룻기',
    '사무엘상',
    '사무엘하',
    '열왕기상',
    '열왕기하',
    '역대상',
    '역대하',
    '에스라',
    '느헤미야',
    '에스더',
    '욥기',
    '시편',
    '잠언',
    '전도서',
    '아가',
    '이사야',
    '예레미야',
    '예레미야애가',
    '에스겔',
    '다니엘',
    '호세아',
    '요엘',
    '아모스',
    '오바댜',
    '요나',
    '미가',
    '나훔',
    '하박국',
    '스바냐',
    '학개',
    '스가랴',
    '말라기'
  ];

  final List<String> _newTestamentBooks = [
    '마태복음',
    '마가복음',
    '누가복음',
    '요한복음',
    '사도행전',
    '로마서',
    '고린도전서',
    '고린도후서',
    '갈라디아서',
    '에베소서',
    '빌립보서',
    '골로새서',
    '데살로니가전서',
    '데살로니가후서',
    '디모데전서',
    '디모데후서',
    '디도서',
    '빌레몬서',
    '히브리서',
    '야고보서',
    '베드로전서',
    '베드로후서',
    '요한일서',
    '요한이서',
    '요한삼서',
    '유다서',
    '요한계시록'
  ];

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  Future<void> _loadInterstitialAd() async {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid ? 'ca-app-pub-2858510929768013/8307776339' : 'ca-app-pub-2858510929768013/1327983752',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('Ad failed to load: $error');
        },
      ),
    );
  }

  void _onBookSelected(String bookName) {
    // 선택한 성경책 이름을 파라미터로 받아서,
    // 해당 성경책의 장 수와 절 수를 드롭다운 형식으로 입력 받는 위젯
    List<BibleBook> bibleList = _showOldTestament ? oldTestamentBooks : newTestamentBooks;
    BibleBook bibleBook = bibleList.firstWhere((element) => element.name == bookName);
    int chapter = 1;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(

              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$bookName'),
                ],
              ),
              titlePadding: const EdgeInsets.all(20),
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              content: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 20),
                  DropdownButton(
                    value: selectedChapter,
                    items: List.generate(
                      bibleBook.chapters,
                          (index) => DropdownMenuItem(
                        child: Text('${index + 1}장', style: TextStyle(fontSize: 28)),
                        value: index + 1,
                      ),
                    ),
                    onChanged: (value) {
                      if(!_isLoading) {
                        setState(() {
                          selectedChapter = value as int;
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 20),
                  DropdownButton(
                    value: selectedVerse,
                    items: List.generate(
                      bibleBook.versesPerChapter[selectedChapter - 1],
                          (index) => DropdownMenuItem(
                        child: Text('${index + 1}절', style: TextStyle(fontSize: 28)),
                        value: index + 1,
                      ),
                    ),
                    onChanged: (value) {
                      if(!_isLoading) {
                        setState(() {
                          selectedVerse = value as int;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    String prompt =

                        "$bookName $selectedChapter장 $selectedVerse절에 대해 설명해줘.";

                    setState(() {
                      _isLoading = true;
                    });

                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return WillPopScope(
                            onWillPop: () async => false,
                            child: AlertDialog(
                              title: Text("질문을 전송하고 있습니다."),
                              content: Row(
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(width: 20),
                                  Text("잠시만 기다려주세요."),
                                ],
                              ),
                            ),
                          );
                        }
                    );

                    String response = '';

                    int _token = await TokenDBHelper.refreshToken();

                    if(_token > 0) {
                      await TokenDBHelper.costToken();
                      response = await getChatGPTResponse(prompt);
                    } else if(_interstitialAd != null) {
                      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
                        onAdDismissedFullScreenContent: (ad) {
                          ad.dispose();
                          _loadInterstitialAd();
                        },
                        onAdFailedToShowFullScreenContent: (ad, error) {
                          ad.dispose();
                          _loadInterstitialAd();
                        },
                      );
                      _interstitialAd!.show();
                      _interstitialAd = null;
                      response = await getChatGPTResponse(prompt);
                    } else {
                      response = await getChatGPTResponse(prompt);
                    }

                    setState(() {
                      _isLoading = false;
                    });

                    Navigator.pop(context);

                    String title = bookName + ' ' + selectedChapter.toString() + '장 ' + selectedVerse.toString() + '절';

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BibleSearchResultScreen(searchQuery: title, response: response),
                        )
                    );
                  },
                  child: Text('확인', style: TextStyle(fontSize: 28, color: Colors.black)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<String> getChatGPTResponse(String prompt) async {
    await dotenv.load(fileName: ".env");
    final String apiKey = dotenv.env['OPENAI_API_KEY'].toString();
    final String apiUrl = "https://api.openai.com/v1/chat/completions";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content":
              "너는 보수적이고 전통적인 복음주의 교회의 기독교 목사 역할을 맡아줘."
              "너의 자기소개와 인사는 하지 말고 바로 내용 설명만 해주면 돼. "
              "존댓말을 써주면 돼. "
              "마무리 인사도 하지마. "
              "내가 물어본 내용과 관련된 내용이 성경 다른 곳에도 있다면 언급해주면 좋아. "
              "근데 성경 다른 부분을 이야기할 때 꼭 몇 장 몇 절인지 이야기해줘 "
              "단어 해석 위주로 설명해주면 돼. "
              "성경 본문은 직접 말하지 말고 설명만 해줘. "},
          {"role": "assistant", "content": "안녕하세요. 저는 보수적이고 전통적인 복음주의 교회의 목사입니다."
              "성경과 기독교에 대해 질문하신다면 저에게 물어보세요. "},
          {"role":"user", "content": '$prompt에 대해 알려주세요. 1000자 이내로 답변해주세요.'},
        ],
        "max_tokens": 1000,
        "n": 1,
        "stop": null,
        "temperature": 0,
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse['choices'][0]['message']['content'];
    } else {
      throw Exception("Failed to get response from ChatGPT API");
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          SizedBox(height: 40),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 30,
                      width: 70,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.brown[400],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 5),
                          Icon(CupertinoIcons.bolt_horizontal_circle, color: Colors.white, size: 20,),
                          SizedBox(width: 5),
                          FutureBuilder(
                              future: TokenDBHelper.refreshToken(),
                              builder: (context, snapshot) {
                                if(snapshot.connectionState == ConnectionState.done) {
                                  return Text(snapshot.data.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white, height: 1),);
                                } else {
                                  return Container();
                                }
                              }
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                    SimpleTooltip(
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () { setState(() { _isTooltipVisible = !_isTooltipVisible; }); },
                          icon: Icon(CupertinoIcons.exclamationmark_circle, color: Colors.brown[400],
                            size: 25,)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('광고시청 없이 질문 가능한 횟수', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Colors.black87, height: 1.5)),
                          Text('(자정마다 5회로 초기화됩니다) ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Colors.black87, height: 1.5)),
                        ],
                      ),
                      show: _isTooltipVisible,
                      hideOnTooltipTap: false,
                      animationDuration: Duration(milliseconds: 200),
                      tooltipDirection: TooltipDirection.left,
                      arrowTipDistance: 50,
                      ballonPadding: EdgeInsets.all(10),
                      borderColor: Colors.brown[100]!,
                      borderWidth: 1,
                      arrowLength: 80,
                      tooltipTap: () {
                        setState(() {
                          _isTooltipVisible = true;
                        });
                      },
                    ),
                  ],
                ),
                Center(
                  child: Text(
                    "성경 구절 해설",
                    style: TextStyle(
                      color: Colors.brown[600],
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        "ChatGPT를 이용해 성경 구절을 해설해드립니다. 번역 및 데이터의 오류가 있을 수 있으니 참고용으로만 활용하세요.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.brown[400],
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _showOldTestament ? Colors.brown[200] : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    '구약',
                    style: TextStyle(
                      color: _showOldTestament ? Colors.white : Colors.blueGrey,
                      fontSize: 36,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _showOldTestament = true;
                    });
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _showOldTestament ? Colors.white : Colors.brown[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    '신약',
                    style: TextStyle(
                      color: _showOldTestament ? Colors.blueGrey : Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _showOldTestament = false;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              childAspectRatio: 2,
              crossAxisCount: 3,
              children: List.generate(
                _showOldTestament ? _oldTestamentBooks.length : _newTestamentBooks.length,
                    (index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.all(0),
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Text(
                      _showOldTestament ? _oldTestamentBooks[index] : _newTestamentBooks[index],
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                    onPressed: () {
                      _onBookSelected(_showOldTestament ? _oldTestamentBooks[index] : _newTestamentBooks[index]);
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
