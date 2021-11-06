import 'dart:async';

import 'package:demo/controller/auth.dart';
import 'package:demo/controller/phone_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({Key? key}) : super(key: key);

  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  TextEditingController phoneController = TextEditingController();
  AuthController authClass = AuthController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  GetX<PhoneController>(
          init: PhoneController(),
          builder: (_){
            return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                        children: [
                         const SizedBox(
                          height: 150,
                        ),
                        textField(),
                      const SizedBox(
                       height: 30,
                     ),
                       SizedBox(
                         width: MediaQuery.of(context).size.width - 30,
                          child: Row(
                               children: [
                              Expanded(
                                child: Container(
                                height: 1,
                                color: Colors.grey,
                                margin: const EdgeInsets.symmetric(horizontal: 12),
                                ),
                             ),
                              const Text(
                               "Enter 6 digit OTP",
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            Expanded(
                                child: Container(
                                height: 1,
                                color: Colors.grey,
                                margin: const EdgeInsets.symmetric(horizontal: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                        const SizedBox(
                          height: 30,
                         ),
                        otpField(),
                        const SizedBox(
                       height: 40,
                        ),
                     RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Send OTP again in ",
                            style: TextStyle(fontSize: 16, color: Colors.yellowAccent),
                          ),
                          TextSpan(
                            text: "00:${_.valueModel.value.start}",
                            style: const TextStyle(fontSize: 16, color: Colors.pinkAccent),
                          ),
                          const TextSpan(
                            text: " sec ",
                            style: TextStyle(fontSize: 16, color: Colors.yellowAccent),
                          ),
                        ],
                      )),
                      const SizedBox(
                      height: 120,
                         ),
                     InkWell(
                        onTap: () {
                      authClass.signInwithPhoneNumber(
                          _.valueModel.value.verificationIdFinal, _.valueModel.value.smsCode, context);
                       },
                         child: Container(
                            height: 60,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 60,
                            decoration: BoxDecoration(
                                color: Colors.lightBlueAccent,
                                borderRadius: BorderRadius.circular(15)),
                            child: const Center(
                                    child: Text(
                                "Lets Go",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white ,
                                    fontWeight: FontWeight.w700),
                              ),
                           ),
                        ),
                     ),
            ],
          ),
        ),
    );
  }
    ),
    );
  }
  Widget otpField() {
    return  OTPTextField(
            length: 6,
            width: MediaQuery.of(context).size.width,
            fieldWidth: 30,
            otpFieldStyle: OtpFieldStyle(
            backgroundColor: Colors.black12,
            borderColor: Colors.white,
            ),
            style: const TextStyle(fontSize: 17, color: Colors.white),
            textFieldAlignment: MainAxisAlignment.spaceAround,
            fieldStyle: FieldStyle.underline,
          onCompleted: (pin) {
          print("Completed: " + pin); // check whether the state object is in tree
          Get.put(PhoneController());
        Get.find<PhoneController>().updateTheValue4(pin);
    },
    );
    }


  Widget textField() {
    return GetX<PhoneController>(
        init: PhoneController(),
        builder: (_) {
          return Container(
            width: MediaQuery
                .of(context)
                .size
                .width - 40,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextFormField(
              controller: phoneController,
              style: const TextStyle(color: Colors.black, fontSize: 17),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter your phone Number",
                hintStyle: const TextStyle(color: Colors.black54, fontSize: 17),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 19, horizontal: 8),
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 14, horizontal: 15),
                  child: Text(
                    "+84",
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                ),
                suffixIcon: InkWell(
                    onTap: _.valueModel.value.wait ? null : () async
                {
                    Get.put(PhoneController());
                    Get.find<PhoneController>().updateTheValue5(30);
                    Get.put(PhoneController());
                    Get.find<PhoneController>().updateTheValue1(true);
                    Get.put(PhoneController());
                    Get.find<PhoneController>().updateTheValue2("Resend");
                    await authClass.verifyPhoneNumber(
                    "+84 ${phoneController.text}", context, setData);
                    },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20, horizontal: 15),
                  child: GetX<PhoneController>(
                      init: PhoneController(),
                      builder: (_) {
                        return Text(_.valueModel.value.buttonName, style: TextStyle(
                          color: _.valueModel.value.wait ? Colors.black12 : Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),);
                      }
                  ),
                ),
              ),
            ),
          ),);
        }
    );
  }

  void setData(String verificationId) {
    Get.put(PhoneController());
    Get.find<PhoneController>().updateTheValue3(verificationId);
  }
}