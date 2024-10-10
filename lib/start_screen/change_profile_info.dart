import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChangeProfileInfo extends StatelessWidget{
  MediaQueryData?mqData;
  TextEditingController emailCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController phoneCon = TextEditingController();
  TextEditingController genderCon = TextEditingController();
  var userData;
  ChangeProfileInfo({required this.userData});
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    var collections = firestore.collection('notes');
    mqData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back_ios_new_outlined)),
        title: Center(child: Text("Edit Profile")),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
          stream: collections.snapshots(),
          builder: (_,snapshot){
            return Container(
              height: mqData!.size.height,
              width: mqData!.size.width,
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  CircleAvatar(
                    maxRadius: 50,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(userData['name'],style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                  SizedBox(
                    height: 15,
                  ),

                ],
              ),
            );
          }),
    );
  }
}