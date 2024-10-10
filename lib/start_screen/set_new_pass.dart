import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes/start_screen/login_page.dart';
import 'package:flutter/material.dart';

class SetNewPassword extends StatelessWidget {
  TextEditingController newPass = TextEditingController();
  TextEditingController confirmPass = TextEditingController();
  User? currUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Set New Password",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: newPass,
              obscureText: true,
              decoration: InputDecoration(
                  label: Text("Password"),
                  hintText: "Enter new password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: confirmPass,
              obscureText: true,
              decoration: InputDecoration(
                  label: Text("Confirm Paswword"),
                  hintText: "Confirm password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  if (newPass.text.toString() == confirmPass.text.toString()) {
                    //updating password
                    currUser!.updatePassword(newPass.text.toString());
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Password updated successfully!!!")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Your password don't match!!!")));
                  }
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text("Reset Password"))
          ],
        ),
      ),
    );
  }
}
