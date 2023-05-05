import 'package:bibletalkapp/model/bible_book.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:simple_tooltip/simple_tooltip.dart';
import '../model/token.dart';
import '../service/token_dbhelper.dart';
import 'bible_search_result_screen.dart';
import 'dart:io';

class BibleSearchScreen extends StatefulWidget {
  const BibleSearchScreen({Key? key}) : super(key: key);

  @override
  _BibleSearchScreenState createState() => _BibleSearchScreenState();
}

class _BibleSearchScreenState extends State<BibleSearchScreen> {
  String _searchText = '';
  bool _isLoadng = false;
  bool _isTooltipVisible = false;

  List<String> _bibleSections = ['구약', '신약'];
  String _selectedBibleSection = '구약';
  int _selectedBookIndex = 0;
  int _selectedChapter = 1;
  int _selectedVerse = 1;

  late InterstitialAd? _interstitialAd;

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

  void _onSearchTextChanged(String value) {
    setState(() {
      _searchText = value;
    });
  }

  Future<String> getChatGPTResponse(String prompt) async {

    await dotenv.load(fileName: ".env");
    final String apiKey = dotenv.env['OPENAI_API_KEY'].toString();
    final String apiUrl = "https://api.openai.com/v1/chat/completions";
    final String bookName = _selectedBibleSection == "구약"? oldTestamentBooks[_selectedBookIndex].name : newTestamentBooks[_selectedBookIndex].name;
    final String fromBible = bookName + " " + _selectedChapter.toString() + "장 " + _selectedVerse.toString()+"절";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "system", "content": "Ask me about a word in $fromBible"},
          {"role": "user", "content": "$prompt 무슨 뜻인가요? 300자 이상 입력해주세요. "},
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
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
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
                        "성경 단어 해설",
                        style: TextStyle(
                          color: Colors.brown[600],
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButton<String>(
                          borderRadius: BorderRadius.circular(10),
                          value: _selectedBibleSection,
                          items: _bibleSections.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: TextStyle(fontSize: 22)),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedBibleSection = newValue!;
                              _selectedBookIndex = 0;
                              _selectedChapter = 1;
                              _selectedVerse = 1;
                            });
                          },
                        ),
                        DropdownButton<String>(
                          menuMaxHeight: 500,
                          alignment: Alignment.center,
                          value:  _selectedBibleSection == '구약' ? oldTestamentBooks[_selectedBookIndex].name : newTestamentBooks[_selectedBookIndex].name,
                          items: (_selectedBibleSection == '구약' ? oldTestamentBooks : newTestamentBooks).map<DropdownMenuItem<String>>((BibleBook value) {
                            return DropdownMenuItem<String>(
                              value: value.name,
                              child: Center(child: Text(value.name, style: TextStyle(fontSize: 22))),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedBookIndex = _selectedBibleSection == '구약' ? oldTestamentBooks.indexWhere((element) => element.name == newValue) : newTestamentBooks.indexWhere((element) => element.name == newValue);
                              _selectedChapter = 1;
                              _selectedVerse = 1;
                            });
                          },
                        ),
                        DropdownButton(
                          menuMaxHeight: 500,
                          alignment: Alignment.center,
                          value: _selectedChapter,
                          items: List.generate(
                            (_selectedBibleSection == '구약' ? oldTestamentBooks[_selectedBookIndex].chapters : newTestamentBooks[_selectedBookIndex].chapters),
                                (index) => DropdownMenuItem(
                              value: index + 1,
                              child: Text('${index + 1}', style: TextStyle(fontSize: 24)),
                            ),
                          ),
                          onChanged: (int? newValue) {
                            setState(() {
                              _selectedChapter = newValue!;
                              _selectedVerse = 1;
                            });
                          },
                        ),
                        DropdownButton(
                          menuMaxHeight: 500,
                          alignment: Alignment.center,
                          value: _selectedVerse,
                          items: List.generate((_selectedBibleSection == '구약' ? oldTestamentBooks[_selectedBookIndex].versesPerChapter[_selectedChapter-1] : newTestamentBooks[_selectedBookIndex].versesPerChapter[_selectedChapter-1]), (index) => index+1).map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString(), style: TextStyle(fontSize: 24)),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            setState(() {
                              _selectedVerse = newValue!;
                            });
                          },
                        )
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        maxLength: 10,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1,
                        ),
                        decoration: InputDecoration(
                          hintText: '정확한 장 절을 입력하세요.',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 24,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1,
                          ),
                        ),
                        onChanged: _onSearchTextChanged,
                      ),
                    ),
                    //로딩중이면 로딩중 표시 다른 위젯 위에 띄우기
                    SizedBox(height: 10),
                    ElevatedButton(
                      child: Text(
                        '질문하기',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1,
                        ),
                      ),
                      onPressed: () async {
                        if(_searchText == '' || _searchText == null) {
                          // showalertdialog
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("질문을 입력해주세요."),
                                  actions: [
                                    TextButton(
                                      child: Text("확인"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              }
                          );
                          return;
                        }
                        setState(() {
                          _isLoadng = true;
                        });
                        FocusScope.of(context).unfocus();

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
                        int count = await TokenDBHelper.refreshToken();

                        if(count > 0) {
                          await TokenDBHelper.costToken();
                          response = await getChatGPTResponse(_searchText);
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
                          response = await getChatGPTResponse(_searchText);
                        } else {
                          response = await getChatGPTResponse(_searchText);
                        }

                        setState(() {
                          _isLoadng = false;
                        });

                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BibleSearchResultScreen(
                                  searchQuery: _searchText,
                                  response: response,
                                )
                            )
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  "이 서비스는 ChatGPT를 활용하는 서비스입니다. 번역 오류 및 데이터 오류가 있을 수 있으니, 참고만 하시고 교회 목사님과 성경 해석에 대해 상담하시는 것을 권장합니다.",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1,
                  ),
                ),
              ),

              //성경 검색하기 이동 버튼
              SizedBox(height: 30),
              // ElevatedButton(
              //   child: Text(
              //     '성경 구절 해설',
              //     style: TextStyle(
              //       color: Colors.grey,
              //       fontSize: 24,
              //       fontWeight: FontWeight.w300,
              //       letterSpacing: 1,
              //     ),
              //   ),
              //   onPressed: () {
              //     Navigator.pushReplacement(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => BibleTalkApp(index: 1),
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
