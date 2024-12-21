import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:machinetest21/database.dart';
import 'package:machinetest21/home_Page.dart';
import 'package:machinetest21/otpscreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              const Text(
                "login page",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    Database().signInWithGoogle(context);
                  },
                  child: const Text("signup with google")),
              const SizedBox(
                height: 50,
              ),
              const Text("or"),
              const SizedBox(
                height: 50,
              ),
              // Using IntlPhoneNumberInput widget for better phone number input
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  // Update phoneController.text with the selected phone number
                  phoneController.text = number.phoneNumber ?? '';
                },
                initialValue:
                    PhoneNumber(isoCode: 'IN'), // Set default country code
                selectorConfig: SelectorConfig(
                    selectorType: PhoneInputSelectorType.DROPDOWN),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                inputDecoration: InputDecoration(
                    fillColor: Colors.grey.withOpacity(0.25),
                    filled: true,
                    hintText: "Enter phone number",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none)),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    String phoneNumber = phoneController.text;
                    if (phoneNumber.isNotEmpty && phoneNumber.startsWith('+')) {
                      FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: phoneNumber,
                        verificationCompleted:
                            (PhoneAuthCredential phoneAuthCredential) {
                          log('Verification completed');
                        },
                        verificationFailed: (FirebaseAuthException error) {
                          log('Verification failed: ${error.message}');
                        },
                        codeSent:
                            (String verificationId, int? forceResendingToken) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Otpscreen(verificationId: verificationId),
                            ),
                          );
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {
                          log("Auto retrieval timeout: $verificationId");
                        },
                      );
                    } else {
                      log('Please enter a valid phone number in E.164 format.');
                    }
                  },
                  child: const Text("sign in")),

              // TextField(
              //   keyboardType: TextInputType.phone,
              //   controller: phoneController,
              //   decoration: InputDecoration(
              //       fillColor: Colors.grey.withOpacity(0.25),
              //       filled: true,
              //       hintText: "enter phone",
              //       border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(30),
              //           borderSide: BorderSide.none)),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              // ElevatedButton(
              //     onPressed: () {
              //       FirebaseAuth.instance.verifyPhoneNumber(
              //         phoneNumber: phoneController.text,
              //         verificationCompleted: (phoneAuthCredential) {},
              //         verificationFailed: (error) {
              //           log(error.toString());
              //         },
              //         codeSent: (verificationId, forceResendingToken) {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => const Otpscreen(verificationId: 'ver',)));
              //         },
              //         codeAutoRetrievalTimeout: (verificationId) {
              //           log("Auto retrivel time");
              //         },
              //       );
              //     },
              //     child: const Text("sigin"))
            ],
          ),
        ),
      ),
    );
  }
}
