import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes/screens/add_update_page.dart';
import 'package:firebase_notes/start_screen/change_profile_info.dart';
import 'package:firebase_notes/start_screen/forgot_pass.dart';
import 'package:firebase_notes/start_screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? uid;
  SharedPreferences? prefs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? currUser = FirebaseAuth.instance.currentUser;
  File? pickedFile;

  @override
  Widget build(BuildContext context) {
    if (currUser != null) {
      uid = currUser!.uid;
    }
    var collections =
        firestore.collection("notes").where('uid', isEqualTo: uid);
    var userInfoCollection =
        firestore.collection('user').where('email', isEqualTo: currUser!.email);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Notes...")),
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: userInfoCollection.snapshots(),
            builder: (_, snapshot) {
              return snapshot.data != null
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 30.0, horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return ChangeProfileInfo(userData: snapshot.data!.docs[0],);
                              }));
                            },
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    try {
                                      //pick image here
                                      final XFile? image = await ImagePicker()
                                          .pickImage(source: ImageSource.gallery);
                                      if (image != null) {
                                        CroppedFile? croppedImage =
                                            await ImageCropper().cropImage(
                                                sourcePath: image.path,uiSettings: [
                                                  WebUiSettings(context: context,size: CropperSize(
                                                    height: 500,
                                                  ))
                                            ]);
                                        if (croppedImage != null) {
                                          pickedFile = File(croppedImage.path);
                                          setState(() {});
                                        }
                                      }
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      //Set image in profile
                                      CircleAvatar(
                                        backgroundImage: pickedFile != null
                                            ? FileImage(pickedFile!)
                                            : null,
                                      ),
                                      Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Icon(
                                            Icons.edit,
                                            size: 20,
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  height: 50,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //name
                                      Text(snapshot.data!.docs[0]['name']),
                                      Text(currUser!.email!),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          /*-----Notes-----*/
                          Row(
                            children: [
                            Icon(Icons.lightbulb),
                            SizedBox(width: 5,),
                            Text("Notes",style: TextStyle(fontSize: 15),),
                          ],),
                          SizedBox(
                            height: 15,
                          ),
                          /*-----Reminders-----*/
                          Row(
                            children: [
                              Icon(Icons.notifications),
                              SizedBox(width: 5,),
                              Text("Reminders",style: TextStyle(fontSize: 15),),
                            ],),
                          SizedBox(
                            height: 15,
                          ),
                          /*-----Create New label-----*/
                          Row(
                            children: [
                              Icon(Icons.add),
                              SizedBox(width: 5,),
                              Text("Create new label",style: TextStyle(fontSize: 15),),
                            ],),
                          SizedBox(
                            height: 15,
                          ),
                          /*-----Settings-----*/
                          Row(
                            children: [
                              Icon(Icons.settings),
                              SizedBox(width: 5,),
                              Text("Settings",style: TextStyle(fontSize: 15),),
                            ],),
                          SizedBox(
                            height: 15,
                          ),
                          /*-----Logout-----*/
                          Row(
                            children: [
                              Icon(Icons.logout),
                              SizedBox(width: 5,),
                              InkWell(
                                onTap: () async {
                                  FirebaseAuth.instance.signOut();
                                  prefs = await SharedPreferences.getInstance();
                                  prefs!.setString('uid', "");
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                        return LoginPage();
                                      }));
                                },
                                  child: Text("Logout",style: TextStyle(fontSize: 15),)),
                            ],),
                          SizedBox(
                            height: 15,
                          ),
                          //Change password when user logged in
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ForgotPass(
                                      isUserLogin: true,
                                    );
                                  }));
                                },
                                child: Text("Change password")),
                          ),
                        ],
                      ),
                    )
                  : Center(child: CircularProgressIndicator());
            }),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: collections.snapshots(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isNotEmpty) {
                return snapshot.data!.docs.isNotEmpty
                    ? ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (_, index) {
                          return Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey,
                                width: 2
                              )
                            ),
                            child: ListTile(
                              title: Text(
                                  snapshot.data!.docs[index].data()['title']),
                              subtitle:
                                  Text(snapshot.data!.docs[index].data()['desc']),
                              trailing: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          /*-----------Update Note--------*/
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return AddUpDatePage(
                                              isDelete: false,
                                              isUpdate: true,
                                              prevTitle: snapshot
                                                  .data!.docs[index]
                                                  .data()['title'],
                                              prevDesc: snapshot.data!.docs[index]
                                                  .data()['desc'],
                                              id: snapshot.data!.docs[index].id,
                                            );
                                          }));
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        )),
                                    /*-------Delete Note here----------*/
                                    InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return AddUpDatePage(
                                              isUpdate: false,
                                              isDelete: true,
                                              id: snapshot.data!.docs[index].id,
                                            );
                                          }));
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                    : Text(
                        "No Notes yet!!",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      );
              }
            }
            return Container();
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddUpDatePage(
              isUpdate: false,
              isDelete: false,
            );
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
