

import 'package:demo/models/phone_model.dart';
import 'package:get/get.dart';

class PhoneController extends GetxController{
  final valueModel = PhoneModel().obs;

  updateTheValue1(bool newBool){
    valueModel.update((model){
      model!.wait = newBool;
    });
  }
  updateTheValue2(String newValue1){
    valueModel.update((model){
       model!.buttonName = newValue1;
    });
  }
  updateTheValue3(String newValue2){
    valueModel.update((model){
       model!.verificationIdFinal = newValue2;
    });
  }
  updateTheValue4(String newValue3){
    valueModel.update((model){
       model!.smsCode = newValue3;
    });
  }
  updateTheValue5(int newValue5){
    valueModel.update((model){
      model!.start = newValue5;
    });
  }
}