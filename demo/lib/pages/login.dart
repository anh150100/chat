import 'package:demo/controller/auth.dart';
import 'package:demo/controller/google_controller.dart';
import 'package:demo/pages/phone.dart';
import 'package:demo/pages/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'home/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController? _email;
  TextEditingController? _password;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _email!.dispose();
    _password!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthController>(context);
    final user = Provider.of<User?>(context);
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80,),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text("Sign In!",style: TextStyle(fontSize: 36,color: Colors.black),),
              ),
             Form(
               key: _formKey,
               child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Container(
                     padding: const EdgeInsets.only(left: 20,right: 20,top:20),
                     child: TextFormField(
                       controller: _email,
                       validator: (val)
                       =>val!.isNotEmpty ? null : "Please enter a email address",
                         decoration: InputDecoration(
                           filled: true,
                           fillColor: Colors.white,
                           hintText: 'Email',
                           prefixIcon: const Icon(Icons.email),
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(25.0),
                             borderSide:  const BorderSide(),
                           ),
                         ),
                        // onSaved: (input) => _email = input! as TextEditingController?,

                     ),
                   ),
                   Container(
                     padding: const EdgeInsets.only(left: 20,right: 20,top:20),
                     child: TextFormField(
                       controller: _password,
                       validator: (val)
                        => val!.length < 6 ? "Enter more than 6 character": null,
                         decoration: InputDecoration(
                           filled: true,
                           fillColor: Colors.white,
                           hintText: 'Password',
                           prefixIcon: const Icon(Icons.lock),
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(25.0),
                             borderSide: const BorderSide(),
                           ),
                         ),
                         // obscureText:true,
                         // onSaved: (input) => _password = input! as TextEditingController?,
                     ),
                   ),
                   const SizedBox(height: 20,),
                   Container(
                     margin: const EdgeInsets.only(left: 20,right: 20),
                     child: MaterialButton(
                         onPressed: () async {
                           if(_formKey.currentState!.validate()){
                             print("Email: ${_email!.text}");
                             print("Email: ${_password!.text}");
                             await loginProvider.login(_email!.text.trim(), _password!.text.trim());
                           }
                         },
                         height:60,
                         minWidth:loginProvider.isLoading? null : double.infinity,
                         color: Colors.lightBlueAccent,
                         textColor: Colors.white,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(20)
                         ),
                        child:loginProvider.isLoading?
                        const CircularProgressIndicator() : const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                         ),
                   ),
                   const SizedBox(height: 10,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       const Text("Create an Account?",
                         style: TextStyle(
                           color: Colors.black54,
                           fontSize: 15,
                           fontWeight: FontWeight.bold
                       ),),
                       const SizedBox(width: 5,),
                       TextButton(
                           onPressed:(){
                             Get.to(()=>const SignUp());
                           },
                           child: const Text("Sign Up",
                             style: TextStyle(
                                 color: Colors.lightBlueAccent,
                               fontSize: 15,
                               fontWeight: FontWeight.bold
                           ),)),
                     ],
                   ),
                ],
              ),
             ),
              const SizedBox(height: 20,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        var provider = Provider.of<GoogleController>(context,listen: false);
                        provider.ggLogin();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[300],
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        textStyle: const TextStyle(
                          fontSize: 20,
                        ),),
                      child: const Text("Sign in with Google",style: TextStyle(color: Colors.white,fontSize: 12),textAlign: TextAlign.center,)),
                  const SizedBox(width: 20,),
                  ElevatedButton(
                      onPressed: () {
                        Get.to(()=>PhoneAuthPage());
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[300],
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        textStyle: const TextStyle(
                          fontSize: 20,
                        ),),
                      child: const Text("Sign in with Phone ",style: TextStyle(color: Colors.white,fontSize: 12),textAlign: TextAlign.center,)),
                ],
              ),
          ],),
    ),
    );
  }
}
