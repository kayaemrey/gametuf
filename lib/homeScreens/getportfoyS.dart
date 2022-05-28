import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gametuf/services/authService.dart';
import 'package:gametuf/services/firebaseDB.dart';
import 'package:provider/provider.dart';

class getportfoyS extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final myAuth = Provider.of<AuthService>(context);
    final myDB = Provider.of<firebasedb>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      body: Container(
        child: FutureBuilder<DocumentSnapshot>(
          future: users.doc(myAuth.authid()).get(),
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
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0,bottom: 8),
                    child: Text(data["about"],style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0,bottom: 8),
                    child: data["takım"] != null ? Text("Oynadıgı takım : " + data["takım"],style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),textAlign: TextAlign.center,) :
                    Text("Oynadıgı takım : Girilmedi!"),
                  ),
                ],
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
