import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gametuf/homeScreens/galleryOpenimage.dart';
import 'package:gametuf/services/authService.dart';
import 'package:gametuf/services/firebaseDB.dart';
import 'package:gametuf/services/firebaseStorage.dart';
import 'package:provider/provider.dart';

class userGallery extends StatefulWidget {
  final String id;
  userGallery(this.id);
  @override
  _userGalleryState createState() => _userGalleryState();
}

class _userGalleryState extends State<userGallery> {

  @override
  Widget build(BuildContext context) {
    final myAuth = Provider.of<AuthService>(context);
    final myStorage = Provider.of<firebasestorage>(context);
    final myDB = Provider.of<firebasedb>(context);
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').doc(widget.id).collection("galeri").orderBy("time",descending: true).snapshots();
    return Scaffold(
      body:StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return new GridView.count(
            scrollDirection: Axis.vertical,
            crossAxisCount: 3,
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return Container(
                child: InkWell(
                    child: Image.network(document.data()["url"],fit: BoxFit.cover,filterQuality: FilterQuality.low,),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>galopenimage(document.id,widget.id)));
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

