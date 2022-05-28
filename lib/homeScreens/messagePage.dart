import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gametuf/homeScreens/reportMessagePage.dart';
import 'package:gametuf/homeScreens/userprofilePage.dart';
import 'package:gametuf/services/authService.dart';
import 'package:gametuf/services/firebaseDB.dart';
import 'package:gametuf/services/firebaseStorage.dart';
import 'package:gametuf/userSearch/userprofile.dart';
import 'package:provider/provider.dart';

class messagepage extends StatefulWidget {
  final String id;
  final String username;
  messagepage(this.id,this.username);
  @override
  _messagepageState createState() => _messagepageState();
}

class _messagepageState extends State<messagepage> {
  TextEditingController txtmessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final myDB = Provider.of<firebasedb>(context);
    final myAuth = Provider.of<AuthService>(context);
    final myStorage = Provider.of<firebasestorage>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('users')
        .doc(myAuth.authid()).collection("creatmessage").doc(widget.id).collection("data");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          PopupMenuButton(
            icon: Image.asset("assets/imagesicon/more.png",width:28,height: 26,),
            itemBuilder: (BuildContext bc) => [
              PopupMenuItem(
                child: Text("Profile bak"), value: "viewprofile",
              ),
              PopupMenuItem(
                child: Text("report"), value: "report",
              ),
            ],
            onSelected: (route) {
              if(route == "report"){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>reportPage(widget.id)));
              }
              if(route == "viewprofile"){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>userProfilePage(widget.id)));
              }
            },
          ),
        ],
      ),
      body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: users.orderBy("time",descending: true).snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }

                      return ListView(
                        reverse: true,
                        children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                          return Padding(
                            padding: const EdgeInsets.only(left:15.0,right: 15,bottom: 8,top: 8),
                            child: new Container(
                              child: Column(
                                children: [
                                  document.data()["sendid"] == myAuth.authid() ?
                                  Container(
                                      alignment: Alignment.bottomRight,child:
                                  Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue.shade100,
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              document.data()["message"].toString().substring(0,5) != "https" ? Text(document.data()["message"],style: TextStyle(fontSize: 18),) : Image.network(document.data()["message"]),
                                              SizedBox(height: 5,),
                                              Text(document.data()["timehm"],style: TextStyle(fontSize: 8),),
                                            ],
                                          ),
                                          // onLongPress: (){
                                          //   AlertDialog alert = AlertDialog(
                                          //     shape: RoundedRectangleBorder(
                                          //         borderRadius: BorderRadius.circular(25)
                                          //     ),
                                          //     backgroundColor: Colors.black,
                                          //     actions: [
                                          //       Row(
                                          //         children: [
                                          //           TextButton(child: Text("Herkesten sil",style: TextStyle(color: Colors.white,fontSize: 22),), onPressed: () {
                                          //             myDB.deleteMyMessage(widget.id,document.id);
                                          //             myDB.deleteUserMessage(widget.id,document.id);
                                          //             Navigator.pop(context);
                                          //           }),
                                          //           TextButton(child: Text("Bender sil",style: TextStyle(color: Colors.white,fontSize: 22),), onPressed: () {
                                          //             myDB.deleteMyMessage(widget.id,document.id);
                                          //             Navigator.pop(context);
                                          //           }),
                                          //         ],
                                          //       )
                                          //
                                          //     ],
                                          //   );
                                          //   showDialog(
                                          //     context: context,
                                          //     builder: (BuildContext context) {
                                          //       return alert;
                                          //     },
                                          //   );
                                          // },
                                        ),
                                      ))) :
                                  Container(
                                      alignment: Alignment.bottomLeft,child:
                                  Container(
                                      decoration: BoxDecoration(
                                          color: Colors.green.shade100,
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          document.data()["message"].toString().substring(0,5) != "https" ? Text(document.data()["message"],style: TextStyle(fontSize: 18),) : Image.network(document.data()["message"]),
                                          SizedBox(height: 2,),
                                          Text(document.data()["timehm"],style: TextStyle(fontSize: 8),),
                                        ],
                                      ),
                                      // onLongPress: (){
                                      //   AlertDialog alert = AlertDialog(
                                      //     shape: RoundedRectangleBorder(
                                      //         borderRadius: BorderRadius.circular(25)
                                      //     ),
                                      //     backgroundColor: Colors.black,
                                      //     actions: [
                                      //       Row(
                                      //         children: [
                                      //           TextButton(child: Text("Herkesten sil",style: TextStyle(color: Colors.white,fontSize: 22),), onPressed: () {
                                      //             myDB.deleteUserMessage(widget.id,document.id);
                                      //             myDB.deleteMyMessage(widget.id,document.id);
                                      //             Navigator.pop(context);
                                      //           }),
                                      //           TextButton(child: Text("Bender sil",style: TextStyle(color: Colors.white,fontSize: 22),), onPressed: () {
                                      //             myDB.deleteMyMessage(widget.id,document.id);
                                      //             Navigator.pop(context);
                                      //           }),
                                      //         ],
                                      //       )
                                      //
                                      //     ],
                                      //   );
                                      //   showDialog(
                                      //     context: context,
                                      //     builder: (BuildContext context) {
                                      //       return alert;
                                      //     },
                                      //   );
                                      // },
                                    ),
                                  ))),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 14),
                      child: TextField(
                        controller: txtmessage,
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            icon: Icon(Icons.image,color: Colors.black ,),
                            onPressed: (){
                              myStorage.sendImage(DateTime.now().toString(),widget.id,widget.username);
                            },
                          ),
                          hintText: "mesaj gönder",
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0,bottom: 8),
                    child: IconButton(
                        icon: Image.asset("assets/imagesicon/send.png"),
                        onPressed: () {
                          myDB.sendmessage(widget.id,txtmessage.text,DateTime.now(),widget.username);
                          myDB.docidwrite(widget.id);
                          myDB.recevmessage(widget.id,txtmessage.text,DateTime.now(),widget.username);
                          myDB.docrecidwrite(widget.id);
                          txtmessage.clear();
                        }),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
