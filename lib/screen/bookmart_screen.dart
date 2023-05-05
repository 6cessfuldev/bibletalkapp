import 'package:bibletalkapp/model/bookmark.dart';
import 'package:flutter/material.dart';

class BookmarkScreen extends StatelessWidget {
  final Bookmark bookmark;
  const BookmarkScreen({Key? key, required this.bookmark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.brown,
        toolbarHeight: 60,
        title: Text('북마크', style: TextStyle(fontSize: 24, color: Colors.white),),
        centerTitle: true,
        titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize:36,
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
      ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Center(
                child: Container(
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
                            child: Text(bookmark.title, style: TextStyle(fontSize: 32),)
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(bookmark.response, style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24,),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12,),
            ],
          )
        ),
      ),
    );
  }
}
