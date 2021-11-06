
import 'package:demo/controller/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50,),
                      const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text("Create an Account!",style: TextStyle(fontSize: 36,color: Colors.black),),
                      ),
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
                              await loginProvider.signUp(_email!.text.trim(), _password!.text.trim());
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
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ],),
                ),
              ],),
        ),
    );
  }
}