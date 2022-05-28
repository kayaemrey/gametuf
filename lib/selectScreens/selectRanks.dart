import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gametuf/services/authService.dart';
import 'package:gametuf/services/firebaseDB.dart';
import 'package:provider/provider.dart';

class selectRanks extends StatefulWidget {
  final String game;
  selectRanks(this.game);
  @override
  _selectRanksState createState() => _selectRanksState();
}

class _selectRanksState extends State<selectRanks> {
  @override
  Widget build(BuildContext context) {
    final myAuth = Provider.of<AuthService>(context);
    final myDB = Provider.of<firebasedb>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('games').doc(widget.game).collection("ranks");

    return StreamBuilder<QuerySnapshot>(
      stream: users.orderBy("id",descending: false).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          body: ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return ListTile(
                title: InkWell(
                    child: Center(child: Text(document.data()["rank"])),
                  onTap: (){
                      myDB.addData(document.data()["rank"], widget.game);
                      Navigator.pop(context);
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
