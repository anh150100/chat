import 'package:demo/models/duration_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ValueController extends GetxController{
  final valueModel = DurationModel().obs;

  updateTheValues(Duration newValue1,String newValue2, Icon newIcon){
    valueModel.update((model){
      model!.value1 = newValue1;
      model.id = newValue2;
      model.icon = newIcon;
    });
  }
}