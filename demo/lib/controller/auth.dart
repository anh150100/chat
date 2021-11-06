

import 'dart:io';

import 'package:demo/pages/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:record/record.dart';

class AuthController extends ChangeNotifier{
  bool _isLoading = false;
  String? _errorMessage;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
 final storage = const FlutterSecureStorage();
  Future signUp(String email,String password)async{
   // setLoading(true);
    try{
      UserCredential authResult = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = authResult.user;
      setLoading(false);
      return user;
    }on SocketException {
      setLoading(false);
      setMesage("No internet, please connect to internet");
    } catch(e) {
      setLoading(false);
      setMesage("");
    }
    notifyListeners();
  }

  Future login(String email,String password)async{
    //setLoading(true);
    try{
      UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User? user = authResult.user;
      setLoading(false);
      return user;
    }on SocketException {
      setLoading(false);
      setMesage("No internet, please connect to internet");
    } catch(e) {
      setLoading(false);
      setMesage("The email address is already in use by another account");
    }
    notifyListeners();
  }

  Future logout() async {
    await firebaseAuth.signOut();
  }
  void setLoading(val){
    _isLoading = val;
    notifyListeners();
  }
  void setMesage(message){
    _errorMessage = message;
    notifyListeners();
  }
  Stream<User?> get user
  => firebaseAuth.authStateChanges().map((event) => event);


   void storeTokenAndData(UserCredential userCredential) async {
    print("storing token and data");
    await storage.write(
        key: "token", value: userCredential.credential!.token.toString());
    await storage.write(
        key: "usercredential", value: userCredential.toString());
  }

    Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

    Future<void> verifyPhoneNumber(
      String? phoneNumber, BuildContext context, Function setData) async {
    // ignore: prefer_function_declarations_over_variables
    PhoneVerificationCompleted? verificationCompleted =
        (PhoneAuthCredential? phoneAuthCredential) async {
      showSnackBar(context, "Verification Completed");
    };
    // ignore: prefer_function_declarations_over_variables
    PhoneVerificationFailed? verificationFailed =
        (FirebaseAuthException? exception) {
      showSnackBar(context, exception.toString());
    };
    // ignore: prefer_function_declarations_over_variables
    void Function(String? verificationID, [int? forceResnedingtoken]) codeSent =
        (String? verificationID, [ int? forceResnedingtoken]) {
      showSnackBar(context, "Verification Code sent on the phone number");
      setData(verificationID);
    };

    // ignore: prefer_function_declarations_over_variables
    PhoneCodeAutoRetrievalTimeout? codeAutoRetrievalTimeout =
        (String? verificationID) {
      showSnackBar(context, "Time out");
    };
    try {
      await firebaseAuth.verifyPhoneNumber(
          timeout: const Duration(seconds: 60),
          phoneNumber: phoneNumber!,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signInwithPhoneNumber(
      String? verificationId, String? smsCode, BuildContext context) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId!, smsCode: smsCode!);

      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      storeTokenAndData(userCredential);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => Home()),
          (route) => false);

      showSnackBar(context, "logged In");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}