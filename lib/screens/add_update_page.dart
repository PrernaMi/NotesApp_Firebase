import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/note_model.dart';

class AddUpDatePage extends StatefulWidget {
  bool isUpdate;
  bool isDelete;
  String? prevTitle;
  String? prevDesc;
  String? id;

  AddUpDatePage(
      {required this.isUpdate,
      this.prevTitle,
      this.prevDesc,
      this.id,
      required this.isDelete});

  @override
  State<AddUpDatePage> createState() => _AddUpDatePageState();
}

class _AddUpDatePageState extends State<AddUpDatePage> {
  var collections = FirebaseFirestore.instance.collection('notes');
  @override
  void initState() {
    if(widget.isDelete){
      //delete here
      collections.doc(widget.id).delete();
      Navigator.pop(context);
    }
    super.initState();
  }
  TextEditingController titleController = TextEditingController();

  TextEditingController descController = TextEditingController();

  var firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  String? uid;
  @override
  Widget build(BuildContext context) {
    var collections = firestore.collection('notes');
    if (user != null) {
      uid = user!.uid;
    }
    if (widget.isUpdate) {
      titleController.text = widget.prevTitle!;
      descController.text = widget.prevDesc!;
    }
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              "Add Note",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                  hintText: "Enter your title..",
                  label: Text("Title"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                  hintText: "Enter your desc",
                  label: Text("Description"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      widget.isUpdate == false
                          /*---------Adding Note in Firestore------*/
                          ? collections.add(NoteModel(
                                  title: titleController.text.toString(),
                                  desc: descController.text.toString(),
                                  uid: uid)
                              .toMap())
                          /*---------Updating Note in Firestore------*/
                          : collections.doc(widget.id!).update(NoteModel(
                                  title: titleController.text.toString(),
                                  desc: descController.text.toString(),
                                  uid: uid)
                              .toMap());
                      Navigator.pop(context);
                    },
                    child: widget.isUpdate ? Text("Update") : Text("Add")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
