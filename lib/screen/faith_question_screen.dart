import 'dart:io';
import 'package:bibletalkapp/service/token_dbhelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:simple_tooltip/simple_tooltip.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../model/token.dart';
import 'bible_search_result_screen.dart';
class FaithQuestionScreen extends StatefulWidget {
  const FaithQuestionScreen({Key? key}) : super(key: key);

  @override
  State<FaithQuestionScreen> createState() => _FaithQuestionScreenState();
}

class _FaithQuestionScreenState extends State<FaithQuestionScreen> {
  bool _isTooltipVisible = false;
  bool _isLoading = false;
  String _searchText = '';

  late InterstitialAd? _interstitialAd = null;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
    TokenDBHelper.refreshToken();

  }

  Future<void> _loadInterstitialAd() async {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid ?
      'ca-app-pub-2858510929768013/8307776339'
      : 'ca-app-pub-2858510929768013/1327983752',
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

  Future<String> getChatGPTResponse(String prompt) async {

    //String trasnlateText = await TranslateService.translateText(prompt, 'ko', 'en');

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
          
          //한글로 물어보기
          {"role": "user",
            "content": "Act as a counselor from a conservative and traditional Christian perspective. I will give you a question. Please answer it. "},
          {"role": "assistant", "content": "Sure. if you give me a prompt, I can help you."},
          {"role": "user", "content": "I have a question about the christianity. But don't quote the bible."},
          {"role": "assistant", "content": "Sure. if you give me a question, I can help you. "},
          {"role": "user", "content": "If I give you a question, consult me and cheer me up in the end, please! "},
          {"role": "assistant", "content": "Sure. I will give you a advice about christianity."},
          {"role": "user", "content": "'$prompt'. 이게 내 고민입니다. 700자 이내로 조언해주세요. "},
        ],
        "max_tokens": 1000,
        "n": 1,
        "stop": null,
        "temperature": 0.5,
        "top_p": 0.9,
        "presence_penalty": 0.2,
        "frequency_penalty": 0.2,
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      String result = jsonResponse['choices'][0]['message']['content'];
      return result;
      // return await TranslateService.translateText(result, 'en', 'ko');
    } else {
      throw Exception("Failed to get response from ChatGPT API");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                  SizedBox(height: 14),
                  Center(
                    child: Text(
                      "고민 Q&A",
                      style: TextStyle(
                        color: Colors.brown[600],
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "다른 사람에게 말 못 할 고민이 있다면",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    "가벼운 마음으로 질문해보세요.",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                      maxLength: 30,
                      onChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "고민을 입력해주세요.",
                        hintStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black87,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
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
                        _isLoading = true;
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

                      int _token = await TokenDBHelper.refreshToken();

                      if(_token > 0) {
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
                        _isLoading = false;
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
                "이 서비스는 사용자의 입력 내용을 저장하지 않습니다. 그러나 입력 내용을 ChatGPT에 전송하므로 민감한 개인정보는 입력하지 않도록 주의해주세요. "
                "번역 오류 및 데이터 오류가 있을 수 있으니, 참고만 하시고 교회 목사님과 상담하시는 것을 권장합니다. ",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
