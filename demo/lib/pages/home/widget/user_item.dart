import 'package:demo/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../chat/chat.dart';

class UserItem extends StatelessWidget {
  const UserItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return Column(
        children:List.generate(
          userList.length, (index) =>_itemUser(context, userList[index]), )
    );
  }
}

_itemUser(BuildContext context,UserModel userModel){
  return GestureDetector(
      onTap: (){
    Get.to(()=> Chat(userModel: userModel));
  },
  child: Container(
    margin: const EdgeInsets.only(bottom: 10),
    child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Expanded(
              flex: 6,
              child: Row(
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Stack(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(userModel.image),
                                  fit: BoxFit.cover)),
                        ),
                        Positioned(
                          bottom: 5,
                          left: 40,
                          child: Container(
                            width: 18,
                            height: 18 ,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                                border: Border.all(
                                  width: 3,
                                  color: Colors.white,
                                )
                            ),
                          ),),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8,),
                      Text(userModel.name,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black54),),
                    ],
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(top: 20,right: 0),
            child:  Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                  color: Colors.black12,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(userModel.image),
                      fit: BoxFit.cover)),
            ),
          ),
        ]
    ),
  ),
  );
}


