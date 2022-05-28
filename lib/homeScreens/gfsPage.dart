import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gametuf/homeScreens/creatGroupsPage.dart';
import 'package:gametuf/homeScreens/chatPage.dart';
import 'package:gametuf/homeScreens/settingspage.dart';
import 'package:gametuf/playerSearch/psScreen.dart';
import 'package:gametuf/services/authService.dart';
import 'package:provider/provider.dart';

class gfsPage extends StatefulWidget {
  @override
  _gfsPageState createState() => _gfsPageState();
}

class _gfsPageState extends State<gfsPage> {
  var gamelist = ["assets/gameBackground/valorantBack.jpg","assets/gameBackground/lolBack.jpg","assets/gameBackground/csgoBack.jpg"];
  var gamename = ["valorant","league of legends","cs:go"];

  @override
  Widget build(BuildContext context) {
    final myAuth = Provider.of<AuthService>(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
              Padding(
                padding: const EdgeInsets.only(top:8.0,bottom: 8),
                child: Text("Oyuncu aramak için dokunun",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
              ),
              rankselectlist("valorant","valorant1Back"),
              rankselectlist("league of legends","lol1Back"),
              rankselectlist("cs:go","csgo1Back"),
            ],
          ),
        ),
      ),
    );
  }
  Widget rankselectlist(String name,String imgname){
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
        child: Image.asset("assets/gameBackground/${imgname}.jpg",fit: BoxFit.cover,width: double.infinity,height: 200,),
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>playerSearch(name)));
      },

    );
  }
}
