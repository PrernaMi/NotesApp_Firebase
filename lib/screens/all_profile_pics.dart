import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePics extends StatelessWidget {
  var profilePic;
  User? currUser = FirebaseAuth.instance.currentUser;
  var profileColl = FirebaseFirestore.instance;
  ProfilePics({this.profilePic});

  @override
  Widget build(BuildContext context) {
    var profilePicInfo = profileColl
        .collection('user')
        .doc(currUser!.uid)
        .collection('picsCollection');
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios_new)),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: profilePicInfo.snapshots(),
            builder: (_, snapshot) {
              return snapshot.data != null ? Column(
                children: [
                  Center(
                    child: SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Image.network(
                        profilePic,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    child: GridView.builder(
                      scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        childAspectRatio: 3/4),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (_,index){
                          return Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            height: 100,
                            width: 100,
                            child: Image.network(snapshot.data!.docs[index].data()['url'],fit: BoxFit.cover,),
                          );
                        }),
                  ),
                ],
              ):Center(child: CircularProgressIndicator());
            }));
  }
}
