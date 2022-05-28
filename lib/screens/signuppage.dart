import 'package:flutter/material.dart';
import 'package:gametuf/homeScreens/profilePage.dart';
import 'package:gametuf/homeScreens/rankPage.dart';
import 'package:gametuf/screens/homepage.dart';
import 'package:gametuf/screens/loginpage.dart';
import 'package:gametuf/services/authService.dart';
import 'package:gametuf/services/firebaseDB.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class signuppage extends StatefulWidget {
  @override
  _signuppageState createState() => _signuppageState();
}

class _signuppageState extends State<signuppage> {
  TextEditingController txtmail = TextEditingController();
  TextEditingController txtpas = TextEditingController();
  TextEditingController txtname = TextEditingController();
  TextEditingController txtusername = TextEditingController();
  TextEditingController txtabout = TextEditingController();

  var obst = true;
  var showd = false;

  @override
  Widget build(BuildContext context) {
    final myAuth = Provider.of<AuthService>(context);
    final myDB = Provider.of<firebasedb>(context);
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Image.asset("assets/imagesicon/back.png",width: 24,height: 24,),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    )
                ),
              ),
              Image.asset(
                "assets/imagesicon/ghost.png",
                width: 144,
                height: 144,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "GameTuf",
                style: TextStyle(fontSize: 28),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left:20,right: 20,bottom: 8,top: 8),
                child: TextField(
                  controller: txtmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "E-mail giriniz",
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:20,right: 20,bottom: 8,top: 8),
                child: TextField(
                  controller: txtpas,
                  obscureText: obst,
                  decoration: InputDecoration(
                    suffixIcon: showd == false ? IconButton(
                      icon: Icon(Icons.remove_red_eye,color: Colors.black,),
                      onPressed: (){
                        setState(() {
                          obst = false;
                          showd = true;
                        });
                      },
                    ) : IconButton(
                      icon: Icon(Icons.remove_red_eye_outlined,color: Colors.black),
                      onPressed: (){
                        setState(() {
                          obst = true;
                          showd = false;
                        });
                      },
                    ),
                    hintText: "Şifre giriniz",
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),

                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left:20,right: 5,bottom: 8,top: 8),
                      child: TextField(
                        controller: txtname,
                        maxLength: 20,
                        decoration: InputDecoration(
                          hintText: "İsim - soyisim",
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left:5,right: 20,bottom: 8,top: 8),
                      child: TextField(
                        controller: txtusername,
                        maxLength: 17,
                        decoration: InputDecoration(
                          hintText: "Kullanıcı adı",
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left:20,right: 20,top: 8),
                child: TextField(
                  maxLength: 111,
                  maxLines: 3,
                  controller: txtabout,
                  decoration: InputDecoration(
                    hintText: "Hakkınızda",
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              RaisedButton(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13,horizontal: 70),
                  child: Text(
                    "KAYIT OL",
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
                onPressed: () async{
                  if (txtabout.text.isEmpty && txtmail.text.isEmpty && txtpas.text.isEmpty && txtname.text.isEmpty && txtusername.text.isEmpty) {
                    AlertDialog alert = AlertDialog(
                      title: Text("Boş kutu hatası"),
                      content: Text("Lütfen tüm kutucukları eksiksiz doldurunuz."),
                      actions: [
                        TextButton(
                            child: Text("Tamam"),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ],
                    );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  } else {
                    await myAuth.register(txtmail.text, txtpas.text);
                    await myDB.adduser(txtmail.text, txtpas.text, txtname.text, txtusername.text,txtabout.text);
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
