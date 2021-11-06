import 'package:demo/models/user.dart';
import 'package:demo/pages/chat/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ListUser extends StatelessWidget {
  const ListUser({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child:Row(
        children: [
          SizedBox(
            height: 100,
            width: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black12,
                  ),
                  child: const Icon(Icons.video_call_rounded,size: 30,),
                ),
                const Text("Tạo phòng họp mặt",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w400),)
              ],
            ),
          ),
        Container(
          height: 100,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: userList.length,
            itemBuilder: (BuildContext context, int index) {
              return _itemList(context, userList[index]);
            }
        ),
      ),
        ],
      ),
    );
  }
}

_itemList(BuildContext context,UserModel userModel){
  return GestureDetector(
    onTap: (){
      Get.to(()=> Chat(userModel: userModel));
    },
    child: SizedBox(
        height: 100,
        width: 80,
        child: Column(
          children: [
            Stack(
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
            Text(userModel.name,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w400),),
          ],
        )
    ),
  );
}
