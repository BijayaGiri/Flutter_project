import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Utils/Utilities.dart';
import '../../Widgets/roundbutton.dart';
import 'LoginScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading =false;
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    //this function is used to dispose the assets when this screen is
    // not used so that it doesnt occupy the memory
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  void sign_up(){
    setState(() {
      loading=true;
    });
    _auth.createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString()).then((value) {
      setState(() {
        loading=false;
      });


    }).onError((error, stackTrace){
      setState(() {
        loading=false;
      });
      Utils().toastMessage(error.toString());//this is calling the function
      // and passing the error message that is caught


    }); //this line helps to catch the error
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey, //to give color to the appbar
        //automaticallyImplyLeading:
        // false, //to disable the back arrow on the top left,
        title: Center(
            child: Text(
              "Sign Up",
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
              title: "Sign Up",
              loading: loading, //making the loading the required parameter
              onTap: () {
                if (_formkey.currentState!.validate()) {
                  sign_up();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));

                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have account?"),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Text("Login "))
              ],
            )
          ],
        ),
      ),
    );
  }
}
