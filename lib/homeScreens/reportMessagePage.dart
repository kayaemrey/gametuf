import 'package:flutter/material.dart';
import 'package:gametuf/homeScreens/chatPage.dart';
import 'package:gametuf/services/firebaseDB.dart';
import 'package:provider/provider.dart';

class reportPage extends StatefulWidget {
  final String id;
  reportPage(this.id);
  @override
  _reportPageState createState() => _reportPageState();
}

class _reportPageState extends State<reportPage> {
  TextEditingController txtexpl = TextEditingController();
  TextEditingController txtsubj = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final myDB = Provider.of<firebasedb>(context);
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLength: 70,
                controller: txtsubj,
                //obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Konuyu giriniz",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLines: 4,
                maxLength: 200,
                controller: txtexpl,
                //obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Açıklama giriniz",
                ),
              ),
            ),
            RaisedButton(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical:15,horizontal: 80),
                child: Text("Gönder",style: TextStyle(color: Colors.white,fontSize: 18),),
              ),
              onPressed: (){
                if(txtexpl.text.isNotEmpty && txtsubj.text.isNotEmpty){
                  myDB.addreport(txtsubj.text, txtexpl.text, widget.id);
                  AlertDialog alert = AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)
                    ),
                    backgroundColor: Colors.blue.shade400,
                    title: Text("Kişi bildirdi"),
                    actions: [
                      TextButton(child: Text("Tamam",style: TextStyle(color: Colors.black,fontSize: 18),), onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>messagePage()));
                      }),
                    ],
                  );
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
