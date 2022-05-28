import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gametuf/homeScreens/chatPage.dart';
import 'package:gametuf/homeScreens/settingspage.dart';
import 'package:gametuf/selectScreens/selectRanks.dart';
import 'package:gametuf/services/authService.dart';
import 'package:provider/provider.dart';

class rankPage extends StatefulWidget {
  @override
  _rankPageState createState() => _rankPageState();
}

class _rankPageState extends State<rankPage> {
  String dropdownValue = 'valorant';

  @override
  Widget build(BuildContext context) {
    final myAuth = Provider.of<AuthService>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 60,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PopupMenuButton(
                    icon: Image.asset("assets/imagesicon/settings.png",width:30,height: 30,),
                    itemBuilder: (BuildContext bc) => [
                      PopupMenuItem(
                        child: Text("Çıkış yap"), value: "signout",
                      ),
                    ],
                    onSelected: (route) {
                      if(route == "signout"){
                        myAuth.signout();
                      }
                    },
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Image.asset("assets/imagesicon/ghost.png",width: 56,height: 56,)
                  ),
                  IconButton(
                    icon: Image.asset("assets/imagesicon/chat.png",width: 40,height: 40,),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>messagePage()));
                    },
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.10,),
              Text("Rank seçim sayfası",style: TextStyle(fontSize: 22),),
              SizedBox(height: MediaQuery.of(context).size.height * 0.11,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Oyun seç: ",style: TextStyle(color: Colors.black, fontSize: 20),),
                  SizedBox(width: 10,),
                  DropdownButton<String>(
                    value: dropdownValue,
                    elevation: 16,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>["valorant", "league of legends","cs:go"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 8,),
              Center(
                child: RaisedButton(
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Rank'ını seç",style: TextStyle(color: Colors.white,fontSize: 20),),
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>selectRanks(dropdownValue)));
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.07,),
              Container(
                width: double.infinity,
                height: 80,
                child: FutureBuilder<DocumentSnapshot>(
                  future: users.doc(myAuth.authid()).get(),
                  builder:
                      (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data = snapshot.data.data();
                      return Center(
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              data["valorant"] != null ? Text("VALORANT : " + data["valorant"],style: TextStyle(fontSize: 18),) : Container(),
                              SizedBox(height: 5,),
                              data["league of legends"] != null ? Text("LOL : " + data["league of legends"],style: TextStyle(fontSize: 18),) : Container(),
                              SizedBox(height: 5,),
                              data["cs:go"] != null ? Text("CS:GO : " + data["cs:go"],style: TextStyle(fontSize: 18),) : Container(),
                            ],
                          )
                      );
                    }

                    return Center(child: CircularProgressIndicator());
                  },
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
