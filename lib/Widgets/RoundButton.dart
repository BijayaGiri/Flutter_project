import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool loading;
  final String title;//declaring a string variable
  const RoundButton({super.key,required this.title,required this.onTap,this.loading=false});//this is a constructor and expects a title string

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,//this will perform the process send to the constructor as onTap

      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Colors.blueGrey.shade400,
            borderRadius:BorderRadius.circular(10)
        ),
        child: Center(child:loading?CircularProgressIndicator(strokeWidth: 3,color: Colors.white,):Text(title,style: TextStyle( // if loading is true then show the
          // circular progress indicator else show the text
            color: Colors.white
        ),)),
      ),
    );
  }
}
