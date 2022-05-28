import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gametuf/homeScreens/chatPage.dart';
import 'package:gametuf/services/authService.dart';
import 'package:gametuf/services/firebaseDB.dart';
import 'package:gametuf/services/firebaseStorage.dart';
import 'package:gametuf/userSearch/userprofile.dart';
import 'package:provider/provider.dart';

class followlist extends StatefulWidget {
  final String id;
  final String foander;
  followlist(this.id,this.foander);
  @override
  _followlistState createState() => _followlistState();
}

class _followlistState extends State<followlist> {

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').doc(widget.id).collection(widget.foander).snapshots();
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final myAuth = Provider.of<AuthService>(context);
    final myStorage = Provider.of<firebasestorage>(context);
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
            Expanded( 
              child: StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return snapshot.data.docs.isNotEmpty ? ListView(
                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      print(document.data()["id"]);
                      return FutureBuilder<DocumentSnapshot>(
                        future: users.doc(document.data()["id"]).get(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                          if (snapshot.hasError) {
                            return Text("Something went wrong");
                          }

                          if (snapshot.hasData && !snapshot.data.exists) {
                            return Text("Document does not exist");
                          }

                          if (snapshot.connectionState == ConnectionState.done) {
                            Map<String, dynamic> data = snapshot.data.data() as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.only(left:8.0,right: 8),
                              child: Container(
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
                                                    backgroundImage: data["profile"] != null
                                                        ? NetworkImage(data["profile"])
                                                        : AssetImage("assets/imagesicon/ghost.png")),
                                                SizedBox(width: 10,),
                                                Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(data["username"], style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),),
                                                    Text(data["name"], style: TextStyle(fontSize: 11),),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>userProfilePage(document.data()["id"])));
                                        },
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }

                          return Center(child: CircularProgressIndicator());
                        },
                      );
                    }).toList(),
                  ) : Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/imagesicon/follow.png",width: 160,),
                        SizedBox(height: 10,),
                        Text("Herhangi bir kişi yok.")
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
