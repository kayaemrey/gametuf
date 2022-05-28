import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gametuf/homeScreens/messagePage.dart';
import 'package:gametuf/services/authService.dart';
import 'package:gametuf/services/firebaseDB.dart';
import 'package:provider/provider.dart';

class searchFriendsChatPage extends StatefulWidget {
  @override
  _searchFriendsChatPageState createState() => _searchFriendsChatPageState();
}

class _searchFriendsChatPageState extends State<searchFriendsChatPage> {
  TextEditingController txtsearch = TextEditingController();
  String name = "name";
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final myAuth = Provider.of<AuthService>(context);
    final myDB = Provider.of<firebasedb>(context);
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.047,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Image.asset("assets/imagesicon/back.png",width: 24,height: 24,),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                Container(
                    alignment: Alignment.center,
                    child: Image.asset("assets/imagesicon/ghost.png",width: 40,height: 40,)
                ),
                IconButton(
                  icon: Image.asset("assets/imagesicon/back.png",width: 24,height: 24,),
                  onPressed: (){
                  },
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
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
            SizedBox(height: 30,),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: users.doc(myAuth.authid()).collection("follow").orderBy('username').startAt([name]).endAt([name + '\uf8ff']).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return new ListView(
                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                      return Container(
                        child: Column(
                          children: [
                            FutureBuilder<DocumentSnapshot>(
                              future: users.doc(document.data()["id"]).get(),
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
                            )
                          ],
                        ),
                      );
                    }).toList(),
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
