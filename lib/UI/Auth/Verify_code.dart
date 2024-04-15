import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasewala/UI/posts/post_screen.dart';
import 'package:flutter/material.dart';
import '../../Utils/Utilities.dart';
import '../../Widgets/RoundButton.dart';
class VerifyCodeScreen extends StatefulWidget {
  final String VerificationID;
  const VerifyCodeScreen({super.key,required this.VerificationID});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final verifyCodeController = TextEditingController();
  //to create the instance of the firebase
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Center(
          child: Text(
            "Verify",
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
              verifyCodeController, //anything entered will be stored in the phonenumbercontroller declared above
              decoration: InputDecoration(
                hintText: "6 digit code",
              ),
            ),
            SizedBox(
              height: 80,
            ),
            RoundButton( // this is to enter the six digit code
                loading: loading,
                title: "Verify",
                onTap: () async{
                  setState(() {
                    loading=true;

                  });
                  final credential=PhoneAuthProvider.credential( // to verify the OTP code or say token
                    //for the verification id we will get through the constructor so to call it we use Widget.----
                      verificationId:widget.VerificationID,//the verification id we will get from the login_with_phone_number
                    // screen which we will get through the constructor and sent by the back screen
                      smsCode: verifyCodeController.text.toString(),//the six digit code entered by the user is stored in the phone controller

                  ); // after the verification is complete the firebase will send us a token
                  //to handle the exception in token we use the try catch method
                  try{
                    await auth.signInWithCredential(credential);//this credential is sent by the firebase as a token
                    // and we are handling it to see if any problem arises


                    // As the signing with credential finishes we need to move on to the next screenas:
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Postscreen()));
                  }
                  catch(e){
                    setState(() {
                      loading=false;
                    });
                    Utils().toastMessage(e.toString());

                  }

                })
          ],
        ),
      ),
    );
  }
}
