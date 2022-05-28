import 'package:flutter/material.dart';
import 'package:gametuf/rankSelect/rankSelect.dart';
import 'package:gametuf/services/authService.dart';
import 'package:gametuf/services/firebaseStorage.dart';
import 'package:provider/provider.dart';

class gameSelect extends StatefulWidget {
  @override
  _gameSelectState createState() => _gameSelectState();
}

class _gameSelectState extends State<gameSelect> {
  var gamelist = ["assets/gameicon/valorant.png","assets/gameicon/lol.png","assets/gameicon/csgo.png"];
  var gamename = ["valorant","league of legends","cs:go"];
  @override
  Widget build(BuildContext context) {
    final myAuth = Provider.of<AuthService>(context);
    final myStorage = Provider.of<firebasestorage>(context);
    return Scaffold(
      body: Center(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: gamelist.length,
          itemBuilder: (context, index) {
            return InkWell(
              child: ListTile(
                title: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(gamelist[index]),
                    Text(gamename[index],style: TextStyle(fontSize: 20,color: Colors.white),textAlign: TextAlign.center,)
                  ],
                ),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>rankSelect(gamename[index])));
              },
            );
          },
        ),
      ),
    );
  }
}
