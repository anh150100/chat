import 'package:demo/controller/auth.dart';
import 'package:demo/controller/google_controller.dart';
import 'package:demo/controller/play_controller.dart';
import 'package:demo/controller/record.dart';
import 'package:demo/controller/voice.dart';
import 'package:demo/pages/home/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'controller/botom_nav.dart';
import 'controller/text_controller.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 // ignore: prefer_const_constructors
 runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
         builder: (context,snapshot)
            =>  MultiProvider(
              providers: [
                ChangeNotifierProvider<AuthController>.value(value:AuthController()),
                StreamProvider<User?>.value(
                  value: AuthController().user,
                  initialData: null,
                ),
                ChangeNotifierProvider<GoogleController>.value(value:GoogleController()),
                ChangeNotifierProvider<BottomNavController>.value(value:BottomNavController()),
                ChangeNotifierProvider(create: (context) => VoiceController()),
                ChangeNotifierProvider(create: (context) => RecordController()),
                ChangeNotifierProvider(create: (context) => TextController()),
              ],
              child:const GetMaterialApp(
                debugShowCheckedModeBanner: false,
                home: Wrapper(),
              ),
            )
    );
        }
  }


class ErrorWidget extends StatelessWidget {
  const ErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: const [
            Icon(Icons.error),
            Text("Something went wrong !")
          ],
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
     body: Center(
       child: CircularProgressIndicator(),
     ),
    );
  }
}



