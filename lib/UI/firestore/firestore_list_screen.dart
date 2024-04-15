import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasewala/UI/firestore/Add_firestore_data.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../../Utils/Utilities.dart';
import '../Auth/LoginScreen.dart';

class FirestoreScreen extends StatefulWidget {
  const FirestoreScreen({super.key});

  @override
  State<FirestoreScreen> createState() => _FirestoreScreenState();
}

class _FirestoreScreenState extends State<FirestoreScreen> {
  final auth = FirebaseAuth.instance; //take the instance of firebase
  final updateController = TextEditingController();
  final firestore = FirebaseFirestore.instance
      .collection("users")
      .snapshots(); //we are creating the instance of thre firestore snapshots
  CollectionReference ref = FirebaseFirestore.instance.collection("users");
//this will return the data in the form of query
  //CollectionReference ref = FirebaseFirestore.instance
  //.collection("users"); //creating instance variable of the firestore
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: true,
        backgroundColor: Colors.blueGrey,
        title: Center(
            child: Text(
          "FireStore",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
        actions: [
          IconButton(
              onPressed: () {
                //to take you to the login screen
                auth.signOut().then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }).onError((error, stackTrace) {
                  // this is to display any errors that occur
                  Utils().toastMessage(error.toString());
                });
              },
              icon: Icon(
                Icons.logout_outlined,
                color: Colors.white,
              )),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          StreamBuilder<QuerySnapshot>(
              stream:
                  firestore, //as the data is to be fetched from the firestore
              // and we have here provided the instance of the firestore
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text("Some Error");
                }
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs
                          .length, //this is providing the length to the list builder
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              snapshot.data!.docs[index]["title"].toString()),
                          subtitle:
                              Text(snapshot.data!.docs[index]["id"].toString()),
                          trailing: PopupMenuButton(
                              icon: Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                    PopupMenuItem(

                                        child: ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        showMyDualog(
                                            snapshot,
                                            index,
                                            snapshot.data!.docs[index]["title"]
                                                .toString(),
                                            snapshot.data!.docs[index]["id"]
                                                .toString());
                                      },
                                      leading: Icon(Icons.update),
                                      title: Text("Update"),
                                    )),
                                    PopupMenuItem(
                                        child: ListTile(
                                      onTap: () {
                                        ref.doc(snapshot.data!.docs[index]["id"]).delete().then((value){
                                          Utils().toastMessage("Deleted successfully");
                                        }).onError((error, stackTrace){
                                          Utils().toastMessage(error.toString());
                                        }); //delete is for firestore and remove is for firebase
                                        Navigator.pop(context);
                                      },
                                      leading:
                                          Icon(Icons.delete_outline_outlined),
                                      title: Text("Delete"),
                                    )),
                                  ]),
                        );
                      }),
                  //FirebaseAnimatedList can only be used with the Widget tree
                );
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddFireStoreData()));
        }, //what we will do here is ask text
        // from the user and store it in the firebase
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDualog(AsyncSnapshot<QuerySnapshot> snapshot, int index,
      String title, String id) async {
    //this function is made as name of showMydialogue and is used to show the dialog box
    updateController.text =
        title; //this is previous data that will be shown in the textform field
    return showDialog(
      //this showDialog is a funciton that accepts contect and builder
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update"),
          content: Container(
            child: TextField(
              controller: updateController,
              decoration: InputDecoration(
                hintText: "Edit",
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel")), //this is just pop
            TextButton(
                onPressed: () {
                  ref.doc(snapshot.data!.docs[index]["id"]).update({
                    "title": updateController.text.toString(),
                  }).then((value) {
                    Utils().toastMessage("Updated");
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                  Navigator.pop(context);
                },
                child: Text("Update"))
          ],
        );
      },
    );
  }
}
