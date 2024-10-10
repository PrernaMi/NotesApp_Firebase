import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes/models/user_model.dart';
import 'package:firebase_notes/screens/home_page.dart';
import 'package:firebase_notes/start_screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpPage extends StatelessWidget {
  TextEditingController nameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  TextEditingController phoneCon = TextEditingController();
  TextEditingController genderCon = TextEditingController();

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
                height: 100,
              ),
              Text(
                "Sign up",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: nameCon,
                decoration: InputDecoration(
                    hintText: "Enter your Name",
                    prefixIcon: Icon(Icons.drive_file_rename_outline),
                    label: Text("Name"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )),
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
                controller: phoneCon,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    hintText: "Enter your Number",
                    label: Text("Number"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: genderCon,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.category),
                    hintText: "Enter your gender",
                    label: Text("Gender"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: passCon,
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
              //already have an account
              InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return LoginPage();
                    }));
                  },
                  child: Text(
                    "Already have an account? Login",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () async {
                    var auth = FirebaseAuth.instance;
                    try {
                      //creating new user account with email and password
                      var cred = await auth.createUserWithEmailAndPassword(
                          email: emailCon.text.toString(),
                          password: passCon.text.toString());
                      //if user create successfully
                      if (cred.user != null) {
                        //then store all info to the firestore with the same user id
                        //which is creating when user is created in authentication
                        var fireStore = FirebaseFirestore.instance;
                        var collection = fireStore.collection("user");
                        collection.doc(cred.user!.uid).set(UserModel(
                                name: nameCon.text.toString(),
                                email: emailCon.text.toString(),
                                phone: phoneCon.text.toString(),
                                gender: genderCon.text.toString())
                            .toDoc());
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return HomePage();
                        }));
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("The password provided is too weak.")));
                      } else if (e.code == 'email-already-in-use') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "The account already exists for that email.")));
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  child: Text("Sign up")),
              SizedBox(
                height: 15,
              ),
              Text("Or"),
              SizedBox(
                height: 15,
              ),
              //sign in with google
              InkWell(
                onTap: ()async{

                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width*0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade700)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/google_logo.png",height: 20,),
                      Text("continue with google",style: TextStyle(color: Colors.blue),)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Step 1: Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      // Step 2: Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Step 3: Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Step 4: Sign in with the credential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("Error during Google Sign-In: $e");
      return null;
    }
  }

}
