import 'package:flutter/material.dart';
import 'package:gametuf/services/authService.dart';
import 'package:gametuf/services/firebaseDB.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

AuthService auth = new AuthService();
firebasedb myDB = new firebasedb();

class firebasestorage with ChangeNotifier {
  File _image;
  final picker = ImagePicker();

  Future<void> getImage(String kayityeri) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 20);
    _image = File(pickedFile.path);
    await firebase_storage.FirebaseStorage.instance
        .ref('${auth.authid()}/${kayityeri}.png')
        .putFile(_image);
    debugPrint("add image");
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('${auth.authid()}/${kayityeri}.png')
        .getDownloadURL();
    debugPrint(downloadURL);
    await FirebaseFirestore.instance.collection("users").doc(auth.authid()).set({"${kayityeri}": downloadURL},SetOptions(merge: true)).then((value) => debugPrint("add users ${kayityeri} data"));
  }

  Future<void> galerikayit(var kayityeri) async {
    Map<String, dynamic> galeri = Map();
    final pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 20);
    _image = File(pickedFile.path);
    await firebase_storage.FirebaseStorage.instance
        .ref('${auth.authid()}/${kayityeri}.png')
        .putFile(_image);
    debugPrint("add image");
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('${auth.authid()}/${kayityeri}.png')
        .getDownloadURL();
    debugPrint(downloadURL);
    galeri["url"] = downloadURL;
    galeri["time"] = DateTime.now();
    await FirebaseFirestore.instance.collection("users").doc(auth.authid()).collection("galeri").doc().set(galeri,SetOptions(merge: true)).then((value) => debugPrint("add users data"));
  }

  Future<void> sendImage(String kayityeri,String id,String username) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 20);
    _image = File(pickedFile.path);
    await firebase_storage.FirebaseStorage.instance
        .ref('${auth.authid()}/${kayityeri}.png')
        .putFile(_image);
    debugPrint("add image");
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('${auth.authid()}/${kayityeri}.png')
        .getDownloadURL();
    debugPrint(downloadURL);
    myDB.sendmessage(id,downloadURL,DateTime.now(),username);
    myDB.docidwrite(id);
    myDB.recevmessage(id,downloadURL,DateTime.now(),username);
    myDB.docrecidwrite(id);
  }

}