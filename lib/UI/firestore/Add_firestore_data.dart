import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasewala/Utils/Utilities.dart';
import 'package:firebasewala/Widgets/RoundButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class AddFireStoreData extends StatefulWidget {
  const AddFireStoreData({super.key});

  @override
  State<AddFireStoreData> createState() => _AddFireStoreDataState();
}

class _AddFireStoreDataState extends State<AddFireStoreData> {

  bool loading = false;
  final postcontroller = TextEditingController();
  final firestore=FirebaseFirestore.instance.collection("users"); //this collection is just like the table name
  //we have created a collection which is just similar to the node
    User? user=FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Center(
            child: Text(
          "Add FireStore",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
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
              maxLines: 4,
              decoration: InputDecoration(
                  hintText: "Any thing on your mind",
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 50,
            ),
            RoundButton(
                title: "Add",
                loading: loading, //to show the circular progress indicator
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  //the document requires id and as in the firebase database we are providing the id by using the milliseconds which is unique
                  String id=DateTime.now().millisecondsSinceEpoch.toString();
                  String uid=user!.uid;
                  firestore.doc(id).set({ // this is the document id which is similar to the child id in the firebase database
                    //we are setting the data in the firestore
                    "title":postcontroller.text.toString(), //the data we write is stored in the post
                    // controller so we are storing the data in title in the firestoredata base
                    "id":id,

                  }).then((value){
                    setState(() {
                      loading=false;
                    });
                    Utils().toastMessage("Post Added");

                  }).onError((error, stackTrace) {
                    setState(() {
                      loading=false;
                    });
                    Utils().toastMessage(error.toString());
                  }); //this is if successfully implemented
                })
          ],
        ),
      ),
    );
  }
}
