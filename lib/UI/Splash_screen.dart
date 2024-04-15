import 'package:flutter/material.dart';

import '../FirebaseServices/Splashservices.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashScreen=SplashServices();//initializing the splash services
  @override
  void initState() {
    super.initState();
    splashScreen.isLogin(context);//calling the function made on the splashservices of the firebaserservices
    // TODO: implement initState

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(child: Text("Firebase",style: TextStyle(color: Colors.blueGrey,fontSize: 30,fontWeight: FontWeight.bold),)),
    );
  }
}
