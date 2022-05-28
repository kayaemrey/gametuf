// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:gametuf/homeScreens/chatPage.dart';
// import 'package:gametuf/services/authService.dart';
// import 'package:gametuf/services/firebaseDB.dart';
// import 'package:gametuf/services/firebaseStorage.dart';
// import 'package:provider/provider.dart';
//
// class userprofilepage extends StatefulWidget {
//   final String id;
//   userprofilepage(this.id);
//   @override
//   _userprofilepageState createState() => _userprofilepageState();
// }
//
// class _userprofilepageState extends State<userprofilepage> {
//   AuthService auth = new AuthService();
//   void friendsquest()async{
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(auth.authid())
//         .collection("friendslist")
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       querySnapshot.docs.forEach((doc) {
//         if(doc["id"] == widget.id){
//           setState(() {
//             useridquest = true;
//           });
//         }
//       });
//     });
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     friendsquest();
//   }
//   var useridquest = false;
//   @override
//   Widget build(BuildContext context) {
//     final myAuth = Provider.of<AuthService>(context);
//     final myDB = Provider.of<firebasedb>(context);
//     CollectionReference users = FirebaseFirestore.instance.collection('users');
//     if(widget.id == myAuth.authid()){
//       useridquest = true;
//     }
//     return Scaffold(
//       body: Container(
//         child: Column(
//           children: [
//             SizedBox(height: 60,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   icon: Image.asset("assets/imagesicon/back.png",width: 24,height: 24,),
//                   onPressed: (){
//                     Navigator.pop(context);
//                   },
//                 ),
//                 Container(
//                     alignment: Alignment.center,
//                     child: Image.asset("assets/imagesicon/ghost.png",width: 56,height: 56,)
//                 ),
//                 Column(
//                   children: [
//                     useridquest != true ? IconButton(
//                       icon: Image.asset("assets/imagesicon/add.png",width: 40,height: 40,),
//                       onPressed: (){
//                         myDB.notificationsAdd(widget.id);
//                         AlertDialog alert = AlertDialog(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(25)
//                           ),
//                           backgroundColor: Colors.black,
//                           title: Text("Arkadaşlık isteği gönderildi"),
//                           titleTextStyle: TextStyle(color: Colors.white,fontSize: 22),
//                           actions: [
//                             TextButton(child: Text("Çık",style: TextStyle(color: Colors.white,fontSize: 18),), onPressed: () {
//                               Navigator.pop(context);
//                             }),
//                           ],
//                         );
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return alert;
//                           },
//                         );
//                       },
//                     ) : IconButton(icon: Image.asset("assets/imagesicon/approve.png"), onPressed: (){},),
//                     useridquest != true ? Padding(
//                       padding: const EdgeInsets.only(right:4.0),
//                       child: Text("Arkadaşı\nekle",textAlign: TextAlign.center,style: TextStyle(fontSize: 12),),
//                     ) : Padding(
//                       padding: const EdgeInsets.only(right:4.0),
//                       child: Text("Ekli",textAlign: TextAlign.center,style: TextStyle(fontSize: 12),),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: MediaQuery.of(context).size.height * 0.06,),
//
//             Expanded(
//               child: FutureBuilder<DocumentSnapshot>(
//                 future: users.doc(widget.id).get(),
//                 builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//
//                   if (snapshot.hasError) {
//                     return Text("Something went wrong");
//                   }
//
//                   if (snapshot.connectionState == ConnectionState.done) {
//                     Map<String, dynamic> data = snapshot.data.data();
//                     return SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           CircleAvatar(
//                             backgroundColor: Colors.white,
//                             maxRadius: 85,
//                             backgroundImage: data["profilepic"] != null ?
//                             NetworkImage(data["profilepic"]) :
//                             AssetImage("assets/imagesicon/ghost.png"),
//                           ),
//                           SizedBox(height: 20,),
//                           Text(data["username"],style: TextStyle(fontSize: 28,fontWeight:FontWeight.bold),),
//                           Text(data["name"],style: TextStyle(fontSize: 24,fontWeight:FontWeight.w400),),
//                           SizedBox(height: 2,),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(data["about"],style: TextStyle(fontSize: 20,fontWeight:FontWeight.w300,),textAlign: TextAlign.center,),
//                           ),
//                           SizedBox(height: 20,),
//                           data["valorant"] != null ? Text("VALORANT : " + data["valorant"],style: TextStyle(fontSize: 18),) : Container(),
//                           SizedBox(height: 5,),
//                           data["league of legends"] != null ? Text("LOL : " + data["league of legends"],style: TextStyle(fontSize: 18),) : Container(),
//                           SizedBox(height: 5,),
//                           data["cs:go"] != null ? Text("CS:GO : " + data["cs:go"],style: TextStyle(fontSize: 18),) : Container(),
//                         ],
//                       ),
//                     );
//                   }
//
//                   return Center(child: CircularProgressIndicator());
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
