import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes/models/user_model.dart';
import 'package:firebase_notes/screens/add_update_page.dart';
import 'package:firebase_notes/screens/all_profile_pics.dart';
import 'package:firebase_notes/screens/explore_note.dart';
import 'package:firebase_notes/start_screen/change_profile_info.dart';
import 'package:firebase_notes/start_screen/forgot_pass.dart';
import 'package:firebase_notes/start_screen/login_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
        firestore.collection('user').doc(currUser!.uid);
    var profileCollection = FirebaseFirestore.instance.collection('user').doc(currUser!.uid).collection('picsCollection');
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Notes...")),
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        child: StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
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
                          /*------Change profile info----*/
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ChangeProfileInfo(
                                  userData: snapshot.data!.data(),
                                );
                              }));
                            },
                            child: Row(
                              children: [
                                //see profile pics
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      return ProfilePics(profilePic: snapshot.data!.data()!['picurl'] ?? CircleAvatar());
                                    }));
                                  },
                                  child: Stack(
                                    children: [
                                      //Set image in profile
                                      SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: snapshot.data!.data()!['picurl'] != null ?
                                        SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(25),
                                              child: Image.network(snapshot.data!.data()!['picurl'],fit: BoxFit.cover,)),
                                        ) :
                                        CircleAvatar()
                                      ),
                                      Positioned(
                                          bottom: 0,
                                          right: 0,
                                          //bottom sheet to change profile picture
                                          child: InkWell(
                                            onTap: () async {
                                              showModalBottomSheet(
                                                  context: (context),
                                                  constraints:
                                                  BoxConstraints(maxHeight: 200),
                                                  builder: (_) {
                                                    return Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: 20, horizontal: 10),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.spaceAround,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              InkWell(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .highlight_remove_rounded,
                                                                    size: 30,
                                                                  )),
                                                              Text(
                                                                "Profile photo",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                    FontWeight.bold,
                                                                    fontSize: 20),
                                                              ),
                                                              InkWell(
                                                                onTap: () {},
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  size: 30,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          /*-----Camera and Gallery----*/
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                            children: [
                                                              InkWell(
                                                                onTap: () async {
                                                                  //pick image here from gallery we can also use camera
                                                                  final XFile? image =
                                                                  await ImagePicker()
                                                                      .pickImage(
                                                                      source: ImageSource
                                                                          .camera);
                                                                  if (image != null) {
                                                                    CroppedFile?
                                                                    croppedImage =
                                                                    await ImageCropper()
                                                                        .cropImage(
                                                                        sourcePath:
                                                                        image
                                                                            .path,
                                                                        uiSettings: [
                                                                          AndroidUiSettings(
                                                                            toolbarTitle:
                                                                            'Cropper',
                                                                            toolbarColor:
                                                                            Colors
                                                                                .deepOrange,
                                                                            toolbarWidgetColor:
                                                                            Colors
                                                                                .white,
                                                                            aspectRatioPresets: [
                                                                              CropAspectRatioPreset
                                                                                  .original,
                                                                              CropAspectRatioPreset
                                                                                  .square,
                                                                            ],
                                                                          ),
                                                                        ]);
                                                                    if (croppedImage != null) {
                                                                      //this picked file will be shown in asset image
                                                                      pickedFile = File(croppedImage.path);
                                                                      //Save image in firestore here
                                                                      var storage = FirebaseStorage.instance;
                                                                      var storageRef = storage.ref();
                                                                      var profilePicRef = storageRef.child(
                                                                          'images/profile_pic/IMG_${DateTime.now().millisecondsSinceEpoch}.jpeg');
                                                                      await profilePicRef.putFile(pickedFile!);
                                                                      var actualUrl = profilePicRef.getDownloadURL();
                                                                      //adding current pic url in user data
                                                                      FirebaseFirestore.instance.collection('user').doc(currUser!.uid).update({
                                                                        'picurl' : actualUrl
                                                                      });
                                                                      //creating a new collection in user doc to store all profile pics
                                                                      //giving same id which is given in user doc
                                                                      profileCollection.doc(DateTime.now().millisecondsSinceEpoch.toString()).set({
                                                                        'url' : actualUrl
                                                                      });
                                                                      Navigator.pop(context);
                                                                      setState(() {});
                                                                    }
                                                                  }
                                                                },
                                                                /*----camera---*/
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                        height: 50,
                                                                        width: 50,
                                                                        decoration: BoxDecoration(
                                                                            border: Border.all(
                                                                                color: Colors
                                                                                    .black),
                                                                            borderRadius:
                                                                            BorderRadius
                                                                                .circular(
                                                                                25)),
                                                                        child: Icon(
                                                                          Icons
                                                                              .camera_alt_outlined,
                                                                          size: 30,
                                                                        )),
                                                                    Text("Camera")
                                                                  ],
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () async {
                                                                  try {
                                                                    //pick image here from gallery we can also use camera
                                                                    final XFile? image =
                                                                    await ImagePicker()
                                                                        .pickImage(
                                                                        source: ImageSource
                                                                            .gallery);
                                                                    if (image != null) {
                                                                      CroppedFile?
                                                                      croppedImage = await ImageCropper().cropImage(
                                                                          sourcePath:
                                                                          image
                                                                              .path,
                                                                          uiSettings: [
                                                                            AndroidUiSettings(
                                                                              toolbarTitle:
                                                                              'Cropper',
                                                                              toolbarColor:
                                                                              Colors
                                                                                  .deepOrange,
                                                                              toolbarWidgetColor:
                                                                              Colors
                                                                                  .white,
                                                                              aspectRatioPresets: [
                                                                                CropAspectRatioPreset
                                                                                    .original,
                                                                                CropAspectRatioPreset
                                                                                    .square,
                                                                              ],
                                                                            ),
                                                                          ]);
                                                                      if (croppedImage !=
                                                                          null) {
                                                                        pickedFile = File(
                                                                            croppedImage
                                                                                .path);
                                                                        Navigator.pop(context);
                                                                        //Save image in firestore here
                                                                        var storage = FirebaseStorage.instance;
                                                                        var storageRef = storage.ref();
                                                                        var profilePicRef = storageRef.child(
                                                                            "images/profile_pic/IMG_${DateTime.now().millisecondsSinceEpoch}.jpg");
                                                                        await profilePicRef.putFile(pickedFile!);
                                                                        var actualUrl = await profilePicRef.getDownloadURL();
                                                                        //adding current pic url in user data
                                                                        FirebaseFirestore.instance.collection('user').doc(currUser!.uid).update({
                                                                          'picurl' : actualUrl
                                                                        });
                                                                        //creating a new collection in user doc to store all profile pics
                                                                        //giving same id which is given in user doc
                                                                        var profileCollection =
                                                                        FirebaseFirestore.instance.collection('user').doc(currUser!.uid).collection('picsCollection');
                                                                        //adding all profile pic to document
                                                                        profileCollection.doc(DateTime.now().millisecondsSinceEpoch.toString()).set({
                                                                            'url': actualUrl});
                                                                        setState(() {});
                                                                        Navigator.pop(context);
                                                                      }
                                                                    }
                                                                  } catch (e) {
                                                                    print(e.toString());
                                                                  }
                                                                },
                                                                /*----Gallery---*/
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                        height: 50,
                                                                        width: 50,
                                                                        decoration: BoxDecoration(
                                                                            border: Border.all(
                                                                                color: Colors
                                                                                    .black),
                                                                            borderRadius:
                                                                            BorderRadius
                                                                                .circular(
                                                                                25)),
                                                                        child: Icon(
                                                                          Icons.photo,
                                                                          size: 30,
                                                                        )),
                                                                    Text("Gallery")
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            },
                                            child: Icon(
                                              Icons.edit,
                                              size: 20,
                                            ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //name
                                      Text(snapshot.data!.data()!['name']),
                                      //email
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
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Notes",
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          /*-----Reminders-----*/
                          Row(
                            children: [
                              Icon(Icons.notifications),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Reminders",
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          /*-----Create New label-----*/
                          Row(
                            children: [
                              Icon(Icons.add),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Create new label",
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          /*-----Settings-----*/
                          Row(
                            children: [
                              Icon(Icons.settings),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Settings",
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          /*-----Logout-----*/
                          Row(
                            children: [
                              Icon(Icons.logout),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                  onTap: () async {
                                    FirebaseAuth.instance.signOut();
                                    prefs =
                                        await SharedPreferences.getInstance();
                                    prefs!.setString('uid', "");
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                      return LoginPage();
                                    }));
                                  },
                                  child: Text(
                                    "Logout",
                                    style: TextStyle(fontSize: 15),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          //Change password when user logged in
                          Row(
                            children: [
                              Icon(Icons.password),
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
                          return InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ExploreNote(
                                    data: snapshot.data!.docs[index].data());
                              }));
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.primaries[Random()
                                          .nextInt(Colors.primaries.length - 1)]
                                      .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey, width: 1)),
                              child: ListTile(
                                title: Text(
                                    snapshot.data!.docs[index].data()['title']),
                                subtitle: Text(
                                    snapshot.data!.docs[index].data()['desc']),
                                trailing: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      //Update Note here
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
                                                prevDesc: snapshot
                                                    .data!.docs[index]
                                                    .data()['desc'],
                                                id: snapshot
                                                    .data!.docs[index].id,
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
                                                id: snapshot
                                                    .data!.docs[index].id,
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
