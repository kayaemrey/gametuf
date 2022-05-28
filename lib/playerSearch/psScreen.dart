import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gametuf/homeScreens/chatPage.dart';
import 'package:gametuf/services/authService.dart';
import 'package:gametuf/services/firebaseDB.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';


class playerSearch extends StatefulWidget {
  final String gamename;
  playerSearch(this.gamename);
  @override
  _playerSearchState createState() => _playerSearchState();
}

class _playerSearchState extends State<playerSearch> {
  var ghost = false;

  AuthService authSer = new AuthService();

  static const duration = const Duration(seconds: 1);

  int secondsPassed = 0;
  bool isActive = false;

  Timer timer;

  void handleTick() {
    if (isActive) {
      setState(() {
        secondsPassed = secondsPassed + 1;
      });
    }
  }


  var rank;
  Future<String> getid() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.authid())
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          rank = documentSnapshot.data()[widget.gamename];
          print(rank);
        });
      } else {
        print('Document does not exist on the database');
      }
    });
    await FirebaseFirestore.instance
        .collection(widget.gamename).doc(rank).collection("id")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(authSer.authid() == doc["id"]){
          setState(() {
            idsorgu = true;
          });
        }
      });
    });
  }

  var idsorgu = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getid();
  }


  @override
  Widget build(BuildContext context) {

    if (timer == null) {
      timer = Timer.periodic(duration, (Timer t) {
        handleTick();
      });
    }
    int seconds = secondsPassed % 60;
    int minutes = secondsPassed ~/ 60;
    int hours = secondsPassed ~/ (60 * 60);

    final myDB = Provider.of<firebasedb>(context);
    final myAuth = Provider.of<AuthService>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
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
            ghost == false ? Expanded(child: Center(child: InkWell(child: Image.asset("assets/imagesicon/circle-button.png",width: 256,),onTap: (){
              setState(() {
                ghost = true;
                isActive = true;
              });
              if(idsorgu == false){
                myDB.addPs(myAuth.authid(), widget.gamename, rank);
              }
              else{
                print("sorgu ne");
              }
              },))) : Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(hours.toString(),style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25,color: Colors.white),),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(minutes.toString(),style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25,color: Colors.white),),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(seconds.toString(),style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25,color: Colors.white),),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
