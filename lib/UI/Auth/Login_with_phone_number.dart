import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Utils/utilities.dart';
import '../../Widgets/RoundButton.dart';
import 'Verify_code.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  //to show the circular progress indicator
  bool loading = false;
  final phonenumbercontroller = TextEditingController();
  //to create the instance of the firebase
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Center(
          child: Text(
            "Login",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            TextFormField(
              controller:
              phonenumbercontroller, //anything entered will be stored in the phonenumbercontroller declared above
              decoration: InputDecoration(
                hintText: "+977 **********",
              ),
            ),
            SizedBox(
              height: 80,
            ),
            RoundButton(
                loading: loading,
                title: "Login",
                onTap: () {
                  setState(() {
                    loading=true;
                  });

                  auth.verifyPhoneNumber( //this provides the firebase the phoneNumber
                    //phone number is stored in the phonenumbercontroller so providing the phonenumbercontroller
                    phoneNumber: phonenumbercontroller.text,
                    verificationCompleted: (_) {
                      setState(() {
                        loading=false;
                      });
                    },
                    verificationFailed: (e) {

                      Utils().toastMessage(e.toString());
                      setState(() {
                        loading=false;
                      });

                    },
                    codeSent: (String VerificationId, int? token) { // to verify we need to pass the verification code to the next screen and we are doing this
                      //token is the six digit code
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyCodeScreen(VerificationID:VerificationId)));//passing the verification id to verify code page
                      setState(() {
                        loading=false;
                      });
                    },

                    codeAutoRetrievalTimeout: (e) {

                      // this function is just because the code expires after ont minute
                      Utils().toastMessage(e.toString());
                      setState(() {
                        loading=false;
                      });
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}
