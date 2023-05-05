import 'package:bibletalkapp/screen/privacy_screen.dart';
import 'package:bibletalkapp/service/bookmark_dbhelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  bool _isLoading = false;
  //report id controller
  TextEditingController? _reportIdController;
  //report content controller
  TextEditingController? _reportContentController;

  // Firestore 인스턴스 생성
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  @override
  void initState() {
    super.initState();
    _reportIdController = TextEditingController();
    _reportContentController = TextEditingController();

  }

// 건의사항 데이터를 Firestore에 저장하는 함수
  Future<void> saveFeedbackToFirestore(String feedbackEmail, String feedbackContent ) async {
    // feedbacks 컬렉션에 새로운 도큐먼트를 생성하고, 사용자가 제출한 건의사항 내용을 저장
    await firestore.collection('feedbacks').add({
      'email': feedbackEmail,
      'content': feedbackContent,
      'timestamp': FieldValue.serverTimestamp()
    });
  }

  @override
  void dispose() {
    _reportIdController!.dispose();
    _reportContentController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        toolbarHeight: 60,
        title: Row(
          children: [
            Icon(Icons.settings, color: Colors.black87, size: 30, ),
            Text('설정', style: TextStyle(color: Colors.black87, fontSize: 30,),),
          ],
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize:36,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
      ),
      body: Column(
        children: [
          // 북마크 저장소 초기화 리스트 타일
          ListTile(
            leading: Icon(Icons.delete_forever),
            title: Text('북마크 저장소 초기화', style: TextStyle(fontSize: 20),),
            onTap: () {
              // 북마크 저장소 초기화 로직
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return !_isLoading?
                  AlertDialog(
                    title: Text('북마크 저장소 초기화'),
                    content: Text('북마크 저장소를 초기화 하시겠습니까?'),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            // 북마크 저장소 초기화 로직
                            _isLoading = true;
                          });
                          // 북마크 저장소 초기화 로직
                          await BookmarkDBHelper().clearTableContents();

                          setState(() {
                            _isLoading = false;
                          });

                          Navigator.pop(context);
                        },
                        child: Text('예'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('아니오'),
                      ),
                    ],
                  ):
                  AlertDialog(
                    title: Text('북마크 저장소 초기화'),
                    content: Row(
                      children: [
                        Text('북마크 저장소를 초기화 중입니다.'),
                        SizedBox(width: 10,),
                        CircularProgressIndicator(),
                      ],
                    ),
                  );
                }
              );
            },
          ),
          // 건의 사항 리스트 타일
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('건의 사항', style: TextStyle(fontSize: 20),),
            onTap: () {
              // 건의 사항 다이얼로그
              showDialog(
                barrierDismissible: true,
                context: context,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(top: 100),
                    child: AlertDialog(

                      title: Text('건의 사항'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('건의 사항을 보내주시면 더욱 좋은 앱으로 발전하겠습니다.'),
                          SizedBox(height: 10,),
                          TextField(
                            controller: _reportIdController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: '이메일',
                            ),
                          ),
                          SizedBox(height: 10,),
                          TextField(
                            controller: _reportContentController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: '내용',
                            ),
                            maxLines: 5,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            _reportIdController!.text = _reportIdController!.text.trim();
                            _reportContentController!.text = _reportContentController!.text.trim();

                            if(_reportIdController!.text.isEmpty || _reportContentController!.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('이메일과 내용을 모두 입력해주세요.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              return;
                            }else{
                              // 건의 사항 보내기 로직
                              saveFeedbackToFirestore(_reportIdController!.text, _reportContentController!.text );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  padding: EdgeInsets.all(20),
                                  content: Text('건의 사항을 보냈습니다.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );

                              //reset
                              _reportIdController!.text = '';
                              _reportContentController!.text = '';
                            }
                            Navigator.pop(context);
                          },
                          child: Text('보내기'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('취소'),
                        ),
                      ],
                    ),
                  );
                }
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('개인 정보 보호 정책', style: TextStyle(fontSize: 20),),
            onTap: () {
              // 개인 정보 보호 정책 화면으로 이동
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}