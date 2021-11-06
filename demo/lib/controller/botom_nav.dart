
import 'package:flutter/material.dart';

class BottomNavController with ChangeNotifier {
  int _count = 0 ;
  List <Color> colors = [
    Colors.lightBlueAccent,
    Colors.black26,
  ];
  int get count => _count;
  void increment(int index) {
    _count=index;
    for(int i=0;i< colors.length;i++){
      if(i == index){
        colors[i] = Colors.lightBlueAccent;
      }
      else{
        colors[i]=Colors.black26;
      }
    }
    notifyListeners();
  }
}