import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gametuf/homeScreens/userprofilePage.dart';
import 'package:gametuf/services/authService.dart';
import 'package:gametuf/services/firebaseDB.dart';
import 'package:gametuf/userSearch/userprofile.dart';
import 'package:provider/provider.dart';

import 'chatPage.dart';

class searchPage extends StatefulWidget {
  @override
  _searchPageState createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  TextEditingController txtsearch = TextEditingController();

  String name = "name";

  @override
  Widget build(BuildContext context) {
    final myDB = Provider.of<firebasedb>(context);
    final myAuth = Provider.of<AuthService>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.047,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PopupMenuButton(
                icon: Image.asset(
                  "assets/imagesicon/settings.png",
                  width: 30,
                  height: 30,
                ),
                itemBuilder: (BuildContext bc) => [
                  PopupMenuItem(
                    child: Text("Sign out"),
                    value: "signout",
                  ),
                ],
                onSelected: (route) {
                  if (route == "signout") {
                    myAuth.signout();
                  }
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => messagePage()));
                },
              ),
            ],
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
              controller: txtsearch,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: "Kullanıcı ara",
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: users.orderBy('username').startAt([name]).endAt([name + '\uf8ff']).limit(5).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return txtsearch.text.length == 0 ? Center(child: Image.asset("assets/imagesicon/searchGroups.png",width: 176,)) : ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return Padding(
                      padding: const EdgeInsets.only(left:8.0,right: 8),
                      child: document.id != myAuth.authid() ? Container(
                        // height: MediaQuery.of(context).size.height * 0.12,
                        // decoration: BoxDecoration(
                        //     color: Colors.grey.shade200,
                        //     borderRadius: BorderRadius.circular(22)),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 5,),
                                        CircleAvatar(
                                            backgroundColor: Colors.white,
                                            maxRadius: 30,
                                            backgroundImage: document.data()["profile"] != null
                                                ? NetworkImage(document.data()["profile"])
                                                : AssetImage("assets/imagesicon/ghost.png")),
                                        SizedBox(width: 10,),
                                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(document.data()["username"], style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),),
                                            Text(document.data()["name"], style: TextStyle(fontSize: 11),),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>userProfilePage(document.id)));
                                },
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ) : Container(),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
