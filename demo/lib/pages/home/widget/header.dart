import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.black12,
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(user!.photoURL!),
                  fit: BoxFit.cover)),
        ),
        const SizedBox(width: 20,),
        const Text(
          "Chat",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: MediaQuery.of(context).size.width/3 ,),
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black12,
          ),
          child: const Icon(Icons.camera_alt_sharp,size: 20,),
        ),
        const SizedBox(width: 10,),
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black12,
          ),
          child: const Icon(Icons.edit,size: 20,),
        ),
      ],
    );
  }
}