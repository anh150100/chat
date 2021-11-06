
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayController extends ChangeNotifier{
 Icon icon = const Icon(Icons.play_arrow, color: Colors.white, size: 14,);
  get iconPlay => icon;
  void player(){
      icon = const Icon(Icons.play_arrow, color: Colors.white, size: 14,);
    notifyListeners();
  }
  void pause(){
    icon = const Icon(Icons.pause, color: Colors.white, size: 14,);
    notifyListeners();
  }
}