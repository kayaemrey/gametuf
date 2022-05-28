import 'package:flutter/material.dart';
import 'package:gametuf/homeScreens/profilePage.dart';
import 'package:gametuf/services/authService.dart';
import 'package:gametuf/services/firebaseDB.dart';
import 'package:gametuf/services/firebaseStorage.dart';
import 'package:provider/provider.dart';

class rankSelect extends StatefulWidget {
  final String gamename;
  rankSelect(this.gamename);
  @override
  _rankSelectState createState() => _rankSelectState();
}

class _rankSelectState extends State<rankSelect> {
  var valorantrank = [
    "IRON1",
    "IRON2",
    "IRON3",
    "BRONZE1",
    "BRONZE2",
    "BRONZE3",
    "SİLVER1",
    "SİLVER2",
    "SİLVER3",
    "GOLD1",
    "GOLD2",
    "GOLD3",
    "PLATINUM1",
    "PLATINUM2",
    "PLATINUM3",
    "DIAMOND1",
    "DIAMOND2",
    "DIAMOND3",
    "IMMORTAL1",
    "IMMORTAL2",
    "IMMORTAL3",
    "RADIANT"
  ];
  var csgorank = [
    "S1",
    "S2",
    "S3",
    "S4",
    "GN1",
    "GN2",
    "GN3",
    "GN4",
    "MG1",
    "MG2",
    "MGE",
    "DMG",
    "LE",
    "LEM",
    "SMFC",
    "TGE",
  ];
  var lolrank = [
    "IRON1",
    "IRON2",
    "IRON3",
    "IRON4",
    "BRONZE4",
    "BRONZE3",
    "BRONZE2",
    "BRONZE1",
    "SILVER4",
    "SILVER3",
    "SILVER2",
    "SILVER1",
    "GOLD4",
    "GOLD3",
    "GOLD2",
    "GOLD1",
    "PLATINUM4",
    "PLATINUM3",
    "PLATINUM2",
    "PLATINUM1",
    "DIAMOND4",
    "DIAMOND3",
    "DIAMOND2",
    "DIAMOND1",
    "MASTER",
    "MASTER+SPLIT1",
    "MASTER+SPLIT2",
    "MASTER+SPLIT3",
    "GRANDMASTER",
    "GRANDMASTER+SPLIT1",
    "GRANDMASTER+SPLIT2",
    "GRANDMASTER+SPLIT3",
    "CHALLENGER",
    "CHALLENGER+SPLIT1",
    "CHALLENGER+SPLIT2",
    "CHALLENGER+SPLIT3",
  ];
  @override
  Widget build(BuildContext context) {
    final myAuth = Provider.of<AuthService>(context);
    final myStorage = Provider.of<firebasestorage>(context);
    final myDB = Provider.of<firebasedb>(context);
    print(widget.gamename);
    if (widget.gamename == "valorant") {
      return Scaffold(
        body: Column(
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
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: valorantrank.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: ListTile(
                      title: Text(
                        valorantrank[index],
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () {
                      myDB.addData(
                        valorantrank[index],
                        widget.gamename,
                      );
                      print(valorantrank[index]);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    } else if (widget.gamename == "league of legends") {
      return Scaffold(
        body: Center(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: lolrank.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: ListTile(
                  title: Text(
                    lolrank[index],
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {
                  myDB.addData(
                    lolrank[index],
                    widget.gamename,
                  );
                  print(lolrank[index]);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: csgorank.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: ListTile(
                  title: Text(
                    csgorank[index],
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {
                  myDB.addData(
                    csgorank[index],
                    widget.gamename,
                  );
                  print(csgorank[index]);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      );
    }
  }
}
