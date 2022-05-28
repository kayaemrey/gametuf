import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gametuf/homeScreens/messagePage.dart';
import 'package:gametuf/homeScreens/newchatPage.dart';
import 'package:gametuf/homeScreens/searchFriendsChat.dart';
import 'package:gametuf/services/authService.dart';
import 'package:gametuf/services/firebaseDB.dart';
import 'package:provider/provider.dart';

class messagePage extends StatefulWidget {
  @override
  _messagePageState createState() => _messagePageState();
}

class _messagePageState extends State<messagePage> {
  @override
  Widget build(BuildContext context) {
    final myAuth = Provider.of<AuthService>(context);
    final myDB = Provider.of<firebasedb>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      body: Container(
        child:Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.047,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Image.asset("assets/imagesicon/back.png",width: 30,height: 30,),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                Container(
                    alignment: Alignment.center,
                    child: Image.asset("assets/imagesicon/ghost.png",width: 40,height: 40,)
                ),
                PopupMenuButton(
                  icon: Image.asset("assets/imagesicon/more.png",width:30,height: 30,),
                  itemBuilder: (BuildContext bc) => [
                    PopupMenuItem(
                      child: Text("Yeni mesaj"), value: "new chat",
                    ),
                    PopupMenuItem(
                      child: Text("Arkadaşlarında ara"), value: "search friends",
                    ),

                  ],
                  onSelected: (route) {
                    if(route == "new chat"){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>newchatPage()));
                    }else if(route == "search friends"){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>searchFriendsChatPage()));
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 30,),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: users.doc(myAuth.authid()).collection("creatmessage").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return snapshot.data.docs.isNotEmpty ? ListView(
                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                      return  Container(
                        child: Column(
                          children: [
                            FutureBuilder<DocumentSnapshot>(
                              future: users.doc(document.id).get(),
                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                                if (snapshot.hasError) {
                                  return Text("Something went wrong");
                                }

                                if (snapshot.connectionState == ConnectionState.done) {
                                  Map<String, dynamic> data = snapshot.data.data();
                                  return Container(
                                    child: Column(
                                      children: [
                                        InkWell(
                                          child: Row(
                                            children: [
                                              SizedBox(width: 8,),
                                              CircleAvatar(
                                                maxRadius: 30,
                                                backgroundColor: Colors.white,
                                                backgroundImage: data["profilepic"] != null
                                                    ? NetworkImage(data["profilepic"])
                                                    : AssetImage("assets/imagesicon/ghost.png"),
                                              ),
                                              SizedBox(width: 20,),
                                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(data["username"], style: TextStyle(fontSize: 22),),
                                                  Text(data["name"], style: TextStyle(fontSize: 14),),
                                                ],
                                              ),
                                            ],
                                          ),
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>messagepage(
                                                document.data()["id"],data["username"]
                                            )));
                                          },
                                        ),
                                        Divider(thickness: 1, color: Colors.black.withOpacity(0.15),)
                                      ],
                                    ),
                                  );
                                }

                                return Center(child: CircularProgressIndicator());
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ) : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/imagesicon/emptymessage.png",width: 164,),
                        SizedBox(height: 10,),
                        Text("Hiç mesaj bulunmuyor.")
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
