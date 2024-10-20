import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes/models/user_model.dart';
import 'package:firebase_notes/screens/home_page.dart';
import 'package:flutter/material.dart';

class ChangeProfileInfo extends StatefulWidget {
  var userData;
  ChangeProfileInfo({required this.userData});
  @override
  State<ChangeProfileInfo> createState() => _ChangeProfileInfoState();
}

class _ChangeProfileInfoState extends State<ChangeProfileInfo> {

  MediaQueryData? mqData;
  TextEditingController emailCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController phoneCon = TextEditingController();
  TextEditingController genderCon = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var currUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    emailCon.text = widget.userData['email'];
    nameCon.text = widget.userData['name'];
    phoneCon.text = widget.userData['phone'];
    genderCon.text = widget.userData['gender'];
    super.initState();
  }

  String? uid;

  @override
  Widget build(BuildContext context) {
    var collections = firestore.collection('user');
    if (currUser != null) {
      uid = currUser!.uid;
    }
    mqData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new_outlined)),
        title: Center(child: Text("Edit Profile")),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: mqData!.size.height,
          width: mqData!.size.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    widget.userData['picurl'] != null ? SizedBox(
                      height: 70,
                      width: 70,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(35),
                          child: Image.network(widget.userData['picurl'],fit: BoxFit.cover,)),
                    ):CircleAvatar(
                      maxRadius: 50,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      widget.userData['name'],
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Email Address",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextField(
                      controller: emailCon,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "UserName",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextField(
                      controller: nameCon,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Mobile No.",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextField(
                      controller: phoneCon,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Gender",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextField(
                      controller: genderCon,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            try {
                              collections.doc(uid).update(UserModel(
                                      name: nameCon.text.toString(),
                                      email: emailCon.text.toString(),
                                      picUrl: widget.userData['picurl'],
                                      phone: phoneCon.text.toString(),
                                      gender: genderCon.text.toString())
                                  .toDoc());
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Information Updated Successfully!!!")));
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return HomePage();
                              }));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          },
                          child: Text("Change profile info")),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
