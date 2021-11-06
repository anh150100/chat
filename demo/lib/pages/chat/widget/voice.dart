
import 'dart:async';
import 'package:demo/controller/record.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:provider/provider.dart';
class AudioRecorder extends StatefulWidget {
  final void Function(String path) onStop;

  const AudioRecorder({required this.onStop});

  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  Timer? _timer;
  Timer? _ampTimer;
  final _audioRecorder = Record();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ampTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool check = context.watch<RecordController>().record;
    return Container(
      margin: const EdgeInsets.only(right: 20,top: 10),
            height: 45,
            width: 45,
            decoration:  BoxDecoration(
              color:Colors.blueAccent[400],
              borderRadius: const BorderRadius.all(Radius.circular(15.0))
            ),
            child: GestureDetector(
                child: const Icon(Icons.mic, color: Colors.white, size: 30),
                onLongPress: (){
                  _start(check);
                },
                onLongPressUp: (){
                  _stop(check);
                }
            ),

             //_buildText(),
    );
  }



  Future<void> _start(bool check) async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start();
        context.read<RecordController>().start();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _stop(bool check) async {
    _timer?.cancel();
    _ampTimer?.cancel();
    final path = await _audioRecorder.stop();
    widget.onStop(path!);
   context.read<RecordController>().stop();
  }
}
