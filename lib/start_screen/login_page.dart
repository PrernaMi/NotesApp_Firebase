import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes/start_screen/forgot_pass.dart';
import 'package:firebase_notes/start_screen/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/home_page.dart';

class LoginPage extends StatelessWidget {
  TextEditingController emailCon = TextEditingController();
  TextEditingController passwCont = TextEditingController();
  TextEditingController newPasswCont = TextEditingController();
  SharedPreferences? prefs;
  var currUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent.shade100.withOpacity(0.3),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
              ),
              Text(
                "Login",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: emailCon,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: "Enter your Email",
                    label: Text("Email"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: passwCont,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.visibility_off),
                    hintText: "Enter your password",
                    label: Text("Password"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              SizedBox(
                height: 15,
              ),
              //don't have account
              InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return SignUpPage();
                    }));
                  },
                  child: Text(
                    "Don't have an account? sign Up",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                height: 10,
              ),
              //Forgot password
              InkWell(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                      return ForgotPass(isUserLogin: false,);
                    }));
                  },
                  child: Text("forgot password?",style: TextStyle(color: Colors.blue),)),
              SizedBox(
                height: 15,
              ),
              //login
              ElevatedButton(
                  onPressed: () async {
                    var auth = FirebaseAuth.instance;
                    try {
                      //sign in with existing user
                      var cred = await auth.signInWithEmailAndPassword(
                          email: emailCon.text.toString(),
                          password: passwCont.text.toString());
                      //if user exist
                      if (cred.user != null) {
                        //used for splash screen
                        prefs = await SharedPreferences.getInstance();
                        prefs!.setString("uid", cred.user!.uid);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return HomePage();
                        }));
                      }
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: ${e.code}")));
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  child: Text("Login"))
            ],
          ),
        ),
      ),
    );
  }
}
