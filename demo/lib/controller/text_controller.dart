import 'package:flutter/cupertino.dart';

class TextController extends ChangeNotifier{
  bool check = false;
  void text(bool value){
    check = value;
    notifyListeners();
  }
}