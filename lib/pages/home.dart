import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:Fluttergram/models_c/post.dart';
import 'package:Fluttergram/models_c/user.dart';
import 'package:Fluttergram/models_c/comment.dart';
import 'package:Fluttergram/models_c/global.dart';
import 'package:Fluttergram/main.dart';
import 'package:Fluttergram/models_c/appbar.dart';
import 'package:Fluttergram/feed.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';


class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}



class _EventPageState extends State<EventPage> {
  static int page = 1;
  static Post the_post = post1;
  
  @override
  Widget build(BuildContext context) {
    // Map<int, Widget> pageview = {
    //   1 : getMain(),
    //   2 : getLikes(the_post.likes),
    //   3 : getComments(the_post.comments)
    // };
    // return pageview[page];
    return MaterialApp(
      title: "Networking",
      home: NewsList()
    );
  }

  


  Widget getMain() {
    return Scaffold(
      
      appBar: AppBar(
        title: Text("WhatsEvent", style: textStyleBold),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget> [
                // Container(
                //   height: 85,
                //   child: getStories(),
                // ),
                Divider(),
                Column(
                  children: getPosts(context),
                )
              ],
            )
          ],
        )
      ),
    );
  }

  

  Widget getStories() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: getUserStories()
    );
  }

  List<Widget> getUserStories() {
    List<Widget> stories = [];
    for (User follower in user.following) {
      stories.add(getStory(follower));
    }
    return stories;
  }

  Widget getStory(User follower) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            width: 50,
            child: Stack(
              alignment: Alignment(0, 0),
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  child: CircleAvatar(
                    backgroundColor: follower.hasStory ? Colors.red : Colors.grey,
                  ),
                ),
                Container(
                  height: 47,
                  width: 47,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                  ),
                ),
                Container(
                  height: 45,
                  width: 45,
                  child: CircleAvatar(
                    backgroundImage: follower.profilePicture,
                  ),
                ),
                FloatingActionButton(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  onPressed: () {

                  },
                )
              ],
            )
          ),
          Text(follower.username, style: textStyle)
        ],
      ),
    );
  }

  List<Widget> getPosts(BuildContext context) {
    List<Widget> posts = [];
    int index = 0;
    for (Post post in userPosts) {
      posts.add(getPost(context, post, index));
      index ++;
    }
    return posts;
  }

  Widget getPost(BuildContext context, Post post, int index) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Row(
                //   children: <Widget>[
                //     Container(
                //       margin: EdgeInsets.only(right: 10),
                //       child: CircleAvatar(backgroundImage: post.user.profilePicture,),
                //     ),
                //     Text(post.user.username,)
                //   ],
                // ),
                // IconButton(
                //   icon: Icon(Icons.more_horiz),
                //   onPressed: () {

                //   },
                // )
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                
                child: Text(
                  "02-25-2020",
                  style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic), 

                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              
              Container(
                margin: EdgeInsets.only(left: 15, right: 40),
                child: Text(

                  "6:30PM",
                  style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic), 

                ),
              ),
              
              Container(
                margin: EdgeInsets.only(left: 15, right: 10),
                
                child: Text(
                  post.user.username,
                  style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic), 
              
                ),
              ),
              // Text(
              //   post.description,
              //   style: TextStyle(fontSize: 15),
              // )
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 120, right: 10,),
                child: Text(
                  "Description: " + post.description,
                  style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                  
                ),
              ),

            ],
          ),
          Container(
            constraints: BoxConstraints.expand(height: 1),
            color: Colors.grey,
          ),
          GestureDetector(
                child: Container(
                constraints: BoxConstraints(
                  maxHeight: 282
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: post.image
                  )
                ),
              ),
                onTap: goToEvent, 
                  
                ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: <Widget>[
          //     Row(
          //       children: <Widget>[
          //         Stack(
          //           alignment: Alignment(0, 0),
          //           children: <Widget>[
          //             Icon(Icons.favorite, size: 30, color: post.isLiked ? Colors.red : Colors.black,),
          //             IconButton(icon: Icon(Icons.favorite), color: post.isLiked ? Colors.red : Colors.white,
          //             onPressed: () {
          //               setState(() {
          //                   userPosts[index].isLiked = post.isLiked ? false : true; 
          //                   if (!post.isLiked) {
          //                     post.likes.remove(user);
          //                   } else {
          //                     post.likes.add(user);
          //                   }                       
          //                 });
          //             },)
          //           ],
          //         ),
          //         Stack(
          //           alignment: Alignment(0, 0),
          //           children: <Widget>[
          //             Icon(Icons.mode_comment, size: 30, color: Colors.black,),
          //             IconButton(icon: Icon(Icons.mode_comment), color: Colors.white,
          //             onPressed: () {
                        
          //             },)
          //           ],
          //         ),
          //         Stack(
          //           alignment: Alignment(0, 0),
          //           children: <Widget>[
          //             Icon(Icons.send, size: 30, color: Colors.black,),
          //             IconButton(icon: Icon(Icons.send), color: Colors.white,
          //             onPressed: () {
                        
          //             },)
          //           ],
          //         )
          //       ],
          //     ),
          //     Stack(
          //           alignment: Alignment(0, 0),
          //           children: <Widget>[
          //             Icon(Icons.bookmark, size: 30, color: Colors.black,),
          //             IconButton(icon: Icon(Icons.bookmark), color: post.isSaved ? Colors.black : Colors.white,
          //             onPressed: () {
          //               setState(() {
          //                   userPosts[index].isSaved = post.isSaved ? false : true; 
          //                   if (!post.isSaved) {
          //                     user.savedPosts.remove(post);
          //                   } else {
          //                     user.savedPosts.add(post);
          //                   }                       
          //                 });
          //             },)
          //           ],
          //         )
          //   ],
          // ),
          FlatButton(
            child: Text(post.likes.length.toString() + " interested", style: textStyleBold,),
            onPressed: () {
                setState(() {
                  the_post = post;
                  page = 2; 
                  build(context);                 
                });
              },
          ),
          
          
          // FlatButton(
          //   child: Text("View all " + post.comments.length.toString() + " comments", style: textStyleLigthGrey,),
          //   onPressed: () {
          //     setState(() {
          //         the_post = post;
          //         page = 3; 
          //         build(context);                 
          //       });
          //     },
          // ),
        ],
      )
    );
  }

  Widget getLikes(List<User> likes) {
    List<Widget> likers = [];
    for (User follower in likes) {
      likers.add(new Container(
        height: 45,
        padding: EdgeInsets.all(10),
        child: FlatButton(
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(follower.username, style: textStyleBold),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(3))
              ),
              child: FlatButton(
                color: user.following.contains(follower) ? Colors.white : Colors.blue,
                child: Text(user.following.contains(follower) ? "Following" : "Follow", style: TextStyle(fontWeight: FontWeight.bold, color: user.following.contains(follower) ? Colors.grey : Colors.white)),
                onPressed: () {
                  setState(() {
                    if (user.following.contains(follower)) {
                      user.following.remove(follower);
                    } else {
                      user.following.add(follower);
                    }
                  });
                },
              ),
            )
          ],
        ),
        onPressed: () {

        },
        )
      ));
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Likes", style: textStyleBold),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
          onPressed: () {
            setState(() {
                page = 1; 
                build(context);                 
            });
          },
        ),
      ),
      body: Container(
        child: ListView(
          children: likers,
        ),
      ),
    );
  }
  
  void goToEvent() {
  Navigator.of(context)
      .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
    return Feed();
  }));}

   Widget getComments(List<Comment> likes) {
    List<Widget> likers = [];
    DateTime now = DateTime.now();
    for (Comment comment in likes) {
      int hoursAgo = (now.hour) - (comment.dateOfComment.hour -1);
      likers.add(new Container(
        // height: 45,
        padding: EdgeInsets.all(10),
        child: FlatButton(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 30,
                  height: 30,
                  child: CircleAvatar(
                    backgroundImage: comment.user.profilePicture,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      text: new TextSpan(
                        style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          new TextSpan(text: comment.user.username, style: textStyleBold),
                          new TextSpan(text: ' ', style: textStyle),
                          new TextSpan(text: comment.comment, style: textStyle),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10, top: 20),
                          child: Text(hoursAgo.toString() + "h", style: textStyleLigthGrey,),
                        ),
                        Container(
                          child: Text("like", style: textStyleLigthGrey,),
                          margin: EdgeInsets.only(right: 10, top: 20),
                        ),
                        Container(
                          child: Text("Reply", style: textStyleLigthGrey,),
                          margin: EdgeInsets.only(right: 10, top: 20),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            Stack(
                  alignment: Alignment(0, 0),
                    children: <Widget>[
                      Container(
                        child: Icon(Icons.favorite, color: Colors.black, size: 15,)),
                      Container(
                          child: IconButton(
                            icon: Icon(Icons.favorite, color: comment.isLiked ? Colors.black : Colors.white, size: 10),
                            onPressed: () {
                              setState(() {
                                comment.isLiked = comment.isLiked ? false : true;
                              });
                           },
                      ),
                    )
                  ],
                ),
          ],
        ),
        onPressed: () {

        },
        )
      ));
    }
    
    
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black,),
                    onPressed: () {
                      setState(() {
                        page = 1; 
                        build(context);                 
                      });
                    },
                  ),
                  Text('Comments', style: textStyleBold,)
                ],
              ),
              IconButton(
                icon: Icon(Icons.send, color: Colors.black,),
                onPressed: () {

                },
              )
            ],
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: ListView(
          children: likers,
        ),
      ),
    );
  }
}

class Event {
  
  final String title; 
  final String description; 
  final String id; 
  final String imageURL;
   var startDate;
   var endDate;
  final String location;
  bool allDay;
  bool recurring;

  Event({
    this.title,
    this.description,
    this.id,
    this.imageURL,
    this.startDate,
    this.endDate,
    this.location,
    this.allDay,
    this.recurring
    });

  factory Event.fromJson(Map<String,dynamic> json) {
    return Event(
      title: json['title'], 
      description: json['description'], 
      id: json['id'],
      imageURL: json['imageURL'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      location: json['location'],
      allDay: json['allDay'],
      recurring: json['recurring']
    );
  }

  static Resource<List<Event>> get all {


    return Resource(
      
      url: "https://gtapp-api.rnoc.gatech.edu/api/v1/events/day/2020/02/05",
      parse: (response) {
        final result = json.decode(response.body); 
        // print("-----------------"+result.toString());
        Iterable list = result.toList();
        // print("------" + list.toString());
        return list.map((model) => Event.fromJson(model)).toList();
      }
    );

  }
}

class Resource<T> {
  final String url; 
  T Function(Response response) parse;

  Resource({this.url,this.parse});
}

class Webservice {

  Future<T> load<T>(Resource<T> resource) async {

      final response = await http.get(resource.url);
      if(response.statusCode == 200) {
        return resource.parse(response);
      } else {
        throw Exception('Failed to load data!');
      }
  }

}

class NewsListState extends State<NewsList> {
  static int page = 1;
  static Post the_post = post1;
  List<Event> _events = List<Event>(); 

  @override
  void initState() {
    super.initState();
    _populateNewsArticles(); 
  }

  void _populateNewsArticles() {
   
    Webservice().load(Event.all).then((events) => {
      setState(() => {
        _events = events
      })
    });

  }

  ListTile _buildItemsForListView(BuildContext context, int index) {

      return ListTile(
        title: _events[index].imageURL == null ? Image.asset("lib/assets/photo_1.jpeg") : Image.network(_events[index].imageURL), 
        subtitle: Text(_events[index].title + _events[index].description, style: TextStyle(fontSize: 18)),
        
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("WhatsEvent"),
        ),
        body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget> [
                // Container(
                //   height: 85,
                //   child: getStories(),
                // ),
                Divider(),
                Column(
                  children: getEvents(context),
                )
              ],
            )
          ],
        )
      ),
        // ListView.builder(
        //   itemCount: _events.length,
        //   itemBuilder: _buildItemsForListView,
        // )
      );
  }


  List<Widget> getEvents(BuildContext context) {
    List<Widget> posts = [];
    int index = 0;
    for (Event post in _events) {
      posts.add(getPost(context, post, index));
      index ++;
    }
    return posts;
  }

  Widget getPost(BuildContext context, Event post, int index) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Row(
                //   children: <Widget>[
                //     Container(
                //       margin: EdgeInsets.only(right: 10),
                //       child: CircleAvatar(backgroundImage: post.user.profilePicture,),
                //     ),
                //     Text(post.user.username,)
                //   ],
                // ),
                // IconButton(
                //   icon: Icon(Icons.more_horiz),
                //   onPressed: () {

                //   },
                // )
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                
                child: post.allDay == false ? Text(
                  "Date: " + new DateFormat("MM-dd-yyyy").format(new DateTime.fromMillisecondsSinceEpoch(post.startDate * 1000)) + " to " + new DateFormat("MM-dd-yyyy").format(new DateTime.fromMillisecondsSinceEpoch(post.endDate * 1000)),
                  style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic), 

                ) : Text(new DateFormat("MM-dd-yyyy").format(new DateTime.fromMillisecondsSinceEpoch(post.startDate * 1000))),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              
              Container(
                margin: EdgeInsets.only(left: 15, right: 40),
                child: post.allDay == false ? Text(

                  new DateFormat("HH:mm").format(new DateTime.fromMillisecondsSinceEpoch(post.startDate * 1000))+ "\nto\n" + new DateFormat("HH:mm").format(new DateTime.fromMillisecondsSinceEpoch(post.endDate * 1000)),
                  style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic), 

                ) : Text("All Day"),
              ),
              Container(child: Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                  post.title,
                  style: TextStyle(fontSize: 23, fontStyle: FontStyle.italic)
                  ), 
                  ],
                ),
              )),
              // Container(
              //   margin: EdgeInsets.only(left: 15, right: 10),
                
              //   child: Text(
              //     post.title,
              //     style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic), 
              
              //   ),
                
              // ),
              // Text(
              //   post.description,
              //   style: TextStyle(fontSize: 15),
              // )
            ],
          ),
          Row(
            children: <Widget>[
              Container(child: Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                  post.description,
                  style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic)
                  ), 
                  ],
                ),
              )),

            ],
          ),
          
          GestureDetector(
                child: Container(
                constraints: BoxConstraints(
                  maxHeight: 282
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: post.imageURL == null ? new NetworkImage("https://brand.gatech.edu/sites/default/files/images/brand-graphics/gt-spirit-marks.png") : new NetworkImage(post.imageURL)
                  )
                ),
              ),
                onTap: goToEvent, 
                  
          ),
          Container(
            constraints: BoxConstraints.expand(height: 1),
            color: Colors.grey,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: <Widget>[
          //     Row(
          //       children: <Widget>[
          //         Stack(
          //           alignment: Alignment(0, 0),
          //           children: <Widget>[
          //             Icon(Icons.favorite, size: 30, color: post.isLiked ? Colors.red : Colors.black,),
          //             IconButton(icon: Icon(Icons.favorite), color: post.isLiked ? Colors.red : Colors.white,
          //             onPressed: () {
          //               setState(() {
          //                   userPosts[index].isLiked = post.isLiked ? false : true; 
          //                   if (!post.isLiked) {
          //                     post.likes.remove(user);
          //                   } else {
          //                     post.likes.add(user);
          //                   }                       
          //                 });
          //             },)
          //           ],
          //         ),
          //         Stack(
          //           alignment: Alignment(0, 0),
          //           children: <Widget>[
          //             Icon(Icons.mode_comment, size: 30, color: Colors.black,),
          //             IconButton(icon: Icon(Icons.mode_comment), color: Colors.white,
          //             onPressed: () {
                        
          //             },)
          //           ],
          //         ),
          //         Stack(
          //           alignment: Alignment(0, 0),
          //           children: <Widget>[
          //             Icon(Icons.send, size: 30, color: Colors.black,),
          //             IconButton(icon: Icon(Icons.send), color: Colors.white,
          //             onPressed: () {
                        
          //             },)
          //           ],
          //         )
          //       ],
          //     ),
          //     Stack(
          //           alignment: Alignment(0, 0),
          //           children: <Widget>[
          //             Icon(Icons.bookmark, size: 30, color: Colors.black,),
          //             IconButton(icon: Icon(Icons.bookmark), color: post.isSaved ? Colors.black : Colors.white,
          //             onPressed: () {
          //               setState(() {
          //                   userPosts[index].isSaved = post.isSaved ? false : true; 
          //                   if (!post.isSaved) {
          //                     user.savedPosts.remove(post);
          //                   } else {
          //                     user.savedPosts.add(post);
          //                   }                       
          //                 });
          //             },)
          //           ],
          //         )
          //   ],
          // ),
          // FlatButton(
          //   child: Text(post.likes.length.toString() + " interested", style: textStyleBold,),
          //   onPressed: () {
          //       setState(() {
          //         the_post = post;
          //         page = 2; 
          //         build(context);                 
          //       });
          //     },
          // ),
          
          // FlatButton(
          //   child: Text("View all " + post.comments.length.toString() + " comments", style: textStyleLigthGrey,),
          //   onPressed: () {
          //     setState(() {
          //         the_post = post;
          //         page = 3; 
          //         build(context);                 
          //       });
          //     },
          // ),
        ],
      ),
      color: Colors.orange[50],
    );
  }
  void goToEvent() {
  Navigator.of(context)
      .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
    return Feed();
  }));}
}

class NewsList extends StatefulWidget {

  @override
  createState() => NewsListState(); 
}

