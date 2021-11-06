
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/controller/duration_controller.dart';
import 'package:demo/controller/duration_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ShowMessage extends StatelessWidget {
  final int id;
  ShowMessage({Key? key, required this.id}) : super(key: key);
  final _player = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .orderBy("time")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            primary: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot x = snapshot.data!.docs[index];
              return x['type'] == "text" && x['id'] == id.toString() ? ListTile(
                  title: Column(
                    crossAxisAlignment: user!.email == x['user']
                        ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      user.email == x['user'] ? Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 30, bottom: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 15,
                                vertical: 15),
                            decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0),
                                  bottomLeft: Radius.circular(15.0),)
                            ),
                            child: Text(x['message'], style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 13),),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 10,
                            //left: MediaQuery.of(context).size.width-60,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.check, size: 10, color: Colors.blue,),
                            ),),
                        ],
                      ) : Container(
                        margin: const EdgeInsets.only(right: 30, bottom: 5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        decoration: const BoxDecoration(
                          color: Colors.white12,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(
                              15.0),),
                        ),
                        child: Text(
                          x['message'], style: const TextStyle(color: Colors
                            .white,
                            fontWeight: FontWeight.w500,
                            fontSize: 13),),
                      ),
                    ],
                  ) //
              ) : x['type'] == "img" && x['id'] == id.toString() ? Container(
                margin: user!.displayName == x['user']
                    ? const EdgeInsets.only(bottom: 10, right: 10)
                    : const EdgeInsets.only(bottom: 10, left: 10),
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 2.5,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                padding: const EdgeInsets.symmetric(
                    vertical: 2, horizontal: 10),
                alignment: user.displayName == x['user']
                    ? Alignment.centerRight : Alignment.centerLeft,
                child: InkWell(
                  onTap: () =>
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ShowImage(
                                imageUrl: x['message'],
                              ),
                        ),
                      ),
                  child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 2.5,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 2,
                    decoration: const BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    alignment: x['message'] != "" ? null : Alignment.center,
                    child: x['message'] != ""
                        ? ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(
                          25.0)),
                      child: Image.network(
                          x['message'],
                          fit: BoxFit.cover
                      ),
                    )
                        : const CircularProgressIndicator(),
                  ),
                ),
              ) : x['type'] == "audio" && x['id'] == id.toString() ?
              user!.displayName == x['user'] ? Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 100, bottom: 10, right: 15),
                    height: 50,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                          bottomLeft: Radius.circular(15.0),)
                    ),
                    child: x['message'] != ""
                        ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 20, right: 10),
                            height: 30,
                            width: 30,
                            decoration: const BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5))
                            ),
                            child:  GetX<ValueController>(
                            init: ValueController(),
                            builder: (_) {
                              return IconButton(
                                icon: x.id == _.valueModel.value.id ?_.valueModel.value.icon:const Icon(Icons.play_arrow, color: Colors.white, size: 14,),
                                onPressed: () async {
                                  await _player.setUrl(x['message']);
                                  _player.play();
                                  final Duration? duration = await _player
                                      .setUrl(
                                      x['message']);
                                  print(_player.playerState.playing);
                                  Get.put(ValueController());
                                  Get.find<ValueController>().updateTheValues(
                                    duration!, x.id, const Icon(
                                    Icons.pause, color: Colors.white,
                                    size: 14,),);
                                },
                              );
                            }
                             )
                          ),
                          for(int i = 1; i < 40; i++)
                            Container(
                              margin: const EdgeInsets.only(right: 1),
                              color: Colors.white,
                              width: 2,
                              height: Random().nextDouble() * 20.0,
                            ),
                          // Text("00:28",style: TextStyle(color: Colors.white),)
                          const SizedBox(width: 7,),
                          GetX<ValueController>(
                              init: ValueController(),
                              builder: (_) {
                                return x.id == _.valueModel.value.id ? Text(
                                  "${_.valueModel.value.value1.inMinutes}:${_
                                      .valueModel.value.value1.inSeconds}",
                                  style: const TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),)
                                    : const Text("0:0", style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13),);
                              }
                          ),
                        ]
                    )
                        : const CircularProgressIndicator(),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 25,
                    //left: MediaQuery.of(context).size.width-60,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.check, size: 10, color: Colors.blue,),
                    ),),
                ],
              ) : Container(
                margin: const EdgeInsets.only(right: 100, bottom: 10, left: 15),
                height: 50,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                decoration: BoxDecoration(
                    color: user.displayName == x['user']
                        ? Colors.green : Colors.white12,
                    borderRadius: const BorderRadius.all(Radius.circular(15.0))
                ),
                child: x['message'] != ""
                    ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 10),
                        height: 35,
                        width: 35,
                        decoration: const BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        child: GetX<ValueController>(
                            init: ValueController(),
                            builder: (_) {
                              return IconButton(
                                icon: x.id == _.valueModel.value.id ?_.valueModel.value.icon:const Icon(Icons.play_arrow, color: Colors.white, size: 14,),
                                onPressed: () async {
                                  await _player.setUrl(x['message']);
                                  _player.play();
                                  final Duration? duration = await _player
                                      .setUrl(
                                      x['message']);
                                  print(_player.playerState.playing);
                                  Get.put(ValueController());
                                  Get.find<ValueController>().updateTheValues(
                                    duration!, x.id, const Icon(
                                    Icons.pause, color: Colors.white,
                                    size: 14,),);
                                },
                              );
                            }
                        )
                      ),
                      for(int i = 1; i < 40; i++)
                        Container(
                          margin: const EdgeInsets.only(right: 1),
                          color: Colors.white,
                          width: 2,
                          height: Random().nextDouble() * 20.0,
                        ),
                      const SizedBox(width: 7,),
                      GetX<ValueController>(
                          init: ValueController(),
                          builder: (_) {
                            return x.id == _.valueModel.value.id ? Text(
                              "${_.valueModel.value.value1.inMinutes}:${_
                                  .valueModel.value.value1.inSeconds}",
                              style: const TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13),)
                                : const Text("0:0", style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 13),);
                          }
                      ),
                    ]
                )
                    : const CircularProgressIndicator(),
              ) : Container();
            },
          );
        }
    );
  }
}


class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Image.network(imageUrl),
      ),
    );
  }
}