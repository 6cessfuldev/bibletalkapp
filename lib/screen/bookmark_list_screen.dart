import 'package:flutter/material.dart';
import 'package:bibletalkapp/service/bookmark_dbhelper.dart';
import 'package:bibletalkapp/model/bookmark.dart';

import 'bookmart_screen.dart';

class BookMarkListScreen extends StatefulWidget {
  const BookMarkListScreen({Key? key}) : super(key: key);

  @override
  State<BookMarkListScreen> createState() => _BookMarkListScreenState();
}

class _BookMarkListScreenState extends State<BookMarkListScreen> {
  late Future<List<Bookmark>> _bookmarksFuture;

  @override
  void initState() {
    super.initState();
    _bookmarksFuture = BookmarkDBHelper().getBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: true,
      body: FutureBuilder<List<Bookmark>>(
        future: _bookmarksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('북마크가 없습니다.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Bookmark bookmark = snapshot.data![index];
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      title: Text(bookmark.title, style: TextStyle(fontSize: 24),),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            BookmarkDBHelper().deleteBookmark(bookmark.id);
                            _bookmarksFuture = BookmarkDBHelper().getBookmarks();
                          });
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookmarkScreen(bookmark: bookmark),
                          ),
                        );
                     },
                    ),
                    Divider(height: 1, ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
