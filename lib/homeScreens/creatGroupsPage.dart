import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gametuf/homeScreens/messagePage.dart';
import 'package:gametuf/services/adcert.dart';
import 'package:gametuf/services/authService.dart';
import 'package:gametuf/services/firebaseDB.dart';
import 'dart:math';
import 'package:provider/provider.dart';

class creatgroupspage extends StatefulWidget {
  final String game;
  creatgroupspage(this.game);

  @override
  _creatgroupspageState createState() => _creatgroupspageState();
}

class _creatgroupspageState extends State<creatgroupspage> {
  final AdvertService _advertService = AdvertService();
  int counter;
  Random random = new Random();
  AuthService auth = AuthService();
  firebasedb DB = firebasedb();
  List userid = [];
  List addid = [];
  String rank;

  Future<String> questioning() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.authid())
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          rank = documentSnapshot.data()[widget.game];
          print(rank);
        });
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  Future<String> arpnumber() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.authid())
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          counter = documentSnapshot.data()["arp"];
          print(counter);
        });
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  Future<String> useridsearch() async {
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        try{
          //print(doc.data()["valorant"]);
          if (doc.data()[widget.game] == rank) {
            setState(() {
              print(doc.id);
              userid.add(doc.id);
            });
          } else {
            print("no match");
          }
        }catch(e){print(e);}
      });
    });
  }

  @override
  void initState() {
    questioning();
    arpnumber();
    useridsearch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myAuth = Provider.of<AuthService>(context);
    final myDB = Provider.of<firebasedb>(context);
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
                IconButton(
                  icon: Image.asset(
                    "assets/imagesicon/back.png",
                    width: 30,
                    height: 30,
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
                    "assets/imagesicon/add.png",
                    width: 30,
                    height: 30,
                  ),
                  onPressed: () {
                    addid.add(myAuth.authid());
                    if (counter == 0) {
                      AlertDialog alert = AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        backgroundColor: Colors.black,
                        title: Text("Arp hakkınız bitti"),
                        titleTextStyle:
                            TextStyle(color: Colors.white, fontSize: 24),
                        content: Text(
                            "Arp sistemini kullanmak için video izliyebilirsiniz.\n"
                                "Bu sizin hesabınıza 1 jeton tanıycaktır.\n\n!Ancak unutma reklamı izledikten sonra "
                                "jetonu al'a basmalısın\n\n"
                                "!Reklamın yüklenmesi biraz sürebilir, lütfen bekleyiniz. "
                                "\n\nKalan hakkınız : ${_advertService.counter}"),
                        contentTextStyle:
                            TextStyle(color: Colors.white, fontSize: 18),
                        actions: [
                          TextButton(
                              child: Text(
                                "Reklam izle",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              onPressed: () {
                                _advertService.showRewar();
                              }),
                          TextButton(
                              child: Text(
                                "Jeton'u al",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              onPressed: () {
                                counter = _advertService.counter;
                                _advertService.counter = 0;
                                if (counter != 0) {
                                  myDB.addData(counter, "arp");
                                } else {
                                  print("Counter : 0");
                                }
                                Navigator.pop(context);
                              }),
                          // TextButton(
                          //     child: Text(
                          //       "Çık",
                          //       style: TextStyle(
                          //           color: Colors.white, fontSize: 18),
                          //     ),
                          //     onPressed: () {
                          //       Navigator.pop(context);
                          //     }),
                        ],
                      );
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    } else {
                      int randomNumber = random.nextInt(userid.length);
                      if (userid[randomNumber] == myAuth.authid()) {
                        print("my id");
                      } else {
                        print(userid[randomNumber]);
                        myDB.creatMygroups(userid[randomNumber], widget.game);
                        // myDB.creatTogroups(myAuth.authid(), userid[randomNumber], widget.game);
                        counter--;
                        myDB.addData(counter, "arp");
                      }
                    }
                  },
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Text("ARP sistemi ile eklenen oyuncular", style: TextStyle(fontSize: 18),),
            Text("Kalan ARP hakkınız : $counter", style: TextStyle(fontSize: 13),),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: users
                    .doc(myAuth.authid())
                    .collection(widget.game)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return new ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return Container(
                        child: Column(
                          children: [
                            FutureBuilder<DocumentSnapshot>(
                              future: users.doc(document.data()["id"]).get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text("Something went wrong");
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  Map<String, dynamic> data =
                                      snapshot.data.data();
                                  return Container(
                                    child: Column(
                                      children: [
                                        InkWell(
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 8,
                                              ),
                                              CircleAvatar(
                                                maxRadius: 30,
                                                backgroundColor: Colors.white,
                                                backgroundImage: data["profile"] != null ? NetworkImage(data["profile"]) : AssetImage("assets/imagesicon/ghost.png"),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data["username"],
                                                    style:
                                                        TextStyle(fontSize: 22),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        data["name"],
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                      Text(
                                                        " ( ${data[widget.game]} )",
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        messagepage(
                                                            document
                                                                .data()["id"],
                                                            data["username"])));
                                          },
                                        ),
                                        Divider(
                                          thickness: 1,
                                          color: Colors.black.withOpacity(0.15),
                                        )
                                      ],
                                    ),
                                  );
                                }

                                return Center(
                                    child: CircularProgressIndicator());
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
            Text("Not : Beta sürümü olduğundan,kullanıcı sayısı azlığından ARP sistemi kullanıcı bulamıyabilir.",textAlign: TextAlign.center,style: TextStyle(fontSize: 13),),
          ],
        ),
      ),
    );
  }
}
