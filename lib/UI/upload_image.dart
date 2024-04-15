import 'dart:io';

import 'package:firebasewala/Utils/Utilities.dart';
import 'package:firebasewala/Widgets/RoundButton.dart';
import"package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool loading=false;
  DatabaseReference databaseReference  =FirebaseDatabase.instance.ref("Post");//creating the instance of the firebasedatabase

  //we have to create the instance of the firebase storage
  firebase_storage.FirebaseStorage storage= firebase_storage.FirebaseStorage.instance; //this is the reference of the storage
  File? _image;
  final picker=ImagePicker(); //we are creating the instance of the Imagepicker as picker
  //this picker will allow us to pick the images form the gallery
  Future getImageGallery() async{
    final pickedfile=await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
    setState(() {
      if(pickedfile!=null){ //this is the condition where the user goes into the gallery but doesnt pick any image
        _image=File(pickedfile.path);//we are getting the path of the picked file here
      }
      else{
        Utils().toastMessage("Image not picked");
      }

    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Center(child: Text("Upload Image",style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:20 ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap:(){
                  getImageGallery();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:Colors.black
                    )
                  ),
                  child:_image!=null?Image.file(_image!.absolute) : Center(child: Icon(Icons.image)),//applying condition
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            RoundButton(
                loading: loading,
                title: "Upload", onTap: ()async{
                  setState(() {
                    loading=true;
                  });
                  String id=DateTime.now().millisecondsSinceEpoch.toString();
              firebase_storage.Reference ref=firebase_storage.FirebaseStorage.instance.ref('/foldername/'+id);//foldername is the name of the folder and the 1224 is the name of the file
              firebase_storage.UploadTask uploadTask=ref.putFile(_image!.absolute);//upload task will provide the url of the image
              await Future.value(uploadTask).then((value)async {
                var newurl=await ref.getDownloadURL();//we get the url;
                databaseReference.child("1").set({
                  "id":"1234",
                  "title":newurl.toString(),
                }).then((value) {
                  setState(() {
                    loading=false;
                  });
                  Utils().toastMessage("Uploaded Successfuly");
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });

              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });//this will wait




            })
          ],
        ),
      ),
    );
  }
}
