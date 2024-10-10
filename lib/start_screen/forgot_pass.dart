import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes/start_screen/login_page.dart';
import 'package:firebase_notes/start_screen/set_new_pass.dart';
import 'package:flutter/material.dart';

class ForgotPass extends StatelessWidget {
  bool isUserLogin;
  ForgotPass({required this.isUserLogin});
  TextEditingController emailCon = TextEditingController();
  var fireStore = FirebaseFirestore.instance;
  var currUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Forgot password",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: emailCon,
              decoration: InputDecoration(
                  label: Text("Email: "),
                  hintText: "Enter your email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
            SizedBox(
              height: 10,
            ),
            isUserLogin==false ?ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: emailCon.text.toString());
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Password reset email sent to ${emailCon.text.toString()}")));
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text("Reset Password")) :ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                    return SetNewPassword();
                  }));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text("Reset Password")) ,
            SizedBox(
              height: 10,
            ),
            //back to login page
            isUserLogin == false
                ? InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginPage();
                      }));
                    },
                    child: Text("Back to login"))
                : Container()
          ],
        ),
      ),
    );
  }
}
