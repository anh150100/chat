import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart' as ap;
import 'package:uuid/uuid.dart';
class VoiceController extends ChangeNotifier {
  ap.AudioSource? audioSource;
  void voice(path, UserModel userModel) async {
    print(Uri.parse(path));
    audioSource = ap.AudioSource.uri(Uri.parse(path));
    String fileName = const Uuid().v1();
    int status = 1;
    var ref =
    FirebaseStorage.instance.ref().child('images').child("$fileName.mp3");

    var uploadTask = await ref.putFile(File(path)).catchError((error) async {
      await FirebaseFirestore.instance
          .collection('user')
          .doc()
          .delete();

      status = 0;
    });
    if (status == 1) {
      String audioUrl =await uploadTask.ref.getDownloadURL();
      FirebaseFirestore.instance
          .collection('user')
          .doc()
          .set({
        'user':FirebaseAuth.instance.currentUser!.displayName,
        'username': userModel.name,
        "message": audioUrl,
        "type": "audio",
        "time": FieldValue.serverTimestamp(),
        "id":"${userModel.id}",
      });
    }
    notifyListeners();
  }

}