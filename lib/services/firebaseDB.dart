import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gametuf/services/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

AuthService auth = new AuthService();

class firebasedb with ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> adduser(String email,String password,String name,String username,String about) async{
    Map<String, dynamic> users = Map();
    users["email"] = email;
    users["password"] = password;
    users["name"] = name;
    users["username"] = username;
    users["about"] = about;
    users["arp"] = 1;
    users["registertime"] = DateTime.now();
    await FirebaseFirestore.instance.collection("users").doc(auth.authid()).set(users,SetOptions(merge: true)).then((value) => debugPrint("add user data"));
  }

  void addData(var data,var eklenecek)async{
    await FirebaseFirestore.instance.collection("users").doc(auth.authid()).set({eklenecek:data},SetOptions(merge: true)).then((value) => debugPrint("add rank data"));
  }
  void addLikeName(var data,var eklenecek)async{
    await FirebaseFirestore.instance.collection("users").doc(auth.authid()).collection("like").doc().set({eklenecek:data},SetOptions(merge: true)).then((value) => debugPrint("add like name data"));
  }
  void imagelike(var eklenecek,var docid,var name)async{
    Map<String, dynamic> users = Map();
    users["like"] = FieldValue.increment(1);
    users["likenamelist"] = "asd";
    await FirebaseFirestore.instance.collection("users").doc(auth.authid()).collection("galeri").doc(docid).set(users,SetOptions(merge: true)).then((value) => debugPrint("add rank data"));
  }
  void creatMygroups(String id,String game) async{
    Map<String, dynamic> groups = Map();
    groups["id"] = id;
    await FirebaseFirestore.instance.collection("users").doc(auth.authid()).collection(game).doc().set(groups,SetOptions(merge: true)).then((value) => debugPrint("add user data"));
  }
  void creatTogroups(String id,String yazilacakid,String game) async{
    Map<String, dynamic> groups = Map();
    groups["id"] = id;
    await FirebaseFirestore.instance.collection("users").doc(yazilacakid).collection(game).doc().set(groups,SetOptions(merge: true)).then((value) => debugPrint("add user data"));
  }


  Future<void> followers(String id)async{
    Map<String, dynamic> followers = Map();
    followers["id"] = id;
    await FirebaseFirestore.instance.collection("users").doc(auth.authid()).collection("followers").doc().set(followers,SetOptions(merge: true)).then((value) => debugPrint("add  user data"));
  }
  Future<void> follow(String id)async{
    Map<String, dynamic> follow = Map();
    follow["id"] = auth.authid();
    await FirebaseFirestore.instance.collection("users").doc(id).collection("follow").doc().set(follow,SetOptions(merge: true)).then((value) => debugPrint("add $id user data"));
  }
  Future<void> notificationsAdd(String id,var Nottype) async{
    Map<String, dynamic> notifications = Map();
    notifications["id"] = auth.authid();
    notifications["sendtime"] = DateTime.now();
    notifications["type"] = Nottype;
    await FirebaseFirestore.instance.collection("users").doc(id).collection("notifications").doc(auth.authid()).set(notifications,SetOptions(merge: true)).then((value) => debugPrint("add user data"));
  }
  Future<void> deletenotifications(String id) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users
        .doc(auth.authid())
        .collection("notifications")
        .doc(id)
        .delete()
        .then((value) => print("notifications Deleted"))
        .catchError((error) => print("Failed to delete notifications: $error"));
  }
  Future<void> deleteimage(String id,String docid) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users
        .doc(id)
        .collection("galeri")
        .doc(docid)
        .delete()
        .then((value) => print("image Deleted"))
        .catchError((error) => print("Failed to delete notifications: $error"));
  }
  Future<void> addreport(String subject,String explanation,String id) async{
    Map<String, dynamic> addfriends = Map();
    addfriends["subject"] = subject;
    addfriends["explanation"] = explanation;
    addfriends["problem id"] = id;
    await FirebaseFirestore.instance.collection("report").doc().set(addfriends,SetOptions(merge: true)).then((value) => debugPrint("add report data"));
  }


  void createMessage(var myregister,var userregister,var message,var sendid)async{
    Map<String, dynamic> message = Map();
    message["message"] = message;
    message["sendid"] = sendid;
    message["date"] = DateTime.now();
    message["datehour"] = DateTime.parse("hh:mm");
    if(myregister > userregister){
      await FirebaseFirestore.instance.collection("message").doc(myregister + userregister)
          .set(message,SetOptions(merge: true)).then((value) => debugPrint("add message"));
    }else{
      await FirebaseFirestore.instance.collection("message").doc(userregister + myregister)
          .set(message,SetOptions(merge: true)).then((value) => debugPrint("add message"));
    }
  }


  void sendmessage(String id,String sendmessage,DateTime time,String username) async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('hh-mm');
    final String formatted = formatter.format(now);
    Map<String, dynamic> message = Map();
    message["message"] = sendmessage;
    message["sendid"] = auth.authid();
    message["time"] = time;
    message["timehm"] = formatted;
    message["username"] = username;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(auth.authid())
        .collection("creatmessage")
        .doc(id)
        .collection("data")
        .doc()
        .set(message, SetOptions(merge: true));
  }
  void recevmessage(String id,String sendmessage,DateTime time,String username) async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('hh-mm');
    final String formatted = formatter.format(now);
    Map<String, dynamic> message = Map();
    message["message"] = sendmessage;
    message["sendid"] = auth.authid();
    message["time"] = time;
    message["timehm"] = formatted;
    message["username"] = username;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("creatmessage")
        .doc(auth.authid())
        .collection("data")
        .doc()
        .set(message, SetOptions(merge: true));
  }
  void docidwrite(String id) async{
    Map<String, dynamic> groups = Map();
    groups["id"] = id;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(auth.authid())
        .collection("creatmessage")
        .doc(id)
        .set(groups,SetOptions(merge: true)).then((value) => debugPrint("add docidwrite $id"));
  }
  void docrecidwrite(String id) async{
    Map<String, dynamic> groups = Map();
    groups["id"] = auth.authid();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("creatmessage")
        .doc(auth.authid())
        .set(groups,SetOptions(merge: true)).then((value) => debugPrint("add docrecidwrite data $id"));
  }
  void addPs(var id,var gamename,var rankname)async{
    await FirebaseFirestore.instance.collection(gamename).doc(rankname).collection("id").doc().set({"id":id},SetOptions(merge: true)).then((value) => debugPrint("add playersearch data"));
  }

  //add prop id to delete messages
  // Future<void> deleteMyMessage(String userid,String silinecekid) {
  //   CollectionReference users = FirebaseFirestore.instance.collection('users');
  //   return users
  //       .doc(auth.authid())
  //       .collection("creatmessage")
  //       .doc(userid)
  //       .collection("data")
  //       .doc(silinecekid)
  //       .delete()
  //       .then((value) => print("message Deleted"))
  //       .catchError((error) => print("Failed to delete message: $error"));
  // }
  // Future<void> deleteUserMessage(String userid,String silinecekid) {
  //   CollectionReference users = FirebaseFirestore.instance.collection('users');
  //   return users
  //       .doc(userid)
  //       .collection("creatmessage")
  //       .doc(auth.authid())
  //       .collection("data")
  //       .doc(silinecekid)
  //       .delete()
  //       .then((value) => print("message Deleted ${auth.authid()} $userid"))
  //       .catchError((error) => print("Failed to delete message: $error"));
  // }

}
