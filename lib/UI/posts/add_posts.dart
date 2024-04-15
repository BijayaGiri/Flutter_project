import 'package:firebase_database/firebase_database.dart';
import 'package:firebasewala/Utils/Utilities.dart';
import 'package:firebasewala/Widgets/RoundButton.dart';
import 'package:flutter/material.dart';
class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool loading=false;
  final postcontroller=TextEditingController();
  final databaseRef= FirebaseDatabase.instance.ref("post"); //creating instance or say reference of the firebase database
  //this reference creates the node or say table in the realtime database of the friebase
//we will store all the data related to the post in this node.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Center(child: Text("Add post",style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: postcontroller,
              maxLines:4 ,
              decoration:InputDecoration(
                hintText: "Any thing on your mind",
                border: OutlineInputBorder(

                )
              ),
            ),
            SizedBox(
              height: 50,
            ),
            RoundButton(title: "Add",
              loading: loading, //to show the circular progress indicator
                onTap: (){
              setState(() {
                loading=true;
              });
              String id=DateTime.now().millisecondsSinceEpoch.toString();
              //we are storing the data in the database
              //we have created table above using the reference and named it as databaseref.
                  // The node will have child composed of the rows and the columns.
              databaseRef.child(id).child("comments").set({
                //this is the child section and we are providing the milliseconds as child and inside the milliseconds as comments we are adding the subchild
                "title":postcontroller.text.toString(),//this is the subchild of the title1,
                //this is creating a key value pair.
                "id":id,
              }).then((value) {
                setState(() {
                  loading=false;
                });
                Utils().toastMessage("Post added!!");

              }).onError((error, stackTrace){
                setState(() {
                  loading=false;
                });
                Utils().toastMessage(error.toString());

              });//adding then to know that the data is stroed properly
                })

          ],
        ),
      ),
    );
  }
}
