import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gametuf/rankSelect/rankSelect.dart';
import 'package:gametuf/services/authService.dart';
import 'package:gametuf/services/firebaseDB.dart';
import 'package:gametuf/services/firebaseStorage.dart';
import 'package:provider/provider.dart';

class editprofile extends StatefulWidget {
  @override
  _editprofileState createState() => _editprofileState();
}

class _editprofileState extends State<editprofile> {
  var gamelist = ["assets/gameBackground/valorant1Back.jpg","assets/gameBackground/lol1Back.jpg","assets/gameBackground/csgo1Back.jpg"];
  var gamename = ["valorant","league of legends","cs:go"];

  TextEditingController txtName = TextEditingController();
  TextEditingController txtAbout = TextEditingController();
  TextEditingController txtTakim = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final myAuth = Provider.of<AuthService>(context);
    final myStorage = Provider.of<firebasestorage>(context);
    final myDB = Provider.of<firebasedb>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
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
            return Container(
              child: SingleChildScrollView(
                child: Column(
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
                          icon: Icon(Icons.add,color: Colors.white,),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    InkWell(
                      child: Container(
                        child: data["kapak"] != null
                            ? Image.network(
                          data["kapak"],
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.low,
                        )
                            : Image.asset(
                          "assets/imagesicon/kapakdeneme.jpg",fit: BoxFit.cover,),
                      ),
                      onLongPress: (){
                        myStorage.getImage("kapak");
                      },
                    ),
                    Container(
                      alignment: Alignment.center,
                      transform: Matrix4.translationValues(0, -40, 0),
                      child: InkWell(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          maxRadius: 50,
                          backgroundImage: data["profile"] != null
                              ? NetworkImage(data["profile"])
                              : AssetImage(
                              "assets/imagesicon/ghost.png"),
                        ),
                        onLongPress: () {
                          myStorage.getImage("profile");
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:20,right: 20,bottom: 8,top: 0),
                      child: TextField(
                        controller: txtName,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: data["name"],
                          helperText: "İsminiz",
                          suffixIcon: IconButton(
                            icon: Image.asset("assets/imagesicon/check.png"),
                            onPressed: (){
                              myDB.addData(txtName.text, "name");
                              txtName.clear();
                            },
                          ),
                          hintStyle: TextStyle(color: Colors.black),
                          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:20,right: 20,bottom: 8,top: 8),
                      child: TextField(
                        controller: txtAbout,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: data["about"],
                          hintMaxLines: 4,
                          helperText: "Hakkınızda",
                          suffixIcon: IconButton(
                            icon: Image.asset("assets/imagesicon/check.png"),
                            onPressed: (){
                              myDB.addData(txtAbout.text, "about");
                              txtAbout.clear();
                            },
                          ),
                          hintStyle: TextStyle(color: Colors.black),
                          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:20,right: 20,bottom: 8,top: 8),
                      child: TextField(
                        controller: txtTakim,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: data["takım"],
                          hintMaxLines: 4,
                          helperText: "Oynadığınız takım",
                          suffixIcon: IconButton(
                            icon: Image.asset("assets/imagesicon/check.png"),
                            onPressed: (){
                              myDB.addData(txtTakim.text, "takım");
                              txtTakim.clear();
                            },
                          ),
                          hintStyle: TextStyle(color: Colors.black),
                          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:8.0,bottom: 8),
                      child: Text("Seviye seçmek için dokunun",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                    ),
                    rankselectlist("valorant","valorant1Back"),
                    rankselectlist("league of legends","lol1Back"),
                    rankselectlist("cs:go","csgo1Back"),
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   itemCount: gamelist.length,
                    //   itemBuilder: (context, index) {
                    //     return InkWell(
                    //       child: ListTile(
                    //         title: Stack(
                    //           alignment: Alignment.center,
                    //           children: [
                    //             Image.asset(gamelist[index],fit: BoxFit.cover,width: double.infinity,),
                    //             Text(gamename[index],style: TextStyle(fontSize: 20,color: Colors.white),textAlign: TextAlign.center,)
                    //           ],
                    //         ),
                    //       ),
                    //       onTap: (){
                    //         Navigator.push(context, MaterialPageRoute(builder: (context)=>rankSelect(gamename[index])));
                    //       },
                    //     );
                    //   },
                    // ),
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
  Widget rankselectlist(String name,String imgname){
    return InkWell(
        child: Padding(
          padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
          child: Image.asset("assets/gameBackground/${imgname}.jpg",fit: BoxFit.cover,width: double.infinity,height: 200,),
        ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>rankSelect(name)));
      },

    );
  }
}
