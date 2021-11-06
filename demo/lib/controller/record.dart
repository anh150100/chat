import 'package:flutter/cupertino.dart';

class RecordController extends ChangeNotifier{
  bool _isRecording =false;
  bool get record => _isRecording;
  void start() async{
    _isRecording = true;
    notifyListeners();
  }
  void stop(){
    _isRecording = false;
    notifyListeners();
  }
}
