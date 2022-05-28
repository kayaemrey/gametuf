import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gametuf/services/authService.dart';
import 'package:gametuf/services/firebaseDB.dart';
import 'package:gametuf/services/firebaseStorage.dart';
import 'package:provider/provider.dart';

class userGetrankS extends StatelessWidget {
  final String id;
  userGetrankS(this.id);
  @override
  Widget build(BuildContext context) {

    final myAuth = Provider.of<AuthService>(context);
    final myStorage = Provider.of<firebasestorage>(context);
    final myDB = Provider.of<firebasedb>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(id).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data() as Map<String, dynamic>;
            return SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Image.asset("assets/gameBackground/valorantBack.jpg",),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                              ),
                              child: data["valorant"] != null ? Text(data["valorant"],style: TextStyle(fontSize: 30, color: Colors.white,fontWeight: FontWeight.w600),) : Text("unknow",style: TextStyle(fontSize: 30, color: Colors.white,fontWeight: FontWeight.w600),)
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Image.asset("assets/gameBackground/lolBack.jpg",),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                              ),
                              child:data["league of legends"] != null ? Text(data["league of legends"],style: TextStyle(fontSize: 30, color: Colors.white,fontWeight: FontWeight.w600),) : Text("unknow",style: TextStyle(fontSize: 30, color: Colors.white,fontWeight: FontWeight.w600),)
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Image.asset("assets/gameBackground/csgoBack.jpg",),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                              ),
                              child: data["cs:go"] != null ? Text(data["cs:go"],style: TextStyle(fontSize: 30, color: Colors.white,fontWeight: FontWeight.w600),) : Text("unknow",style: TextStyle(fontSize: 30, color: Colors.white,fontWeight: FontWeight.w600),)
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
