import 'package:flutter/material.dart';
import 'image_post.dart';
import 'dart:async';
import 'main.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'upload_page.dart';
import 'profile_page.dart';
import 'search_page.dart';
import 'activity_feed.dart';

class Feed extends StatefulWidget {
  _Feed createState() => _Feed();
}
PageController pageController;
class _Feed extends State<Feed> with AutomaticKeepAliveClientMixin<Feed> {
  List<ImagePost> feedData;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    this._loadFeed();
    pageController = PageController();
  }

  buildFeed() {
    if (feedData != null) {
      return ListView(
        children: feedData,
      );
    } else {
      return Container(
          alignment: FractionalOffset.center,
          child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // reloads state when opened again
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fluttergram',
            style: const TextStyle(
                fontFamily: "Billabong", color: Colors.black, fontSize: 35.0)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
              onRefresh: _refresh,
              child: PageView(
                children: [
                  Container(
                    color: Colors.white,
                    child: buildFeed(),
                  ),
                  Container(color: Colors.white, child: SearchPage()),
                  Container(
                    color: Colors.white,
                    child: Uploader(),
                  ),
                  Container(
                      color: Colors.white, child: ActivityFeedPage()),
                  Container(
                      color: Colors.white,
                      child: ProfilePage(
                        userId: googleSignIn.currentUser.id,
                      )),
                  
                ],
                controller: pageController,
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: onPageChanged,
              
              ),
            
            ),
            bottomNavigationBar: CupertinoTabBar(
              backgroundColor: Colors.white,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.home,
                        color: (_page == 0) ? Colors.black : Colors.grey),
                    title: Container(height: 0.0),
                    backgroundColor: Colors.white),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search,
                        color: (_page == 1) ? Colors.black : Colors.grey),
                    title: Container(height: 0.0),
                    backgroundColor: Colors.white),
                BottomNavigationBarItem(
                    icon: Icon(Icons.add_circle,
                        color: (_page == 2) ? Colors.black : Colors.grey),
                    title: Container(height: 0.0),
                    backgroundColor: Colors.white),
                BottomNavigationBarItem(
                    icon: Icon(Icons.star,
                        color: (_page == 3) ? Colors.black : Colors.grey),
                    title: Container(height: 0.0),
                    backgroundColor: Colors.white),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person,
                        color: (_page == 4) ? Colors.black : Colors.grey),
                    title: Container(height: 0.0),
                    backgroundColor: Colors.white),
              ],
              onTap: navigationTapped,
              currentIndex: _page,
    )
      
  
      );
  }

  Future<Null> _refresh() async {
    print("refresh----------");
    await _getFeed();

    setState(() {});

    return;
  }

  _loadFeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString("feed");

    if (json != null) {
      List<Map<String, dynamic>> data =
          jsonDecode(json).cast<Map<String, dynamic>>();
      List<ImagePost> listOfPosts = _generateFeed(data);
      setState(() {
        feedData = listOfPosts;
      });
    } else {
      _getFeed();
    }
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  _getFeed() async {
    print("Staring getFeed");

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userId = googleSignIn.currentUser.id.toString();
    var url =
        // 'https://us-central1-whatevent-88ec4.cloudfunctions.net/getFeed?uid=' + userId;
        'https://us-central1-whatevent-88ec4.cloudfunctions.net/getFeed?uid=100240771706161409045';
        // 'https://us-central1-whatevent-88ec4.cloudfunctions.net/getFeed?uid=${userId}';
                // 'https://us-central1-whatevent-88ec4.cloudfunctions.net/getFeed?uid=' + userId;

    var httpClient = HttpClient();

    List<ImagePost> listOfPosts;
    String result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        String json = await response.transform(utf8.decoder).join();
        prefs.setString("feed", json);
        List<Map<String, dynamic>> data =
            jsonDecode(json).cast<Map<String, dynamic>>();
        listOfPosts = _generateFeed(data);
        result = "Success in http request for feed";
      } else {
        result =
            'Error getting a feed: Http status ${response.statusCode}  ${HttpStatus.ok}| userId $userId';
      }
    } catch (exception) {
      result = 'Failed invoking the getFeed function. Exception: $exception';
    }
    print(result);

    setState(() {
      feedData = listOfPosts;
    });
  }

  List<ImagePost> _generateFeed(List<Map<String, dynamic>> feedData) {
    List<ImagePost> listOfPosts = [];

    for (var postData in feedData) {
      listOfPosts.add(ImagePost.fromJSON(postData));
    }

    return listOfPosts;
  }

  // ensures state is kept when switching pages
  @override
  bool get wantKeepAlive => true;
}
