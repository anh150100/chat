import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/controller/record.dart';
import 'package:demo/controller/text_controller.dart';
import 'package:demo/controller/voice.dart';
import 'package:demo/models/user.dart';
import 'package:demo/pages/chat/widget/show_message.dart';
import 'package:demo/pages/chat/widget/voice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:just_audio/just_audio.dart' as ap;
class Chat extends StatefulWidget {
  final UserModel userModel;
  const Chat({Key? key, required this.userModel}) : super(key: key);
  @override
  _ChatState createState() => _ChatState(this.userModel);
}
class _ChatState extends State<Chat> {
  final UserModel userModel;
  TextEditingController msg = TextEditingController();
  File? imageFile;
  ap.AudioSource? audioSource;

  _ChatState(this.userModel);


  Future getImage() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }


  Future uploadImage() async {
    String fileName = const Uuid().v1();
    int status = 1;

    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await FirebaseFirestore.instance
          .collection('user')
          .doc()
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();
      print(imageUrl);
      await FirebaseFirestore.instance
          .collection('user')
          .doc()
          .set({
        'user':FirebaseAuth.instance.currentUser!.displayName,
        'username': userModel.name,
        "message": imageUrl,
        "type": "img",
        "time": FieldValue.serverTimestamp(),
        "id":"${userModel.id}",
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    bool check = context.watch<RecordController>().record;
  return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          leading:Container(
              margin: const EdgeInsets.only(left: 10,top: 10,bottom: 10,right: 5),
              width: 30,
              decoration: const BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios,color: Colors.white,size: 20,),
                  onPressed: (){
                    Get.back();
                  },
                ),
              )
          ),
          title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(userModel.name,style: const TextStyle(color: Colors.white,fontSize: 16),),
                  const Text("Đang hoạt động",style: TextStyle(color: Colors.white54,fontSize: 10),)
                ],
              ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20,top: 10 ,bottom: 10),
            width: 40,
            height: 30,
            decoration: const BoxDecoration(
                color: Colors.white12,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              child: Image.network(
                  userModel.image,
                  fit: BoxFit.cover
              ),
            ),
          ),
      ],
          ),
    body: SingleChildScrollView(
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height-140,
            child:  SingleChildScrollView(
              physics: const ScrollPhysics(),
              reverse: true,
              child: ShowMessage(id: userModel.id,),
            ),
          ),
          SizedBox(
            child: Row(
              children: [
                Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 7,left: 20,right: 15),
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.all(Radius.circular(20.0),),
                      ),
                      child:TextField(
                          onChanged: (text) {
                            // Provider.of<TextController>(context, listen: false);
                            print(text);
                            context.read<TextController>().text(text.isNotEmpty);
                          },
                          maxLines: 6,
                          minLines: 1,
                          controller: msg,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 10),
                              suffixIcon: IconButton(
                                onPressed: () => getImage(),
                                icon: Icon(Icons.add_circle,
                                  color: Colors.blueAccent[400],),
                              ),
                              hintText: "Aa",
                              hintStyle: const TextStyle(color: Colors.white12),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              )
                          ),
                            )
                    )
                ),
                if(context.watch<TextController>().check == false)
                  AudioRecorder(
                    onStop: (path) {
                      context.read<VoiceController>().voice(path,userModel);
                    }
                 )
                else Padding(
                    padding: const EdgeInsets.only(right: 10,top: 5),
                  child:   IconButton(
                      onPressed: () async {
                        if(msg.text.isNotEmpty) {
                          final refUser = FirebaseFirestore.instance.collection('user').doc();
                          await refUser.set({
                            'username': userModel.name,
                            'user':user!.email.toString(),
                            'message' : msg.text.trim(),
                            'time': DateTime.now(),
                            "type": "text",
                            "id":"${userModel.id}",
                          });
                          msg.clear();
                          Provider.of<TextController>(context, listen: false);
                          context.read<TextController>().text(false);
                        }
                      },
                      icon: const Icon(Icons.send,color: Colors.blue,)),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
  }
}