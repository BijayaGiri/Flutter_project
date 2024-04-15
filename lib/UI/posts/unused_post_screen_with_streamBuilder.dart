import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebasewala/UI/posts/add_posts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Utils/Utilities.dart';
import '../Auth/LoginScreen.dart';

class UnusedPostScreen extends StatefulWidget {
  const UnusedPostScreen({super.key});

  @override
  State<UnusedPostScreen> createState() => _UnusedPostScreenState();
}

class _UnusedPostScreenState extends State<UnusedPostScreen> {
  final ref=FirebaseDatabase.instance.ref("post"); //creating the reference of the databae
  //of the node "Post"
  final auth = FirebaseAuth.instance; //take the instance of firebase
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
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
      body:Column(
        children: [
          //using the StreamBuilder
          Expanded(child: StreamBuilder(
            stream:ref.onValue, //this is a future function and expects async
            builder: (context,AsyncSnapshot<DatabaseEvent> snapshot){

              //since a list is comming we will uew Listview Builder
              if(!snapshot.hasData){
                return CircularProgressIndicator();

              }else{
                Map<dynamic,dynamic> map = snapshot.data!.snapshot.value as dynamic;//we are using Map here
                //since we are getting a list we should use List
                List<dynamic> list =[]; //creating an empty list
                list.clear(); //cleawring the previous list
                list=map.values.toList(); //we get the list from the map and providing the List to the variable list

                return ListView.builder(
                  //the listview builder will build the list by the count given by the list count
                  itemCount:snapshot.data!.snapshot.children.length ,
                  itemBuilder: (context,index){
                    return ListTile(
                      title: Text(list[index]["comments"]["title"]),//this title is from the realtimedatabase firebase
                      subtitle:Text(list[index]["comments"]["id"]) ,
                    );
                  },
                );
              }


            },
          )),
          //this FirebaseAnimatedList is a list and it should be wrapped with the Expanded widget
          Expanded( //FirebaseAnimatedList can only be used with the Widget tree
            child: FirebaseAnimatedList(//this comes with the firebase package
              // this is used to fetch the data from the realtime database
                defaultChild: Text("Loading.."),
                query: ref,//the query is assigned with the
                // ref because the node is lnitialized with the ref.
                //the loop will run until the data finishes
                itemBuilder: (context,snapshot,animation,inedx){
                  return ListTile(
                    title: Text(snapshot.child('comments').child("title").value.toString()),//this will show the content of the title of the firebase
                    //to show the id
                    subtitle: Text(snapshot.child("comments").child('id').value.toString()),
                  );
                }),
          ),
        ],
      ) ,
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
}
