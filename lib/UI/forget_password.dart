import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasewala/Utils/Utilities.dart';
import 'package:firebasewala/Widgets/RoundButton.dart';
import 'package:flutter/material.dart';

import 'Auth/LoginScreen.dart';
class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final emailcontroller=TextEditingController();
  final auth=FirebaseAuth.instance;//creating the instance of the firebaseauthentication
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Center(
          child: Text("Forgot Password",style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),),
        ),
      ),
      body:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailcontroller,
              decoration: InputDecoration(
                hintText: "Email",
              ),
            ),
            SizedBox(height: 40,),
            RoundButton(title: "Forgot", onTap: (){
              auth.sendPasswordResetEmail(email: emailcontroller.text.toString()).then((value) {
                Utils().toastMessage("Email sent to you ");
                Utils().toastMessage("Please check your Email");
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());

              });

            })

          ],
        ),
      ),
    );
  }
}
