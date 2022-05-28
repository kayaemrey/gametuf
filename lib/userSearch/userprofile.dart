import 'package:flutter/material.dart';
import 'package:gametuf/follower/followAndErList.dart';
import 'package:gametuf/homeScreens/gallery_screen.dart';
import 'package:gametuf/homeScreens/getportfoyS.dart';
import 'package:gametuf/userSearch/userGallery.dart';
import 'package:gametuf/userSearch/userGetportfoys.dart';
import 'package:gametuf/userSearch/userGetranks.dart';
import 'package:gametuf/widgetsP/profile_header_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gametuf/homeScreens/chatPage.dart';
import 'package:gametuf/rankSelect/gameSelect.dart';
import 'package:gametuf/services/authService.dart';
import 'package:gametuf/services/firebaseDB.dart';
import 'package:gametuf/services/firebaseStorage.dart';
import 'package:gametuf/widgetsP/profile_header_widget.dart';
import 'package:provider/provider.dart';

class userProfilePage extends StatefulWidget {
  final String id;
  userProfilePage(this.id);
  @override
  _userProfilePageState createState() => _userProfilePageState();
}

class _userProfilePageState extends State<userProfilePage> {
  AuthService auth = new AuthService();

  int followlenght = 0;
  int followerlenght = 0;
  int gallerycount = 0;

  void followcount() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .collection("follow")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          followlenght = querySnapshot.size;
        });
        print("followers" + querySnapshot.size.toString());
      });
    });
  }

  void followercount() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .collection("followers")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          followerlenght = querySnapshot.size;
        });
        print("followers" + querySnapshot.size.toString());
      });
    });
  }

  void galleryco() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .collection("galeri")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          gallerycount = querySnapshot.size;
        });
        print("galeri" + querySnapshot.size.toString());
      });
    });
  }

  var useridquest = false;
  void friendsquest() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.authid())
        .collection("follow")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc["id"] == widget.id) {
          print(doc["id"]);
          setState(() {
            useridquest = true;
          });
        }
        print("galeri" + querySnapshot.size.toString());
      });
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.authid())
        .collection("takip")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc["id"] == widget.id) {
          setState(() {
            useridquest = true;
          });
        }
      });
    });
  }

  var notifsitat = false;

  void notifsit() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .collection("notifications")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (auth.authid() == doc["id"]) {
          setState(() {
            notifsitat = true;
          });
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    friendsquest();
    followercount();
    followcount();
    galleryco();
    notifsit();
  }

  @override
  Widget build(BuildContext context) {
    final myAuth = Provider.of<AuthService>(context);
    final myStorage = Provider.of<firebasestorage>(context);
    final myDB = Provider.of<firebasedb>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .collection("galeri")
        .orderBy('time', descending: true)
        .snapshots();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[200],
              ),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.047,
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Image.asset(
                        "assets/imagesicon/back.png",
                        width: 40,
                        height: 40,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/imagesicon/ghost.png",
                          width: 40,
                          height: 40,
                        )),
                    IconButton(
                      icon: Image.asset(
                        "assets/imagesicon/chat.png",
                        width: 40,
                        height: 40,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => messagePage()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(widget.id).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data.data() as Map<String, dynamic>;
            return DefaultTabController(
              length: 3,
              child: NestedScrollView(
                headerSliverBuilder: (context, _) {
                  return [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // SizedBox(height: 20,),
                                InkWell(
                                  child: Container(
                                    child: data["kapak"] != null
                                        ? Image.network(
                                            data["kapak"],
                                            width: double.infinity,
                                            height: 150,
                                            fit: BoxFit.cover,
                                            filterQuality: FilterQuality.low,
                                          )
                                        : Image.asset(
                                            "assets/imagesicon/kapakdeneme.jpg",
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  transform:
                                      Matrix4.translationValues(0, -40, 0),
                                  child: InkWell(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      maxRadius: 50,
                                      backgroundImage: data["profile"] != null
                                          ? NetworkImage(data["profile"])
                                          : AssetImage(
                                              "assets/imagesicon/ghost.png"),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          gallerycount.toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          "Gönderi",
                                          style: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 0.4,
                                          ),
                                        )
                                      ],
                                    ),
                                    InkWell(
                                      child: Column(
                                        children: [
                                          Text(
                                            followerlenght.toString(),
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            "Takipçi",
                                            style: TextStyle(
                                              letterSpacing: 0.4,
                                              fontSize: 15,
                                            ),
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    followlist(widget.id,
                                                        "followers")));
                                      },
                                    ),
                                    InkWell(
                                      child: Column(
                                        children: [
                                          Text(
                                            followlenght.toString(),
                                            style: TextStyle(
                                              letterSpacing: 0.4,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            "Takip",
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    followlist(
                                                        widget.id, "follow")));
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    data["name"],
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "@" + data["username"],
                                    style: TextStyle(
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: notifsitat == false
                                          ? OutlinedButton(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 50,
                                                    vertical: 10),
                                                child: useridquest == false
                                                    ? Text("Takip et",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black))
                                                    : Text("Takip",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  minimumSize: Size(0, 30),
                                                  side: BorderSide(
                                                    color: Colors.grey[400],
                                                  )),
                                              onPressed: () {
                                                if (useridquest != false) {
                                                  print("zaten takipte");
                                                } else if (notifsitat !=
                                                    false) {
                                                  print("istek gönderildi");
                                                } else {
                                                  myDB.notificationsAdd(
                                                      widget.id, "follow");
                                                }
                                              },
                                            )
                                          : OutlinedButton(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 50,
                                                    vertical: 10),
                                                child: useridquest == false
                                                    ? Text(
                                                        "Takip isteği gönderildi",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black))
                                                    : Text("Takip",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  minimumSize: Size(0, 30),
                                                  side: BorderSide(
                                                    color: Colors.grey[400],
                                                  )),
                                              onPressed: () {},
                                              // onPressed: () {
                                              //   myDB.notificationsAdd(widget.id,"follow");
                                              // },
                                            ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                // Container(
                                //   height: 85,
                                //   child: ListView.builder(
                                //     shrinkWrap: true,
                                //     scrollDirection: Axis.horizontal,
                                //     itemCount: highlightItems.length,
                                //     itemBuilder: (context, index) {
                                //       return Row(
                                //         children: [
                                //           Column(
                                //             children: [
                                //               CircleAvatar(
                                //                 radius: 30,
                                //                 backgroundColor: Colors.grey,
                                //                 child: Padding(
                                //                   padding: const EdgeInsets.all(2.0),
                                //                   child: CircleAvatar(
                                //                     backgroundImage:
                                //                         AssetImage(highlightItems[index].thumbnail),
                                //                     radius: 28,
                                //                   ),
                                //                 ),
                                //               ),
                                //               Padding(
                                //                 padding: const EdgeInsets.only(top: 4),
                                //                 child: Text(
                                //                   highlightItems[index].title,
                                //                   style: TextStyle(fontSize: 13),
                                //                 ),
                                //               )
                                //             ],
                                //           ),
                                //           SizedBox(
                                //             width: 10,
                                //           )
                                //         ],
                                //       );
                                //     },
                                //   ),
                                // )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ];
                },
                body: Column(
                  children: <Widget>[
                    Material(
                      color: Colors.white,
                      child: TabBar(
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey[400],
                        indicatorWeight: 1,
                        indicatorColor: Colors.black,
                        tabs: [
                          Tab(
                            icon: Icon(
                              Icons.home,
                              color: Colors.black,
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              Icons.grid_on_sharp,
                              color: Colors.black,
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              Icons.assignment,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          userGetrankS(widget.id),
                          userGallery(widget.id),
                          userGetportfoyS(widget.id),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
