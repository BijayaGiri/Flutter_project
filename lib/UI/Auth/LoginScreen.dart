import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasewala/UI/forget_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../Utils/utilities.dart';
import '../../Widgets/roundbutton.dart';
import '../posts/post_screen.dart';
import 'Login_with_phone_number.dart';
import 'Signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth
      .instance; //creating reference for the firebase authentication
  @override
  void dispose() {
    //this function is used to dispose the assets when this screen is
    // not used so that it doesnt occupy the memory
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() {
    setState(() {
      loading=true;//while validating the circular progress bar should turn on
    });
    _auth
        .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text.toString())
        .then((value) {
      Utils().toastMessage(
          value.user!.email.toString()); //this will display the userid
      // and go to the next sereen via navigator below
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Postscreen()));

      setState(() {
        loading=false; //when validated the circular progress bar should not be shown
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
      setState(() {
        loading=false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey, //to give color to the appbar
        automaticallyImplyLeading:
        false, //to disable the back arrow on the top left,
        title: Center(
            child: Text(
              "Login",
              style: TextStyle(color: Colors.white),
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType
                          .emailAddress, //decides which keyboard to be apperared
                      controller:
                      emailController, //the thing typed by the user remains in this email controller
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: "Email",
                      ),
                      validator: (value) {
                        //this validator is used to see if the form is empty or not
                        if (value!.isEmpty) {
                          return "Enter Email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(Icons.password),
                      ),
                      validator: (value) {
                        //This is used to check is the password field is empty or not
                        if (value!.isEmpty) {
                          return "Enter password";
                        }
                        return null;
                      },
                    ),
                  ],
                )),
            SizedBox(
              height: 30,
            ),
            RoundButton(
              title: "Login",
              loading:loading,
              onTap: () {
                if (_formkey.currentState!.validate()) {
                  login();
                }
              },
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgetPasswordScreen()));
                  },
                  child: Text("Forget Password")),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: Text("SIgn up"))
              ],
            ),
            SizedBox(height: 30,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginWithPhoneNumber()));
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                        color: Colors.black
                    )
                ),
                //to verify the apks with the firebase we need the SHA keys for the android
                child: Center(
                    child: Text("Login with Phone Number",style: TextStyle(
                      color: Colors.blueGrey,
                    ),)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
