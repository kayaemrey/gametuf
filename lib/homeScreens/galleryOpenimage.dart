import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gametuf/homeScreens/reportMessagePage.dart';
import 'package:gametuf/services/authService.dart';
import 'package:gametuf/services/firebaseDB.dart';
import 'package:gametuf/services/firebaseStorage.dart';
import 'package:provider/provider.dart';

class galopenimage extends StatefulWidget {
  final String galid;
  final String id;
  galopenimage(this.galid,this.id);

  @override
  _galopenimageState createState() => _galopenimageState();
}

class _galopenimageState extends State<galopenimage> {
  @override
  Widget build(BuildContext context) {
    final myAuth = Provider.of<AuthService>(context);
    final myStorage = Provider.of<firebasestorage>(context);
    final myDB = Provider.of<firebasedb>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('users').doc(widget.id).collection("galeri");
    CollectionReference userss = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      body: Container(
        child:  Column(
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
                  icon: Icon(Icons.add,color: Colors.white,),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: FutureBuilder<DocumentSnapshot>(
                  future: users.doc(widget.galid).get(),
                  builder:
                      (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (snapshot.hasData && !snapshot.data.exists) {
                      return Text("Document does not exist");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data = snapshot.data.data() as Map<String, dynamic>;

                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FutureBuilder<DocumentSnapshot>(
                              future: userss.doc(widget.id).get(),
                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                                if (snapshot.hasError) {
                                  return Text("Something went wrong");
                                }

                                if (snapshot.hasData && !snapshot.data.exists) {
                                  return Text("Document does not exist");
                                }

                                if (snapshot.connectionState == ConnectionState.done) {
                                  Map<String, dynamic> data = snapshot.data.data() as Map<String, dynamic>;
                                  return Row(
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
                                      PopupMenuButton(
                                        icon: Image.asset("assets/imagesicon/more.png"),
                                        itemBuilder: (BuildContext bc) => [
                                          PopupMenuItem(
                                            child: Text("Sil"), value: "delete",
                                          ),
                                          PopupMenuItem(
                                            child: Text("Şikayet et"), value: "report",
                                          ),
                                        ],
                                        onSelected: (route) {
                                          if(route == "delete"){
                                            myDB.deleteimage(widget.id, widget.galid);
                                          }
                                          if(route == "report"){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>reportPage(widget.id)));
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                }

                                return Center(child: CircularProgressIndicator());
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  child: Image.network(data["url"],width: double.infinity,),
                                decoration: BoxDecoration(
                                    // border: Border.all(color: Colors.black,width: 5)
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
