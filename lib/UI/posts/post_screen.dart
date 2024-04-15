import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebasewala/UI/posts/add_posts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Utils/Utilities.dart';
import '../Auth/LoginScreen.dart';

class Postscreen extends StatefulWidget {
  const Postscreen({super.key});

  @override
  State<Postscreen> createState() => _PostscreenState();
}

class _PostscreenState extends State<Postscreen> {
  final ref = FirebaseDatabase.instance
      .ref("post"); //creating the reference of the databae
  //of the node "Post"
  final auth = FirebaseAuth.instance; //take the instance of firebase
  final SearchFilter = TextEditingController();
  final updateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: true,
        backgroundColor: Colors.blueGrey,
        title: Center(
            child: Text(
          "Post Screen",
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

          //lets filter the list
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: SearchFilter,
              decoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              onChanged: (String Value) {
                //this expects string and the value is get by the textform field
                setState(() {});
              },
            ),
          ),

          //using the StreamBuilder
          //this FirebaseAnimatedList is a list and it should be wrapped with the Expanded widget
          Expanded(
            //FirebaseAnimatedList can only be used with the Widget tree
            child: FirebaseAnimatedList(
                //this comes with the firebase package
                // this is used to fetch the data from the realtime database
                defaultChild: Text("Loading.."),
                query: ref, //the query is assigned with the
                // ref because the node is lnitialized with the ref.
                //the loop will run until the data finishes
                itemBuilder: (context, snapshot, animation, inedx) {
                  final title = snapshot
                      .child('comments')
                      .child("title")
                      .value
                      .toString();
                  //we will check if the searchfilter is empty or not
                  if (SearchFilter.text.isEmpty) {
                    return ListTile(
                      title: Text(snapshot
                          .child('comments')
                          .child("title")
                          .value
                          .toString()), //this will show the content of the title of the firebase
                      //to show the id
                      subtitle: Text(snapshot
                          .child("comments")
                          .child('id')
                          .value
                          .toString()),
                      trailing: PopupMenuButton(
                        icon: Icon(Icons
                            .more_vert), //this will add more icon in the trailing section
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value: 1, //to make its own identity
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  showMyDualog(
                                      title,
                                      snapshot.child("comments").child('id').value.toString());
                                  //this title and is is passed so that when we update we can see
                                  // what is in the title previously and id is passed to update te
                                },
                                leading: Icon(Icons.edit),
                                title: Text("Edit"),
                              )),
                          PopupMenuItem(

                              value: 1, //to make its own identity
                              child: ListTile(
                                onTap: (){ //this is simply creating function for deleting
                                  //we have created the instance variable of the firebase database
                                  Navigator.pop(context);
                                  ref.child(snapshot.child("comments").child('id').value.toString()).remove();
                                  //the above function simply goes to the particular id of the child comments which is the child of the posts andf removes it.

                                },
                                leading: Icon(Icons.delete_outline_outlined),
                                title: Text("Delete"),
                              ))
                        ],
                      ),
                    );
                  } else if (title
                      .toLowerCase()
                      .contains(SearchFilter.text.toLowerCase().toString())) {
                    //if the user enters the value existing in the title
                    return ListTile(
                      title: Text(snapshot
                          .child('comments')
                          .child("title")
                          .value
                          .toString()), //this will show the content of the title of the firebase
                      //to show the id
                      subtitle: Text(snapshot
                          .child("comments")
                          .child('id')
                          .value
                          .toString()),
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPostScreen()));
        }, //what we will do here is ask text
        // from the user and store it in the firebase
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDualog(String title, String id) async {
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
                child: Text("Cancel")),//this is just pop
            TextButton(onPressed: () {
              ref.child(id).child("comments").update({
                "title":updateController.text.toString(),
              }).then((value){
                Utils().toastMessage("Post Updated");
                Navigator.pop(context);
              }).onError((error, stackTrace){
                Utils().toastMessage(error.toString());
              });
            }, child: Text("Update"))
          ],
        );
      },
    );
  }
}
